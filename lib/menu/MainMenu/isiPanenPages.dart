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
  String? selectedGreenhouse;
  String _greenhouseError = '';
  String _jumlahBeratError = '';
  String _ukuranRataError = '';
  String _rasaRataError = '';
  String _biayaOperasionalError = '';
  String _pendapatanError = '';

  final List<String> greenhouseList = ['GH-01', 'GH-02', 'GH-03'];

  final TextEditingController jumlahBeratController = TextEditingController();
  final TextEditingController ukuranRataController = TextEditingController();
  final TextEditingController rasaRataController = TextEditingController();
  final TextEditingController biayaOperasionalController =
      TextEditingController();
  final TextEditingController pendapatanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    jumlahBeratController.addListener(_clearJumlahBeratError);
    ukuranRataController.addListener(_clearUkuranRataError);
    rasaRataController.addListener(_clearRasaRataError);
    biayaOperasionalController.addListener(_clearBiayaOperasionalError);
    pendapatanController.addListener(_clearPendapatanError);
  }

  // Clear error functions
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

  void _validateInputs() async {
    setState(() {
      _greenhouseError =
          selectedGreenhouse == null ? 'Greenhouse harus dipilih' : '';
      _jumlahBeratError = jumlahBeratController.text.isEmpty
          ? 'Jumlah berat tidak boleh kosong'
          : '';
      _ukuranRataError = ukuranRataController.text.isEmpty
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
    });

    if (_greenhouseError.isEmpty &&
        _jumlahBeratError.isEmpty &&
        _ukuranRataError.isEmpty &&
        _rasaRataError.isEmpty &&
        _biayaOperasionalError.isEmpty &&
        _pendapatanError.isEmpty) {
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

              // Greenhouse Dropdown
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

              // Jumlah Berat
              CustomFormField(
                controller: jumlahBeratController,
                labelText: 'Jumlah Berat',
                hintText: 'Pilih Jumlah Berat',
                keyboardType: TextInputType.number,
                errorText:
                    _jumlahBeratError.isNotEmpty ? _jumlahBeratError : null,
              ),
              const SizedBox(height: 20),

              // Ukuran Rata-rata
              CustomFormField(
                controller: ukuranRataController,
                labelText: 'Ukuran Rata - Rata',
                hintText: 'Masukan Ukuran rata - rata',
                keyboardType: TextInputType.number,
                errorText:
                    _ukuranRataError.isNotEmpty ? _ukuranRataError : null,
              ),
              const SizedBox(height: 20),

              // Rasa Rata-rata
              CustomFormField(
                controller: rasaRataController,
                labelText: 'Rasa Rata - Rata',
                hintText: 'Masukan Rasa Rata - Rata',
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
    jumlahBeratController.removeListener(_clearJumlahBeratError);
    ukuranRataController.removeListener(_clearUkuranRataError);
    rasaRataController.removeListener(_clearRasaRataError);
    biayaOperasionalController.removeListener(_clearBiayaOperasionalError);
    pendapatanController.removeListener(_clearPendapatanError);
    super.dispose();
  }
}
