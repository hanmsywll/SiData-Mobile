import 'package:flutter/material.dart';
import '../utils/api_service.dart';

class Peringkat {
  final int idPengguna;
  final String nama;
  final int skor;

  Peringkat({required this.idPengguna, required this.nama, required this.skor});

  factory Peringkat.fromJson(Map<String, dynamic> json) {
    return Peringkat(
      idPengguna: json['id_pengguna'],
      nama: json['nama'],
      skor: json['poin'],
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

  @override
  void initState() {
    super.initState();
    futurePeringkat = fetchPeringkat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responden Paling Aktif'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              // Aksi untuk tombol info
            },
          ),
        ],
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
                      'Edisi Bulan Mei',
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
                          imagePath: 'assets/sophia.jpg',
                        ),
                        _buildTopResponder(
                          rank: 1,
                          name: snapshot.data![0].nama,
                          points: snapshot.data![0].skor,
                          imagePath: 'assets/kevin.jpg',
                          isCrown: true,
                        ),
                        _buildTopResponder(
                          rank: 3,
                          name: snapshot.data![2].nama,
                          points: snapshot.data![2].skor,
                          imagePath: 'assets/alex.jpg',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...snapshot.data!.map((peringkat) {
                      return _buildRankedResponder(
                        rank: snapshot.data!.indexOf(peringkat) + 1,
                        name: peringkat.nama,
                        university: 'Telkom University',
                        surveys: 200, // Dummy data for surveys
                        points: peringkat.skor,
                        imagePath: 'assets/avatar.png',
                        isCurrentUser: peringkat.nama == 'Rahesal (me)',
                      );
                    }).toList(),
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
    required String imagePath,
    bool isCrown = false,
  }) {
    // Potong nama jika lebih dari 9 karakter
    String displayName = name.length > 9 ? '${name.substring(0, 9)}...' : name;

    return Column(
      children: [
        if (isCrown) const Icon(Icons.emoji_events, color: Colors.orange, size: 32),
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(height: 8),
        Text(
          '$rank. $displayName',
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
    required String university,
    required int surveys,
    required int points,
    required String imagePath,
    bool isCurrentUser = false,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imagePath),
      ),
      title: Text(name),
      subtitle: Text('$university\n$surveys survei telah diisi'),
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
