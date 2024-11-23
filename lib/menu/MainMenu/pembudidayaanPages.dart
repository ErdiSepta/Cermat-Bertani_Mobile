import 'package:intl/intl.dart';
import 'package:apps/SendApi/ghApi.dart';
import 'package:apps/SendApi/pembudidayaanApi.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/topnav.dart';
import 'package:apps/src/customConfirmDialog.dart';

class PembudidayaanPages extends StatefulWidget {
  const PembudidayaanPages({super.key});

  @override
  State<PembudidayaanPages> createState() => _PembudidayaanPagesState();
}

class _PembudidayaanPagesState extends State<PembudidayaanPages> {
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
  String _greenhouseError = '';
  String _perendamanAwalError = '';
  String _perendamanAkhirError = '';
  String _semaiAwalError = '';
  String _semaiAkhirError = '';
  String _vegetatifAwalError = '';
  String _vegetatifAkhirError = '';
  String _penyiramanAwalError = '';
  String _penyiramanAkhirError = '';

  final List<String> greenhouseList = [];

  // Controllers untuk tanggal
  final TextEditingController perendamanAwalController =
      TextEditingController();
  final TextEditingController perendamanAkhirController =
      TextEditingController();
  final TextEditingController semaiAwalController = TextEditingController();
  final TextEditingController semaiAkhirController = TextEditingController();
  final TextEditingController vegetatifAwalController = TextEditingController();
  final TextEditingController vegetatifAkhirController =
      TextEditingController();
  final TextEditingController penyiramanAwalController =
      TextEditingController();
  final TextEditingController penyiramanAkhirController =
      TextEditingController();

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        // Format tanggal dengan dua digit untuk bulan dan hari
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    showDataGh();
    perendamanAwalController.addListener(_clearPerendamanAwalError);
    perendamanAkhirController.addListener(_clearPerendamanAkhirError);
    semaiAwalController.addListener(_clearSemaiAwalError);
    semaiAkhirController.addListener(_clearSemaiAkhirError);
    vegetatifAwalController.addListener(_clearVegetatifAwalError);
    vegetatifAkhirController.addListener(_clearVegetatifAkhirError);
    penyiramanAwalController.addListener(_clearPenyiramanAwalError);
    penyiramanAkhirController.addListener(_clearPenyiramanAkhirError);
  }

  // Clear error functions
  void _clearPerendamanAwalError() {
    if (_perendamanAwalError.isNotEmpty) {
      setState(() => _perendamanAwalError = '');
    }
  }

  void _clearPerendamanAkhirError() {
    if (_perendamanAkhirError.isNotEmpty) {
      setState(() => _perendamanAkhirError = '');
    }
  }
//

  void _clearSemaiAwalError() {
    if (_semaiAwalError.isNotEmpty) setState(() => _semaiAwalError = '');
  }

  void _clearSemaiAkhirError() {
    if (_semaiAkhirError.isNotEmpty) setState(() => _semaiAkhirError = '');
  }

//

  void _clearVegetatifAwalError() {
    if (_vegetatifAwalError.isNotEmpty) {
      setState(() => _vegetatifAwalError = '');
    }
  }

  void _clearVegetatifAkhirError() {
    if (_vegetatifAkhirError.isNotEmpty) {
      setState(() => _vegetatifAkhirError = '');
    }
  }
//

  void _clearPenyiramanAwalError() {
    if (_penyiramanAwalError.isNotEmpty) {
      setState(() => _penyiramanAwalError = '');
    }
  }

  void _clearPenyiramanAkhirError() {
    if (_penyiramanAkhirError.isNotEmpty) {
      setState(() => _penyiramanAkhirError = '');
    }
  }

// Fungsi untuk memeriksa apakah format tanggal valid
  bool _isInvalidDateFormat(String date) {
    try {
      DateTime.parse(date); // Coba untuk parsing
      return false; // Jika sukses, berarti formatnya valid
    } catch (e) {
      return true; // Jika terjadi error, berarti formatnya invalid
    }
  }

  void _validateInputs() async {
    setState(() {
      _greenhouseError = ''; // Reset error jika ada

      // Flag untuk cek apakah semua pasangan tanggal kosong
      bool allFieldsEmpty = perendamanAwalController.text.isEmpty &&
          perendamanAkhirController.text.isEmpty &&
          semaiAwalController.text.isEmpty &&
          semaiAkhirController.text.isEmpty &&
          vegetatifAwalController.text.isEmpty &&
          vegetatifAkhirController.text.isEmpty &&
          penyiramanAwalController.text.isEmpty &&
          penyiramanAkhirController.text.isEmpty;

      // Fungsi untuk validasi pasangan tanggal
      String validatePair(
          String awal, String akhir, String labelAwal, String labelAkhir) {
        if (awal.isEmpty && akhir.isEmpty) {
          return allFieldsEmpty ? '$labelAwal dan $labelAkhir harus diisi' : '';
        } else if (awal.isEmpty) {
          return '$labelAwal harus diisi';
        } else if (akhir.isEmpty) {
          return '$labelAkhir harus diisi';
        } else if (_isInvalidDateFormat(akhir)) {
          return 'Format $labelAkhir tidak valid';
        } else if (DateTime.parse(akhir).isBefore(DateTime.parse(awal))) {
          return '$labelAkhir tidak boleh sebelum $labelAwal';
        }
        return '';
      }

      // Validasi pasangan tanggal
      _perendamanAwalError = validatePair(
        perendamanAwalController.text,
        perendamanAkhirController.text,
        'Tanggal awal perendaman',
        'Tanggal akhir perendaman',
      );
      _perendamanAkhirError = _perendamanAwalError;

      _semaiAwalError = validatePair(
        semaiAwalController.text,
        semaiAkhirController.text,
        'Tanggal awal semai',
        'Tanggal akhir semai',
      );
      _semaiAkhirError = _semaiAwalError;

      _vegetatifAwalError = validatePair(
        vegetatifAwalController.text,
        vegetatifAkhirController.text,
        'Tanggal awal vegetatif',
        'Tanggal akhir vegetatif',
      );
      _vegetatifAkhirError = _vegetatifAwalError;

      _penyiramanAwalError = validatePair(
        penyiramanAwalController.text,
        penyiramanAkhirController.text,
        'Tanggal awal penyiraman',
        'Tanggal akhir penyiraman',
      );
      _penyiramanAkhirError = _penyiramanAwalError;
    });

    if (_greenhouseError.isEmpty &&
        _perendamanAwalError.isEmpty &&
        _perendamanAkhirError.isEmpty &&
        _semaiAwalError.isEmpty &&
        _semaiAkhirError.isEmpty &&
        _vegetatifAwalError.isEmpty &&
        _vegetatifAkhirError.isEmpty &&
        _penyiramanAwalError.isEmpty &&
        _penyiramanAkhirError.isEmpty) {
      bool confirm = await CustomConfirmDialog.show(
        context: context,
        title: 'Konfirmasi',
        message: 'Apakah data yang anda masukkan sudah benar?',
        confirmText: 'Ya',
        cancelText: 'Tidak',
      );

      if (confirm) {
        try {
          {
            final result = await PembudidayaanApi.tambahPembudidayaan(
                perendamanAwalController.text,
                perendamanAkhirController.text,
                semaiAwalController.text,
                semaiAkhirController.text,
                vegetatifAwalController.text,
                vegetatifAkhirController.text,
                penyiramanAwalController.text,
                penyiramanAkhirController.text,
                _idGH.toString());

            if (result == null) {
              print(result);
              print('Data kosong!!!');
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pengiriman data gagal: ')));
            } else if (result['status'] == "success") {
              print('berhasil simpan');
              Navigator.pop(context); // Kembali ke halaman sebelumnya
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Pengiriman data gagal: ${result['message']}')),
              );
            }
          }
        } catch (e) {
          SnackBar(content: Text('Pengiriman data gagal: ${e.toString()}'));
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
          title: 'Pembudidayaan',
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
                  'assets/images/pembudidayaan.png',
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
              const SizedBox(height: 30),

              // Fase Perendaman
              const Text(
                'Fase Perendaman',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSanSemiBold',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Awal')),
                  Expanded(
                    child: CustomFormField(
                      onTap: () =>
                          _selectDate(context, perendamanAwalController),
                      controller: perendamanAwalController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Awal Fase',
                      errorText: _perendamanAwalError.isNotEmpty
                          ? _perendamanAwalError
                          : null,
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: null),
                      enabled: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Akhir')),
                  Expanded(
                    child: CustomFormField(
                      onTap: () =>
                          _selectDate(context, perendamanAkhirController),
                      controller: perendamanAkhirController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Akhir Fase',
                      errorText: _perendamanAkhirError.isNotEmpty
                          ? _perendamanAkhirError
                          : null,
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: null),
                      enabled: true,
                    ),
                  ),
                ],
              ),

              // Fase Semai
              const SizedBox(height: 10),
              const Text(
                'Fase Semai',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSanSemiBold',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Awal')),
                  Expanded(
                    child: CustomFormField(
                      onTap: () => _selectDate(context, semaiAwalController),
                      controller: semaiAwalController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Awal Fase',
                      errorText:
                          _semaiAwalError.isNotEmpty ? _semaiAwalError : null,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: null,
                      ),
                      enabled: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Akhir')),
                  Expanded(
                    child: CustomFormField(
                      onTap: () => _selectDate(context, semaiAkhirController),
                      controller: semaiAkhirController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Akhir Fase',
                      errorText:
                          _semaiAkhirError.isNotEmpty ? _semaiAkhirError : null,
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: null),
                      enabled: true,
                    ),
                  ),
                ],
              ),

              // Fase Vegetatif
              const SizedBox(height: 20),
              const Text(
                'Fase Vegetatif',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSanSemiBold',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Awal')),
                  Expanded(
                    child: CustomFormField(
                      onTap: () =>
                          _selectDate(context, vegetatifAwalController),
                      controller: vegetatifAwalController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Awal Fase',
                      errorText: _vegetatifAwalError.isNotEmpty
                          ? _vegetatifAwalError
                          : null,
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: null),
                      enabled: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Akhir')),
                  Expanded(
                    child: CustomFormField(
                      onTap: () =>
                          _selectDate(context, vegetatifAkhirController),
                      controller: vegetatifAkhirController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Akhir Fase',
                      errorText: _vegetatifAkhirError.isNotEmpty
                          ? _vegetatifAkhirError
                          : null,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: null,
                      ),
                      enabled: true,
                    ),
                  ),
                ],
              ),

              // Fase Penyiraman
              const SizedBox(height: 20),
              const Text(
                'Fase Penyiraman',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSanSemiBold',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Awal')),
                  Expanded(
                    child: CustomFormField(
                      onTap: () =>
                          _selectDate(context, penyiramanAwalController),
                      controller: penyiramanAwalController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Awal Fase',
                      errorText: _penyiramanAwalError.isNotEmpty
                          ? _penyiramanAwalError
                          : null,
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: null),
                      enabled: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Akhir')),
                  Expanded(
                    child: CustomFormField(
                      onTap: () =>
                          _selectDate(context, penyiramanAkhirController),
                      controller: penyiramanAkhirController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Akhir Fase',
                      errorText: _penyiramanAkhirError.isNotEmpty
                          ? _penyiramanAkhirError
                          : null,
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: null),
                      enabled: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
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
    perendamanAwalController.removeListener(_clearPerendamanAwalError);
    perendamanAkhirController.removeListener(_clearPerendamanAkhirError);
    semaiAwalController.removeListener(_clearSemaiAwalError);
    semaiAkhirController.removeListener(_clearSemaiAkhirError);
    vegetatifAwalController.removeListener(_clearVegetatifAwalError);
    vegetatifAkhirController.removeListener(_clearVegetatifAkhirError);
    penyiramanAwalController.removeListener(_clearPenyiramanAwalError);
    penyiramanAkhirController.removeListener(_clearPenyiramanAkhirError);
    super.dispose();
  }
}
