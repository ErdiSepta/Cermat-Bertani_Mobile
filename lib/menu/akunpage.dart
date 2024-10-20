import 'package:apps/menu/profilakunpage.dart';
import 'package:apps/menu/profilgh.dart';
import 'package:apps/menu/tambahghpage.dart';
import 'package:apps/menu/tentangapk.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Akunpage());
}

class Akunpage extends StatelessWidget {
  const Akunpage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AkunSettingsPage(); // Hapus MaterialApp di sini
  }
}

class AkunSettingsPage extends StatelessWidget {
  const AkunSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        centerTitle: true,
        backgroundColor: const Color(0xFFD8A37E), // Sesuaikan warna AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar profil
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/avatar.png'), // Pastikan file ada di folder assets
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
            buildButton(
                context, 'Tentang Aplikasi', const TentangAplikasiPage()),
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: 331, // Lebar tombol
        height: 52, // Tinggi tombol
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD8A37E), // Warna tombol D8A37E
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10), // Membuat tombol melengkung
            ),
            textStyle: const TextStyle(
                color: Colors.white), // Menambahkan warna teks putih
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 18, color: Colors.white), // Teks putih
          ),
        ),
      ),
    );
  }
}

// Halaman Profil Akun
// class ProfilAkunPage extends StatelessWidget {
//   const ProfilAkunPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profil Akun'),
//         backgroundColor: const Color(0xFFD8A37E), // Warna yang sama pada AppBar
//       ),
//       body: const Center(
//         child: Text('Halaman Profil Akun'),
//       ),
//     );
//   }
// }

// Halaman Tambah GH
// class TambahGHPage extends StatelessWidget {
//   const TambahGHPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tambah GH'),
//         backgroundColor: const Color(0xFFD8A37E), // Warna yang sama pada AppBar
//       ),
//       body: const Center(
//         child: Text('Halaman Tambah GH'),
//       ),
//     );
//   }
// }

// Halaman Profil GH
// class ProfilGHPage extends StatelessWidget {
//   const ProfilGHPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profil GH'),
//         backgroundColor: const Color(0xFFD8A37E), // Warna yang sama pada AppBar
//       ),
//       body: const Center(
//         child: Text('Halaman Profil GH'),
//       ),
//     );
//   }
// }

// Halaman Tentang Aplikasi
// class TentangAplikasiPage extends StatelessWidget {
//   const TentangAplikasiPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tentang Aplikasi'),
//         backgroundColor: const Color(0xFFD8A37E), // Warna yang sama pada AppBar
//       ),
//       body: const Center(
//         child: Text('Halaman Tentang Aplikasi'),
//       ),
//     );
//   }
// }
