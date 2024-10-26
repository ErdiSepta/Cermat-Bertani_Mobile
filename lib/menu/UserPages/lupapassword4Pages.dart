import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:apps/src/customColor.dart';
import 'package:flutter/material.dart';

class LupaPassword4 extends StatefulWidget {
  const LupaPassword4({super.key});

  @override
  State<LupaPassword4> createState() => _LupaPassword4State();
}

class _LupaPassword4State extends State<LupaPassword4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80), // Menambah jarak dari atas
              const Text(
                'Lupa Password',
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
                'Ubah Password Berhasil',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontFamily: 'OdorMeanChey',
                ),
              ),
              const SizedBox(height: 60), // Mengurangi jarak sebelum button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
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
              const SizedBox(height: 30), // Mengurangi jarak di bawah button
            ],
          ),
        ),
      ),
    );
  }
}
