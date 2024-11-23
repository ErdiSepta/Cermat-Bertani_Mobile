import 'package:apps/SendApi/tokenJWT.dart';
import 'package:apps/SendApi/userApi.dart';
import 'package:apps/main.dart';
import 'dart:convert';
import 'package:apps/menu/UserPages/lupapassword1Pages.dart';
import 'package:apps/menu/UserPages/register1Pages.dart';
import 'package:apps/src/customColor.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/pageTransition.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
//AWAL BACKEND
  String errorText = "";
  bool showError = false;
  // Fungsi untuk mendekode JWT
  Map<String, dynamic> decodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT token');
    }

    final payload = parts[1];
    final normalizedPayload = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalizedPayload));

    return jsonDecode(decoded); // Mengembalikan data dalam format map
  }

  // Fungsi untuk menyimpan data pengguna dan token
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(userData));
  }

  // Fungsi untuk menyimpan token ke SharedPreferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Fungsi untuk mengambil data pengguna
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    return userDataString != null ? jsonDecode(userDataString) : null;
  }

  // Fungsi untuk mengambil data pengguna
  void fetchData() async {
    final userData = await getUserData();
    if (userData != null) {
      print("Data User: $userData"); // Data user yang berhasil diambil
    }
  }

  // Fungsi untuk memeriksa login
  bool isLoading = false;

  Future<void> _ceklogin() async {
    setState(() {
      _usernameError =
          _usernameController.text.isEmpty ? 'Username tidak boleh kosong' : '';
      _passwordError =
          _passwordController.text.isEmpty ? 'Password tidak boleh kosong' : '';
    });

    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      setState(() {
        showError = false;
        errorText = "";
        isLoading = true; // Mulai loading
      });

      try {
        String email = _usernameController.text;
        String password = _passwordController.text;

        final result = await UserApi.login(email, password);
        print("result : $result");
        String? token = await TokenJwt.getToken();
        if (result != null) {
          if (result['status'] != "error") {
            await TokenJwt.saveEmail(result['data']['email']);
            setState(() {
              isLoading = false; // Berhenti loading
            });

            Navigator.of(context).pushReplacement(
              SmoothPageTransition(page: MainPage()),
            );
          } else {
            setState(() {
              showError = true;
              errorText = result['message'];
              isLoading = false; // Berhenti loading
            });
          }
        } else {
          setState(() {
            showError = true;
            errorText = "Kesalahan Pada Server";
            isLoading = false; // Berhenti loading
          });
          print("email :$email");
          print("pw :$password");
          print(result);
          print('Login gagall: ${result?['message']}');
        }
      } catch (e) {
        setState(() {
          isLoading = false; // Berhenti loading jika ada error
        });
        print("Error: $e");
      }
    } else {
      print("KOSONGG");
    }
  }

//AKHIR BACKEND
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
                    // Navigator.pushReplacement(
                    //   context,
                    //   SmoothPageTransition(page: const MainPage()),
                    // );
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
              const SizedBox(height: 30),
              if (isLoading) // Tampilkan loading overlay jika isLoading true
                Center(
                  child: CircularProgressIndicator(
                    color: CustomColors.BiruPrimary,
                  ),
                ),
              Center(
                child: Visibility(
                  visible: showError,
                  child: Text(
                    errorText,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red, // Mengubah warna di sini
                      fontFamily: 'OdorMeanChey',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30), // Mengurangi jarak di sini jika perlu
              CustomFormField(
                controller: _usernameController,
                labelText: 'Email',
                hintText: 'Masukan Email Pengguna',
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
                      SmoothPageTransition(
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
                    onPressed: _ceklogin,
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
