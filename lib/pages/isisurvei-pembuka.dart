import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'isisurvei-pertanyaan.dart';

class PembukaSurvei extends StatefulWidget {
  final int idSurvei;

  const PembukaSurvei({super.key, required this.idSurvei});

  @override
  _PembukaSurveiState createState() => _PembukaSurveiState();
}

class _PembukaSurveiState extends State<PembukaSurvei> {
  late Future<SurveyDetails> futureSurveyDetails;

  @override
  void initState() {
    super.initState();
    futureSurveyDetails = fetchSurveyDetails(widget.idSurvei);
  }

  Future<SurveyDetails> fetchSurveyDetails(int id) async {
    final response = await http.get(Uri.parse(
        'https://9525-103-161-206-36.ngrok-free.app/SiDataAPI/api/survey.php?id=$id'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return SurveyDetails.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load survey details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<SurveyDetails>(
          future: futureSurveyDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Survey not found'));
            } else {
              SurveyDetails surveyDetails = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/header_isisurvei.png'),
                  const SizedBox(height: 16.0),
                  Text(
                    surveyDetails.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    surveyDetails.description,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Pratinjau Pertanyaan:',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 8.0),
                  ...surveyDetails.questions
                      .map((q) => Text(
                            q.question,
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.left,
                          ))
                      .toList(),
                  const SizedBox(height: 40.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                SurveyQuestionsPage(idSurvei: widget.idSurvei)),
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
              );
            }
          },
        ),
      ),
    );
  }
}

class SurveyDetails {
  final String title;
  final String description;
  final List<Question> questions;

  SurveyDetails({
    required this.title,
    required this.description,
    required this.questions,
  });

  factory SurveyDetails.fromJson(List<dynamic> json) {
    String title = json[0]['judul_survei'];
    String description = json[0]['deskripsi_survei'];
    List<Question> questions = json.map((q) => Question.fromJson(q)).toList();

    return SurveyDetails(
      title: title,
      description: description,
      questions: questions,
    );
  }
}

class Question {
  final String question;
  final String questionType;
  final List<String> options;

  Question({
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
      question: json['pertanyaan'],
      questionType: json['jenis_pertanyaan'],
      options: options,
    );
  }
}
