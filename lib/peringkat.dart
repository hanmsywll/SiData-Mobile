import 'package:flutter/material.dart';

class PeringkatPage extends StatelessWidget {
  const PeringkatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responden Paling Aktif'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              // Aksi untuk tombol info
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Edisi Bulan Mei',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTopResponder(
                    rank: 2,
                    name: 'Sophia',
                    points: 1450,
                    imagePath: 'assets/sophia.jpg',
                  ),
                  _buildTopResponder(
                    rank: 1,
                    name: 'Kevin',
                    points: 1500,
                    imagePath: 'assets/kevin.jpg',
                    isCrown: true,
                  ),
                  _buildTopResponder(
                    rank: 3,
                    name: 'Alex',
                    points: 1400,
                    imagePath: 'assets/alex.jpg',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildRankedResponder(
                rank: 5,
                name: 'Rahesal (me)',
                university: 'Telkom University',
                surveys: 200,
                points: 1000,
                imagePath: 'assets/avatar.png',
                isCurrentUser: true,
              ),
              const Divider(height: 32, color: Colors.grey),
              _buildRankedResponder(
                rank: 1,
                name: 'Kevin',
                university: 'Telkom University',
                surveys: 300,
                points: 1500,
                imagePath: 'assets/kevin.jpg',
              ),
              _buildRankedResponder(
                rank: 2,
                name: 'Sophia',
                university: 'Telkom University',
                surveys: 290,
                points: 1450,
                imagePath: 'assets/sophia.jpg',
              ),
              _buildRankedResponder(
                rank: 3,
                name: 'Alex',
                university: 'Institut Teknologi Bandung',
                surveys: 280,
                points: 1400,
                imagePath: 'assets/alex.jpg',
              ),
              _buildRankedResponder(
                rank: 4,
                name: 'Raiden',
                university: 'Universitas Airlangga',
                surveys: 260,
                points: 1300,
                imagePath: 'assets/raiden.jpg',
              ),
              _buildRankedResponder(
                rank: 5,
                name: 'Rahesal (me)',
                university: 'Telkom University',
                surveys: 200,
                points: 1000,
                imagePath: 'assets/avatar.png',
                isCurrentUser: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopResponder({
    required int rank,
    required String name,
    required int points,
    required String imagePath,
    bool isCrown = false,
  }) {
    return Column(
      children: [
        if (isCrown) const Icon(Icons.emoji_events, color: Colors.orange, size: 32),
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(height: 8),
        Text(
          '$rank. $name',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('$points Pts'),
      ],
    );
  }

  Widget _buildRankedResponder({
    required int rank,
    required String name,
    required String university,
    required int surveys,
    required int points,
    required String imagePath,
    bool isCurrentUser = false,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imagePath),
      ),
      title: Text(name),
      subtitle: Text('$university\n$surveys survei telah diisi'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$points Pts'),
          if (isCurrentUser) const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      tileColor: isCurrentUser ? Colors.orange.shade100 : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.grey, width: 0.5),
      ),
    );
  }
}
