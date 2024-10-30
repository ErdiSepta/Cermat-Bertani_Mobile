import 'package:apps/src/customFormfield.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart';
import 'package:apps/src/customColor.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/customConfirmDialog.dart';

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
  String _selectedJenisKelamin = 'Laki - Laki'; // Default value
  final List<String> _jenisKelaminItems = ['Laki - Laki', 'Perempuan'];
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
      _jenisKelaminError = _selectedJenisKelamin.isEmpty
          ? 'Jenis kelamin tidak boleh kosong'
          : '';
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
          _isEditing = false;
        });
      }
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
                keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.deny(RegExp(r'[A-Za-z]')),
                  LengthLimitingTextInputFormatter(16),
                ],
                onChanged: (value) {
                  if (value.contains(RegExp(r'[A-Za-z]'))) {
                    nikController.text = value.replaceAll(RegExp(r'[A-Za-z]'), '');
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
                value: _selectedJenisKelamin,
                items: _jenisKelaminItems,
                errorText:
                    _jenisKelaminError.isNotEmpty ? _jenisKelaminError : null,
                enabled: _isEditing,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedJenisKelamin = newValue ?? _selectedJenisKelamin;
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
                keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.deny(RegExp(r'[A-Za-z]')),
                  LengthLimitingTextInputFormatter(13),
                ],
                onChanged: (value) {
                  if (value.contains(RegExp(r'[A-Za-z]'))) {
                    noHpController.text = value.replaceAll(RegExp(r'[A-Za-z]'), '');
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
                enabled: _isEditing,
                keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.deny(RegExp(r'[A-Za-z]')),
                ],
                onChanged: (value) {
                  if (value.contains(RegExp(r'[A-Za-z]'))) {
                    jumlahGHController.text = value.replaceAll(RegExp(r'[A-Za-z]'), '');
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

  @override
  void dispose() {
    // Dispose semua controller
    namaLengkapController.dispose();
    nikController.dispose();
    noHpController.dispose();
    alamatController.dispose();
    jumlahGHController.dispose();
    super.dispose();
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
