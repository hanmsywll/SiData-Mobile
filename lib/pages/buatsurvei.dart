import 'package:flutter/material.dart';
import 'buatsurvei-pengaturan.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/session_manager.dart';

class CreateSurveyPage extends StatefulWidget {
  @override
  _CreateSurveyPageState createState() => _CreateSurveyPageState();
}

class _CreateSurveyPageState extends State<CreateSurveyPage> {
  List<Question> _questions = [];
  String _surveyTitle = '';
  String _surveyDescription = '';
  bool _isSubmitting = false;

  void _addQuestion() {
    setState(() {
      _questions.add(Question(type: QuestionType.radio, options: []));
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  void _addOption(int questionIndex) {
    setState(() {
      _questions[questionIndex].options.add('');
    });
  }

  void _removeOption(int questionIndex, int optionIndex) {
    setState(() {
      _questions[questionIndex].options.removeAt(optionIndex);
    });
  }

  void _setQuestionType(int questionIndex, QuestionType? type) {
    setState(() {
      if (type != null) {
        _questions[questionIndex].type = type;
        if (type == QuestionType.text) {
          _questions[questionIndex].options.clear();
        }
      }
    });
  }

  void _setQuestionText(int questionIndex, String text) {
    setState(() {
      _questions[questionIndex].text = text;
    });
  }

  void _setOptionText(int questionIndex, int optionIndex, String text) {
    setState(() {
      _questions[questionIndex].options[optionIndex] = text;
    });
  }

  void _validateSurveyData() {
  if (_surveyTitle.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Judul survei harus diisi')),
    );
    return;
  }

  if (_surveyDescription.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deskripsi survei harus diisi')),
    );
    return;
  }

    // Memeriksa apakah setidaknya ada satu pertanyaan
  if (_questions.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Setidaknya satu pertanyaan harus ditambahkan')),
    );
    return;
  }

    // Memeriksa apakah setiap pertanyaan memiliki teks
  for (var question in _questions) {
    if (question.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Setiap pertanyaan harus memiliki teks')),
      );
      return;
    }
  }




  _submitSurvey();
}


  Future<void> _submitSurvey() async {
    setState(() {
      _isSubmitting = true;
    });

    String? userId = await SessionManager.getUserId();

    if (userId == null) {
      // Handle the case where the user ID is not available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID not found. Please log in again.')),
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    final surveyData = {
      'action': 'create_survey',
      'judul_survei': _surveyTitle,
      'deskripsi_survei': _surveyDescription,
      'questions': _questions.map((q) => q.toJson()).toList(),
      'id_pengguna': userId,
    };

    try {
      final response = await http.post(
        Uri.parse('https://a2ae-125-164-21-172.ngrok-free.app/SiDataAPI/api/survei.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(surveyData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final int surveyId = int.tryParse(responseBody['id_survei'].toString()) ?? -1;

        if (surveyId != -1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurveySettingsPage(surveyId: surveyId),
            ),
          );
        } else {
          print('Failed to parse survey ID');
        }
      } else {
        print('Failed to submit survey: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
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
            onPressed: _isSubmitting ? null : _validateSurveyData,
            child: _isSubmitting
                ? CircularProgressIndicator()
                : const Text(
                    'Selesai',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                  ),
          ),
        ],
      ),
      body: _isSubmitting
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Judul Survei',
                    ),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    onChanged: (text) {
                      _surveyTitle = text;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Tambahkan deskripsi tentang surveimu',
                    ),
                    onChanged: (text) {
                      _surveyDescription = text;
                    },
                  ),
                  SizedBox(height: 30),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      return QuestionCard(
                        question: _questions[index],
                        onTypeChanged: (type) => _setQuestionType(index, type),
                        onTextChanged: (text) => _setQuestionText(index, text),
                        onOptionAdded: () => _addOption(index),
                        onOptionRemoved: (optionIndex) => _removeOption(index, optionIndex),
                        onOptionTextChanged: (optionIndex, text) => _setOptionText(index, optionIndex, text),
                        onQuestionRemoved: () => _removeQuestion(index),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: FloatingActionButton(
                      onPressed: _addQuestion,
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

enum QuestionType { text, radio, checkbox }

class Question {
  QuestionType type;
  String text;
  List<String> options;

  Question({required this.type, this.text = '', required this.options});

  Map<String, dynamic> toJson() {
    return {
      'question': text,
      'questionType': type.toString().split('.').last,
      'options': options,
    };
  }
}

class QuestionCard extends StatelessWidget {
  final Question question;
  final ValueChanged<QuestionType?> onTypeChanged;
  final ValueChanged<String> onTextChanged;
  final VoidCallback onOptionAdded;
  final ValueChanged<int> onOptionRemoved;
  final Function(int, String) onOptionTextChanged;
  final VoidCallback onQuestionRemoved;

  QuestionCard({
    required this.question,
    required this.onTypeChanged,
    required this.onTextChanged,
    required this.onOptionAdded,
    required this.onOptionRemoved,
    required this.onOptionTextChanged,
    required this.onQuestionRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<QuestionType>(
                  value: question.type,
                  items: QuestionType.values.map((QuestionType type) {
                    return DropdownMenuItem<QuestionType>(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: onTypeChanged,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Pertanyaan',
                  ),
                  onChanged: onTextChanged,
                ),
                if (question.type != QuestionType.text)
                  Column(
                    children: question.options.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String val = entry.value;
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Opsi ${idx + 1}',
                              ),
                              onChanged: (text) {
                                onOptionTextChanged(idx, text);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close_rounded),
                            onPressed: () {
                              onOptionRemoved(idx);
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                if (question.type != QuestionType.text)
                  TextButton(
                    onPressed: onOptionAdded,
                    child: Text('Tambah Opsi'),
                  ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close_rounded),
                onPressed: onQuestionRemoved,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
