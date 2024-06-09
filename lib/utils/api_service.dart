import 'dart:convert';
import 'package:http/http.dart' as http;
import '../pages/peringkat.dart';

Future<List<Peringkat>> fetchPeringkat() async {
  final response = await http.get(Uri.parse('https://7cab-114-122-79-93.ngrok-free.app/SiDataAPI/api/peringkat.php'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Peringkat.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load peringkat');
  }
}