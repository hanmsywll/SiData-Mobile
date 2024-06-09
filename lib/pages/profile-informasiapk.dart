import 'package:flutter/material.dart';

class InformasiAplikasiPage extends StatelessWidget {
  const InformasiAplikasiPage({super.key});

  void _showFullImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.contain,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Aplikasi'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/Frame.png', // Ensure the image is added to your assets folder and listed in pubspec.yaml
            fit: BoxFit.cover,
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Versi aplikasi'),
                  onTap: () {
                    _showFullImageDialog(context, 'assets/versi aplikasi.png');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Kebijakan privasi'),
                  onTap: () {
                    _showFullImageDialog(context, 'assets/kebijakan privasi.png');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.rule),
                  title: const Text('Syarat dan ketentuan pengguna'),
                  onTap: () {
                    _showFullImageDialog(context, 'assets/syarat dan ketentuan pengguna.png');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.developer_mode),
                  title: const Text('Detail pengembang'),
                  onTap: () {
                    _showFullImageDialog(context, 'assets/detail pengembang.png');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
