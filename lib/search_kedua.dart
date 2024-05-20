import 'package:flutter/material.dart';
import 'survei_pembuka.dart';
import 'survei_card.dart';

class SearchKedua extends StatelessWidget {
  const SearchKedua({Key? key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    searchController.text = "Penggunaan e-money";

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Cari survei',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          SurveiCard(
            title: 'Survei Responden Terhadap Penggunaan Aplikasi E-Money',
            author: 'Dyasningrum',
            imagePath: 'assets/hdr1.png', 
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PembukaSurvei(
                    title:
                        'Survei Responden Terhadap Penggunaan Aplikasi E-Money',
                  ),
                ),
              );
            },
          ),
          SurveiCard(
            title: 'Survei Responden Terhadap Fenomena Trend Thrifting',
            author: 'Arinda Lutvia',
            imagePath: 'assets/hdr2.png', 
            onTap: () {},
          ),
          SurveiCard(
            title: 'Survei Preferensi dalam Penggunaan Sistem Operasi',
            author: 'Naufal Andika',
            imagePath: 'assets/hdr3.png', 
            onTap: () {},
          ),
          SurveiCard(
            title: 'Survei Responden Terhadap Penggunaan Aplikasi E-Money',
            author: 'Jonathan Alvaro',
            imagePath:
                'assets/hdr4.png', 
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PembukaSurvei(
                    title:
                        'Survei Responden Terhadap Penggunaan Aplikasi E-Money',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
