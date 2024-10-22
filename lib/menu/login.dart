import 'package:apps/main.dart';
import 'package:apps/menu/lupapassword.dart';
import 'package:apps/menu/register.dart';
import 'package:apps/src/customColor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// Import halaman homepage Anda
// Sesuaikan dengan path yang benar

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
        MaterialPageRoute(builder: (context) => const MainPage()),
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
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  },
                  child: Image.asset(
                    'assets/images/LogoApk.png',
                    width: 320,
                    height: 320,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Bertani Modern',
                  style: TextStyle(
                    fontSize: 24,
                    color: CustomColors.coklatMedium,
                    fontFamily:
                        'OdorMeanChey', // Ganti dengan nama font kustom Anda
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Hasil Maksimal',
                  style: TextStyle(
                    fontSize: 28,
                    color: CustomColors.hijauPrimary, // Mengubah warna di sini
                    fontFamily: 'OdorMeanChey',
                  ),
                ),
              ),
              const SizedBox(height: 30), // Mengurangi jarak di sini jika perlu
              const Text(
                'Username',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'NotoSan'), // Menambahkan gaya tebal
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Masukan Username Pengguna',
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
                  errorText: _usernameError.isNotEmpty
                      ? _usernameError
                      : null, // Menampilkan pesan kesalahan
                ),
              ),
              const SizedBox(height: 10),
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
                obscureText: !_isPasswordVisible, // Mengatur tampilan password
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
                  errorText: _passwordError.isNotEmpty
                      ? _passwordError
                      : null, // Menampilkan pesan kesalahan
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LupaPassword(),
                      ),
                    );
                  },
                  child: const Text(
                    'Lupa Password?',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'NotoSan',
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
                      backgroundColor: CustomColors.hijauPrimary, // Mengubah warna tombol di sini
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
                      // Tambahkan logika untuk Google Login di sini
                    },
                    icon: Image.asset('assets/images/Google.png',
                        width: 24), // Ganti dengan path ikon Google
                    label: const Text(
                      'Google Login',
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
              const SizedBox(height: 20),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Belum Punya Akun? ',
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'NotoSan',
                        fontWeight: FontWeight.w400),
                    children: [
                      TextSpan(
                        text: 'Register Disini',
                        style: TextStyle(
                            color: CustomColors.hijauPrimary, // Mengubah warna di sini
                            fontFamily: 'NotoSan',
                            fontWeight: FontWeight.w400),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Register(),
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
