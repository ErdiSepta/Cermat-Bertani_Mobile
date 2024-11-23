import 'package:apps/SendApi/userApi.dart';
import 'package:apps/menu/UserPages/register4Pages.dart';
import 'package:apps/src/customColor.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:apps/src/customConfirmDialog.dart';

class Register3 extends StatefulWidget {
  final String nik;
  final String email;
  final String nama;
  final String gender;
  final String noHp;
  final String alamat;

  const Register3(
      {super.key,
      required this.nik,
      required this.email,
      required this.nama,
      required this.gender,
      required this.noHp,
      required this.alamat});

  @override
  _Register3State createState() => _Register3State();
}

class _Register3State extends State<Register3> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  double _strength = 0;
  bool _isLoading = false;
  String _password = '';

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool get _isButtonEnabled =>
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text &&
      _strength >= 2 / 4;

  String _getPasswordStrengthText() {
    if (_strength <= 1 / 4) {
      return 'Lemah';
    } else if (_strength == 2 / 4) {
      return 'Sedang';
    } else if (_strength == 3 / 4) {
      return 'Kuat';
    } else {
      return 'Sangat Kuat';
    }
  }

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  void _checkPassword(String value) {
    _password = value.trim();

    if (_password.isEmpty) {
      setState(() {
        _strength = 0;
      });
    } else if (_password.length < 6) {
      setState(() {
        _strength = 1 / 4;
      });
    } else if (_password.length < 8) {
      setState(() {
        _strength = 2 / 4;
      });
    } else {
      if (!letterReg.hasMatch(_password) || !numReg.hasMatch(_password)) {
        setState(() {
          _strength = 3 / 4;
        });
      } else {
        setState(() {
          _strength = 1;
        });
      }
    }
  }

  void _handleNext() async {
    bool confirm = await CustomConfirmDialog.show(
      context: context,
      title: 'Konfirmasi',
      message: 'Apakah password yang anda masukkan sudah benar?',
      confirmText: 'Ya',
      cancelText: 'Tidak',
    );

    if (confirm) {
      setState(() {
        _isLoading = true;
        _registerUser();
      });

      // Simulasi loading 2 detik
    }
  }

  void showDataPrint() {
    print("data : ${widget.nik}");
    print("data : ${widget.nama}");
    print("data : ${widget.gender}");
    print("data : ${widget.noHp}");
    print("data : ${widget.alamat}");
    print("data : ${widget.email}");
    print("data : ${_passwordController.text}");
    print("data : ${_confirmPasswordController.text}");
  }

  Future<void> _registerUser() async {
    final result = await UserApi.register(
        widget.nik,
        widget.nama,
        widget.gender,
        widget.noHp,
        widget.alamat,
        widget.email,
        _passwordController.text,
        _confirmPasswordController.text);
    showDataPrint();
    if (result != null) {
      if (result['status'] == "success") {
        print("Result : $result");
        // Berhasil mendaftar
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Register4pages()),
        );
      } else if (result['status'] == "error") {
        print("Resultt : $result");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pendaftaran gagal: ${result['message']}')),
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    const Center(
                      child: Text(
                        'Buat Akun',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.black,
                          fontFamily: 'OdorMeanChey',
                        ),
                      ),
                    ),
                    const SizedBox(height: 75),
                    CustomFormField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Masukan Password Pengguna',
                      obscureText: !_isPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      onChanged: (value) {
                        _checkPassword(value);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 5,
                          child: LinearProgressIndicator(
                            value: _strength,
                            backgroundColor: Colors.grey[300],
                            color: _strength <= 1 / 4
                                ? Colors.red
                                : _strength == 2 / 4
                                    ? Colors.yellow
                                    : _strength == 3 / 4
                                        ? Colors.blue
                                        : Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _getPasswordStrengthText(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomFormField(
                      controller: _confirmPasswordController,
                      labelText: 'Konfirmasi Password',
                      hintText: 'Masukan Kembali Password',
                      obscureText: !_isConfirmPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          onPressed: _isButtonEnabled ? _handleNext : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isButtonEnabled
                                ? CustomColors.BiruPrimary
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                          ),
                          child: const Text(
                            'Buat',
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
                    const SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon:
                              Image.asset('assets/images/back.png', width: 24),
                          label: const Text(
                            'Kembali',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'NotoSanSemiBold',
                              fontWeight: FontWeight.w400,
                            ),
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/animations/loading.json',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Mohon Tunggu...',
                      style: TextStyle(
                        fontFamily: 'NotoSanSemiBold',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
