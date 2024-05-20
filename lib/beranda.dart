import 'package:flutter/material.dart';

class Beranda extends StatelessWidget {
  const Beranda({super.key});

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
                  const Text(
                    'Halo, Rahesal!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                          const Icon(Icons.notifications,
                              color: Colors.amber, size: 28),
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
                  Navigator.pushNamed(context, '/search');
                },
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari survei',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  enabled: false, // Make the TextField non-editable
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
                        // Navigasi ke halaman buat survei jika diperlukan
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
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemBuilder: (context, index) {
                    return const SurveyCard(
                      title:
                          'Survei Responden Terhadap Penggunaan Aplikasi E-Money',
                      author: 'Dyasingrum, ITB 2021',
                      points: 12,
                      isRecommendation: true,
                      imagePath: 'assets/survey_image.jpg',
                    );
                  },
                ),
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
                      title:
                          'Survei Preferensi Mahasiswa Terhadap Video Live Streaming',
                      author: 'Nazmy Maulina, Telkom 2022',
                      points: 12,
                      claimed: true,
                      imagePath: 'assets/survey_image1.jpg',
                      showViewSurveyButton: false,
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
  final int points;
  final bool claimed;
  final bool isRecommendation;
  final String imagePath;
  final bool showViewSurveyButton;

  const SurveyCard({
    super.key,
    required this.title,
    required this.author,
    required this.points,
    this.claimed = false,
    this.isRecommendation = false,
    required this.imagePath,
    this.showViewSurveyButton = false,
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
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(author),
              const SizedBox(height: 8),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '+ $points pts',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                    ],
                  ),
                  if (isRecommendation)
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
                        // Tambahkan aksi klaim poin di sini
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
