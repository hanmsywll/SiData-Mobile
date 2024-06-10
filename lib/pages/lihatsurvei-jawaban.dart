import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'lihatsurvei-jawabanindividu.dart';

class SurveyAnswersPage extends StatelessWidget {
  final int surveyId;

  SurveyAnswersPage({required this.surveyId});

  Future<List<dynamic>> fetchRespondents(int surveyId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId == null) {
      throw Exception("User ID not found in session");
    }

    final response = await http.get(Uri.parse(
        'https://20a2-114-122-107-182.ngrok-free.app/SiDataAPI/api/get_surveys.php?user_id=$userId&action=responden&survey_id=$surveyId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load respondents');
    }
  }

  Future<List<dynamic>> fetchSurveyAnswers(int surveyId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId == null) {
      throw Exception("User ID not found in session");
    }

    final response = await http.get(Uri.parse(
        'https://20a2-114-122-107-182.ngrok-free.app/SiDataAPI/api/get_surveys.php?user_id=$userId&action=answers&survey_id=$surveyId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load survey answers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jawaban Survei'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<dynamic>>(
              future: fetchRespondents(surveyId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(child: Text('Maaf, belum terdapat jawaban untuk survei mu.'));
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Responden:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ...snapshot.data!.map<Widget>((respondent) {
                          return ListTile(
                            title: Text(respondent['nama']),
                            leading: Icon(Icons.person),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IndividualAnswersPage(
                                    surveyId: surveyId,
                                    respondentId: respondent['id_pengguna'],
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
            FutureBuilder<List<dynamic>>(
              future: fetchSurveyAnswers(surveyId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(child: Text('Maaf, belum terdapat jawaban untuk survei mu.'));
                } else if (snapshot.hasData) {
                  var questionsMap = <String, List<dynamic>>{};

                  // Organize answers by questions
                  snapshot.data!.forEach((answer) {
                    if (!questionsMap.containsKey(answer['pertanyaan'])) {
                      questionsMap[answer['pertanyaan']] = [];
                    }
                    questionsMap[answer['pertanyaan']]!.add(answer['isi_jawaban']);
                  });

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: questionsMap.entries.map<Widget>((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              ...entry.value.map<Widget>((answer) {
                                return Container(
                                  margin: EdgeInsets.only(top: 8.0),
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(answer),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
