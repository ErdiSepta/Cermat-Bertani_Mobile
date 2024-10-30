import 'package:flutter/material.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/topnav.dart';
import 'package:apps/src/customConfirmDialog.dart';

class PembudidayaanPages extends StatefulWidget {
  const PembudidayaanPages({super.key});

  @override
  State<PembudidayaanPages> createState() => _PembudidayaanPagesState();
}

class _PembudidayaanPagesState extends State<PembudidayaanPages> {
  String? selectedGreenhouse;
  String _greenhouseError = '';
  String _perendamanAwalError = '';
  String _perendamanAkhirError = '';
  String _semaiAwalError = '';
  String _semaiAkhirError = '';
  String _vegetatifAwalError = '';
  String _vegetatifAkhirError = '';
  String _penyiramanAwalError = '';
  String _penyiramanAkhirError = '';

  final List<String> greenhouseList = ['GH-01', 'GH-02', 'GH-03'];
  
  // Controllers untuk tanggal
  final TextEditingController perendamanAwalController = TextEditingController();
  final TextEditingController perendamanAkhirController = TextEditingController();
  final TextEditingController semaiAwalController = TextEditingController();
  final TextEditingController semaiAkhirController = TextEditingController();
  final TextEditingController vegetatifAwalController = TextEditingController();
  final TextEditingController vegetatifAkhirController = TextEditingController();
  final TextEditingController penyiramanAwalController = TextEditingController();
  final TextEditingController penyiramanAkhirController = TextEditingController();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
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
    if (_perendamanAwalError.isNotEmpty) setState(() => _perendamanAwalError = '');
  }
  void _clearPerendamanAkhirError() {
    if (_perendamanAkhirError.isNotEmpty) setState(() => _perendamanAkhirError = '');
  }
  void _clearSemaiAwalError() {
    if (_semaiAwalError.isNotEmpty) setState(() => _semaiAwalError = '');
  }
  void _clearSemaiAkhirError() {
    if (_semaiAkhirError.isNotEmpty) setState(() => _semaiAkhirError = '');
  }
  void _clearVegetatifAwalError() {
    if (_vegetatifAwalError.isNotEmpty) setState(() => _vegetatifAwalError = '');
  }
  void _clearVegetatifAkhirError() {
    if (_vegetatifAkhirError.isNotEmpty) setState(() => _vegetatifAkhirError = '');
  }
  void _clearPenyiramanAwalError() {
    if (_penyiramanAwalError.isNotEmpty) setState(() => _penyiramanAwalError = '');
  }
  void _clearPenyiramanAkhirError() {
    if (_penyiramanAkhirError.isNotEmpty) setState(() => _penyiramanAkhirError = '');
  }

  void _validateInputs() async {
    setState(() {
      _greenhouseError = selectedGreenhouse == null ? 'Greenhouse harus dipilih' : '';
      _perendamanAwalError = perendamanAwalController.text.isEmpty ? 'Tanggal awal perendaman harus diisi' : '';
      _perendamanAkhirError = perendamanAkhirController.text.isEmpty ? 'Tanggal akhir perendaman harus diisi' : '';
      _semaiAwalError = semaiAwalController.text.isEmpty ? 'Tanggal awal semai harus diisi' : '';
      _semaiAkhirError = semaiAkhirController.text.isEmpty ? 'Tanggal akhir semai harus diisi' : '';
      _vegetatifAwalError = vegetatifAwalController.text.isEmpty ? 'Tanggal awal vegetatif harus diisi' : '';
      _vegetatifAkhirError = vegetatifAkhirController.text.isEmpty ? 'Tanggal akhir vegetatif harus diisi' : '';
      _penyiramanAwalError = penyiramanAwalController.text.isEmpty ? 'Tanggal awal penyiraman harus diisi' : '';
      _penyiramanAkhirError = penyiramanAkhirController.text.isEmpty ? 'Tanggal akhir penyiraman harus diisi' : '';
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

              // Greenhouse Dropdown
              CustomDropdown(
                labelText: 'Greenhouse',
                hintText: 'Pilih Greenhouse',
                value: selectedGreenhouse ?? greenhouseList[0],
                items: greenhouseList,
                errorText: _greenhouseError.isNotEmpty ? _greenhouseError : null,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGreenhouse = newValue;
                    _greenhouseError = '';
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
                      controller: perendamanAwalController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Awal Fase',
                      errorText: _perendamanAwalError.isNotEmpty ? _perendamanAwalError : null,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, perendamanAwalController),
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
                      controller: perendamanAkhirController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Akhir Fase',
                      errorText: _perendamanAkhirError.isNotEmpty ? _perendamanAkhirError : null,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, perendamanAkhirController),
                      ),
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
                      controller: semaiAwalController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Awal Fase',
                      errorText: _semaiAwalError.isNotEmpty ? _semaiAwalError : null,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, semaiAwalController),
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
                      controller: semaiAkhirController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Akhir Fase',
                      errorText: _semaiAkhirError.isNotEmpty ? _semaiAkhirError : null,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, semaiAkhirController),
                      ),
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
                      controller: vegetatifAwalController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Awal Fase',
                      errorText: _vegetatifAwalError.isNotEmpty ? _vegetatifAwalError : null,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, vegetatifAwalController),
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
                      controller: vegetatifAkhirController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Akhir Fase',
                      errorText: _vegetatifAkhirError.isNotEmpty ? _vegetatifAkhirError : null,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, vegetatifAkhirController),
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
                      controller: penyiramanAwalController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Awal Fase',
                      errorText: _penyiramanAwalError.isNotEmpty ? _penyiramanAwalError : null,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, penyiramanAwalController),
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
                      controller: penyiramanAkhirController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Akhir Fase',
                      errorText: _penyiramanAkhirError.isNotEmpty ? _penyiramanAkhirError : null,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, penyiramanAkhirController),
                      ),
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
