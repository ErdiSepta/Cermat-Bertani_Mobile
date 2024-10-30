import 'package:flutter/material.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/topnav.dart';
import 'package:apps/src/customConfirmDialog.dart';

class PantauTanamanPages extends StatefulWidget {
  const PantauTanamanPages({super.key});

  @override
  State<PantauTanamanPages> createState() => _PantauTanamanPagesState();
}

class _PantauTanamanPagesState extends State<PantauTanamanPages> {
  String? selectedGreenhouse;
  String _greenhouseError = '';
  String _tinggiError = '';
  String _jumlahDaunError = '';
  String _beratBuahError = '';
  final TextEditingController tinggiController = TextEditingController();
  final TextEditingController jumlahDaunController = TextEditingController();
  final TextEditingController beratBuahController = TextEditingController();

  // Daftar greenhouse (contoh)
  final List<String> greenhouseList = ['GH-01', 'GH-02', 'GH-03'];

  @override
  void initState() {
    super.initState();
    tinggiController.addListener(_clearTinggiError);
    jumlahDaunController.addListener(_clearJumlahDaunError);
    beratBuahController.addListener(_clearBeratBuahError);
  }

  void _clearTinggiError() {
    if (_tinggiError.isNotEmpty) {
      setState(() => _tinggiError = '');
    }
  }

  void _clearJumlahDaunError() {
    if (_jumlahDaunError.isNotEmpty) {
      setState(() => _jumlahDaunError = '');
    }
  }

  void _clearBeratBuahError() {
    if (_beratBuahError.isNotEmpty) {
      setState(() => _beratBuahError = '');
    }
  }

  void _validateInputs() async {
    setState(() {
      _tinggiError = tinggiController.text.isEmpty ? 'Tinggi tanaman tidak boleh kosong' : '';
      _jumlahDaunError = jumlahDaunController.text.isEmpty ? 'Jumlah daun tidak boleh kosong' : '';
      _beratBuahError = beratBuahController.text.isEmpty ? 'Berat buah tidak boleh kosong' : '';
      _greenhouseError = selectedGreenhouse == null ? 'Greenhouse harus dipilih' : '';
    });

    if (_tinggiError.isEmpty && 
        _jumlahDaunError.isEmpty && 
        _beratBuahError.isEmpty && 
        _greenhouseError.isEmpty) {

      bool confirm = await CustomConfirmDialog.show(
        context: context,
        title: 'Konfirmasi',
        message: 'Apakah data yang anda masukkan sudah benar?',
        confirmText: 'Ya',
        cancelText: 'Tidak',
      );

      if (confirm) {
        print('Semua data valid, siap untuk disimpan');
        Navigator.pop(context);
      }
    }
  }

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
                errorText:
                    _greenhouseError.isNotEmpty ? _greenhouseError : null,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGreenhouse = newValue;
                    _greenhouseError = '';
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
                errorText: _tinggiError.isNotEmpty ? _tinggiError : null,
              ),
              const SizedBox(height: 20),

              // Jumlah Daun
              CustomFormField(
                controller: jumlahDaunController,
                labelText: 'Jumlah Daun',
                hintText: 'Masukkan jumlah daun',
                keyboardType: TextInputType.number,
                errorText: _jumlahDaunError.isNotEmpty ? _jumlahDaunError : null,
              ),
              const SizedBox(height: 20),

              // Berat Buah
              CustomFormField(
                controller: beratBuahController,
                labelText: 'Berat Buah',
                hintText: 'Masukkan berat buah dalam satuan gram',
                keyboardType: TextInputType.number,
                errorText: _beratBuahError.isNotEmpty ? _beratBuahError : null,
              ),
              const SizedBox(height: 30),

              // Tombol Simpan
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: _validateInputs,
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
    tinggiController.removeListener(_clearTinggiError);
    jumlahDaunController.removeListener(_clearJumlahDaunError);
    beratBuahController.removeListener(_clearBeratBuahError);
    super.dispose();
  }
}
