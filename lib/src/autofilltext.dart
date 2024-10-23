import 'package:flutter/material.dart';

class AutoFillText {
  static void autoFillRegister1(
    TextEditingController nikController,
    TextEditingController emailController,
    TextEditingController namaController,
    void Function(String?) setSelectedGender,
    TextEditingController noHpController,
    TextEditingController alamatController,
  ) {
    nikController.text = '1234567890123456';
    emailController.text = 'test@example.com';
    namaController.text = 'NAMA LENGKAP TEST';
    setSelectedGender('Laki-laki');
    noHpController.text = '081234567890';
    alamatController.text = 'Jl. Test No. 123, Kota Test, 12345';
  }
}

