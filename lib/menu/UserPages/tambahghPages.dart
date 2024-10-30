import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/topnav.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/customColor.dart';
import 'package:apps/src/customConfirmDialog.dart';

class TambahghpagePages extends StatefulWidget {
  const TambahghpagePages({super.key});

  @override
  State<TambahghpagePages> createState() => _TambahghpagePagesState();
}

class _TambahghpagePagesState extends State<TambahghpagePages> {
  // Tambahkan variabel error
  String _namaError = '';
  String _alamatError = '';
  String _fokusError = '';
  String _tanggalError = '';
  String _metodeError = '';
  String _luasError = '';
  String _lubangError = '';

  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final fokusController = TextEditingController();
  final tanggalController = TextEditingController();
  final metodeController = TextEditingController();
  final luasController = TextEditingController();
  final lubangController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Tambahkan listeners
    namaController.addListener(() => _clearError('nama'));
    alamatController.addListener(() => _clearError('alamat'));
    fokusController.addListener(() => _clearError('fokus'));
    tanggalController.addListener(() => _clearError('tanggal'));
    metodeController.addListener(() => _clearError('metode'));
    luasController.addListener(() => _clearError('luas'));
    lubangController.addListener(() => _clearError('lubang'));
  }

  void _clearError(String field) {
    setState(() {
      switch (field) {
        case 'nama':
          _namaError = '';
        case 'alamat':
          _alamatError = '';
        case 'fokus':
          _fokusError = '';
        case 'tanggal':
          _tanggalError = '';
        case 'metode':
          _metodeError = '';
        case 'luas':
          _luasError = '';
        case 'lubang':
          _lubangError = '';
      }
    });
  }

  void _validateInputs() async {
    setState(() {
      _namaError =
          namaController.text.isEmpty ? 'Nama GH tidak boleh kosong' : '';
      _alamatError =
          alamatController.text.isEmpty ? 'Alamat GH tidak boleh kosong' : '';
      _fokusError = fokusController.text.isEmpty
          ? 'Fokus pertanian tidak boleh kosong'
          : '';
      _tanggalError =
          tanggalController.text.isEmpty ? 'Tanggal tidak boleh kosong' : '';
      _metodeError =
          metodeController.text.isEmpty ? 'Metode tidak boleh kosong' : '';
      _luasError = luasController.text.isEmpty ? 'Luas tidak boleh kosong' : '';
      _lubangError =
          lubangController.text.isEmpty ? 'Lubang tidak boleh kosong' : '';
    });

    if (_namaError.isEmpty &&
        _alamatError.isEmpty &&
        _fokusError.isEmpty &&
        _tanggalError.isEmpty &&
        _metodeError.isEmpty &&
        _luasError.isEmpty &&
        _lubangError.isEmpty) {

      // Tambahkan dialog konfirmasi
      bool confirm = await CustomConfirmDialog.show(
        context: context,
        title: 'Konfirmasi',
        message: 'Apakah data yang anda masukkan sudah benar?',
        confirmText: 'Ya',
        cancelText: 'Tidak',
      );

      if (confirm) {
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Topnav(
              title: 'Tambah GH',
              showBackButton: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Image.asset(
                          'assets/images/gh.png',
                          height: 200,
                        ),
                      ),
                      const SizedBox(height: 50),
                      // Update CustomFormField untuk Nama GH
                      CustomFormField(
                        controller: namaController,
                        labelText: 'Nama GH',
                        hintText: 'Masukan Nama GH',
                        errorText: _namaError.isNotEmpty ? _namaError : null,
                        onChanged: (value) {
                          setState(() {
                            _namaError = '';
                          });
                        },
                      ),
                      const SizedBox(height: 20), // Kurangi jarak antar field

                      // Update CustomFormField untuk Alamat GH
                      CustomFormField(
                        controller: alamatController,
                        labelText: 'Alamat GH',
                        hintText: 'Masukan Alamat GH',
                        errorText:
                            _alamatError.isNotEmpty ? _alamatError : null,
                        maxLines: 3,
                        height: 100,
                        onChanged: (value) {
                          setState(() {
                            _alamatError = '';
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Update CustomFormField untuk Fokus Pertanian
                      CustomFormField(
                        controller: fokusController,
                        labelText: 'Fokus Pertanian',
                        hintText: 'Masukan Fokus Pertanian',
                        errorText: _fokusError.isNotEmpty ? _fokusError : null,
                        onChanged: (value) {
                          setState(() {
                            _fokusError = '';
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Update CustomFormField untuk Tanggal
                      CustomFormField(
                        controller: tanggalController,
                        labelText: 'Tanggal GH Dibuat',
                        hintText: 'Masukan Tanggal GH Dibuat',
                        errorText:
                            _tanggalError.isNotEmpty ? _tanggalError : null,
                        onChanged: (value) {
                          setState(() {
                            _tanggalError = '';
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Update CustomFormField untuk Metode
                      CustomFormField(
                        controller: metodeController,
                        labelText: 'Metode Penanaman',
                        hintText: 'Masukan Metode Penanaman',
                        errorText:
                            _metodeError.isNotEmpty ? _metodeError : null,
                        onChanged: (value) {
                          setState(() {
                            _metodeError = '';
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Update CustomFormField untuk Luas Greenhouse
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Luas Green House',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'NotoSanSemiBold',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: TextField(
                                  controller: luasController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Masukan Luas',
                                    errorText: _luasError.isNotEmpty
                                        ? _luasError
                                        : null,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _luasError = '';
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'm² ( Meter Persegi )',
                                style: TextStyle(
                                  fontFamily: 'NotoSanSemiBold',
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Update CustomFormField untuk Jumlah Lubang Tanam
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jumlah Lubang Tanam',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'NotoSanSemiBold',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: TextField(
                                  controller: lubangController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Lubang Tanam',
                                    errorText: _lubangError.isNotEmpty
                                        ? _lubangError
                                        : null,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _lubangError = '';
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Lubang Tanam',
                                style: TextStyle(
                                  fontFamily: 'NotoSanSemiBold',
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ElevatedButton(
                            onPressed: _validateInputs,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.BiruPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
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
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
