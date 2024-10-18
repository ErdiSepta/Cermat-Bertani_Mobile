import 'package:apps/menu/login.dart';
import 'package:apps/src/customColor.dart';
import 'package:flutter/material.dart';

class Register2 extends StatefulWidget {
  const Register2({super.key});

  @override
  State<Register2> createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth * 0.1;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Center(
                  child: Text(
                    'Buat Akun',
                    style: TextStyle(
                      fontSize: 28,
                      color: CustomColors.coklatMedium,
                      fontFamily: 'OdorMeanChey',
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Center(
                child: Image.asset(
                  'assets/images/checkmark.png',
                  width: 320, // Ganti dengan path gambar Anda
                  height: 320,
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Text(
                  'Pendaftaran Berhasil',
                  style: TextStyle(
                    fontSize: 24,
                    color: CustomColors.coklatMedium,
                    fontFamily: 'OdorMeanChey',
                    ),
                  ),
                ),
                    const SizedBox(height: 50),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.coklatMedium,
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
                            fontFamily: 'NotoSan',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ) 
              ],
            ),
          );
        },
      ), 
    );
  }
}