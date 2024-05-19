import 'package:flutter/material.dart';
import 'bantuan.dart';
import 'akunsaya.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/avatar.png'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Rahesal',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextButton.icon(
                onPressed: () {
                  // Aksi untuk tombol edit
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
                child: const Text(
                  'Gabung Sejak 11 Januari 2023',
                  style: TextStyle(color: Colors.white),
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
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.monetization_on, color: Colors.amber),
                    SizedBox(width: 8),
                    Text(
                      'Point kamu\n1000 Pts',
                      style: TextStyle(fontSize: 16),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AkunSaya()),
                  );
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
                  // Aksi untuk navigasi ke halaman Informasi Aplikasi
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifikasi'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Aksi untuk navigasi ke halaman Notifikasi
                },
              ),
              const Divider(),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  // Aksi untuk tombol keluar
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
