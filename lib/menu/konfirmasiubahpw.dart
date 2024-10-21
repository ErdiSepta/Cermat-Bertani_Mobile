import 'package:flutter/material.dart';
import 'package:apps/src/customColor.dart';
import 'package:apps/menu/akunpage.dart';

class KonfirmasiUbahPWPage extends StatelessWidget {
  const KonfirmasiUbahPWPage({Key? key, required String passwordLama, required String oldPassword, required String newPassword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ubah Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Ganti Password Berhasil',
                style: TextStyle(
                  fontSize: 18,
                  color: CustomColors.coklatMedium,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 60),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.coklatMedium,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(200, 50),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Akunpage()),
                    (route) => false,
                  );
                },
                child: Text(
                  'Kembali Ke Menu Akun',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
