import 'package:apps/SendApi/ghApi.dart';
import 'package:apps/SendApi/PanenApi.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/topnav.dart';
import 'package:apps/src/customConfirmDialog.dart';

class IsiPanenPages extends StatefulWidget {
  const IsiPanenPages({super.key});

  @override
  State<IsiPanenPages> createState() => _IsiPanenPagesState();
}

class _IsiPanenPagesState extends State<IsiPanenPages> {
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
  String? selectedUkuran = 'besar';
  String _greenhouseError = '';
  String _jumlahBuahError = '';
  String _jumlahBeratError = '';
  String _ukuranRataError = '';
  String _rasaRataError = '';
  String _biayaOperasionalError = '';
  String _pendapatanError = '';
  String _tanggalError = '';

  final List<String> ukuranList = ['besar', 'sedang', 'kecil'];

  final TextEditingController jumlahBuahController = TextEditingController();
  final TextEditingController jumlahBeratController = TextEditingController();
  final TextEditingController ukuranRataController = TextEditingController();
  final TextEditingController rasaRataController = TextEditingController();
  final TextEditingController biayaOperasionalController =
      TextEditingController();
  final TextEditingController pendapatanController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    showDataGh();
    jumlahBuahController.addListener(_clearJumlahBuahError);
    jumlahBeratController.addListener(_clearJumlahBeratError);
    ukuranRataController.addListener(_clearUkuranRataError);
    rasaRataController.addListener(_clearRasaRataError);
    biayaOperasionalController.addListener(_clearBiayaOperasionalError);
    pendapatanController.addListener(_clearPendapatanError);
  }

  // Clear error functions
  void _clearJumlahBuahError() {
    if (_jumlahBuahError.isNotEmpty) setState(() => _jumlahBuahError = '');
  }

  void _clearJumlahBeratError() {
    if (_jumlahBeratError.isNotEmpty) setState(() => _jumlahBeratError = '');
  }

  void _clearUkuranRataError() {
    if (_ukuranRataError.isNotEmpty) setState(() => _ukuranRataError = '');
  }

  void _clearRasaRataError() {
    if (_rasaRataError.isNotEmpty) setState(() => _rasaRataError = '');
  }

  void _clearBiayaOperasionalError() {
    if (_biayaOperasionalError.isNotEmpty) {
      setState(() => _biayaOperasionalError = '');
    }
  }

  void _clearPendapatanError() {
    if (_pendapatanError.isNotEmpty) setState(() => _pendapatanError = '');
  }

  void _clearTanggalError() {
    if (_tanggalError.isNotEmpty) setState(() => _tanggalError = '');
  }

  void _validateInputs() async {
    setState(() {
      _greenhouseError = _selectedGH == null ? 'Greenhouse harus dipilih' : '';
      _jumlahBuahError = jumlahBuahController.text.isEmpty
          ? 'Jumlah berat tidak boleh kosong'
          : '';
      _jumlahBeratError = jumlahBeratController.text.isEmpty
          ? 'Jumlah berat tidak boleh kosong'
          : '';
      _ukuranRataError = selectedUkuran.toString().isEmpty
          ? 'Ukuran rata-rata tidak boleh kosong'
          : '';
      _rasaRataError = rasaRataController.text.isEmpty
          ? 'Rasa rata-rata tidak boleh kosong'
          : '';
      _biayaOperasionalError = biayaOperasionalController.text.isEmpty
          ? 'Biaya operasional tidak boleh kosong'
          : '';
      _pendapatanError = pendapatanController.text.isEmpty
          ? 'Pendapatan tidak boleh kosong'
          : '';
      _tanggalError =
          tanggalController.text.isEmpty ? 'Tanggal tidak boleh kosong' : '';
    });

    if (_greenhouseError.isEmpty &&
        _jumlahBeratError.isEmpty &&
        _rasaRataError.isEmpty &&
        _biayaOperasionalError.isEmpty &&
        _pendapatanError.isEmpty &&
        _tanggalError.isEmpty) {
      bool confirm = await CustomConfirmDialog.show(
        context: context,
        title: 'Konfirmasi',
        message: 'Apakah data yang anda masukkan sudah benar?',
        confirmText: 'Ya',
        cancelText: 'Tidak',
      );

      if (confirm) {
        final result = await PanenApi.tambahIsiPanen(
            jumlahBuahController.text,
            jumlahBeratController.text,
            selectedUkuran.toString(),
            rasaRataController.text,
            tanggalController.text,
            biayaOperasionalController.text,
            pendapatanController.text,
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

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        tanggalController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Topnav(
          title: 'Isi Panen',
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
                  'assets/images/panen.png',
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
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: CustomFormField(
                    controller: tanggalController,
                    labelText: 'Tanggal Panen',
                    hintText: 'Pilih Tanggal',
                    errorText: _tanggalError.isNotEmpty ? _tanggalError : null,
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Jumlah Berat
              CustomFormField(
                controller: jumlahBuahController,
                labelText: 'Jumlah Buah',
                hintText: 'Masukkan jumlah buah',
                keyboardType: TextInputType.number,
                errorText:
                    _jumlahBeratError.isNotEmpty ? _jumlahBeratError : null,
              ),
              const SizedBox(height: 20),

              // Jumlah Berat
              CustomFormField(
                controller: jumlahBeratController,
                labelText: 'Jumlah Berat',
                hintText: 'Masukkan Jumlah Berat',
                keyboardType: TextInputType.number,
                errorText:
                    _jumlahBeratError.isNotEmpty ? _jumlahBeratError : null,
              ),
              const SizedBox(height: 20),

              // Ukuran Rata-rata
              CustomDropdown(
                labelText: 'Ukuran Rata - Rata',
                hintText: 'Pilih Ukuran',
                value: selectedUkuran ?? ukuranList[0],
                items: ukuranList,
                errorText:
                    _ukuranRataError.isNotEmpty ? _ukuranRataError : null,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedUkuran = newValue;
                    _ukuranRataError = '';
                  });
                },
              ),
              const SizedBox(height: 20),

              // Rasa Rata-rata
              CustomFormField(
                controller: rasaRataController,
                labelText: 'Rasa Rata - Rata',
                hintText: 'Masukan Rasa Rata - Rata',
                keyboardType: TextInputType.number,
                errorText: _rasaRataError.isNotEmpty ? _rasaRataError : null,
              ),
              const SizedBox(height: 20),

              // Biaya Operasional
              CustomFormField(
                controller: biayaOperasionalController,
                labelText: 'Biaya Operasional',
                hintText: 'Masukan Biaya Operasional',
                keyboardType: TextInputType.number,
                errorText: _biayaOperasionalError.isNotEmpty
                    ? _biayaOperasionalError
                    : null,
              ),
              const SizedBox(height: 20),

              // Pendapatan Hasil Penjualan
              CustomFormField(
                controller: pendapatanController,
                labelText: 'Pendapatan Hasil Penjualan',
                hintText: 'Masukan Pendapatan Hasil Penjualan',
                keyboardType: TextInputType.number,
                errorText:
                    _pendapatanError.isNotEmpty ? _pendapatanError : null,
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
    jumlahBuahController.removeListener(_clearJumlahBuahError);
    jumlahBeratController.removeListener(_clearJumlahBeratError);
    ukuranRataController.removeListener(_clearUkuranRataError);
    rasaRataController.removeListener(_clearRasaRataError);
    biayaOperasionalController.removeListener(_clearBiayaOperasionalError);
    pendapatanController.removeListener(_clearPendapatanError);
    super.dispose();
  }
}
