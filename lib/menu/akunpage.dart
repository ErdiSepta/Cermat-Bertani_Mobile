import 'package:apps/menu/profilakunpage.dart';
import 'package:apps/menu/profilgh.dart';
import 'package:apps/menu/tambahghpage.dart';
import 'package:apps/menu/tentangapk.dart';
import 'package:apps/src/topnav.dart';
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
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Topnav(
          title: 'Pengaturan',
          showBackButton: false, // Tidak perlu tombol kembali di halaman utama
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar profil
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/fufufafa.png'),
            ),
            const SizedBox(height: 10),
            // Nama dan email pengguna
            const Text(
              'Mas Ilham',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'masilham@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            // Tombol-tombol
            buildButton(context, 'Profil Akun', const ProfilAkunPage()),
            buildButton(context, 'Tambah GH', const TambahGHPage()),
            buildButton(context, 'Profil GH', const ProfilGHPage()),
            buildButton(context, 'Tentang Aplikasi', const TentangAplikasiPage()),
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: 331,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD8A37E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          child: Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
