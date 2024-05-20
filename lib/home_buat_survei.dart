import 'package:flutter/material.dart';
import 'buat_survei.dart';

class SurveyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mendapatkan lebar layar perangkat
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Text('Buat Survei'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: screenWidth,
                  child: Image.asset(
                    'assets/home_buat_survei.jpg',
                    width: screenWidth, // Mengatur lebar gambar sesuai dengan lebar layar
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Batas pengajuan survei yang kamu miliki:',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1/1 kesempatan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateSurveyPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text('Buat Survei', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Divider(),
              SizedBox(height: 25),
              Text(
                'Buat dengan template',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TemplateCard(
                imagePath: 'assets/template1.jpg', // Ganti dengan path gambar Anda
                title: 'Kuesioner Pengukuran Kualitas Jasa dengan Metode SERVQUAL',
              ),
              SizedBox(height: 16),
              TemplateCard(
                imagePath: 'assets/template2.jpg', // Ganti dengan path gambar Anda
                title: 'Kuesioner Maslach Burnout Inventory (Maslach dan Jackson, 1981)',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TemplateCard extends StatelessWidget {
  final String imagePath;
  final String title;

  TemplateCard({required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    // Get the width of the screen
    double screenWidth = MediaQuery.of(context).size.width;
    // Define the desired width of the card
    double cardWidth = screenWidth * 0.9; // 90% of the screen width

    return Center(
      child: Container(
        width: cardWidth,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: Image.asset(
                  imagePath,
                  height: 150, // Fixed height for the image
                  width: double.infinity, // Make the image take the full width
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}