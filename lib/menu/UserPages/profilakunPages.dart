import 'dart:convert';
import 'package:apps/SendApi/tokenJWT.dart';
import 'package:apps/src/pageTransition.dart';

import 'package:apps/SendApi/Server.dart';
import 'package:apps/SendApi/userApi.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart';
import 'package:apps/src/customColor.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/customConfirmDialog.dart';
import 'package:http/http.dart' as http;

class ProfilAkunPage extends StatefulWidget {
  const ProfilAkunPage({super.key});

  @override
  State<ProfilAkunPage> createState() => _ProfilAkunPageState();
}

class _ProfilAkunPageState extends State<ProfilAkunPage> {
  bool _isEditing = false;
  bool _isLoading = false;
  String email = "";
  String nama_lengkap = "";
  String nik = "";
  String alamat = "";
  String no_hp = "";
  String foto = "";
  int jumlah_gh = 0;

  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  String ImageSaatIni = "";
  // Definisi controller untuk setiap field
  TextEditingController namaLengkapController = TextEditingController();
  TextEditingController nikController = TextEditingController();
  TextEditingController noHpController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController jumlahGHController = TextEditingController();

  String jenis_kelamin = "laki-laki";
  final List<String> _jenisKelaminItems = ['laki-laki', 'perempuan'];

  @override
  void dispose() {
    // Bersihkan controller untuk menghindari kebocoran memori
    namaLengkapController.dispose();
    nikController.dispose();
    noHpController.dispose();
    alamatController.dispose();
    jumlahGHController.dispose();
    super.dispose();
  }

//Awal backend

  Future<void> showProfil() async {
    String? email = await TokenJwt.getEmail();
    String? token = await TokenJwt.getToken();
    final result = await UserApi.getProfil(email.toString());
    if (result != null) {
      if (result['status'] == "success") {
        if (result['data']['foto'] != null) {
          foto = result['data']['foto'];
        }
        nik = result['data']['nik'];
        nama_lengkap = result['data']['nama_lengkap'];
        no_hp = result['data']['no_telpon'];
        jenis_kelamin = result['data']['jenis_kelamin'];
        if (result['data']['alamat'] == null) {
          alamat = "";
        } else {
          alamat = result['data']['alamat'];
        }
        if (result['jumlah_greenhouse'] == null) {
          jumlah_gh = 0;
        } else {
          jumlah_gh = result['jumlah_greenhouse'];
        }
        print(nama_lengkap);
        namaLengkapController.text = nama_lengkap;
        nikController.text = nik;
        noHpController.text = no_hp;
        alamatController.text = alamat;
        jumlahGHController.text = "$jumlah_gh";
      } else if (result['status'] == "error" &&
          result['message'] == "token error must login") {
        print("Resultt : $result");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pengambilan data gagal email: ${email}}')),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pengambilan data gagal token: ${token}')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          SmoothPageTransition(page: const Login()),
          (route) => false, // Ini akan menghapus semua halaman sebelumnya
        );
      } else if (result['status'] == "error") {
        print("Resultt : $result");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Pengambilan data gagal: ${result['message']}')),
        );
      } else {
        print("Resulttt : $result");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Pendaftaran gagal: ada kesalahan pengiriman data')),
        );
      }
    } else {
      print("gagal : $result");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Pendaftaran gagal: ada kesalahan pengiriman data')),
      );
    }

    setState(() {
      _isLoading = false; // Menyembunyikan loading setelah permintaan selesai
    });
  }

  Future<void> postDataToServer() async {
    String? email =
        await TokenJwt.getEmail(); // Persiapkan data yang akan dikirim
    Map<String, dynamic> data = {
      'nik': nikController.text,
      'nama_lengkap': namaLengkapController.text,
      'alamat': alamatController.text,
      'jenis_kelamin': jenis_kelamin,
      'no_telpon': noHpController.text,
      'foto': ImageSaatIni,
      'email': email.toString(),
    };

    // Buat request POST ke URL server
    Uri url = Server.urlLaravel("users/profile/profile");

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
        await TokenJwt.saveToken(result['data'].toString());
        print(result['data']);
        _uploadImage();
        // final decodedPayload = _parseJwt(jwtToken);

        print('Data berhasil dikirim');
      } else {
        // Gagal mengirim
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Gagal mengirim data. keterangan : ${json.decode(response.body)['message']}')),
        );
        print('Gagal mengirim data. Kode status: ${response.statusCode}');
        print('Gagal mengirim data. status: ${response.body}');
        print(json.encode(data));
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

// Fungsi untuk mendekode JWT
  static Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Token tidak valid');
    }

    final payload = _decodeBase64(parts[1]);
    return json.decode(payload);
  }

  static String _decodeBase64(String str) {
    String normalized = base64Url.normalize(str);
    return utf8.decode(base64Url.decode(normalized));
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

  late http.MultipartRequest request;
  Future<void> _uploadImage() async {
    if (_profileImage == null) {
      print("Foto kosong");
      return;
    }

    // Menyiapkan request untuk mengunggah gambar ke server
    var request = http.MultipartRequest(
      'POST',
      Server.urlLaravel(
          "users/profile/profile/uploadFoto"), // Mengubah ke Uri.parse
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
//AKHIR BACKEND

  // Definisi error untuk setiap field
  String _namaLengkapError = '';
  String _nikError = '';
  String _jenisKelaminError = '';
  String _noHpError = '';
  String _alamatError = '';
  String _jumlahGHError = '';

  @override
  void initState() {
    super.initState();
    // Tambahkan listeners untuk setiap controller

    namaLengkapController.addListener(() => _clearError('namaLengkap'));
    nikController.addListener(() => _clearError('nik'));
    noHpController.addListener(() => _clearError('noHp'));
    alamatController.addListener(() => _clearError('alamat'));
    jumlahGHController.addListener(() => _clearError('jumlahGH'));
    showProfil();
  }

  void _clearError(String field) {
    setState(() {
      switch (field) {
        case 'namaLengkap':
          _namaLengkapError = '';
        case 'nik':
          _nikError = '';
        case 'jenisKelamin':
          _jenisKelaminError = '';
        case 'noHp':
          _noHpError = '';
        case 'alamat':
          _alamatError = '';
        case 'jumlahGH':
          _jumlahGHError = '';
      }
    });
  }

  void _validateInputs() async {
    setState(() {
      // Validasi NIK
      if (nikController.text.isEmpty) {
        _nikError = 'NIK tidak boleh kosong';
      } else if (nikController.text.length != 16) {
        _nikError = 'NIK harus 16 digit';
      } else {
        _nikError = '';
      }

      // Validasi No HP
      if (noHpController.text.isEmpty) {
        _noHpError = 'Nomor HP tidak boleh kosong';
      } else if (!noHpController.text.startsWith('08')) {
        _noHpError = 'Nomor HP Tidak Valid';
      } else if (noHpController.text.length > 13) {
        _noHpError = 'Nomor HP maksimal 13 digit';
      } else {
        _noHpError = '';
      }

      // Validasi lainnya
      _namaLengkapError = namaLengkapController.text.isEmpty
          ? 'Nama lengkap tidak boleh kosong'
          : '';
      _jenisKelaminError =
          jenis_kelamin.isEmpty ? 'Jenis kelamin tidak boleh kosong' : '';
      _alamatError =
          alamatController.text.isEmpty ? 'Alamat tidak boleh kosong' : '';
      _jumlahGHError =
          jumlahGHController.text.isEmpty ? 'Jumlah GH tidak boleh kosong' : '';
    });

    if (_namaLengkapError.isEmpty &&
        _nikError.isEmpty &&
        _jenisKelaminError.isEmpty &&
        _noHpError.isEmpty &&
        _alamatError.isEmpty &&
        _jumlahGHError.isEmpty) {
      // Menampilkan CustomConfirmDialog
      bool konfirmasi = await CustomConfirmDialog.show(
        context: context,
        title: 'Konfirmasi',
        message: 'Apakah Anda yakin ingin menyimpan perubahan data?',
        confirmText: 'Simpan',
        cancelText: 'Batal',
      );

      if (konfirmasi && mounted) {
        setState(() {
          postDataToServer();
        });
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Topnav(
          title: 'Akun',
          showBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  : Image.network(Server.UrlImageProfil(foto))),
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
              const SizedBox(height: 50),
              CustomFormField(
                controller: namaLengkapController,
                labelText: 'Nama Lengkap',
                hintText: 'Masukan Nama Lengkap',
                errorText:
                    _namaLengkapError.isNotEmpty ? _namaLengkapError : null,
                enabled: _isEditing,
                textCapitalization: TextCapitalization.words,
                inputFormatters: [
                  UpperCaseTextFormatter(),
                ],
                onChanged: (value) {
                  setState(() {
                    _namaLengkapError = '';
                  });
                },
              ),
              const SizedBox(height: 20),
              CustomFormField(
                controller: nikController,
                labelText: 'NIK',
                hintText: 'Masukan NIK',
                errorText: _nikError.isNotEmpty ? _nikError : null,
                enabled: _isEditing,
                maxLength: 16,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.deny(RegExp(r'[A-Za-z]')),
                  LengthLimitingTextInputFormatter(16),
                ],
                onChanged: (value) {
                  if (value.contains(RegExp(r'[A-Za-z]'))) {
                    nikController.text =
                        value.replaceAll(RegExp(r'[A-Za-z]'), '');
                  }
                  setState(() {
                    _nikError = '';
                  });
                },
              ),
              const SizedBox(height: 20),
              CustomDropdown(
                labelText: 'Jenis Kelamin',
                hintText: 'Pilih Jenis Kelamin',
                value: jenis_kelamin,
                items: _jenisKelaminItems,
                errorText:
                    _jenisKelaminError.isNotEmpty ? _jenisKelaminError : null,
                enabled: _isEditing,
                onChanged: (String? newValue) {
                  setState(() {
                    jenis_kelamin = newValue ?? jenis_kelamin;
                    _jenisKelaminError = '';
                  });
                },
              ),
              const SizedBox(height: 20),
              CustomFormField(
                controller: noHpController,
                labelText: 'No HP',
                hintText: 'Masukan No HP',
                errorText: _noHpError.isNotEmpty ? _noHpError : null,
                enabled: _isEditing,
                maxLength: 13,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.deny(RegExp(r'[A-Za-z]')),
                  LengthLimitingTextInputFormatter(13),
                ],
                onChanged: (value) {
                  if (value.contains(RegExp(r'[A-Za-z]'))) {
                    noHpController.text =
                        value.replaceAll(RegExp(r'[A-Za-z]'), '');
                  }
                  setState(() {
                    _noHpError = '';
                  });
                },
              ),
              const SizedBox(height: 20),
              CustomFormField(
                controller: alamatController,
                labelText: 'Alamat Lengkap',
                hintText: 'Masukan Alamat Lengkap',
                errorText: _alamatError.isNotEmpty ? _alamatError : null,
                enabled: _isEditing,
                maxLines: 3,
                onChanged: (value) {
                  setState(() {
                    _alamatError = '';
                  });
                },
              ),
              const SizedBox(height: 20),
              CustomFormField(
                controller: jumlahGHController,
                labelText: 'Jumlah GH',
                hintText: 'Masukan Jumlah GH',
                errorText: _jumlahGHError.isNotEmpty ? _jumlahGHError : null,
                enabled: false,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.deny(RegExp(r'[A-Za-z]')),
                ],
                onChanged: (value) {
                  if (value.contains(RegExp(r'[A-Za-z]'))) {
                    jumlahGHController.text =
                        value.replaceAll(RegExp(r'[A-Za-z]'), '');
                  }
                  setState(() {
                    _jumlahGHError = '';
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
                            fontWeight: FontWeight.w400),
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
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
