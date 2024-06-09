import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../utils/session_manager.dart';

class AkunSaya extends StatefulWidget {
  const AkunSaya({super.key});

  @override
  _AkunSayaState createState() => _AkunSayaState();
}

class _AkunSayaState extends State<AkunSaya> {
  String? email;
  String? username;
  String? profileImage;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final userId = await SessionManager.getUserId();
    if (userId == null) return;

    try {
      final response = await http.get(
        Uri.parse('https://7cab-114-122-79-93.ngrok-free.app/SiDataAPI/api/profile.php?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          email = data['email'];
          username = data['nama'];
          profileImage = data['pp'];
          emailController.text = email!;
          usernameController.text = username!;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch profile data')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = await SessionManager.getUserId();
    if (userId == null) return;

    try {
      final response = await http.post(
        Uri.parse('https://7cab-114-122-79-93.ngrok-free.app/SiDataAPI/api/update_profile.php'),
        body: jsonEncode({
          'user_id': userId,
          'email': emailController.text,
          'username': usernameController.text,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          isEditing = false;
          email = emailController.text;
          username = usernameController.text;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final userId = await SessionManager.getUserId();
      if (userId == null) return;

      try {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('https://7cab-114-122-79-93.ngrok-free.app/SiDataAPI/api/upload_profile_image.php'),
        );
        request.fields['user_id'] = userId;
        request.files.add(await http.MultipartFile.fromPath('image', pickedFile.path));

        final response = await request.send();
        if (response.statusCode == 200) {
          final responseData = await http.Response.fromStream(response);
          final data = jsonDecode(responseData.body);

          setState(() {
            profileImage = data['image_url'];
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile image updated successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload profile image')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: isEditing ? _pickImage : null,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImage != null && profileImage!.isNotEmpty
                        ? NetworkImage(profileImage!)
                        : AssetImage('assets/avatar.png') as ImageProvider,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  username ?? '',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                buildProfileField(
                  icon: Icons.email,
                  label: 'Email',
                  controller: emailController,
                  isEditable: isEditing,
                ),
                buildProfileField(
                  icon: Icons.person_outline,
                  label: 'Username',
                  controller: usernameController,
                  isEditable: isEditing,
                ),
                if (isEditing)
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text('Simpan'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool isEditable,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  enabled: isEditable,
                  decoration: InputDecoration(
                    border: isEditable ? const UnderlineInputBorder() : InputBorder.none,
                    contentPadding: const EdgeInsets.only(top: 4),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '$label tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
