import 'package:flutter/material.dart';

class PemantauanPages extends StatefulWidget {
  const PemantauanPages({super.key});

  @override
  State<PemantauanPages> createState() => _PemantauanPagesState();
}

class _PemantauanPagesState extends State<PemantauanPages> {
  final List<Map<String, dynamic>> menuItems = [
    {"title": "Informasi Tatacara Pengisian", "icon": Icons.info_outline},
    {"title": "Pantau Lingkungan", "icon": Icons.landscape},
    {"title": "Pantau Tanaman", "icon": Icons.local_florist},
    {"title": "Hama dan Penyakit", "icon": Icons.bug_report},
    {"title": "Pembudidayaan", "icon": Icons.agriculture},
    {"title": "Isi Panen", "icon": Icons.shopping_basket},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pemantauan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )
        ),
        backgroundColor: const Color(0xFFD8A37E),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/monitoring.jpg',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...menuItems.map((item) => buildListTile(context, item["icon"], item["title"], () {
              // Tambahkan navigasi atau aksi yang sesuai di sini
            })),
          ],
        ),
      ),
    );
  }

  Widget buildListTile(BuildContext context, IconData icon, String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFFD8A37E), size: 24),
          title: Text(text, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
      ),
    );
  }
}
