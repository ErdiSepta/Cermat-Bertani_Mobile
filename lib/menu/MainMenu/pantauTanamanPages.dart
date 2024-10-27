import 'package:flutter/material.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/topnav.dart';

class PantauTanamanPages extends StatefulWidget {
  const PantauTanamanPages({super.key});

  @override
  State<PantauTanamanPages> createState() => _PantauTanamanPagesState();
}

class _PantauTanamanPagesState extends State<PantauTanamanPages> {
  String? selectedGreenhouse;
  final TextEditingController tinggiController = TextEditingController();
  final TextEditingController jumlahDaunController = TextEditingController();
  final TextEditingController beratBuahController = TextEditingController();

  // Daftar greenhouse (contoh)
  final List<String> greenhouseList = ['GH-01', 'GH-02', 'GH-03'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Topnav(
          title: 'Pantau Tanaman',
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
                  'assets/images/pantau tanaman.png', // Pastikan gambar tersedia
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

              // Tinggi Tanaman
              CustomFormField(
                controller: tinggiController,
                labelText: 'Tinggi Tanaman',
                hintText: 'Masukkan tinggi tanaman dalam satuan cm',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Jumlah Daun
              CustomFormField(
                controller: jumlahDaunController,
                labelText: 'Jumlah Daun',
                hintText: 'Masukkan jumlah daun',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Berat Buah
              CustomFormField(
                controller: beratBuahController,
                labelText: 'Berat Buah',
                hintText: 'Masukkan berat buah dalam satuan gram',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),

              // Tombol Simpan
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      // Implementasi logika simpan
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0165FF),
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
    tinggiController.dispose();
    jumlahDaunController.dispose();
    beratBuahController.dispose();
    super.dispose();
  }
}
