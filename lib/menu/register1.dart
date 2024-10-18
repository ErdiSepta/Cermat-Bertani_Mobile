import 'package:apps/src/customColor.dart';
import 'package:flutter/material.dart';
// Pastikan Anda mengimpor halaman register2
import 'package:apps/menu/register2.dart'; // Sesuaikan path sesuai struktur proyek Anda

class Register1 extends StatefulWidget {
  const Register1({super.key});

  @override
  _Register1State createState() => _Register1State();
}

class _Register1State extends State<Register1> {
  bool _isPasswordVisible =
      false; // Variabel untuk mengatur visibilitas password
  bool _isConfirmPasswordVisible =
      false; // Variabel untuk visibilitas konfirmasi password
  String _password = '';
  // ignore: unused_field
  String _confirmPassword = '';
  double _strength = 0;
  bool _isPasswordMatch = true;

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _usernameError = '';
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
      _usernameError =
          _usernameController.text.isEmpty ? 'Username tidak boleh kosong' : '';
      _passwordError =
          _passwordController.text.isEmpty ? 'Password tidak boleh kosong' : '';
      _confirmPasswordError = _confirmPasswordController.text.isEmpty
          ? 'Konfirmasi password tidak boleh kosong'
          : '';
      _isPasswordMatch =
          _passwordController.text == _confirmPasswordController.text;
    });

    if (_usernameError.isEmpty &&
        _passwordError.isEmpty &&
        _confirmPasswordError.isEmpty &&
        _strength >= 1 / 2 &&
        _isPasswordMatch) {
      // Navigasi ke halaman Register2
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Register2()),
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

  bool _isCheckingUsername = false;
  String _usernameAvailability = '';

  void _checkUsernameAvailability() async {
    setState(() {
      _isCheckingUsername = true;
      _usernameAvailability = '';
    });

    // Simulasi pengecekan username (ganti dengan logika sebenarnya nanti)
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isCheckingUsername = false;
      if (_usernameController.text.toLowerCase() == 'admin') {
        _usernameAvailability = 'Username tidak tersedia';
      } else {
        _usernameAvailability = 'Username tersedia';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double padding = constraints.maxWidth * 0.1; // 10% dari lebar layar
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50), // Menambahkan jarak di atas teks
                  Center(
                    child: Text(
                      'Buat Akun',
                      style: TextStyle(
                        fontSize: 28,
                        color: CustomColors.coklatMedium,
                        fontFamily:
                            'OdorMeanChey', // Ganti dengan nama font kustom Anda
                      ),
                    ),
                  ),
                  const SizedBox(height: 75),
                  const Text(
                    'Username',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'NotoSan'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'Masukan Username',
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(8.0)), // Menambahkan border radius
                              borderSide: BorderSide(
                                color: Colors.black, // Warna border
                                width: 2.0, // Ketebalan border
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
                            errorText:
                                _usernameError.isNotEmpty ? _usernameError : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: _isCheckingUsername ? null : _checkUsernameAvailability,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        child: _isCheckingUsername
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                ),
                              )
                            : const Text(
                                'Check',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: 'NotoSan',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                      ),
                    ],
                  ),
                  if (_usernameAvailability.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _usernameAvailability,
                        style: TextStyle(
                          color: _usernameAvailability == 'Username tersedia'
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'NotoSan', // Menambahkan gaya tebal
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText:
                        !_isPasswordVisible, // Mengatur tampilan password
                    onChanged: (value) => _checkPassword(value),
                    decoration: InputDecoration(
                      hintText: 'Masukan Password Pengguna',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(8.0)), // Menambahkan border radius
                        borderSide: BorderSide(
                          color: Colors.black, // Warna border
                          width: 2.0, // Ketebalan border
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
                        padding: const EdgeInsets.only(
                            right: 8.0), // Menambahkan padding di sebelah kanan
                        child: IconButton(
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
                      ),
                      errorText:
                          _passwordError.isNotEmpty ? _passwordError : null,
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
                      fontFamily: 'NotoSan', // Menambahkan gaya tebal
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText:
                        !_isConfirmPasswordVisible, // Mengatur tampilan konfirmasi password
                    onChanged: (value) => _confirmPassword = value.trim(),
                    decoration: InputDecoration(
                      hintText: 'Masukan Kembali Password',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(8.0)), // Menambahkan border radius
                        borderSide: BorderSide(
                          color: Colors.black, // Warna border
                          width: 2.0, // Ketebalan border
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
                        padding: const EdgeInsets.only(
                            right: 8.0), // Menambahkan padding di sebelah kanan
                        child: IconButton(
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
                            // Navigasi ke halaman Register2
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register2()),
                            );
                          },
                        ),
                      ),
                      errorText: _confirmPasswordError.isNotEmpty
                          ? _confirmPasswordError
                          : null,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: _onCreateAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors
                              .coklatMedium, // Ganti dengan warna yang diinginkan
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
                          Navigator.pop(context); // Menggunakan Navigator.pop
                        },
                        icon: Image.asset('assets/images/back.png',
                            width: 24), // Ganti dengan path ikon Google
                        label: const Text(
                          'Kembali',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'NotoSan',
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
