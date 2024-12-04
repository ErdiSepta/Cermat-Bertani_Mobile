import 'package:flutter/cupertino.dart';
import 'package:apps/SendApi/Server.dart';
import 'package:apps/SendApi/ghApi.dart';
import 'package:apps/SendApi/tokenJWT.dart';
import 'package:apps/SendApi/userApi.dart';
import 'package:apps/menu/UserPages/profilakunPages.dart';
import 'package:apps/menu/UserPages/profilghPages.dart';
import 'package:apps/menu/UserPages/tambahghPages.dart';
import 'package:apps/menu/UserPages/tentangapkPages.dart';
import 'package:apps/menu/UserPages/ubahpasswordPages1.dart';
import 'package:apps/src/pageTransition.dart';
import 'package:flutter/material.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Sesuaikan dengan path file login Anda

List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];
GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: 'your-client_id.apps.googleusercontent.com',
  scopes: scopes,
);

class Akunpage extends StatefulWidget {
  const Akunpage({super.key});

  @override
  State<Akunpage> createState() => _AkunpageState();
}

class _AkunpageState extends State<Akunpage> {
  //Awal backend

  bool _isLoading = false;
  String email = "...";
  String nama = "...";
  String foto = "";
  @override
  void initState() {
    super.initState();

    showProfil();
  }

  Future<void> showProfil() async {
    String? email1 = await TokenJwt.getEmail();
    String? token = await TokenJwt.getToken();
    final result = await UserApi.getProfil(email1.toString());
    print('result : $result');
    if (result != null) {
      if (result['status'] == "success") {
        email = result['data']['email'];
        nama = result['data']['nama_lengkap'];
        if (result['data']['foto'] != null) {
          foto = result['data']['foto'];
        }
      } else if (result['status'] == "error") {
        print("Resultt : $result");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pengambilan data gagal email: $email1}')),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pengambilan data gagal token: $token')),
        );
      } else {
        print("Resulttt : $result");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Pengambilan data gagal: ada kesalahan pengiriman data')),
        );
      }
    } else {
      print("gagal : $result");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Pengambilan data gagal: ada kesalahan pengiriman data')),
      );
    }

    setState(() {
      _isLoading = false; // Menyembunyikan loading setelah permintaan selesai
    });
  }

//AKHIR BACKEND
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Akun',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontFamily: 'OdorMeanChey', // Mengubah font family sesuai topnav
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
                ClipOval(
                    child: foto == ""
                        ? Image.asset(
                            'assets/images/Logos Apps.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            Server.UrlImageProfil(foto),
                            width: 100,
                            height: 100,
                          )),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              nama,
              style: TextStyle(
                fontFamily: 'NotoSan',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              email,
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
                const UbahPasswordPage1()),
            buildMenuButtongh(context, Icons.home_work_outlined,
                'Profil Greenhouse', const ProfilGHPage()),
            buildMenuButton(context, Icons.add_circle_outline,
                'Tambah Greenhouse Baru', const TambahghpagePages()),
            buildMenuButton(context, Icons.info_outline, 'Tentang Aplikasi',
                const Tentangapk()),
            // Tombol keluar dengan warna merah
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red, // Mengubah warna menjadi merah
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      _showAlertDialog(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.logout_outlined,
                              color: Colors.white, size: 22),
                          SizedBox(width: 12),
                          Text(
                            'Keluar',
                            style: TextStyle(
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
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Logout'),
        content: Text(
          'Anda yakin ingin logout?',
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              TokenJwt.clearToken();
              TokenJwt.clearEmail();
              await _googleSignIn.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                SmoothPageTransition(page: const Login()),
                (route) => false, // Ini akan menghapus semua halaman sebelumnya
              );
            },
            child: const Text('Yes'),
          ),
        ],
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
              Navigator.push(context, SmoothPageTransition(page: page));
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

  Widget buildMenuButtongh(
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
            onTap: () async {
              final result = await ghApi.getDataGh();
              if (result?['data_gh'] != null && result?['data_gh'] != '[]') {
                print(result?['data_gh']);
                Navigator.push(context, SmoothPageTransition(page: page));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Anda belum memiliki Green House!')),
                );
              }
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
