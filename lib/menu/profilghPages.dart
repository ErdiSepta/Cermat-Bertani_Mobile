import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart'; // Pastikan path import ini benar

class ProfilGHPage extends StatefulWidget {
  const ProfilGHPage({super.key});

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
      'gambar': 'assets/images/gh1.png',
    },
    'GH 2': {
      'nama': 'Green House 2',
      'fokus': 'Selada',
      'metode': 'Aeroponik',
      'alamat': 'Jl. Contoh No. 2',
      'gambar': 'assets/images/gh2.png',
    },
    'GH 3': {
      'nama': 'Green House 3',
      'fokus': 'Paprika',
      'metode': 'Akuaponik',
      'alamat': 'Jl. Contoh No. 3',
      'gambar': 'assets/images/gh3.png',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Topnav(
          title: 'Profil GH',
          showBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar GH
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: ClipOval(
                  child: Image.asset(
                    ghData[selectedGH]?['gambar'] ?? 'assets/images/default_gh.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return const Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: selectedGH,
                isExpanded: true,
                underline: const SizedBox(),
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
            const SizedBox(height: 24),

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
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
