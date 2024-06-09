import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'buatsurvei-berhasil.dart';

class SurveySettingsPage extends StatefulWidget {
  final int surveyId;

  SurveySettingsPage({required this.surveyId});

  @override
  _SurveySettingsPageState createState() => _SurveySettingsPageState();
}

class _SurveySettingsPageState extends State<SurveySettingsPage> {
  bool isTechnologyChecked = false;
  bool isHealthChecked = false;
  bool isEducationChecked = false;
  int _targetRespondents = 40;
  DateTime? _startDate;
  DateTime? _endDate;
  String _respondentCategoryDescription = '';

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _getSelectedCategories() {
    List<String> selectedCategories = [];
    if (isTechnologyChecked) selectedCategories.add('Teknologi');
    if (isHealthChecked) selectedCategories.add('Kesehatan');
    if (isEducationChecked) selectedCategories.add('Pendidikan');
    return selectedCategories.join(', ');
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  void _validateSettings() {
    if (_respondentCategoryDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deskripsi kategori responden harus diisi')),
      );
      return;
    }

    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tanggal mulai harus diisi')),
      );
      return;
    }

    if (_endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tanggal selesai harus diisi')),
      );
      return;
    }

    _submitSettings();
  }



  Future<void> _submitSettings() async {
    final settingsData = {
      'action': 'update_survey_settings',
      'id_survei': widget.surveyId,
      'kriteria_responden': _respondentCategoryDescription,
      'target_jumlah': _targetRespondents,
      'startDate': _formatDate(_startDate),
      'endDate': _formatDate(_endDate),
      'categories': _getSelectedCategories(),
    };

    final response = await http.post(
      Uri.parse('https://a2ae-125-164-21-172.ngrok-free.app/SiDataAPI/api/survei.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(settingsData),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmationPage()),
      );
    } else {
      // Handle error
      print('Failed to submit settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        const Text(
                          'Kategori responden',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Deskripsi Kategori Responden',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (text) {
                            setState(() {
                              _respondentCategoryDescription = text;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Target jumlah responden',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (_targetRespondents > 0) _targetRespondents--;
                                });
                              },
                            ),
                            Text('$_targetRespondents', style: TextStyle(fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _targetRespondents++;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Survei akan disebarkan sampai mencapai target jumlah responden yang ditentukan',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Kategori Survei',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        CheckboxListTile(
                          title: const Text('Teknologi'),
                          value: isTechnologyChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isTechnologyChecked = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('Kesehatan'),
                          value: isHealthChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isHealthChecked = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('Pendidikan'),
                          value: isEducationChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isEducationChecked = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Tenggat penyebaran survei',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('Mulai   ', style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _selectDate(context, true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(_startDate != null ? _formatDate(_startDate) : 'Pilih Tanggal'),
                                          Icon(Icons.calendar_today),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Text('Selesai', style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _selectDate(context, false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(_endDate != null ? _formatDate(_endDate) : 'Pilih Tanggal'),
                                          Icon(Icons.calendar_today),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _validateSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    ),
                    child: const Text('Aktifkan survei', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
