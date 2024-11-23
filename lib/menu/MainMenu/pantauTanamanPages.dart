import 'package:apps/SendApi/PantauTanamanApi.dart';
import 'package:flutter/material.dart';
import 'package:apps/SendApi/ghApi.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/topnav.dart';
import 'package:apps/src/customConfirmDialog.dart';

class PantauTanamanPages extends StatefulWidget {
  const PantauTanamanPages({super.key});

  @override
  State<PantauTanamanPages> createState() => _PantauTanamanPagesState();
}

class _PantauTanamanPagesState extends State<PantauTanamanPages> {
  //AWAL BACKEND
  String? _selectedGH;
  String? _idGH = "";
  int? RealIDGH = 0;
  List<String> _ghList = [];
  void showDataGh() async {
    final result = await ghApi.getDataGhNama();
    if (result != null) {
      print("result $result");
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
  String _tinggiError = '';
  String _jumlahDaunError = '';
  String _beratBuahError = '';
  final TextEditingController tinggiController = TextEditingController();
  final TextEditingController jumlahDaunController = TextEditingController();
  final TextEditingController beratBuahController = TextEditingController();

  @override
  void initState() {
    super.initState();
    showDataGh();
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
      _tinggiError = tinggiController.text.isEmpty
          ? 'Tinggi tanaman tidak boleh kosong'
          : '';
      _jumlahDaunError = jumlahDaunController.text.isEmpty
          ? 'Jumlah daun tidak boleh kosong'
          : '';
      _beratBuahError = beratBuahController.text.isEmpty
          ? 'Berat buah tidak boleh kosong'
          : '';
    });

    if (_tinggiError.isEmpty &&
        _jumlahDaunError.isEmpty &&
        _beratBuahError.isEmpty) {
      bool confirm = await CustomConfirmDialog.show(
        context: context,
        title: 'Konfirmasi',
        message: 'Apakah data yang anda masukkan sudah benar?',
        confirmText: 'Ya',
        cancelText: 'Tidak',
      );

      if (confirm) {
        final result = await PantauTanamanApi.tambahPantauTanaman(
            tinggiController.text,
            jumlahDaunController.text,
            beratBuahController.text,
            _idGH.toString());

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
                errorText:
                    _jumlahDaunError.isNotEmpty ? _jumlahDaunError : null,
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
