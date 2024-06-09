import 'package:flutter/material.dart';
import 'dart:convert';
import '../utils/api_service.dart';
import 'package:http/http.dart' as http;
import '../utils/session_manager.dart';

class Peringkat {
  final int idPengguna;
  final String nama;
  final int skor;
  final String avatar;

  Peringkat({required this.idPengguna, required this.nama, required this.skor, required this.avatar});

  factory Peringkat.fromJson(Map<String, dynamic> json) {
    return Peringkat(
      idPengguna: json['id_pengguna'],
      nama: json['nama'],
      skor: json['poin'],
      avatar: json['pp'] ?? 'assets/avatar.png',
    );
  }
}

class PeringkatPage extends StatefulWidget {
  const PeringkatPage({super.key});

  @override
  _PeringkatPageState createState() => _PeringkatPageState();
}

class _PeringkatPageState extends State<PeringkatPage> {
  late Future<List<Peringkat>> futurePeringkat;
  String? username;
  int userPoints = 0;
  int? userId;
  String? profileImage;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    futurePeringkat = fetchPeringkat();
  }

  Future<void> _fetchUserProfile() async {
    final String? userIdString = await SessionManager.getUserId();
    if (userIdString == null) return;

    int userId = int.tryParse(userIdString) ?? -1;
    if (userId == -1) return;

    try {
      final response = await http.get(
        Uri.parse('https://7cab-114-122-79-93.ngrok-free.app/SiDataAPI/api/profile.php?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          username = data['nama'];
          userPoints = data['poin'] ?? 0;
          profileImage = data['pp'] ?? 'assets/avatar.png';
          this.userId = userId; // Set userId in the state
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch user profile data')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responden Paling Aktif'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Peringkat>>(
            future: futurePeringkat,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data found'));
              } else {
                return Column(
                  children: [
                    const Text(
                      'Top 3 Global SiData',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTopResponder(
                          rank: 2,
                          name: snapshot.data![1].nama,
                          points: snapshot.data![1].skor,
                          avatar: snapshot.data![1].avatar,
                        ),
                        _buildTopResponder(
                          rank: 1,
                          name: snapshot.data![0].nama,
                          points: snapshot.data![0].skor,
                          avatar: snapshot.data![0].avatar,
                          isCrown: true,
                        ),
                        _buildTopResponder(
                          rank: 3,
                          name: snapshot.data![2].nama,
                          points: snapshot.data![2].skor,
                          avatar: snapshot.data![2].avatar,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...snapshot.data!.sublist(3).asMap().entries.map((entry) {
                      int index = entry.key + 4; // +4 karena sudah ada 3 teratas
                      Peringkat peringkat = entry.value;
                      return _buildRankedResponder(
                        rank: index,
                        name: peringkat.nama,
                        points: peringkat.skor,
                        avatar: peringkat.avatar,
                        isCurrentUser: peringkat.idPengguna == userId,
                      );
                    }).toList(),
                    const Divider(),
                    Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: profileImage != null
                            ? (profileImage!.startsWith('http')
                                ? Image.network(profileImage!, width: 70, height: 70, fit: BoxFit.cover)
                                : Image.asset(profileImage!, width: 70, height: 70, fit: BoxFit.cover))
                            : Image.asset('assets/avatar.png', width: 70, height: 70, fit: BoxFit.cover), // Use your uploaded image
                        title: Text(
                          username != null ? 'Poin Anda: $userPoints' : 'Memuat data pengguna...',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: username != null ? Text('Nama: $username') : null,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopResponder({
    required int rank,
    required String name,
    required int points,
    required String avatar,
    bool isCrown = false,
  }) {
    // Potong nama jika lebih dari 9 karakter
    String displayName = name.length > 9 ? '${name.substring(0, 9)}...' : name;

    return Column(
      children: [
        if (isCrown) const Icon(Icons.emoji_events, color: Colors.orange, size: 32),
        Text(
          '$rank',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        CircleAvatar(
          radius: 40,
          backgroundImage: avatar.startsWith('http') ? NetworkImage(avatar) : AssetImage(avatar) as ImageProvider,
        ),
        const SizedBox(height: 8),
        Text(
          displayName,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        Text('$points Pts'),
      ],
    );
  }

  Widget _buildRankedResponder({
    required int rank,
    required String name,
    required int points,
    required String avatar,
    bool isCurrentUser = false,
  }) {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$rank',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ],
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: avatar.startsWith('http') ? NetworkImage(avatar) : AssetImage(avatar) as ImageProvider,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(name),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$points Pts'),
          if (isCurrentUser) const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      tileColor: isCurrentUser ? Colors.orange.shade100 : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.grey, width: 0.5),
      ),
    );
  }
}
