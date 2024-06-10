import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/session_manager.dart';
import 'profile-bantuan.dart';
import 'profile-akunsaya.dart';
import 'profile-informasiapk.dart'; // Add this line

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  String? joinDate;
  int points = 0;
  String? profileImage;

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
        Uri.parse('https://20a2-114-122-107-182.ngrok-free.app/SiDataAPI/api/profile.php?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          username = data['nama'];
          joinDate = data['waktu_buatakun'];
          points = data['poin'] ?? 0;
          profileImage = data['pp'] ?? 'assets/avatar.png';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch profile data')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    }
  }

  void _logout(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('https://20a2-114-122-107-182.ngrok-free.app/SiDataAPI/api/logout.php'),
      );

      if (response.statusCode == 200) {
        await SessionManager.clearSession();
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal keluar. Status code: ${response.statusCode}')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    }
  }

  void _navigateToAkunSaya(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AkunSaya()),
    ).then((_) => _fetchProfile()); // Refresh profil setelah kembali dari halaman Akun Saya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 40,
                backgroundImage: profileImage != null
                    ? NetworkImage(profileImage!)
                    : AssetImage('assets/avatar.png') as ImageProvider,
              ),
              const SizedBox(height: 8),
              Text(
                username ?? '',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextButton.icon(
                onPressed: () {
                  _navigateToAkunSaya(context);
                },
                icon: const Icon(Icons.edit, color: Colors.orange),
                label: const Text(
                  'Edit',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  joinDate != null
                      ? 'Gabung Sejak $joinDate'
                      : '',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      'Point kamu\n$points Pts',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Akun Saya'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _navigateToAkunSaya(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Bantuan'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BantuanPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Informasi Aplikasi'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InformasiAplikasiPage()), // Update this line
                  );
                },
              ),
              const Divider(),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  _logout(context);
                },
                icon: const Icon(Icons.logout, color: Colors.blue),
                label: const Text(
                  'Keluar',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
