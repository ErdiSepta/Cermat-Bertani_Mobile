import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart';
import 'package:apps/src/customColor.dart';
import 'package:apps/menu/konfirmasiubahpw.dart'; // Pastikan untuk mengimpor halaman konfirmasi

class UbahPasswordPage extends StatefulWidget {
  const UbahPasswordPage({super.key});

  @override
  State<UbahPasswordPage> createState() => _UbahPasswordPageState();
}

class _UbahPasswordPageState extends State<UbahPasswordPage> {
  final Map<String, TextEditingController> _controllers = {
    'Password Lama': TextEditingController(),
    'Password Baru': TextEditingController(),
    'Konfirmasi Password Baru': TextEditingController(),
  };

  bool _passwordMatch = true;
  Map<String, bool> _fieldEmpty = {
    'Password Lama': false,
    'Password Baru': false,
    'Konfirmasi Password Baru': false,
  };
  Map<String, bool> _obscureText = {
    'Password Lama': true,
    'Password Baru': true,
    'Konfirmasi Password Baru': true,
  };

  @override
  void initState() {
    super.initState();
    _controllers.forEach((key, controller) {
      controller.addListener(() => _validateField(key));
    });
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _validateField(String field) {
    setState(() {
      _fieldEmpty[field] = _controllers[field]!.text.isEmpty;
      if (field == 'Password Baru' || field == 'Konfirmasi Password Baru') {
        _passwordMatch = _controllers['Password Baru']!.text ==
            _controllers['Konfirmasi Password Baru']!.text;
      }
    });
  }

  Widget buildTextField(String label, TextEditingController controller) {
    bool isConfirmPassword = label == 'Konfirmasi Password Baru';
    bool showError = (isConfirmPassword && !_passwordMatch) || _fieldEmpty[label]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: _obscureText[label]!,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: showError ? Colors.red : Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: showError ? Colors.red : Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: showError ? Colors.red : Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText[label]! ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText[label] = !_obscureText[label]!;
                });
              },
            ),
          ),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _fieldEmpty[label]! ? 'Password tidak boleh kosong' : 'Password tidak cocok',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        SizedBox(height: 16),
      ],
    );
  }

  bool _isFormValid() {
    return !_fieldEmpty['Password Lama']! &&
           !_fieldEmpty['Password Baru']! &&
           !_fieldEmpty['Konfirmasi Password Baru']! &&
           _passwordMatch;
  }

  void _handleSimpanPerubahan() {
    if (_isFormValid()) {
      // Navigasi ke halaman konfirmasi
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KonfirmasiUbahPWPage(
            oldPassword: _controllers['Password Lama']!.text,
            newPassword: _controllers['Password Baru']!.text, passwordLama: '',
          ),
        ),
      );
    } else {
      // Tampilkan pesan error jika form tidak valid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mohon periksa kembali input Anda.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Topnav(
          title: 'Ubah Password',
          showBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._controllers.entries.map((e) => buildTextField(e.key, e.value)),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.coklatMedium,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _handleSimpanPerubahan,
                  child: Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
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
