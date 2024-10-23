import 'package:apps/menu/register4Pages.dart';
import 'package:apps/src/customColor.dart';
import 'package:flutter/material.dart';

class Register3 extends StatefulWidget {
  const Register3({super.key});

  @override
  _Register3State createState() => _Register3State();
}

class _Register3State extends State<Register3> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _password = '';
  String _confirmPassword = '';
  double _strength = 0;
  bool _isPasswordMatch = true;

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _passwordError = '';
  String _confirmPasswordError = '';

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

  void _onCreateAccount() {
    setState(() {
      _passwordError =
          _passwordController.text.isEmpty ? 'Password tidak boleh kosong' : '';
      _confirmPasswordError = _confirmPasswordController.text.isEmpty
          ? 'Konfirmasi password tidak boleh kosong'
          : '';
      _isPasswordMatch =
          _passwordController.text == _confirmPasswordController.text;
    });

    if (_passwordError.isEmpty &&
        _confirmPasswordError.isEmpty &&
        _strength >= 1 / 2 &&
        _isPasswordMatch) {
      // Navigasi ke halaman berikutnya atau proses pembuatan akun
      // Misalnya:
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Register4pages()));
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            double padding = constraints.maxWidth * 0.1;
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
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
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Password',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'NotoSan',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  onChanged: (value) => _checkPassword(value),
                                  decoration: InputDecoration(
                                    hintText: 'Masukan Password Pengguna',
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible = !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    errorText: _passwordError.isNotEmpty ? _passwordError : null,
                                  ),
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
                                const Text(
                                  'Konfirmasi Password',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'NotoSan',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _confirmPasswordController,
                                  obscureText: !_isConfirmPasswordVisible,
                                  onChanged: (value) => _confirmPassword = value.trim(),
                                  decoration: InputDecoration(
                                    hintText: 'Masukan Kembali Password',
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: IconButton(
                                        icon: Icon(
                                          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    errorText: _confirmPasswordError.isNotEmpty ? _confirmPasswordError : null,
                                  ),
                                ),
                                const SizedBox(height: 50),
                                Center(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: ElevatedButton(
                                      onPressed: _onCreateAccount,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: CustomColors.BiruPrimary,
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
                                          fontFamily: 'NotoSan',
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
                                          fontFamily: 'NotoSan',
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
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
