import 'package:flutter/material.dart';
import 'package:apps/src/customColor.dart';

class Lupapassword1 extends StatefulWidget {
  const Lupapassword1({super.key});

  @override
  _lupapassword1state createState() => _lupapassword1state();
}

class _lupapassword1state extends State<Lupapassword1> {
  final TextEditingController _passwordBaruController = TextEditingController();
  final TextEditingController _konfirmasiPasswordController = TextEditingController();
  String _passwordBaruError = '';
  String _konfirmasiPasswordError = '';

  void _validateInputs() {
    setState(() {
      _passwordBaruError = _passwordBaruController.text.isEmpty ? 'Password baru tidak boleh kosong' : '';
      _konfirmasiPasswordError = _konfirmasiPasswordController.text.isEmpty ? 'Konfirmasi password tidak boleh kosong' : '';
      
      if (_passwordBaruController.text != _konfirmasiPasswordController.text) {
        _konfirmasiPasswordError = 'Password tidak cocok';
      }
    });

    if (_passwordBaruError.isEmpty && _konfirmasiPasswordError.isEmpty) {
      // Proses ganti password
      // Misalnya, kirim permintaan ke server untuk mengubah password
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
                Center(
                  child: Text(
                    'Lupa Password',
                    style: TextStyle(
                      fontSize: 28,
                      color: CustomColors.coklatMedium,
                      fontFamily: 'OdorMeanChey',
                    ),
                  ),
                ),
                const SizedBox(height: 75),
                const Text(
                  'Password Baru',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'NotoSan',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordBaruController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Masukan Password Baru',
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
                    errorText: _passwordBaruError.isNotEmpty ? _passwordBaruError : null,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Konfirmasi Password Baru',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'NotoSan',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _konfirmasiPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Masukan Konfirmasi Password Baru',
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
                    errorText: _konfirmasiPasswordError.isNotEmpty ? _konfirmasiPasswordError : null,
                  ),
                ),
                const SizedBox(height: 50),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: _validateInputs,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.hijauPrimary,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
