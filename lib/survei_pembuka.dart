import 'package:flutter/material.dart';
import 'pertanyaan1.dart';

class PembukaSurvei extends StatelessWidget {
  const PembukaSurvei({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                'assets/header_isisurvei.png'),
            const SizedBox(height: 16.0),
            const Text(
              'Survei Responden Terhadap Penggunaan\n'
              'Aplikasi E-Money',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Pratinjau Pertanyaan:',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8.0),
            const Text(
              '1. Apa alasan utama Anda menggunakan aplikasi e-money?\n'
              '2. Apa jenis transaksi yang biasa Anda lakukan menggunakan aplikasi e-money?\n'
              '3. Menurut Anda, seberapa mudah dalam menggunakan aplikasi e-money?\n'
              '4. Apakah Anda pernah mengalami masalah atau kesulitan dalam menggunakan aplikasi e-money? Jika ya, silakan jelaskan!\n'
              '5. Beri penilaian terhadap tingkat kemungkinannya Anda dalam merekomendasikan aplikasi e-money kepada orang lain!',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Pertanyaan1()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(35, 55, 63, 1),
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Isi survei',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
