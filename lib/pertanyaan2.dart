import 'package:flutter/material.dart';
import 'survei_penutup.dart';

class Pertanyaan2 extends StatefulWidget {
  const Pertanyaan2({super.key});

  @override
  _Pertanyaan2State createState() => _Pertanyaan2State();
}

class _Pertanyaan2State extends State<Pertanyaan2> {
  int? _selectedOption;

  Future<void> tampilKonfirmasi(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menyelesaikan survei?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ya'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const PenutupSurvei()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/header_isisurvei.png'),
            const SizedBox(height: 16.0),
            const Text(
              'Menurut Anda, seberapa mudah\n'
              'dalam menggunakan aplikasi e-money?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(5, (int index) {
                return Row(
                  children: [
                    Radio<int>(
                      value: index + 1,
                      groupValue: _selectedOption,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                    ),
                    Text(
                      '${index + 1}',
                    ),
                  ],
                );
              }),
            ),
            const Text(
              "Sangat Tidak Mudah                                        Sangat Mudah",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    minimumSize: const Size(100, 40),
                  ),
                  child: const Text(
                    'Sebelumnya',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    tampilKonfirmasi(context);
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
