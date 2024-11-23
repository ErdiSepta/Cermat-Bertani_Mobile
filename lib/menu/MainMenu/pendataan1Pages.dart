import 'package:apps/SendApi/ghApi.dart';
import 'package:apps/menu/MainMenu/rekapHamadanPenyakitPages.dart';
import 'package:apps/menu/MainMenu/rekapIsiPanenPages.dart';
import 'package:apps/menu/MainMenu/rekapPemantauanPages.dart';
import 'package:apps/menu/MainMenu/rekapPembudidayaanPages.dart';
import 'package:apps/src/pageTransition.dart';
import 'package:flutter/material.dart';

class Pendataan1pages extends StatelessWidget {
  const Pendataan1pages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pendataan',
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
              buildMenuButton(
                context,
                'assets/images/pantau tanaman.png',
                'Rekap Pemantauan',
                () async {
                  final result = await ghApi.getDataGh();
                  if (result?['data_gh'] != null &&
                      result?['data_gh'] != '[]') {
                    print(result?['data_gh']);
                    Navigator.push(context,
                        SmoothPageTransition(page: RekapPemantauanPages()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Anda belum memiliki Green House!')),
                    );
                  }
                },
              ),
              buildMenuButton(
                context,
                'assets/images/hama.png',
                'Rekap Hama & Penyakit',
                () async {
                  final result = await ghApi.getDataGh();
                  if (result?['data_gh'] != null &&
                      result?['data_gh'] != '[]') {
                    print(result?['data_gh']);
                    Navigator.push(
                        context,
                        SmoothPageTransition(
                            page: RekapHamadanPenyakitPages()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Anda belum memiliki Green House!')),
                    );
                  }
                },
              ),
              buildMenuButton(
                context,
                'assets/images/pembudidayaan.png',
                'Rekap Pembudidayaan',
                () async {
                  final result = await ghApi.getDataGh();
                  if (result?['data_gh'] != null &&
                      result?['data_gh'] != '[]') {
                    print(result?['data_gh']);
                    Navigator.push(context,
                        SmoothPageTransition(page: RekapPembudidayaanPages()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Anda belum memiliki Green House!')),
                    );
                  }
                },
              ),
              buildMenuButton(
                context,
                'assets/images/panen.png',
                'Rekap Hasil Panen',
                () async {
                  final result = await ghApi.getDataGh();
                  if (result?['data_gh'] != null &&
                      result?['data_gh'] != '[]') {
                    print(result?['data_gh']);
                    Navigator.push(context,
                        SmoothPageTransition(page: RekapIsiPanenPages()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Anda belum memiliki Green House!')),
                    );
                  }
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
