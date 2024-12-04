import 'package:apps/SendApi/Server.dart';
import 'package:apps/SendApi/tokenJWT.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/topnav.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/customColor.dart';
import 'package:apps/src/customConfirmDialog.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class TambahghpagePages extends StatefulWidget {
  const TambahghpagePages({super.key});

  @override
  State<TambahghpagePages> createState() => _TambahghpagePagesState();
}

class _TambahghpagePagesState extends State<TambahghpagePages> {
//awal backend
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

  Future<void> postDataToServer() async {
    String? email =
        await TokenJwt.getEmail(); // Persiapkan data yang akan dikirim
    Map<String, dynamic> data = {
      'nama_gh': namaController.text,
      'fokus_gh': fokusController.text,
      'metode_gh': metodeController.text,
      'alamat_gh': alamatController.text,
      'luasgh': luasController.text,
      'populasi': lubangController.text,
      'tanggal': tanggalController.text,
      'foto_gh': ImageSaatIni,
      'email': email.toString(),
    };

    // Buat request POST ke URL server
    Uri url = Server.urlLaravel("green-house/tambah");

    try {
      String? token = await TokenJwt.getToken();
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": token.toString()
          },
          body: json.encode(data));

      // Periksa kode status respons
      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        print("token baru : " + result['data']);

        _uploadImage();
        Navigator.pop(context);
        print('Data berhasil dikirim');
      } else if (response.statusCode == 400) {
        final result = json.decode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Gagal mengirim data. keterangan : ${result['message']}')),
        );
      } else {
        print('Terjadi kesalahan1: ${response.statusCode} ');
        print('Terjadi kesalahan1: ${response.body} ');
        print('Terjadi kesalahan2: ${json.encode(data)} ');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim data.')),
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
//  // Tambahkan variabel error
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
      if (ImageSaatIni.isNotEmpty) {
        bool confirm = await CustomConfirmDialog.show(
          context: context,
          title: 'Konfirmasi',
          message: 'Apakah data yang anda masukkan sudah benar?',
          confirmText: 'Ya',
          cancelText: 'Tidak',
        );

        if (confirm) {
          postDataToServer();
        }
        // Kembali ke halaman sebelumnya
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gambar Green House harus di isi!')),
        );
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
                                        : Image.asset(
                                            'assets/images/Logos Apps.png',
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ))),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: getImage,
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
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: CustomFormField(
                            controller: tanggalController,
                            labelText: 'Tanggal GH Dibuat',
                            hintText: 'Pilih Tanggal',
                            errorText:
                                _tanggalError.isNotEmpty ? _tanggalError : null,
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
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
                            'Jumlah Populasi Tanaman',
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
