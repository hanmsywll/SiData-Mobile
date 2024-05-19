import 'package:flutter/material.dart';

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
              TextField(
                decoration: InputDecoration(
                  hintText: 'Ketik kata kunci (cth: transaksi)',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pilih Topik',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  TopicIcon(icon: Icons.account_circle, label: 'Akun'),
                  TopicIcon(icon: Icons.assignment, label: 'Survei'),
                  TopicIcon(icon: Icons.monetization_on, label: 'Transaksi'),
                  TopicIcon(icon: Icons.leaderboard, label: 'Leaderboard'),
                  TopicIcon(icon: Icons.warning, label: 'Pelanggaran'),
                  TopicIcon(icon: Icons.info, label: 'Info Umum'),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Pertanyaan yang sering diajukan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const FAQItem(question: 'SiData itu apa sih?'),
              const FAQItem(question: 'Aku sudah tukar poin. Kapan hadiah diterima?'),
              const FAQItem(question: 'Kenapa aku nggak dapat OTP?'),
              const FAQItem(question: 'Kapan leaderboard di-reset?'),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Aksi untuk tombol chat
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
}

class TopicIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const TopicIcon({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, size: 30, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;

  const FAQItem({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(question),
      children: const [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Jawaban untuk pertanyaan ini akan ditampilkan di sini.'),
        ),
      ],
    );
  }
}
