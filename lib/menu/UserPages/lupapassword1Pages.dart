import 'package:apps/menu/UserPages/lupapassword2pages.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/customColor.dart';


class Lupapassword1 extends StatefulWidget {
  const Lupapassword1({super.key});

  @override
  _Lupapassword1State createState() => _Lupapassword1State();
}

class _Lupapassword1State extends State<Lupapassword1> {
  final TextEditingController _emailController = TextEditingController();
  String _emailError = '';

  void _validateInputs() {
    setState(() {
      _emailError = _emailController.text.isEmpty ? 'Email tidak boleh kosong' : '';
    });

    if (_emailError.isEmpty) {
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
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/images/forgotpassword.png',
                    height: 312, width: 312,
                  ),
                ),
                const SizedBox(height: 75),
                CustomFormField(
                  controller: _emailController,
                  labelText: 'Email Pengguna',
                  hintText: 'Masukan Email Terdaftar',
                  errorText: _emailError.isNotEmpty ? _emailError : null,
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