import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'lihatsurvei-jawaban.dart';
import 'buatsurvei.dart';
import 'buatsurvei-edit.dart'; // Import laman EditSurveyPage

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  late Future<List<dynamic>> _surveysFuture;

  @override
  void initState() {
    super.initState();
    _surveysFuture = fetchSurveys();
  }

  Future<List<dynamic>> fetchSurveys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId == null) {
      throw Exception("User ID not found in session");
    }

    final response = await http.get(Uri.parse('https://9525-103-161-206-36.ngrok-free.app/SiDataAPI/api/get_surveys.php?user_id=$userId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to load surveys');
    }
  }

  Future<void> deleteSurvey(int surveyId) async {
    final response = await http.delete(Uri.parse('https://9525-103-161-206-36.ngrok-free.app/SiDataAPI/api/delete_survey.php?id_survei=$surveyId'));

    if (response.statusCode == 200) {
      setState(() {
        _surveysFuture = fetchSurveys();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Survey deleted successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete survey')));
    }
  }

  void _confirmDelete(int surveyId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Apakah Anda yakin ingin menghapus survei ini beserta semua jawabannya?"),
          actions: <Widget>[
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Hapus"),
              onPressed: () {
                Navigator.of(context).pop();
                deleteSurvey(surveyId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Buat Survei'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: screenWidth,
                  child: Image.asset(
                    'assets/home_buat_survei.jpg',
                    width: screenWidth,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Batas pengajuan survei yang kamu miliki:',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1/1 kesempatan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateSurveyPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text('Buat Survei', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Divider(),
              SizedBox(height: 25),
              Text(
                'Lihat Survei mu',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              FutureBuilder<List<dynamic>>(
                future: _surveysFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return Text(
                      'Kamu belum pernah membuat survei',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    );
                  } else if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!.map<Widget>((survey) {
                        return TemplateCard(
                          imagePath: 'assets/home_buat_survei.jpg',
                          title: survey['judul_survei'],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SurveyAnswersPage(surveyId: survey['id_survei']),
                              ),
                            );
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditSurveyPage(surveyId: survey['id_survei']),
                              ),
                            );
                          },
                          onDelete: () {
                            _confirmDelete(survey['id_survei']);
                          },
                        );
                      }).toList(),
                    );
                  }
                  return Container();
                },
              ),
              SizedBox(height: 25),
              Divider(),
              SizedBox(height: 25),
              Text(
                'Buat dengan template',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TemplateCard(
                imagePath: 'assets/template1.jpg',
                title: 'Kuesioner Pengukuran Kualitas Jasa dengan Metode SERVQUAL',
                onTap: () {},
              ),
              SizedBox(height: 16),
              TemplateCard(
                imagePath: 'assets/template2.jpg',
                title: 'Kuesioner Maslach Burnout Inventory (Maslach dan Jackson, 1981)',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TemplateCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  TemplateCard({required this.imagePath, required this.title, required this.onTap, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.9;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: cardWidth,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  child: Image.asset(
                    imagePath,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (onEdit != null || onDelete != null)
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (onEdit != null)
                        TextButton(
                          onPressed: onEdit,
                          child: Text('Edit'),
                        ),
                      if (onDelete != null)
                        TextButton(
                          onPressed: onDelete,
                          child: Text('Hapus'),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
