import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart'; // Pastikan path import ini benar

class ProfilGHPage extends StatefulWidget {
  const ProfilGHPage({Key? key}) : super(key: key);

  @override
  _ProfilGHPageState createState() => _ProfilGHPageState();
}

class _ProfilGHPageState extends State<ProfilGHPage> {
  String selectedGH = 'GH 1';
  
  final Map<String, Map<String, String>> ghData = {
    'GH 1': {
      'nama': 'Green House 1',
      'fokus': 'Tomat',
      'metode': 'Hidroponik',
      'alamat': 'Jl. Contoh No. 1',
      'gambar': 'assets/images/gh1.jpg',
    },
    'GH 2': {
      'nama': 'Green House 2',
      'fokus': 'Selada',
      'metode': 'Aeroponik',
      'alamat': 'Jl. Contoh No. 2',
      'gambar': 'assets/images/gh2.jpg',
    },
    'GH 3': {
      'nama': 'Green House 3',
      'fokus': 'Paprika',
      'metode': 'Akuaponik',
      'alamat': 'Jl. Contoh No. 3',
      'gambar': 'assets/images/gh3.jpg',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Topnav(
          title: 'Profil GH',
          showBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar GH
            Center(
              child: Container(
                width: 250, // Ukuran lebar gambar
                height: 250, // Ukuran tinggi gambar
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20), // Sudut membulat
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    ghData[selectedGH]?['gambar'] ?? 'assets/images/default_gh.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return Center(child: Text('Gambar tidak tersedia'));
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            
            // Dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: selectedGH,
                isExpanded: true,
                underline: SizedBox(),
                items: ghData.keys.map((String gh) {
                  return DropdownMenuItem<String>(
                    value: gh,
                    child: Text(gh),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGH = newValue!;
                  });
                },
              ),
            ),
            SizedBox(height: 24),
            
            // Data GH
            buildInfoRow('Nama GH', ghData[selectedGH]!['nama']!),
            buildInfoRow('Fokus', ghData[selectedGH]!['fokus']!),
            buildInfoRow('Metode', ghData[selectedGH]!['metode']!),
            buildInfoRow('Alamat', ghData[selectedGH]!['alamat']!),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
