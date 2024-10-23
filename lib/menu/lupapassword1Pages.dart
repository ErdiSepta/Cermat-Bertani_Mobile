import 'package:apps/menu/lupapassword2Pages.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/customColor.dart';
import 'package:apps/menu/lupapassword3Pages.dart'; // Pastikan untuk mengimpor file lupapassword1.dart

class Lupapassword1 extends StatefulWidget {
  const Lupapassword1({super.key});

  @override
  _Lupapassword1State createState() => _Lupapassword1State();
}

class _Lupapassword1State extends State<Lupapassword1> {
  final TextEditingController _emailController = TextEditingController();
  String _emailError = '';
  String _usernameError = '';

  void _validateInputs() {
    setState(() {
      _emailError = _emailController.text.isEmpty ? 'Email tidak boleh kosong' : '';
    });

    if (_emailError.isEmpty && _usernameError.isEmpty) {
      // Navigasi ke halaman LupaPassword1
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LupaPassword2()),
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
                const SizedBox(height: 75),
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
                // Menambahkan gambar di bawah tulisan "Lupa Password"
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/images/forgotpassword.png', // Ganti dengan path gambar yang sesuai
                    height: 312, width: 312, // Atur tinggi gambar sesuai kebutuhan
                  ),
                ),
                const SizedBox(height: 75),
                // Mengubah tulisan "Email Terdaftar" menjadi ditengah
                const Center(
                  child: Text(
                    'Email Pengguna',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'NotoSan',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Masukan Email Terdaftar',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    errorText: _emailError.isNotEmpty ? _emailError : null,
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
                        'Lanjutan',
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
