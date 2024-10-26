import 'package:apps/src/customColor.dart';
import 'package:flutter/material.dart';

class Ubahpasswordpages2 extends StatelessWidget {
  final String passwordLama;
  final String passwordBaru;

  const Ubahpasswordpages2({
    super.key,
    required this.passwordLama,
    required this.passwordBaru,
  });

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
                'Ubah Password',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontFamily: 'OdorMeanChey',
                ),
              ),
              const SizedBox(height: 40),
              Image.asset(
                'assets/images/Hore.png', // Pastikan gambar ini ada di proyek Anda
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
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Kembali ke halaman utama (akunPages)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.BiruPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  child: const Text(
                    'Kembali ke Menu Utama',
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
