import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hi, ada yang bisa dibantu?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'assets/bantuan.png',
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pertanyaan yang sering diajukan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const FAQItem(
                question: 'SiData itu apa sih?',
                answer: 'SiData adalah aplikasi mobile untuk memudahkan Mahasiswa untuk mengumpulkan responden dan melakukan penelitian.',
              ),
              const FAQItem(
                question: 'Ada fitur apa aja sih di SiData ini?',
                answer: 'Ada buat survei buat penelitian, isi survei untuk dapatkan poin, peringkat biar kamu semangat isi surveinya, bisa lihat survei juga untuk dianalisis!',
              ),
              const FAQItem(
                question: 'Poin itu dapat dari mana?',
                answer: 'Poin itu dapat dari isi survei yaa kawan-kawaaaaaaaaaan!',
              ),
              const FAQItem(
                question: 'Yang buat ini SiData itu siapaaa yaaa?',
                answer: 'Ada Raihan Syawal, Mahessssss, dan Salmaaaaaaa.',
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _launchURL('https://instagram.com/raihansyawaal');
                  },
                  icon: const Icon(Icons.chat, color: Colors.white),
                  label: const Text('Chat Kami'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Tangani kasus error di sini
      print('Could not launch $url');
    }
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(question),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(answer),
        ),
      ],
    );
  }
}
