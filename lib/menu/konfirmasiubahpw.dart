import 'package:flutter/material.dart';
import 'package:apps/src/customColor.dart';
import 'package:apps/menu/akunpage.dart';

class KonfirmasiUbahPWPage extends StatelessWidget {
  const KonfirmasiUbahPWPage({super.key, required String passwordLama, required String oldPassword, required String newPassword});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double padding = constraints.maxWidth * 0.1;
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        Center(
                          child: Text(
                            'Ubah Password',
                            style: TextStyle(
                              fontSize: 28,
                              color: CustomColors.coklatMedium,
                              fontFamily: 'OdorMeanChey',
                            ),
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: Image.asset(
                            'assets/images/checkmark.png',
                            width: 320,
                            height: 320,
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: Text(
                            'Ganti Password Berhasil',
                            style: TextStyle(
                              fontSize: 24,
                              color: CustomColors.coklatMedium,
                              fontFamily: 'OdorMeanChey',
                            ),
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Akunpage()),
                                  (route) => false,
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
                                'Kembali Ke Menu Akun',
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
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}