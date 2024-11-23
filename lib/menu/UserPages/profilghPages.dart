import 'dart:convert';
import 'dart:io';

import 'package:apps/SendApi/tokenJWT.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:http/http.dart' as http;
import 'package:apps/SendApi/Server.dart';
import 'package:apps/SendApi/ghApi.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart'; // Pastikan path import ini benar
import 'package:apps/src/customColor.dart';
import 'package:apps/src/customConfirmDialog.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfilGHPage extends StatefulWidget {
  const ProfilGHPage({super.key});

  @override
  _ProfilGHPageState createState() => _ProfilGHPageState();
}

class _ProfilGHPageState extends State<ProfilGHPage> {
  // Inisialisasi _isEditing sebagai false di awal
  bool _isEditing = false; // Pastikan ini false
  String? _selectedGH;
  String? _idGH = "";
  List<String> _ghList = [];

  void _loadGHData(String gh) {
    final data = _ghData[gh]; // Mengambil Sdata berdasarkan nama GH
    // Menyesuaikan controller dengan data yang diterima
    namaGHController.text = data['nama']!;
    alamatGHController.text = data['alamat']!;
    fokusPertanianController.text = data['fokus']!;
    foto = data['foto']!;
    tanggalGHController.text = formatTanggal(data['tanggal']!);
    metodePenanamanController.text = data['metode']!;
    luasGHController.text = data['luas'] ?? "";
    jumlahPopulasiController.text = data['populasi'] ?? "";

    // Menyimpan ID GH untuk kebutuhan lainnya
    _idGH = data['uuid']; // Menyimpan ID Greenhouse
    print("id gh : $_idGH");
  }

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
  void showDataGh() async {
    final result = await ghApi.getDataGh();
    if (result != null) {
      print(result['data_gh']);
      _ghData = result['data_gh'];
      _ghList = result['data_gh'].keys.toList();
      _selectedGH = "GH 1";
      _loadGHData(_selectedGH!);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda belum memiliki Green House!')),
      );
    }
  }

  // Data dummy untuk setiap GH
  Map<String, dynamic> _ghData = {};

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
        tanggalGHController.text =
            "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    showDataGh();

    // Tambahkan listeners untuk setiap controller
    namaGHController.addListener(() => _clearError('namaGH'));
    alamatGHController.addListener(() => _clearError('alamatGH'));
    fokusPertanianController.addListener(() => _clearError('fokusPertanian'));
    tanggalGHController.addListener(() => _clearError('tanggalGH'));
    metodePenanamanController.addListener(() => _clearError('metodePenanaman'));
    luasGHController.addListener(() => _clearError('luasGH'));
    jumlahPopulasiController.addListener(() => _clearError('jumlahPopulasi'));
  }

  String formatTanggal(String tgl) {
    // Parse string tanggal ke dalam objek DateTime
    DateTime tanggal = DateTime.parse(tgl);

// Ambil tahun, bulan, dan tanggal
    int tahun = tanggal.year;
    int bulan = tanggal.month;
    int hari = tanggal.day;

// Jika ingin menampilkan dalam format yang lebih spesifik
    String tanggalFormatted = '$tahun-$bulan-$hari';
    return tanggalFormatted;
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
        case 'namaGH':
          _namaGHError = '';
        case 'alamatGH':
          _alamatGHError = '';
        case 'fokusPertanian':
          _fokusPertanianError = '';
        case 'tanggalGH':
          _tanggalGHError = '';
        case 'metodePenanaman':
          _metodePenanamanError = '';
        case 'luasGH':
          _luasGHError = '';
        case 'jumlahPopulasi':
          _jumlahPopulasiError = '';
      }
    });
  }

  void _validateInputs() async {
    setState(() {
      _namaGHError =
          namaGHController.text.isEmpty ? 'Nama GH tidak boleh kosong' : '';
      _alamatGHError =
          alamatGHController.text.isEmpty ? 'Alamat GH tidak boleh kosong' : '';
      _fokusPertanianError = fokusPertanianController.text.isEmpty
          ? 'Fokus Pertanian tidak boleh kosong'
          : '';
      _tanggalGHError = tanggalGHController.text.isEmpty
          ? 'Tanggal GH tidak boleh kosong'
          : '';
      _metodePenanamanError = metodePenanamanController.text.isEmpty
          ? 'Metode Penanaman tidak boleh kosong'
          : '';
      _luasGHError =
          luasGHController.text.isEmpty ? 'Luas GH tidak boleh kosong' : '';
      _jumlahPopulasiError = jumlahPopulasiController.text.isEmpty
          ? 'Jumlah Populasi tidak boleh kosong'
          : '';
    });

    if ([
      _namaGHError,
      _alamatGHError,
      _fokusPertanianError,
      _tanggalGHError,
      _metodePenanamanError,
      _luasGHError,
      _jumlahPopulasiError
    ].every((error) => error.isEmpty)) {
      bool confirm = await CustomConfirmDialog.show(
        context: context,
        title: 'Konfirmasi',
        message: 'Apakah anda yakin ingin menyimpan perubahan?',
        confirmText: 'Ya',
        cancelText: 'Tidak',
      );

      if (confirm) {
        setState(() {
          postDataToServer();
          _isEditing = false;
        });
      }
    }
  }

  void _deleteGH() async {
    bool confirm = await CustomConfirmDialog.show(
      context: context,
      title: 'Konfirmasi',
      message: 'Apakah anda yakin ingin menghapus GH ini?',
      confirmText: 'Hapus',
      cancelText: 'Batal',
    );

    if (confirm) {
      final result = await ghApi.deleteDataGh(_idGH.toString());
      print(_idGH);
      print("result : $result");
      if (result != null && result['data'] != null) {
        await TokenJwt.saveToken(result['data'].toString());
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Gagal menghapus green house : ${result?['message']}')),
        );
      }
    }
  }

// awal backend

  String foto = "";
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  String ImageSaatIni = "";
  Future<void> getImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        ImageSaatIni = _encodeBase64(pickedFile.name);
        print("GAMBAR : $ImageSaatIni");
      });
    }
  }

  Future<void> postDataToServer() async {
    String? email =
        await TokenJwt.getEmail(); // Persiapkan data yang akan dikirim
    Map<String, dynamic> data = {
      'id_gh': _idGH,
      'nama_gh': namaGHController.text,
      'fokus_gh': fokusPertanianController.text,
      'metode_gh': metodePenanamanController.text,
      'alamat_gh': alamatGHController.text,
      'luasgh': luasGHController.text,
      'populasi': jumlahPopulasiController.text,
      'tanggal': tanggalGHController.text,
      'foto_gh': ImageSaatIni,
      'email': email.toString(),
    };

    // Buat request POST ke URL server
    Uri url = Server.urlLaravel("green-house/update");
    print("Data yang di kirim : $data");
    try {
      String? token = await TokenJwt.getToken();
      final response = await http.put(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": token.toString()
          },
          body: json.encode(data));

      // Periksa kode status respons
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print("Hasil pengiriman data : $result");
        _uploadImage();
        Navigator.pop(context);
      } else {
        // Gagal mengirim
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Gagal mengirim data. keterangan : ${json.decode(response.body)['message']}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim data. keterangan : $error')),
      );
      print('Terjadi kesalahan1: $url ');
      print('Terjadi kesalahan2: ${json.encode(data)} ');
      print('Terjadi kesalahan3: $error ');
    }
  }

  late http.MultipartRequest request;
  Future<void> _uploadImage() async {
    if (_profileImage == null) {
      print("Foto kosong");
      return;
    }

    // Menyiapkan request untuk mengunggah gambar ke server
    var request = http.MultipartRequest(
      'POST',
      Server.urlLaravel("green-house/uploadFoto"), // Mengubah ke Uri.parse
    );

    // Menambahkan file gambar ke dalam request
    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // Nama field harus sesuai dengan API di Laravel
        _profileImage!.path,
        filename: ImageSaatIni,
      ),
    );

    try {
      // Mengirim request ke server
      var response = await request.send();

      // Menangani respons server
      if (response.statusCode == 200) {
        print('Gambar berhasil diunggah');
      } else {
        // Cetak isi respons untuk debug
        String responseBody = await response.stream.bytesToString();
        print('Terjadi kesalahan: Kode status: ${response.statusCode}');
        print('Isi respons: $responseBody'); // Tampilkan seluruh isi respons

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Terjadi kesalahan saat mengunggah gambar\nKode: ${response.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      print("Terjadi kesalahannn: $e");
    }
  }

  static String _encodeBase64(String str) {
    // Extract the file name without the extension
    // Split the file path to get the file name and extension

    List<String> nameParts = str.split('.');

    // Separate the base name and the extension
    String baseName = nameParts[0];
    String extension = nameParts.length > 1 ? nameParts.last : "";

    // Encode the base name in Base64
    String encodedBaseName = base64Url.encode(utf8.encode(baseName));

    // Limit the encoded result to a maximum of 50 characters
    String truncatedEncodedBaseName = encodedBaseName.length > 30
        ? encodedBaseName.substring(0, 30)
        : encodedBaseName;

    // Combine the encoded base name with the original extension
    return extension.isNotEmpty
        ? "$truncatedEncodedBaseName.$extension"
        : truncatedEncodedBaseName;
  }

//akhir backend
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
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                        child: _profileImage != null
                            ? Image.file(
                                _profileImage!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : foto == ""
                                ? Image.asset(
                                    'assets/images/Logos Apps.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    Server.UrlImageGreenhouse(foto))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _isEditing ? getImage : null,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: CustomColors.coklatMedium,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
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
              onChanged: _isEditing
                  ? null
                  : (String? newValue) {
                      setState(() {
                        _selectedGH = newValue;
                        _loadGHData(newValue!); // Load data ketika GH dipilih
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
              maxLines: 3,
              onChanged: (value) {
                setState(() {
                  _alamatGHError = '';
                });
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _isEditing ? () => _selectDate(context) : null,
              child: AbsorbPointer(
                child: CustomFormField(
                  controller: tanggalGHController,
                  labelText: 'Tanggal GH Dibuat',
                  hintText: 'Pilih Tanggal',
                  errorText:
                      _tanggalGHError.isNotEmpty ? _tanggalGHError : null,
                  enabled: _isEditing,
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomFormField(
              controller: metodePenanamanController,
              labelText: 'Metode Penanaman',
              hintText: 'Masukkan Metode Penanaman',
              errorText: _metodePenanamanError.isNotEmpty
                  ? _metodePenanamanError
                  : null,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _metodePenanamanError = '';
                });
              },
            ),
            const SizedBox(height: 20),
            CustomFormField(
              controller: fokusPertanianController,
              labelText: 'Fokus Pertanian',
              hintText: 'Masukkan Fokus Pertanian',
              errorText: _metodePenanamanError.isNotEmpty
                  ? _metodePenanamanError
                  : null,
              enabled: _isEditing,
              onChanged: (value) {
                setState(() {
                  _metodePenanamanError = '';
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomFormField(
                    controller: luasGHController,
                    labelText: 'Luas Green House',
                    hintText: 'Masukkan Luas',
                    errorText: _luasGHError.isNotEmpty ? _luasGHError : null,
                    enabled: _isEditing,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'm² (Meter Persegi)',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'NotoSanSemiBold',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomFormField(
                    controller: jumlahPopulasiController,
                    labelText: 'Jumlah Populasi Tanaman',
                    hintText: 'Masukkan Jumlah',
                    errorText: _jumlahPopulasiError.isNotEmpty
                        ? _jumlahPopulasiError
                        : null,
                    enabled: _isEditing,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Lubang Tanam',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'NotoSanSemiBold',
                      ),
                    ),
                  ),
                ),
              ],
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
