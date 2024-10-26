import 'package:apps/menu/UserPages/lupapassword4Pages.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/customColor.dart';

class Lupapassword3 extends StatefulWidget {
  const Lupapassword3({super.key});

  @override
  _Lupapassword3State createState() => _Lupapassword3State();
}

class _Lupapassword3State extends State<Lupapassword3> {
  final TextEditingController _passwordBaruController = TextEditingController();
  final TextEditingController _konfirmasiPasswordController = TextEditingController();
  String _passwordBaruError = '';
  String _konfirmasiPasswordError = '';
  bool _isPasswordVisible = false;
  bool _isKonfirmasiPasswordVisible = false;
  String _password = '';
  double _strength = 0;
  bool _isPasswordMatch = true;

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

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

  void _validateInputs() {
    setState(() {
      _passwordBaruError = _passwordBaruController.text.isEmpty 
          ? 'Password baru tidak boleh kosong' 
          : '';
      _konfirmasiPasswordError = _konfirmasiPasswordController.text.isEmpty
          ? 'Konfirmasi password tidak boleh kosong'
          : '';
      _isPasswordMatch = _passwordBaruController.text == _konfirmasiPasswordController.text;
    });

    if (_passwordBaruError.isEmpty &&
        _konfirmasiPasswordError.isEmpty &&
        _strength >= 1 / 2 &&
        _isPasswordMatch) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LupaPassword4()),
      );
    } else if (!_isPasswordMatch) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Peringatan'),
            content: const Text('Password dan konfirmasi tidak cocok'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
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
                const Center(
                  child: Text(
                    'Lupa Password',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontFamily: 'OdorMeanChey',
                    ),
                  ),
                ),
                const SizedBox(height: 75),
                CustomFormField(
                  controller: _passwordBaruController,
                  labelText: 'Password Baru',
                  hintText: 'Masukan Password Baru',
                  obscureText: !_isPasswordVisible,
                  errorText: _passwordBaruError.isNotEmpty ? _passwordBaruError : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  onChanged: (value) => _checkPassword(value),
                ),
                const SizedBox(height: 5),
                // Bar strength password tetap sama
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
                  controller: _konfirmasiPasswordController,
                  labelText: 'Konfirmasi Password Baru',
                  hintText: 'Masukan Konfirmasi Password Baru',
                  obscureText: !_isKonfirmasiPasswordVisible,
                  errorText: _konfirmasiPasswordError.isNotEmpty ? _konfirmasiPasswordError : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isKonfirmasiPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isKonfirmasiPasswordVisible = !_isKonfirmasiPasswordVisible;
                      });
                    },
                  ),
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
                        'Ganti',
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
                      icon: Image.asset('assets/images/back.png', width: 24),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
