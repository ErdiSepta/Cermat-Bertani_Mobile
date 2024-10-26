import 'package:apps/src/customFormfield.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart'; // Pastikan path import ini benar
import 'package:apps/src/customColor.dart';

class ProfilGHPage extends StatefulWidget {
  const ProfilGHPage({super.key});

  @override
  _ProfilGHPageState createState() => _ProfilGHPageState();
}

class _ProfilGHPageState extends State<ProfilGHPage> {
  // Inisialisasi _isEditing sebagai false di awal
  bool _isEditing = false;  // Pastikan ini false
  String? _selectedGH;
  final List<String> _ghList = ['GH 1', 'GH 2', 'GH 3', 'GH 4'];

  // Definisi controller untuk setiap field secara manual
  final namaGHController = TextEditingController();
  final alamatGHController = TextEditingController();
  final fokusPertanianController = TextEditingController();
  final tanggalGHController = TextEditingController();
  final metodePenanamanController = TextEditingController();
  final luasGHController = TextEditingController();
  final jumlahPopulasiController = TextEditingController();

  // Definisi error untuk setiap field
  String _namaGHError = '';
  String _alamatGHError = '';
  String _fokusPertanianError = '';
  String _tanggalGHError = '';
  String _metodePenanamanError = '';
  String _luasGHError = '';
  String _jumlahPopulasiError = '';

  // Data dummy untuk setiap GH
  final Map<String, Map<String, String>> _ghData = {
    'GH 1': {
      'nama': 'Green House 1',
      'alamat': 'Jl. Raya No. 1',
      'fokus': 'Sayuran',
      'tanggal': '01/01/2022',
      'metode': 'Hidroponik',
      'luas': '100 m2',
      'populasi': '1000'
    },
    'GH 2': {
      'nama': 'Green House 2',
      'alamat': 'Jl. Raya No. 2',
      'fokus': 'Buah',
      'tanggal': '02/02/2022',
      'metode': 'Aeroponik',
      'luas': '150 m2',
      'populasi': '1500'
    },
    'GH 3': {
      'nama': 'Green House 3',
      'alamat': 'Jl. Raya No. 3',
      'fokus': 'Herbal',
      'tanggal': '03/03/2022',
      'metode': 'NFT',
      'luas': '200 m2',
      'populasi': '2000'
    },
    'GH 4': {
      'nama': 'Green House 4',
      'alamat': 'Jl. Raya No. 4',
      'fokus': 'Bunga',
      'tanggal': '04/04/2022',
      'metode': 'DFT',
      'luas': '250 m2',
      'populasi': '2500'
    },
  };

  @override
  void initState() {
    super.initState();
    _selectedGH = _ghList.first;
    _loadGHData(_selectedGH!);
    
    // Tambahkan listeners untuk setiap controller
    namaGHController.addListener(() => _clearError('namaGH'));
    alamatGHController.addListener(() => _clearError('alamatGH'));
    fokusPertanianController.addListener(() => _clearError('fokusPertanian'));
    tanggalGHController.addListener(() => _clearError('tanggalGH'));
    metodePenanamanController.addListener(() => _clearError('metodePenanaman'));
    luasGHController.addListener(() => _clearError('luasGH'));
    jumlahPopulasiController.addListener(() => _clearError('jumlahPopulasi'));
  }

  void _loadGHData(String gh) {
    final data = _ghData[gh]!;
    namaGHController.text = data['nama']!;
    alamatGHController.text = data['alamat']!;
    fokusPertanianController.text = data['fokus']!;
    tanggalGHController.text = data['tanggal']!;
    metodePenanamanController.text = data['metode']!;
    luasGHController.text = data['luas']!;
    jumlahPopulasiController.text = data['populasi']!;
  }

  @override
  void dispose() {
    // Dispose semua controller
    namaGHController.dispose();
    alamatGHController.dispose();
    fokusPertanianController.dispose();
    tanggalGHController.dispose();
    metodePenanamanController.dispose();
    luasGHController.dispose();
    jumlahPopulasiController.dispose();
    super.dispose();
  }

  void _clearError(String field) {
    setState(() {
      switch (field) {
        case 'namaGH': _namaGHError = '';
        case 'alamatGH': _alamatGHError = '';
        case 'fokusPertanian': _fokusPertanianError = '';
        case 'tanggalGH': _tanggalGHError = '';
        case 'metodePenanaman': _metodePenanamanError = '';
        case 'luasGH': _luasGHError = '';
        case 'jumlahPopulasi': _jumlahPopulasiError = '';
      }
    });
  }

  void _validateInputs() {
    setState(() {
      _namaGHError = namaGHController.text.isEmpty ? 'Nama GH tidak boleh kosong' : '';
      _alamatGHError = alamatGHController.text.isEmpty ? 'Alamat GH tidak boleh kosong' : '';
      _fokusPertanianError = fokusPertanianController.text.isEmpty ? 'Fokus Pertanian tidak boleh kosong' : '';
      _tanggalGHError = tanggalGHController.text.isEmpty ? 'Tanggal GH tidak boleh kosong' : '';
      _metodePenanamanError = metodePenanamanController.text.isEmpty ? 'Metode Penanaman tidak boleh kosong' : '';
      _luasGHError = luasGHController.text.isEmpty ? 'Luas GH tidak boleh kosong' : '';
      _jumlahPopulasiError = jumlahPopulasiController.text.isEmpty ? 'Jumlah Populasi tidak boleh kosong' : '';
    });

    if ([_namaGHError, _alamatGHError, _fokusPertanianError, _tanggalGHError,
         _metodePenanamanError, _luasGHError, _jumlahPopulasiError]
        .every((error) => error.isEmpty)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sukses'),
            content: const Text('Data GH berhasil disimpan'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _isEditing = false;
                  });
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _deleteGH() {
    // Implementasi fungsi hapus GH di sini
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin menghapus GH ini?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Hapus"),
              onPressed: () {
                // Logika penghapusan GH
                print('GH $_selectedGH dihapus');
                Navigator.of(context).pop();
                // Kembali ke halaman sebelumnya setelah menghapus
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Topnav(
          title: 'Profil GH',
          showBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/images/gh.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
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
              onChanged: _isEditing ? null : (String? newValue) {
                setState(() {
                  _selectedGH = newValue;
                  _loadGHData(newValue!);  // Load data ketika GH dipilih
                });
              },
            ),
            const SizedBox(height: 20),
            CustomFormField(
              controller: namaGHController,
              labelText: 'Nama GH',
              hintText: 'Masukkan Nama GH',
              errorText: _namaGHError.isNotEmpty ? _namaGHError : null,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _namaGHError = '';
                });
              },
            ),
            const SizedBox(height: 20),
            CustomFormField(
              controller: alamatGHController,
              labelText: 'Alamat GH',
              hintText: 'Masukkan Alamat GH',
              errorText: _alamatGHError.isNotEmpty ? _alamatGHError : null,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _alamatGHError = '';
                });
              },
            ),
            const SizedBox(height: 20),
            CustomFormField(
              controller: fokusPertanianController,
              labelText: 'Fokus Pertanian',
              hintText: 'Masukkan Fokus Pertanian',
              errorText: _fokusPertanianError.isNotEmpty ? _fokusPertanianError : null,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _fokusPertanianError = '';
                });
              },
            ),
            const SizedBox(height: 20),
            CustomFormField(
              controller: tanggalGHController,
              labelText: 'Tanggal GH Dibuat',
              hintText: 'Masukkan Tanggal GH Dibuat',
              errorText: _tanggalGHError.isNotEmpty ? _tanggalGHError : null,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _tanggalGHError = '';
                });
              },
            ),
            const SizedBox(height: 20),
            CustomFormField(
              controller: metodePenanamanController,
              labelText: 'Metode Penanaman',
              hintText: 'Masukkan Metode Penanaman',
              errorText: _metodePenanamanError.isNotEmpty ? _metodePenanamanError : null,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _metodePenanamanError = '';
                });
              },
            ),
            const SizedBox(height: 20),
            CustomFormField(
              controller: luasGHController,
              labelText: 'Luas Green House',
              hintText: 'Masukkan Luas Green House',
              errorText: _luasGHError.isNotEmpty ? _luasGHError : null,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _luasGHError = '';
                });
              },
            ),
            const SizedBox(height: 20),
            CustomFormField(
              controller: jumlahPopulasiController,
              labelText: 'Jumlah Populasi Tanaman',
              hintText: 'Masukkan Jumlah Populasi Tanaman',
              errorText: _jumlahPopulasiError.isNotEmpty ? _jumlahPopulasiError : null,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _jumlahPopulasiError = '';
                });
              },
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.coklatMedium,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    child: Text(
                      _isEditing ? 'Selesai' : 'Edit',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'NotoSanSemiBold',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.BiruPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    onPressed: _isEditing ? _validateInputs : null,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'NotoSanSemiBold',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _deleteGH,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
                child: const Text(
                  'Hapus GH',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'NotoSanSemiBold',
                    fontWeight: FontWeight.w400,
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
