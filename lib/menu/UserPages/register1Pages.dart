import 'package:apps/SendApi/userApi.dart';
import 'package:apps/menu/Models/RegisterModels.dart';
import 'package:apps/menu/UserPages/register2Pages.dart';
import 'package:apps/src/customColor.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/pageTransition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apps/src/autofilltext.dart';
import 'package:apps/src/customConfirmDialog.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? _selectedGender;
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  String _nikError = '';
  String _namaError = '';
  String _alamatError = '';
  String _genderError = '';
  final TextEditingController _noHpController = TextEditingController();
  String _noHpError = '';
  final TextEditingController _emailController = TextEditingController();
  String _emailError = '';

  @override
  void initState() {
    super.initState();
    _nikController.addListener(_clearNikError);
    _emailController.addListener(_clearEmailError);
    _namaController.addListener(_clearNamaError);
    _alamatController.addListener(_clearAlamatError);
    _noHpController.addListener(_clearNoHpError);
  }

  @override
  void dispose() {
    _nikController.removeListener(_clearNikError);
    _emailController.removeListener(_clearEmailError);
    _namaController.removeListener(_clearNamaError);
    _alamatController.removeListener(_clearAlamatError);
    _noHpController.removeListener(_clearNoHpError);
    _nikController.dispose();
    _emailController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  void _clearNikError() {
    if (_nikError.isNotEmpty) {
      setState(() {
        _nikError = '';
      });
    }
  }

  void _clearEmailError() {
    if (_emailError.isNotEmpty) {
      setState(() {
        _emailError = '';
      });
    }
  }

  void _clearNamaError() {
    if (_namaError.isNotEmpty) {
      setState(() {
        _namaError = '';
      });
    }
  }

  void _clearAlamatError() {
    if (_alamatError.isNotEmpty) {
      setState(() {
        _alamatError = '';
      });
    }
  }

  void _clearNoHpError() {
    if (_noHpError.isNotEmpty) {
      setState(() {
        _noHpError = '';
      });
    }
  }

  void _clearGenderError() {
    if (_genderError.isNotEmpty) {
      setState(() {
        _genderError = '';
      });
    }
  }

  void _validateInputs() async {
    setState(() {
      // Validasi NIK
      if (_nikController.text.isEmpty) {
        _nikError = 'NIK tidak boleh kosong';
      } else if (_nikController.text.length != 16) {
        _nikError = 'NIK harus 16 digit';
      } else {
        _nikError = '';
      }

      // Validasi Email
      if (_emailController.text.isEmpty) {
        _emailError = 'Email tidak boleh kosong';
      } else if (!_emailController.text.endsWith('@gmail.com')) {
        _emailError = 'Email Tidak Valid';
      } else {
        _emailError = '';
      }

      // Validasi No HP
      if (_noHpController.text.isEmpty) {
        _noHpError = 'Nomor HP tidak boleh kosong';
      } else if (!_noHpController.text.startsWith('08')) {
        _noHpError = 'Nomor HP Tidak Valid';
      } else if (_noHpController.text.length > 13) {
        _noHpError = 'Nomor HP maksimal 13 digit';
      } else {
        _noHpError = '';
      }

      // Validasi lainnya
      _namaError =
          _namaController.text.isEmpty ? 'Nama tidak boleh kosong' : '';
      _alamatError =
          _alamatController.text.isEmpty ? 'Alamat tidak boleh kosong' : '';
      _genderError =
          _selectedGender == null ? 'Jenis kelamin harus dipilih' : '';
    });

    if (_nikError.isEmpty &&
        _emailError.isEmpty &&
        _namaError.isEmpty &&
        _alamatError.isEmpty &&
        _genderError.isEmpty &&
        _noHpError.isEmpty) {
      // Memeriksa ketersediaan email
      String? emailCheckMessage =
          await UserApi.checkEmailAvailability(_emailController.text);
      if (emailCheckMessage == "success") {
        bool confirm = await CustomConfirmDialog.show(
          context: context,
          title: 'Konfirmasi',
          message: 'Apakah data yang anda masukkan sudah benar?',
          confirmText: 'Ya',
          cancelText: 'Tidak',
        );
        if (confirm) {
          // Membuat objek RegisterData
          final registerData = RegisterData(
            nik: _nikController.text,
            email: _emailController.text,
            nama: _namaController.text,
            gender: _selectedGender!,
            noHp: _noHpController.text,
            alamat: _alamatController.text,
          );
          Navigator.push(
            context,
            SmoothPageTransition(
              page: Register2(registerData: registerData),
            ),
          );
        }
        return;
        // Mengirim data ke halaman Register2
      } else {
        setState(() {
          _emailError = emailCheckMessage
              .toString(); // Tampilkan pesan error jika email sudah digunakan
          print(emailCheckMessage);
        });
        print(emailCheckMessage);
        return;
      }
    }
  }

  void _autoFillForTesting() {
    AutoFillText.autoFillRegister1(
      _nikController,
      _emailController,
      _namaController,
      (String? gender) {
        setState(() {
          _selectedGender = gender;
        });
      },
      _noHpController,
      _alamatController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Center(
                  child: GestureDetector(
                    onDoubleTap: _autoFillForTesting,
                    child: const Text(
                      'Buat Akun',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontFamily: 'OdorMeanChey',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                CustomFormField(
                  controller: _nikController,
                  labelText: 'Nomor Induk Kependudukan',
                  hintText: 'Masukan NIK Sesuai KTP',
                  errorText: _nikError.isNotEmpty ? _nikError : null,
                  maxLength: 16,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  controller: _emailController,
                  labelText: 'Email Pengguna',
                  hintText: 'Masukan Email Aktif Pengguna',
                  errorText: _emailError.isNotEmpty ? _emailError : null,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  controller: _namaController,
                  labelText: 'Nama Lengkap Sesuai KTP',
                  hintText: 'Masukan Nama Lengkap Sesuai KTP',
                  errorText: _namaError.isNotEmpty ? _namaError : null,
                  textCapitalization: TextCapitalization.words,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Jenis Kelamin',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'NotoSanSemiBold'),
                ),
                const SizedBox(height: 10),
                InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12.0),
                    errorText: _genderError.isNotEmpty ? _genderError : null,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedGender,
                      isExpanded: true,
                      hint: const Text('Pilih Jenis Kelamin'),
                      items: <String>['laki-laki', 'perempuan']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGender = newValue;
                          _clearGenderError(); // Panggil metode ini untuk menghapus pesan error
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  controller: _noHpController,
                  labelText: 'Nomor HP',
                  hintText: 'Masukkan Nomor HP',
                  errorText: _noHpError.isNotEmpty ? _noHpError : null,
                  maxLength: 13,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(13),
                  ],
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  controller: _alamatController,
                  labelText: 'Alamat',
                  hintText: 'Masukkan Alamat Lengkap',
                  errorText: _alamatError.isNotEmpty ? _alamatError : null,
                  maxLines: 3, // Membuat textfield lebih lebar
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
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      child: const Text(
                        'Lanjutkan',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'NotoSanSemiBold',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset('assets/images/back.png', width: 24),
                      label: const Text(
                        'Kembali',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'NotoSanSemiBold  ',
                            fontWeight: FontWeight.w400),
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        side: const BorderSide(color: Colors.black),
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
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
