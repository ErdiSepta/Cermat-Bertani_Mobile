import 'package:apps/SendApi/PantauLingkunganApi.dart';
import 'package:apps/SendApi/ghApi.dart';
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
  //AWAL BACKEND
  String? _selectedGH;
  String? _idGH = "";
  int? RealIDGH = 0;
  List<String> _ghList = [];
  void showDataGh() async {
    final result = await ghApi.getDataGhNama();
    if (result != null) {
      print("result " + result.toString());
      setState(() {
        // Pastikan ini di dalam setState untuk memperbarui UI
        _ghData = result['data_gh'];
        _ghList = result['data_gh'].keys.toList();
        _selectedGH = _ghList[0].toString();
        print(_selectedGH);
        if (_selectedGH != null) {
          _loadGHData(_selectedGH!); // Panggil fungsi untuk memuat data GH
        }
      });
    } else {
      print("data kosong");
    }
  }

  // Data dummy untuk setiap GH
  Map<String, dynamic> _ghData = {};
  void _loadGHData(String gh) {
    final data = _ghData[gh];
    // Menyimpan ID GH untuk kebutuhan lainnya
    _idGH = data['uuid'];
    RealIDGH = data['id_gh'];
  }

  //AKHIR BACKEND
  final TextEditingController phController = TextEditingController();
  final TextEditingController ppmController = TextEditingController();
  final TextEditingController suhuController = TextEditingController();
  final TextEditingController kelembapanController = TextEditingController();

  // Tambahkan variabel untuk error messages
  String _phError = '';
  String _ppmError = '';
  String _suhuError = '';
  String _kelembapanError = '';
  String _greenhouseError = '';

  @override
  void initState() {
    super.initState();
    showDataGh();
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
      _kelembapanError = kelembapanController.text.isEmpty
          ? 'Kelembapan tidak boleh kosong'
          : '';
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
        final result = await Pantaulingkunganapi.tambahPantanuLingkungan(
            phController.text,
            ppmController.text,
            suhuController.text,
            kelembapanController.text,
            RealIDGH.toString());

        if (result == null) {
          print('Data kosong!!!');
        } else if (result['status'] == "success") {
          print('berhasil simpan');
          Navigator.pop(context); // Kembali ke halaman sebelumnya
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Pengiriman data gagal: ${result['message']}')),
          );
        }
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
              DropdownButtonFormField<String>(
                value: _selectedGH,
                decoration: InputDecoration(
                  labelText: 'Pilih Green House',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: _ghList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGH = newValue;
                    _loadGHData(newValue!); // Load data ketika GH dipilih
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
                errorText:
                    _kelembapanError.isNotEmpty ? _kelembapanError : null,
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
