import 'package:flutter/material.dart';
import 'pengaturan_survei.dart';

class CreateSurveyPage extends StatefulWidget {
  const CreateSurveyPage({super.key});

  @override
  _CreateSurveyPageState createState() => _CreateSurveyPageState();
}

class _CreateSurveyPageState extends State<CreateSurveyPage> {
  List<Widget> _questions = [];

  void _addQuestion() {
    setState(() {
      _questions.add(QuestionCard(
        key: UniqueKey(),
        onRemove: (key) {
          _removeQuestion(key);
        },
      ));
    });
  }

  void _removeQuestion(Key key) {
    setState(() {
      _questions.removeWhere((element) => element.key == key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Survei'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SurveySettingsPage()),
              );
            },
            child: const Text(
              'Selesai',
              style: TextStyle(color: Colors.blueAccent, fontSize: 18),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/header_survei.jpg',
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Tambahkan aksi untuk unggah header
                        },
                        icon: const Icon(Icons.upload),
                        label: const Text('Unggah header'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Judul Survei',
                  ),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Tambahkan deskripsi tentang surveimu',
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  children: _questions,
                ),
                const SizedBox(height: 80), // Memberikan ruang untuk FloatingActionButton
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _addQuestion,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Function(Key) onRemove;

  const QuestionCard({super.key, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Pertanyaan',
                  ),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Tambahkan Jawaban',
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                onRemove(key!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
