import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'isisurvei-penutup.dart';
import '../utils/session_manager.dart'; // Import SessionManager

class SurveyQuestionsPage extends StatefulWidget {
  final int idSurvei;

  const SurveyQuestionsPage({super.key, required this.idSurvei});

  @override
  _SurveyQuestionsPageState createState() => _SurveyQuestionsPageState();
}

class _SurveyQuestionsPageState extends State<SurveyQuestionsPage> {
  late Future<List<Question>> futureQuestions;
  List<Answer> answers = [];
  String surveyTitle = '';
  String? userId;

  @override
  void initState() {
    super.initState();
    fetchSurveyTitle(widget.idSurvei);
    futureQuestions = fetchQuestions(widget.idSurvei);
    getUserId(); // Get user ID
  }

  Future<void> getUserId() async {
    userId = await SessionManager.getUserId();
  }

  Future<void> fetchSurveyTitle(int id) async {
    final response = await http.get(Uri.parse(
        'https://9525-103-161-206-36.ngrok-free.app/SiDataAPI/api/survey.php?id=$id'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      if (jsonResponse.isNotEmpty) {
        setState(() {
          surveyTitle = jsonResponse[0]['judul_survei'];
        });
      }
    } else {
      throw Exception('Gagal untuk menampilkan judul survei');
    }
  }

  Future<List<Question>> fetchQuestions(int id) async {
    final response = await http.get(Uri.parse(
        'https://9525-103-161-206-36.ngrok-free.app/SiDataAPI/api/survey.php?id=$id'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Question.fromJson(data)).toList();
    } else {
      throw Exception('Gagal untuk menampilkan pertanyaan');
    }
  }

  void submitAnswers() async {
    if (answers.length != (await futureQuestions).length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda belum menjawab seluruh pertanyaan!')),
      );
      return;
    }

    // Wait for userId to be retrieved
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendapatkan ID pengguna')),
      );
      return;
    }

    // Add userId to each answer
    final updatedAnswers = answers.map((a) {
      a.idPengguna = int.parse(userId!);
      return a;
    }).toList();

    final response = await http.post(
      Uri.parse(
          'https://9525-103-161-206-36.ngrok-free.app/SiDataAPI/api/insert_jawaban.php'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'answers': updatedAnswers.map((a) => a.toJson()).toList()}),
    );

    if (response.statusCode == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PenutupSurvei(surveyTitle: surveyTitle),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan jawaban')),
      );
    }
  }

  void updateAnswer(Answer answer) {
    setState(() {
      answers.removeWhere((a) => a.idPertanyaan == answer.idPertanyaan);
      answers.add(answer);
    });
  }

  Future<void> showConfirmationDialog() async {
    final bool? shouldSubmit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin menyelesaikan survei?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Ya'),
            ),
          ],
        );
      },
    );

    if (shouldSubmit == true) {
      submitAnswers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            text: surveyTitle.isEmpty ? 'Survey Questions' : 'Isi Survei',
            style: TextStyle(
                color: surveyTitle.isEmpty ? Colors.white : Colors.white,
                fontSize: 24),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Question>>(
        future: futureQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Pertanyaan tidak tersedia'));
          } else {
            List<Question> questions = snapshot.data!;
            return ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return QuestionWidget(
                  question: questions[index],
                  onAnswered: updateAnswer,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showConfirmationDialog,
        backgroundColor: Colors.white,
        child: Icon(Icons.save, size: 40),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final Question question;
  final Function(Answer) onAnswered;

  const QuestionWidget(
      {super.key, required this.question, required this.onAnswered});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? selectedRadioOption;
  List<String> selectedCheckboxOptions = [];
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      submitAnswer();
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void submitAnswer() {
    if (widget.question.questionType == 'text') {
      widget.onAnswered(Answer(
        idPertanyaan: widget.question.id,
        isiJawaban: textController.text,
      ));
    } else if (widget.question.questionType == 'radio') {
      widget.onAnswered(Answer(
        idPertanyaan: widget.question.id,
        isiJawaban: selectedRadioOption ?? '',
      ));
    } else if (widget.question.questionType == 'checkbox') {
      widget.onAnswered(Answer(
        idPertanyaan: widget.question.id,
        isiJawaban: selectedCheckboxOptions.join(', '),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question.question,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (widget.question.questionType == 'text')
              TextField(
                controller: textController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              )
            else if (widget.question.questionType == 'radio')
              ...widget.question.options.map((option) => RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: selectedRadioOption,
                    onChanged: (value) {
                      setState(() {
                        selectedRadioOption = value;
                        submitAnswer();
                      });
                    },
                  ))
            else if (widget.question.questionType == 'checkbox')
              ...widget.question.options.map((option) => CheckboxListTile(
                    title: Text(option),
                    value: selectedCheckboxOptions.contains(option),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedCheckboxOptions.add(option);
                        } else {
                          selectedCheckboxOptions.remove(option);
                        }
                        submitAnswer();
                      });
                    },
                  )),
          ],
        ),
      ),
    );
  }
}

class Question {
  final int id;
  final String question;
  final String questionType;
  final List<String> options;

  Question({
    required this.id,
    required this.question,
    required this.questionType,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    List<String> options = [];
    if (json['pilihan'] != null && json['pilihan'].isNotEmpty) {
      options = json['pilihan'].split(', ');
    }
    return Question(
      id: json['id_pertanyaan'],
      question: json['pertanyaan'],
      questionType: json['jenis_pertanyaan'],
      options: options,
    );
  }
}

class Answer {
  final int idPertanyaan;
  final String isiJawaban;
  int? idPengguna;

  Answer({required this.idPertanyaan, required this.isiJawaban, this.idPengguna});

  Map<String, dynamic> toJson() {
    return {
      'id_pertanyaan': idPertanyaan,
      'isi_jawaban': isiJawaban,
      'id_pengguna': idPengguna,
    };
  }
}
