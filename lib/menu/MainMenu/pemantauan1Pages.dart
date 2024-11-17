import 'package:apps/SendApi/ghApi.dart';
import 'package:apps/menu/MainMenu/hamaPenyakitPages.dart';
import 'package:apps/menu/MainMenu/isiPanenPages.dart';
import 'package:apps/menu/MainMenu/pantauLingkunganPages.dart';
import 'package:apps/menu/MainMenu/pantauTanamanPages.dart';
import 'package:apps/menu/MainMenu/pembudidayaanPages.dart';
import 'package:apps/menu/MainMenu/tatacaraPemantauanPages.dart';
import 'package:apps/src/pageTransition.dart';
import 'package:flutter/material.dart';

class Pemantauan1pages extends StatelessWidget {
  const Pemantauan1pages({super.key});

  @override
  Widget build(BuildContext context) {
    return const PemantauanPage();
  }
}

class PemantauanPage extends StatelessWidget {
  const PemantauanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pemantauan',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 35.0),
          child: Column(
            children: [
              buildMenuButtonTP(
                context,
                'assets/images/tatacara.png', // Sesuaikan path gambar
                'Tatacara Penggunaan',
                tatacaraPemantauanPages(),
                // Tambahkan navigasi
              ),
              buildMenuButton(
                context,
                'assets/images/pantau lingkungan.png',
                'Pantau Lingkungan',
                PantauLingkunganPages(),
              ),
              buildMenuButton(
                context,
                'assets/images/pantau tanaman.png',
                'Pantau Tanaman',
                PantauTanamanPages(),
              ),
              buildMenuButton(
                context,
                'assets/images/hama.png',
                'Hama & Penyakit',
                HamaPenyakitPages(),
              ),
              buildMenuButton(
                context,
                'assets/images/pembudidayaan.png',
                'Pembudidayaan',
                PembudidayaanPages(),
              ),
              buildMenuButton(
                context,
                'assets/images/panen.png',
                'Isi Panen',
                IsiPanenPages(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuButton(
      BuildContext context, String imagePath, String text, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black,
            width: 0.8,
          ),
          // Menghapus boxShadow property
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
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(11),
                      bottomLeft: Radius.circular(11),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'NotoSan',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuButtonTP(
      BuildContext context, String imagePath, String text, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black,
            width: 0.8,
          ),
          // Menghapus boxShadow property
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(context, SmoothPageTransition(page: page));
            },
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(11),
                      bottomLeft: Radius.circular(11),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'NotoSan',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
