import 'package:flutter/material.dart';

class ConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 60.0,
              left: 16.0,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 32), // Adding space to push content down
                      Image.asset('assets/berhasil.png',
                          height: 300), // Adjust the height as needed
                      SizedBox(height: 32),
                      Text(
                        'Yeay, survei telah diaktifkan!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Bagikan juga surveimu dengan:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Image.asset('assets/instagram_icon.png'),
                            iconSize: 48,
                            onPressed: () {
                              // Tambahkan aksi untuk berbagi di Instagram
                            },
                          ),
                          IconButton(
                            icon: Image.asset('assets/twitter_icon.png'),
                            iconSize: 48,
                            onPressed: () {
                              // Tambahkan aksi untuk berbagi di Twitter
                            },
                          ),
                          IconButton(
                            icon: Image.asset('assets/whatsapp_icon.png'),
                            iconSize: 48,
                            onPressed: () {
                              // Tambahkan aksi untuk berbagi di WhatsApp
                            },
                          ),
                          IconButton(
                            icon: Image.asset('assets/link_icon.png'),
                            iconSize: 48,
                            onPressed: () {
                              // Tambahkan aksi untuk menyalin tautan survei
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 250, 252, 255),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Kembali ke Beranda',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
