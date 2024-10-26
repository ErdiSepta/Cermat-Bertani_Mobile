import 'package:apps/src/customFormfield.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart';
import 'package:apps/src/customColor.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilAkunPage extends StatefulWidget {
  const ProfilAkunPage({super.key});

  @override
  State<ProfilAkunPage> createState() => _ProfilAkunPageState();
}

class _ProfilAkunPageState extends State<ProfilAkunPage> {
  bool _isEditing = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Definisi controller untuk setiap field secara manual
  final namaLengkapController = TextEditingController(text: 'Ilhammm');
  final nikController = TextEditingController(text: '3512395710297312');
  final jenisKelaminController = TextEditingController(text: 'Laki - Laki');
  final noHpController = TextEditingController(text: '081345123120');
  final alamatController = TextEditingController(text: 'Nganjuk, Bogo');
  final jumlahGHController = TextEditingController(text: '3');

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
    jenisKelaminController.addListener(() => _clearError('jenisKelamin'));
    noHpController.addListener(() => _clearError('noHp'));
    alamatController.addListener(() => _clearError('alamat'));
    jumlahGHController.addListener(() => _clearError('jumlahGH'));
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

  void _validateInputs() {
    setState(() {
      _namaLengkapError = namaLengkapController.text.isEmpty
          ? 'Nama lengkap tidak boleh kosong'
          : '';
      _nikError = nikController.text.isEmpty ? 'NIK tidak boleh kosong' : '';
      _jenisKelaminError = jenisKelaminController.text.isEmpty
          ? 'Jenis kelamin tidak boleh kosong'
          : '';
      _noHpError =
          noHpController.text.isEmpty ? 'No HP tidak boleh kosong' : '';
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sukses'),
            content: const Text('Data profil berhasil disimpan'),
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

  Future<void> getImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
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
                        child: _image != null
                            ? Image.file(
                                _image!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/fufufafa.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
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
                onChanged: (value) {
                  setState(() {
                    _nikError = '';
                  });
                },
              ),
              const SizedBox(height: 20),
              CustomFormField(
                controller: jenisKelaminController,
                labelText: 'Jenis Kelamin',
                hintText: 'Masukan Jenis Kelamin',
                errorText:
                    _jenisKelaminError.isNotEmpty ? _jenisKelaminError : null,
                enabled: _isEditing,
                onChanged: (value) {
                  setState(() {
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
                onChanged: (value) {
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
                enabled: _isEditing,
                onChanged: (value) {
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
                      onPressed: _isEditing
                          ? () {
                              // Implementasi fungsi save
                              setState(() {
                                _isEditing = false;
                              });
                            }
                          : null,
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

  @override
  void dispose() {
    // Dispose semua controller
    namaLengkapController.dispose();
    nikController.dispose();
    jenisKelaminController.dispose();
    noHpController.dispose();
    alamatController.dispose();
    jumlahGHController.dispose();
    super.dispose();
  }
}
