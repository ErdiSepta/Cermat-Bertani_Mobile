import 'package:flutter/material.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/topnav.dart';
import 'package:apps/src/customConfirmDialog.dart';

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

  // Tambahkan variabel untuk error messages
  String _phError = '';
  String _ppmError = '';
  String _suhuError = '';
  String _kelembapanError = '';
  String _greenhouseError = '';

  @override
  void initState() {
    super.initState();
    // Tambahkan listeners untuk clear error
    phController.addListener(_clearPhError);
    ppmController.addListener(_clearPpmError);
    suhuController.addListener(_clearSuhuError);
    kelembapanController.addListener(_clearKelembapanError);
  }

  // Tambahkan fungsi clear error
  void _clearPhError() {
    if (_phError.isNotEmpty) {
      setState(() {
        _phError = '';
      });
    }
  }

  void _clearPpmError() {
    if (_ppmError.isNotEmpty) {
      setState(() {
        _ppmError = '';
      });
    }
  }

  void _clearSuhuError() {
    if (_suhuError.isNotEmpty) {
      setState(() {
        _suhuError = '';
      });
    }
  }

  void _clearKelembapanError() {
    if (_kelembapanError.isNotEmpty) {
      setState(() {
        _kelembapanError = '';
      });
    }
  }

  void _clearGreenhouseError() {
    if (_greenhouseError.isNotEmpty) {
      setState(() {
        _greenhouseError = '';
      });
    }
  }

  // Tambahkan fungsi validasi
  void _validateInputs() async {
    setState(() {
      _phError = phController.text.isEmpty ? 'PH tidak boleh kosong' : '';
      _ppmError = ppmController.text.isEmpty ? 'PPM tidak boleh kosong' : '';
      _suhuError = suhuController.text.isEmpty ? 'Suhu tidak boleh kosong' : '';
      _kelembapanError = kelembapanController.text.isEmpty ? 'Kelembapan tidak boleh kosong' : '';
      _greenhouseError = selectedGreenhouse == null ? 'Greenhouse harus dipilih' : '';
    });

    if (_phError.isEmpty &&
        _ppmError.isEmpty &&
        _suhuError.isEmpty &&
        _kelembapanError.isEmpty &&
        _greenhouseError.isEmpty) {

      // Tambahkan dialog konfirmasi
      bool confirm = await CustomConfirmDialog.show(
        context: context,
        title: 'Konfirmasi',
        message: 'Apakah data yang anda masukkan sudah benar?',
        confirmText: 'Ya',
        cancelText: 'Tidak',
      );

      if (confirm) {
        // Implementasi logika simpan jika semua validasi berhasil
        print('Semua data valid, siap untuk disimpan');
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      }
    }
  }

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
                errorText: _greenhouseError.isNotEmpty ? _greenhouseError : null,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGreenhouse = newValue;
                    _clearGreenhouseError();
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
                errorText: _phError.isNotEmpty ? _phError : null,
              ),
              const SizedBox(height: 20),

              // PPM Tanaman
              CustomFormField(
                controller: ppmController,
                labelText: 'PPM Tanaman',
                hintText: 'Masukan PPM Tanaman',
                keyboardType: TextInputType.number,
                errorText: _ppmError.isNotEmpty ? _ppmError : null,
              ),
              const SizedBox(height: 20),

              // Suhu Greenhouse
              CustomFormField(
                controller: suhuController,
                labelText: 'Suhu Greenhouse',
                hintText: 'Masukan Suhu Tanaman',
                keyboardType: TextInputType.number,
                errorText: _suhuError.isNotEmpty ? _suhuError : null,
              ),
              const SizedBox(height: 20),

              // Kelembapan Polibag
              CustomFormField(
                controller: kelembapanController,
                labelText: 'Kelembapan Polibag',
                hintText: 'Masukan Kelembapan Polibag',
                keyboardType: TextInputType.number,
                errorText: _kelembapanError.isNotEmpty ? _kelembapanError : null,
              ),
              const SizedBox(height: 30),

              // Tombol Simpan (opsional, sesuai kebutuhan)
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: _validateInputs,
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
    // Tambahkan remove listeners
    phController.removeListener(_clearPhError);
    ppmController.removeListener(_clearPpmError);
    suhuController.removeListener(_clearSuhuError);
    kelembapanController.removeListener(_clearKelembapanError);
    super.dispose();
  }
}
