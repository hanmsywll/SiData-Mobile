import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditSurveyPage extends StatefulWidget {
  final int surveyId;

  EditSurveyPage({required this.surveyId});

  @override
  _EditSurveyPageState createState() => _EditSurveyPageState();
}

class _EditSurveyPageState extends State<EditSurveyPage> {
  final _formKey = GlobalKey<FormState>();
  late Future<Map<String, dynamic>> _surveyDataFuture;
  late String _judulSurvei;
  late String _deskripsiSurvei;
  late String _kategoriSurvei;
  late String _kriteriaResponden;
  late String _targetJumlah;
  late String _tanggalMulai;
  late String _tanggalSelesai;

  @override
  void initState() {
    super.initState();
    _surveyDataFuture = _loadSurveyData();
  }

  Future<Map<String, dynamic>> _loadSurveyData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://7cab-114-122-79-93.ngrok-free.app/SiDataAPI/api/get_surveys.php?id_survei=${widget.surveyId}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic>) {
          return data;
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load survey data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error loading survey data: $error');
      throw Exception('Failed to load survey data');
    }
  }

  Future<void> _editSurvey() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final response = await http.post(
          Uri.parse(
              'https://7cab-114-122-79-93.ngrok-free.app/SiDataAPI/api/update_survey.php'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'id_survei': widget.surveyId.toString(),
            'judul_survei': _judulSurvei,
            'deskripsi_survei': _deskripsiSurvei,
            'kategori_survei': _kategoriSurvei,
            'kriteria_responden': _kriteriaResponden,
            'target_jumlah': _targetJumlah,
            'tanggal_mulai': _tanggalMulai,
            'tanggal_selesai': _tanggalSelesai,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Survey updated successfully')));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update survey')));
          throw Exception('Failed to update survey');
        }
      } catch (error) {
        print('Error updating survey: $error');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update survey')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Survei'),
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
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
            child: FutureBuilder<Map<String, dynamic>>(
              future: _surveyDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  var data = snapshot.data!;
                  _judulSurvei = data['judul_survei'] ?? '';
                  _deskripsiSurvei = data['deskripsi_survei'] ?? '';
                  _kategoriSurvei = data['kategori_survei'] ?? '';
                  _kriteriaResponden = data['kriteria_responden'] ?? '';
                  _targetJumlah = data['target_jumlah']?.toString() ?? ''; // Convert to String
                  _tanggalMulai = data['tanggal_mulai'] ?? '';
                  _tanggalSelesai = data['tanggal_selesai'] ?? '';

                  return Form(
                    key: _formKey,
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
                                  'Edit Survei',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: _judulSurvei,
                                  decoration: InputDecoration(
                                    labelText: 'Judul Survei',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Judul survei tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _judulSurvei = value!;
                                  },
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: _deskripsiSurvei,
                                  decoration: InputDecoration(
                                    labelText: 'Deskripsi Survei',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Deskripsi survei tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _deskripsiSurvei = value!;
                                  },
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: _kategoriSurvei,
                                  decoration: InputDecoration(
                                    labelText: 'Kategori Survei',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Kategori survei tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _kategoriSurvei = value!;
                                  },
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: _kriteriaResponden,
                                  decoration: InputDecoration(
                                    labelText: 'Kriteria Responden',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Kriteria responden tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _kriteriaResponden = value!;
                                  },
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: _targetJumlah,
                                  decoration: InputDecoration(
                                    labelText: 'Target Jumlah',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Target jumlah tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _targetJumlah = value!;
                                  },
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: _tanggalMulai,
                                  decoration: InputDecoration(
                                    labelText: 'Tanggal Mulai',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Tanggal mulai tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _tanggalMulai = value!;
                                  },
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue: _tanggalSelesai,
                                  decoration: InputDecoration(
                                    labelText: 'Tanggal Selesai',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Tanggal selesai tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _tanggalSelesai = value!;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: _editSurvey,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 15),
                            ),
                            child: const Text('Simpan Perubahan',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
