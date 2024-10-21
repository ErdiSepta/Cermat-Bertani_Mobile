import 'package:apps/menu/profilakunpage.dart';
import 'package:apps/menu/profilgh.dart';
import 'package:apps/menu/tambahghpage.dart';
import 'package:apps/menu/tentangapk.dart';
import 'package:apps/menu/ubahpassword.dart';
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
          'Akun', 
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )
        ),
        backgroundColor: const Color(0xFFD8A37E),
        elevation: 0,
        centerTitle: true, // Menambahkan ini untuk memposisikan judul di tengah
      ),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFD8A37E),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              const Positioned(
                top: 50, // Sesuaikan nilai ini untuk mengatur posisi vertikal foto profil
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 47,
                    backgroundImage: AssetImage('assets/images/fufufafa.png'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60), // Sesuaikan untuk memberikan ruang di bawah foto profil
          const Text(
            'Mas Ilham',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Text(
            'masilham@gmail.com',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          buildListTile(context, Icons.person_outline, 'Profil Akun', const ProfilAkunPage()),
          buildListTile(context, Icons.info_outline, 'Ubah Password', const UbahPasswordPage()),
          buildListTile(context, Icons.add_circle_outline, 'Tambah GH', const TambahGHPage()),
          buildListTile(context, Icons.home_work_outlined, 'Profil GH', const ProfilGHPage()),
          buildListTile(context, Icons.info_outline, 'Tentang Aplikasi', const TentangAplikasiPage()),
          
        ],
      ),
    );
  }

  Widget buildListTile(BuildContext context, IconData icon, String text, Widget page) {
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
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => page));
          },
        ),
      ),
    );
  }
}
