import 'package:apps/SendApi/HamaAndPenyakitApi.dart';
import 'package:apps/SendApi/ghApi.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/topnav.dart';
import 'package:apps/src/customConfirmDialog.dart';

class HamaPenyakitPages extends StatefulWidget {
  const HamaPenyakitPages({super.key});

  @override
  State<HamaPenyakitPages> createState() => _HamaPenyakitPagesState();
}

class _HamaPenyakitPagesState extends State<HamaPenyakitPages> {
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
  String? selectedWarnaDaun;
  String? selectedWarnaBatang;
  String? selectedSeranganHama;

  final TextEditingController warnaDaunLainController = TextEditingController();
  final TextEditingController warnaBatangLainController =
      TextEditingController();
  final TextEditingController seranganHamaLainController =
      TextEditingController();
  final TextEditingController caraPenangananController =
      TextEditingController();
  final TextEditingController pestisidaController = TextEditingController();

  // Data dummy untuk dropdown
  final List<String> greenhouseList = ['GH-01', 'GH-02', 'GH-03'];
  final List<String> warnaDaunList = ['Hijau', 'Kuning', 'Coklat', 'Lainnya'];
  final List<String> warnaBatangList = ['Coklat', 'Hitam', 'Putih', 'Lainnya'];
  final List<String> seranganHamaList = ['Ulat', 'Kutu', 'Belalang', 'Lainnya'];

  // Tambahkan variabel error
  String _greenhouseError = '';
  String _warnaDaunError = '';
  String _warnaBatangError = '';
  String _seranganHamaError = '';
  String _warnaDaunLainError = '';
  String _warnaBatangLainError = '';
  String _seranganHamaLainError = '';
  String _caraPenangananError = '';
  String _pestisidaError = '';

  @override
  void initState() {
    super.initState();
    showDataGh();
    warnaDaunLainController.addListener(_clearWarnaDaunLainError);
    warnaBatangLainController.addListener(_clearWarnaBatangLainError);
    seranganHamaLainController.addListener(_clearSeranganHamaLainError);
    caraPenangananController.addListener(_clearCaraPenangananError);
    pestisidaController.addListener(_clearPestisidaError);
  }

  // Fungsi clear error
  void _clearWarnaDaunLainError() {
    if (_warnaDaunLainError.isNotEmpty) {
      setState(() => _warnaDaunLainError = '');
    }
  }

  void _clearWarnaBatangLainError() {
    if (_warnaBatangLainError.isNotEmpty) {
      setState(() => _warnaBatangLainError = '');
    }
  }

  void _clearSeranganHamaLainError() {
    if (_seranganHamaLainError.isNotEmpty) {
      setState(() => _seranganHamaLainError = '');
    }
  }

  void _clearCaraPenangananError() {
    if (_caraPenangananError.isNotEmpty) {
      setState(() => _caraPenangananError = '');
    }
  }

  void _clearPestisidaError() {
    if (_pestisidaError.isNotEmpty) setState(() => _pestisidaError = '');
  }

  void _validateInputs() async {
    setState(() {
      _greenhouseError = _selectedGH == null ? 'Greenhouse harus dipilih' : '';
      _warnaDaunError =
          selectedWarnaDaun == null ? 'Warna daun harus dipilih' : '';
      _warnaBatangError =
          selectedWarnaBatang == null ? 'Warna batang harus dipilih' : '';
      _seranganHamaError =
          selectedSeranganHama == null ? 'Serangan hama harus dipilih' : '';

      // Validasi input lain jika "Lainnya" dipilih
      if (selectedWarnaDaun == 'Lainnya' &&
          warnaDaunLainController.text.isEmpty) {
        _warnaDaunLainError = 'Warna daun lain harus diisi';
      }
      if (selectedWarnaBatang == 'Lainnya' &&
          warnaBatangLainController.text.isEmpty) {
        _warnaBatangLainError = 'Warna batang lain harus diisi';
      }
      if (selectedSeranganHama == 'Lainnya' &&
          seranganHamaLainController.text.isEmpty) {
        _seranganHamaLainError = 'Serangan hama lain harus diisi';
      }
    });

    if (_greenhouseError.isEmpty &&
        _warnaDaunError.isEmpty &&
        _warnaBatangError.isEmpty &&
        _seranganHamaError.isEmpty &&
        _warnaDaunLainError.isEmpty &&
        _warnaBatangLainError.isEmpty &&
        _seranganHamaLainError.isEmpty) {
      bool confirm = await CustomConfirmDialog.show(
        context: context,
        title: 'Konfirmasi',
        message: 'Apakah data yang anda masukkan sudah benar?',
        confirmText: 'Ya',
        cancelText: 'Tidak',
      );

      String? getwarnaDaun = warnaDaunLainController.text.isEmpty
          ? selectedWarnaDaun
          : warnaDaunLainController.text;
      String? getwarnaBatang = warnaBatangLainController.text.isEmpty
          ? selectedWarnaBatang
          : warnaBatangLainController.text;
      String? getSerangan = seranganHamaLainController.text.isEmpty
          ? selectedSeranganHama
          : seranganHamaLainController.text;
      String? getPenanganan = caraPenangananController.text.isEmpty
          ? "Belum Ada"
          : caraPenangananController.text;
      String? getSPestisida =
          pestisidaController.text.isEmpty ? "0" : pestisidaController.text;
      if (confirm) {
        final result = await HamaAndPenyakitApi.tambahHamaAndPenyakit(
            getwarnaDaun.toString(),
            getwarnaBatang.toString(),
            getSerangan.toString(),
            getPenanganan.toString(),
            getSPestisida.toString(),
            _idGH.toString());
        print("Isi data yang di kirim : $getwarnaDaun $getwarnaBatang $getSerangan $getPenanganan $getSPestisida $_idGH");
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
          title: 'Hama & Penyakit',
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
                  'assets/images/hama.png',
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

              // Warna Daun dropdown dan textfield
              CustomDropdown(
                labelText: 'Warna Daun',
                hintText: 'Pilih Warna Daun',
                value: selectedWarnaDaun ?? warnaDaunList[0],
                items: warnaDaunList,
                errorText: _warnaDaunError.isNotEmpty ? _warnaDaunError : null,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedWarnaDaun = newValue;
                    _warnaDaunError = '';
                    if (newValue != 'Lainnya') {
                      warnaDaunLainController.clear();
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              CustomFormField(
                controller: warnaDaunLainController,
                labelText: 'Warna Daun Lain',
                hintText: 'Masukan Warna Daun Lain',
                enabled: selectedWarnaDaun == 'Lainnya',
                errorText:
                    _warnaDaunLainError.isNotEmpty ? _warnaDaunLainError : null,
              ),

              const SizedBox(height: 20),

              // Warna Batang dropdown dan textfield
              CustomDropdown(
                labelText: 'Warna Batang',
                hintText: 'Pilih Warna Batang',
                value: selectedWarnaBatang ?? warnaBatangList[0],
                items: warnaBatangList,
                errorText:
                    _warnaBatangError.isNotEmpty ? _warnaBatangError : null,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedWarnaBatang = newValue;
                    _warnaBatangError = '';
                    if (newValue != 'Lainnya') {
                      warnaBatangLainController.clear();
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              CustomFormField(
                controller: warnaBatangLainController,
                labelText: 'Warna Batang Lain',
                hintText: 'Masukan Warna Batang Lain',
                enabled: selectedWarnaBatang == 'Lainnya',
                errorText: _warnaBatangLainError.isNotEmpty
                    ? _warnaBatangLainError
                    : null,
              ),

              const SizedBox(height: 20),
              // Serangan Hama dropdown dan textfield
              CustomDropdown(
                labelText: 'Serangan Hama',
                hintText: 'Tentukan Serangan Hama',
                value: selectedSeranganHama ?? seranganHamaList[0],
                items: seranganHamaList,
                errorText:
                    _seranganHamaError.isNotEmpty ? _seranganHamaError : null,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSeranganHama = newValue;
                    _seranganHamaError = '';
                    if (newValue != 'Lainnya') {
                      seranganHamaLainController.clear();
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              CustomFormField(
                controller: seranganHamaLainController,
                labelText: 'Serangan Hama Lain',
                hintText: 'Masukan Serangan Hama Lain',
                enabled: selectedSeranganHama == 'Lainnya',
                errorText: _seranganHamaLainError.isNotEmpty
                    ? _seranganHamaLainError
                    : null,
              ),

              const SizedBox(height: 20),

              // Cara Penanganan
              CustomFormField(
                controller: caraPenangananController,
                labelText: 'Cara Penanganan',
                hintText: 'Kosongkan Jika Belum ada',
                errorText: _caraPenangananError.isNotEmpty
                    ? _caraPenangananError
                    : null,
              ),
              const SizedBox(height: 20),

              // Pestisida Yang Digunakan
              CustomFormField(
                controller: pestisidaController,
                labelText: 'Pestisida Yang Digunakan',
                hintText: 'Kosongkan Jika Belum ada',
                errorText: _pestisidaError.isNotEmpty ? _pestisidaError : null,
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
    // Tambahkan remove listeners
    warnaDaunLainController.removeListener(_clearWarnaDaunLainError);
    warnaBatangLainController.removeListener(_clearWarnaBatangLainError);
    seranganHamaLainController.removeListener(_clearSeranganHamaLainError);
    caraPenangananController.removeListener(_clearCaraPenangananError);
    pestisidaController.removeListener(_clearPestisidaError);
    super.dispose();
  }
}
