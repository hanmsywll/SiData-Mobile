import 'package:flutter/material.dart';
import 'search_kedua.dart';

class SearchPertama extends StatefulWidget {
  const SearchPertama({super.key});

  @override
  SearchPertamaState createState() => SearchPertamaState();
}

class SearchPertamaState extends State<SearchPertama> {
  List<String> categories = [
    'Semua',
    'Pendidikan',
    'Kesehatan',
    'Teknologi',
    'Olahraga',
    'Makanan',
    'Gaya hidup'
  ];
  String selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari survei',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      Navigator.pushNamed(context, '/search');
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedCategory == categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color.fromARGB(255, 16, 147, 228),
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategory =
                            selected ? categories[index] : 'Semua';
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Penggunaan e-money'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchKedua(),
                      ),
                    );
                  },
                ),
                const ListTile(title: Text('Perilaku mahasiswa')),
                const ListTile(title: Text('Basket')),
                const ListTile(title: Text('Pembelajaran daring')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
