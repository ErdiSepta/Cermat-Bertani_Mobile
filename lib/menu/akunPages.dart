import 'package:apps/menu/profilakunPages.dart';
import 'package:apps/menu/profilghPages.dart';
import 'package:apps/menu/tambahghpagePages.dart';
import 'package:apps/menu/tentangapkPages.dart';
import 'package:apps/menu/ubahpasswordPages.dart';
import 'package:flutter/material.dart';

class Akunpage extends StatelessWidget {
  const Akunpage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AkunSettingsPage();
  }
}

class AkunSettingsPage extends StatelessWidget {
  const AkunSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            fontFamily: 'NotoSan',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Stack(
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.yellow,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage('assets/images/fufufafa.png'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Mas Ilham',
              style: TextStyle(
                fontFamily: 'NotoSan',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'masilham@gmail.com',
              style: TextStyle(
                fontFamily: 'NotoSan',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 25),
            buildMenuButton(context, Icons.person_outline, 'Profil Pengguna',
                const ProfilAkunPage()),
            buildMenuButton(context, Icons.lock_outline, 'Ubah Password',
                const UbahPasswordPage()),
            buildMenuButton(context, Icons.home_work_outlined,
                'Profil Greenhouse', const ProfilGHPage()),
            buildMenuButton(context, Icons.add_circle_outline,
                'Tambah Greenhouse Baru', const TambahGHPage()),
            buildMenuButton(context, Icons.info_outline, 'Tentang Aplikasi',
                const TentangAplikasiPage()),
          ],
        ),
      ),
    );
  }

  Widget buildMenuButton(
      BuildContext context, IconData icon, String text, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => page));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 22),
                  const SizedBox(width: 12),
                  Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'NotoSan',
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
