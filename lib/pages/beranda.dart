import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/session_manager.dart';
import 'buatsurvei-home.dart';
import 'isisurvei-pembuka.dart';
import 'search-pertama.dart';


class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  String? _namaPengguna;
  int _poin = 0;
  String? _urlAvatar;
  late Future<List<Survei>> futureSurvei;

  @override
  void initState() {
    super.initState();
    _ambilProfil();
    futureSurvei = ambilSurvei();
  }

  Future<void> _ambilProfil() async {
    final idPengguna = await SessionManager.getUserId();
    if (idPengguna == null) return;

    try {
      final response = await http.get(
        Uri.parse(
            'https://9525-103-161-206-36.ngrok-free.app/SiDataAPI/api/profile.php?user_id=$idPengguna'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _namaPengguna = data['nama'];
          _poin = data['poin'] ?? 0;
          _urlAvatar = data['pp'] ?? 'assets/avatar.png';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data profil')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    }
  }

  Future<List<Survei>> ambilSurvei() async {
    final response = await http.get(Uri.parse(
        'https://9525-103-161-206-36.ngrok-free.app/SiDataAPI/api/survey.php'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Survei.fromJson(data)).toList();
    } else {
      throw Exception('Gagal menampilkan survei');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'SiData',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Halo, ${_namaPengguna ?? 'Pengguna'}!',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: CircleAvatar(
                      radius: 20, // Mengembalikan ukuran avatar seperti semula
                      backgroundImage: _urlAvatar != null
                          ? NetworkImage(_urlAvatar!)
                          : const AssetImage('assets/avatar.png')
                              as ImageProvider,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchPertama()),
                  );
                },
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari survei',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  enabled: false,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 24,
                      child: const Icon(Icons.monetization_on,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '$_poin Pts',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/buatsurvei.png', // Ganti dengan path gambar yang diinginkan
                      height: 100, // Sesuaikan ukuran sesuai kebutuhan
                      width: 100, // Sesuaikan ukuran sesuai kebutuhan
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            'Ayo mulai survei mu sendiri untuk mendapatkan data primer dari responden!',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SurveyPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              'Buat survei',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Rekomendasi Survei Untukmu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<Survei>>(
                future: futureSurvei,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Survei tidak tersedia');
                  } else {
                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemBuilder: (context, index) {
                          return KartuSurvei(
                            judul: snapshot.data![index].judul,
                            penulis: snapshot.data![index].penulis,
                            rekomendasi: true,
                            pathGambar: snapshot.data![index].pathGambar,
                            idSurvei: snapshot.data![index].idSurvei,
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KartuSurvei extends StatelessWidget {
  final String judul;
  final String penulis;
  final bool rekomendasi;
  final String pathGambar;
  final int idSurvei;

  const KartuSurvei({
    super.key,
    required this.judul,
    required this.penulis,
    this.rekomendasi = false,
    required this.pathGambar,
    required this.idSurvei,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    pathGambar,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                judul,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                penulis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text(
                        '20 Poin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.monetization_on,
                          color: Colors.amber, size: 20),
                    ],
                  ),
                  if (rekomendasi)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PembukaSurvei(idSurvei: idSurvei),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Isi Survei',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Survei {
  final String judul;
  final String penulis;
  final String pathGambar;
  final int idSurvei;

  Survei({
    required this.judul,
    required this.penulis,
    required this.pathGambar,
    required this.idSurvei,
  });

  factory Survei.fromJson(Map<String, dynamic> json) {
    return Survei(
      judul: json['judul_survei'] ?? 'No Title',
      penulis: json['nama_pengguna'] ?? 'Unknown Author',
      pathGambar: 'assets/survey_image.jpg',
      idSurvei: json['id_survei'] ?? 0,
    );
  }
}