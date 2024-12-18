import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:apps/src/customColor.dart';
import 'package:apps/src/pageTransition.dart';
import 'package:flutter/material.dart';

class Register4pages extends StatelessWidget {
  const Register4pages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Text(
                'Buat Akun',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontFamily: 'OdorMeanChey',
                ),
              ),
              const SizedBox(height: 40),
              Image.asset(
                'assets/images/Hore.png',
                width: 320,
                height: 320,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 40),
              const Text(
                'Buat Akun Berhasil',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontFamily: 'OdorMeanChey',
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      SmoothPageTransition(page: const Login()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.BiruPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  child: const Text(
                    'Kembali ke Menu Login',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'NotoSanSemiBold',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
