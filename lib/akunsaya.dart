import 'package:flutter/material.dart';

class AkunSaya extends StatelessWidget {
  const AkunSaya({super.key});

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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/avatar.png'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Raihan Mahes Salma',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              buildProfileField(Icons.person, 'Nama Lengkap', 'Raihan Mahes Salma'),
              buildProfileField(Icons.location_city, 'Tempat Lahir', 'Jakarta Selatan, DKI Jakarta, Indonesia'),
              buildProfileField(Icons.cake, 'Tanggal Lahir', '03/04/2003'),
              buildProfileField(Icons.school, 'Asal Universitas', 'Universitas Telkom'),
              buildProfileField(Icons.book, 'Jurusan', 'D3 Sistem Informasi'),
              buildProfileField(Icons.date_range, 'Tahun Angkatan', '2022'),
              buildProfileField(Icons.credit_card, 'Nomor Induk Mahasiswa', '3048202103'),
              buildProfileField(Icons.email, 'Email', 'rahesaltelkom@gmail.com', isEditable: true),
              buildProfileField(Icons.phone, 'No. Telepon', '098374879834', isEditable: true),
              buildProfileField(Icons.person_outline, 'Username', 'Rahesal', isEditable: true),
              buildProfileField(Icons.lock, 'Password', '********', isEditable: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileField(IconData icon, String label, String value, {bool isEditable = false}) {
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
                  initialValue: value,
                  enabled: isEditable,
                  decoration: InputDecoration(
                    border: isEditable
                        ? const UnderlineInputBorder()
                        : InputBorder.none,
                    contentPadding: const EdgeInsets.only(top: 4),
                  ),
                ),
              ),
              if (isEditable)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Handle edit action here
                  },
                ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
