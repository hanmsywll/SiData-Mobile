import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'beranda.dart';
import 'isisurvei-pembuka.dart';

class SearchKedua extends StatefulWidget {
  const SearchKedua({super.key});

  @override
  _SearchKeduaState createState() => _SearchKeduaState();
}

class _SearchKeduaState extends State<SearchKedua> {
  late Future<List<Survey>> futureSurveys;

  @override
  void initState() {
    super.initState();
    futureSurveys = fetchSurveys();
  }

  Future<List<Survey>> fetchSurveys() async {
    final response = await http.get(Uri.parse(
        'https://20a2-114-122-107-182.ngrok-free.app/SiDataAPI/api/survey.php'));

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
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari survei',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Survey>>(
        future: futureSurveys,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Survei tidak tersedia'));
          } else {
            List<Survey> surveys = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
              ),
              itemCount: surveys.length,
              itemBuilder: (context, index) {
                return SurveyCard2(
                    title: surveys[index].title,
                    author: surveys[index].author,
                    imagePath: surveys[index].imagePath,
                    idSurvei: surveys[index].idSurvei);
              },
            );
          }
        },
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
        idSurvei: json['id_survei'] ?? 0);
  }
}

class SurveyCard2 extends StatelessWidget {
  final String title;
  final String author;
  final String imagePath;
  final int idSurvei;

  const SurveyCard2({
    super.key,
    required this.title,
    required this.author,
    required this.imagePath,
    required this.idSurvei,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 4),
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Oleh: $author',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          '+ 20 pts',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Icon(Icons.monetization_on,
                            color: Colors.amber, size: 24),
                      ],
                    ),
                  ),
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
                        borderRadius: BorderRadius.circular(25),
                      ),
                      minimumSize: Size(100, 40),
                    ),
                    child: const Text(
                      'Isi Survei',
                      style: TextStyle(color: Colors.white, fontSize: 15),
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
