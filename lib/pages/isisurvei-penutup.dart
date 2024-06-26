import 'package:flutter/material.dart';

class PenutupSurvei extends StatelessWidget {
  final String surveyTitle;

  const PenutupSurvei({super.key, required this.surveyTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/header_isisurvei.png'),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Selamat, kamu mendapatkan 20 pts!',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                Icon(Icons.monetization_on, color: Colors.amber, size: 22),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              surveyTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Terima kasih telah berpartisipasi dalam pengisian survei.',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: const Color.fromRGBO(33, 55, 63, 1),
              ),
              child:
                  const Text('Kembali', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
