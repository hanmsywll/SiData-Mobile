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
  String? _username;
  late Future<List<Survey>> futureSurveys;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    futureSurveys = fetchSurveys();
  }

  Future<void> _loadUsername() async {
    String? username = await SessionManager.getUserName();
    setState(() {
      _username = username;
    });
  }

  Future<List<Survey>> fetchSurveys() async {
    final response = await http.get(Uri.parse(
        'https://7cab-114-122-79-93.ngrok-free.app/SiDataAPI/api/survey.php'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Survey.fromJson(data)).toList();
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
                    'Halo, ${_username ?? 'Pengguna'}!',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                        child: const CircleAvatar(
                          backgroundImage: AssetImage('assets/avatar.png'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Stack(
                        children: [
                          const Icon(Icons.notifications, color: Colors.amber, size: 28),
                          Positioned(
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: const Text(
                                '3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPertama()),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.monetization_on, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          '1000 Pts',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SurveyPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text(
                        'Buat survei',
                        style: TextStyle(color: Colors.white),
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
              FutureBuilder<List<Survey>>(
                future: futureSurveys,
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
                          return SurveyCard(
                            title: snapshot.data![index].title,
                            author: snapshot.data![index].author,
                            isRecommendation: true,
                            imagePath: snapshot.data![index].imagePath,
                            idSurvei: snapshot.data![index].idSurvei,
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Riwayat Pengisian Survei',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemBuilder: (context, index) {
                    return const SurveyCard(
                      title: 'Survei Preferensi Mahasiswa Terhadap Video Live Streaming',
                      author: 'Nazmy Maulina, Telkom 2022',
                      claimed: true,
                      imagePath: 'assets/survey_image1.jpg',
                      showViewSurveyButton: false,
                      idSurvei: 0,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SurveyCard extends StatelessWidget {
  final String title;
  final String author;
  final bool claimed;
  final bool isRecommendation;
  final String imagePath;
  final bool showViewSurveyButton;
  final int idSurvei;

  const SurveyCard({
    super.key,
    required this.title,
    required this.author,
    this.claimed = false,
    this.isRecommendation = false,
    required this.imagePath,
    this.showViewSurveyButton = false,
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
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Oleh: $author'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '+ 20 pts',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.monetization_on,
                          color: Colors.amber, size: 20),
                    ],
                  ),
                  if (isRecommendation)
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
                  if (claimed)
                    ElevatedButton(
                      onPressed: () {
                        // Aksi klaim poin di sini
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Klaim',
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

class Survey {
  final String title;
  final String author;
  final String imagePath;
  final int idSurvei;

  Survey({
    required this.title,
    required this.author,
    required this.imagePath,
    required this.idSurvei,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      title: json['judul_survei'] ?? 'No Title',
      author: json['nama_pengguna'] ?? 'Unknown Author',
      imagePath: 'assets/survey_image.jpg',
      idSurvei: json['id_survei'] ?? 0,
    );
  }
}
