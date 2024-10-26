import 'package:apps/main.dart';
import 'package:apps/menu/UserPages/lupapassword1Pages.dart';
import 'package:apps/menu/UserPages/register1Pages.dart';
import 'package:apps/src/customColor.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/pageTransition.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false; // Variabel untuk mengatur tampilan password
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _usernameError = '';
  String _passwordError = '';

  void _validateInputs() {
    setState(() {
      _usernameError =
          _usernameController.text.isEmpty ? 'Username tidak boleh kosong' : '';
      _passwordError =
          _passwordController.text.isEmpty ? 'Password tidak boleh kosong' : '';
    });

    if (_usernameError.isEmpty && _passwordError.isEmpty) {
      // Logika untuk login jika semua input valid
      Navigator.of(context).pushReplacement(
        SmoothPageTransition(page: const MainPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Navigasi ke MainPage alih-alih langsung ke Homepage
                    Navigator.pushReplacement(
                      context,
                      SmoothPageTransition(page: const MainPage()),
                    );
                  },
                  child: Image.asset(
                    'assets/images/Logos Apps.png',
                    width: 241,
                    height: 241,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Pantau dan Kelola',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontFamily:
                        'OdorMeanChey', // Ganti dengan nama font kustom Anda
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Dengan Login Aplikasi',
                  style: TextStyle(
                    fontSize: 24,
                    color: CustomColors.BiruPrimary, // Mengubah warna di sini
                    fontFamily: 'OdorMeanChey',
                  ),
                ),
              ),
              const SizedBox(height: 30), // Mengurangi jarak di sini jika perlu
              CustomFormField(
                controller: _usernameController,
                labelText: 'Username',
                hintText: 'Masukan Username Pengguna',
                errorText: _usernameError.isNotEmpty ? _usernameError : null,
              ),
              const SizedBox(height: 10),
              CustomFormField(
                controller: _passwordController,
                labelText: 'Password',
                hintText: 'Masukan Password Pengguna',
                obscureText: !_isPasswordVisible,
                errorText: _passwordError.isNotEmpty ? _passwordError : null,
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
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
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      SmoothPageTransition  (
                        page: const Lupapassword1(),
                      ),
                    );
                  },
                  child: const Text(
                    'Lupa Password?',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'NotoSanSemiBold',
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: _validateInputs,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors
                          .BiruPrimary, // Mengubah warna tombol di sini
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    child: const Text(
                      'Masuk',
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
                      // Tambahkan logika untuk Google Login di sini
                    },
                    icon: Image.asset('assets/images/Google.png',
                        width: 24), // Ganti dengan path ikon Google
                    label: const Text(
                      'Google Login',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'NotoSanSemiBold',
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
              const SizedBox(height: 20),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Belum Punya Akun? ',
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'NotoSanSemiBold',
                        fontWeight: FontWeight.w400),
                    children: [
                      TextSpan(
                        text: 'Register Disini',
                        style: const TextStyle(
                            color: CustomColors
                                .BiruPrimary, // Mengubah warna di sini
                            fontFamily: 'NotoSanSemiBold',
                            fontWeight: FontWeight.w400),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              SmoothPageTransition(
                                page: const Register(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
