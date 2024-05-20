import 'package:flutter/material.dart';
import 'pertanyaan2.dart';

class Pertanyaan1 extends StatefulWidget {
  const Pertanyaan1({super.key});

  @override
  PertanyaanState createState() => PertanyaanState();
}

class PertanyaanState extends State<Pertanyaan1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                'assets/header_isisurvei.png'),
            const SizedBox(height: 16.0),
            const Text(
              'Apa alasan utama Anda menggunakan aplikasi e-money?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(33, 55, 63, 1),
                minimumSize: const Size(270, 40),
              ),
              child: const Text('Kemudahan dan Kenyamanan',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(33, 55, 63, 1),
                minimumSize: const Size(270, 40),
              ),
              child:
                  const Text('Keamanan', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(33, 55, 63, 1),
                minimumSize: const Size(270, 40),
              ),
              child: const Text('Bonus dan Cashback',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(33, 55, 63, 1),
                minimumSize: const Size(270, 40),
              ),
              child: const Text('Melacak dan Mengelola Keuangan',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const Pertanyaan2()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(33, 55, 63, 1),
                  minimumSize: const Size(100, 40),
                ),
                child: const Text(
                  'Selanjutnya',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
