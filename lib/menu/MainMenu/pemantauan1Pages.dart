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
            fontFamily: 'OdorMeanChey',  // Mengubah font family sesuai topnav
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
              buildMenuButton(
                context,
                'assets/images/tatacara.png', // Sesuaikan path gambar
                'Tatacara Penggunaan',
                () {
                  Navigator.push(
                    context,
                    SmoothPageTransition(
                      page: const tatacaraPemantauanPages(),
                    ),
                  );
                }, // Tambahkan navigasi
              ),
              buildMenuButton(
                context,
                'assets/images/pantau lingkungan.png',
                'Pantau Lingkungan',
                () {
                  Navigator.push(
                    context,
                    SmoothPageTransition(
                      page: const PantauLingkunganPages(),
                    ),
                  );
                },
              ),
              buildMenuButton(
                context,
                'assets/images/pantau tanaman.png',
                'Pantau Tanaman',
                () {
                  Navigator.push(
                    context,
                    SmoothPageTransition(
                      page: const PantauTanamanPages(),
                    ),
                  );
                },
              ),
              buildMenuButton(
                context,
                'assets/images/hama.png',
                'Hama & Penyakit',
                () {
                  Navigator.push(
                    context,
                    SmoothPageTransition(
                      page: const HamaPenyakitPages(),
                    ),
                  );
                },
              ),
              buildMenuButton(
                context,
                'assets/images/pembudidayaan.png',
                'Pembudidayaan',
                () {
                  Navigator.push(
                    context,
                    SmoothPageTransition(
                      page: const PembudidayaanPages(),
                    ),
                  );
                },
              ),
              buildMenuButton(
                context,
                'assets/images/panen.png',
                'Isi Panen',
                () {
                  Navigator.push(
                    context,
                    SmoothPageTransition(
                      page: const IsiPanenPages(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuButton(
      BuildContext context, String imagePath, String text, VoidCallback onTap) {
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
            onTap: onTap,
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
