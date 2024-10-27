import 'package:flutter/material.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/topnav.dart';

class PantauLingkunganPages extends StatefulWidget {
  const PantauLingkunganPages({super.key});

  @override
  State<PantauLingkunganPages> createState() => _PantauLingkunganPagesState();
}

class _PantauLingkunganPagesState extends State<PantauLingkunganPages> {
  String? selectedGreenhouse;
  final TextEditingController phController = TextEditingController();
  final TextEditingController ppmController = TextEditingController();
  final TextEditingController suhuController = TextEditingController();
  final TextEditingController kelembapanController = TextEditingController();

  // Daftar greenhouse (contoh)
  final List<String> greenhouseList = ['GH-01', 'GH-02', 'GH-03'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Topnav(
          title: 'Pantau Lingkungan',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/pantau lingkungan.png', // Pastikan gambar tersedia
                  height: 200,
                ),
              ),
              const SizedBox(height: 30),

              // Dropdown Greenhouse
              CustomDropdown(
                labelText: 'Greenhouse',
                hintText: 'Pilih Greenhouse',
                value: selectedGreenhouse ?? greenhouseList[0],
                items: greenhouseList,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGreenhouse = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),

              // PH Tanaman
              CustomFormField(
                controller: phController,
                labelText: 'PH Tanaman',
                hintText: 'Masukan PH Tanaman',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // PPM Tanaman
              CustomFormField(
                controller: ppmController,
                labelText: 'PPM Tanaman',
                hintText: 'Masukan PPM Tanaman',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Suhu Greenhouse
              CustomFormField(
                controller: suhuController,
                labelText: 'Suhu Greenhouse',
                hintText: 'Masukan Suhu Tanaman',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Kelembapan Polibag
              CustomFormField(
                controller: kelembapanController,
                labelText: 'Kelembapan Polibag',
                hintText: 'Masukan Kelembapan Polibag',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),

              // Tombol Simpan (opsional, sesuai kebutuhan)
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      // Implementasi logika simpan
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFF0165FF), // Sesuaikan dengan warna tema
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'NotoSanSemiBold',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    phController.dispose();
    ppmController.dispose();
    suhuController.dispose();
    kelembapanController.dispose();
    super.dispose();
  }
}
