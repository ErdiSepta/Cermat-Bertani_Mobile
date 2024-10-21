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
  final Map<String, bool> _fieldEmpty = {
    'Password Lama': false,
    'Password Baru': false,
    'Konfirmasi Password Baru': false,
  };
  final Map<String, bool> _obscureText = {
    'Password Lama': true,
    'Password Baru': true,
    'Konfirmasi Password Baru': true,
  };

  double _strength = 0;
  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  String _getPasswordStrengthText() {
    if (_strength <= 1 / 4) {
      return 'Lemah';
    } else if (_strength == 2 / 4) {
      return 'Sedang';
    } else if (_strength == 3 / 4) {
      return 'Kuat';
    } else {
      return 'Sangat Kuat';
    }
  }

  void _checkPassword(String value) {
    String password = value.trim();

    if (password.isEmpty) {
      setState(() {
        _strength = 0;
      });
    } else if (password.length < 6) {
      setState(() {
        _strength = 1 / 4;
      });
    } else if (password.length < 8) {
      setState(() {
        _strength = 2 / 4;
      });
    } else {
      if (!letterReg.hasMatch(password) || !numReg.hasMatch(password)) {
        setState(() {
          _strength = 3 / 4;
        });
      } else {
        setState(() {
          _strength = 1;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controllers.forEach((key, controller) {
      controller.addListener(() {
        _validateField(key);
        setState(() {}); // Tambahkan ini untuk memperbarui UI
      });
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontFamily: 'NotoSan'
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            obscureText: _obscureText[label]!,
            onChanged: label == 'Password Baru' ? _checkPassword : null,
            decoration: InputDecoration(
              hintText: 'Masukkan $label',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(
                  color: showError ? Colors.red : Colors.black,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(
                  color: showError ? Colors.red : Colors.black,
                  width: 1.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 12.0
              ),
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
                style: const TextStyle(color: Colors.red, fontSize: 12, fontFamily: 'NotoSan'),
              ),
            ),
          if (label == 'Password Baru')
            Column(
              children: [
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 5,
                      child: LinearProgressIndicator(
                        value: _strength,
                        backgroundColor: Colors.grey[300],
                        color: _strength <= 1 / 4
                            ? Colors.red
                            : _strength == 2 / 4
                                ? Colors.yellow
                                : _strength == 3 / 4
                                    ? Colors.blue
                                    : Colors.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _getPasswordStrengthText(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  bool _isFormValid() {
    return !_controllers.values.any((controller) => controller.text.isEmpty) &&
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
        const SnackBar(
          content: Text('Mohon periksa kembali input Anda.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Topnav(
          title: 'Ubah Password',
          showBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._controllers.entries.map((e) => buildTextField(e.key, e.value)),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.coklatMedium,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'NotoSan',
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD8A37E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      onPressed: _isFormValid() ? _handleSimpanPerubahan : null,
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'NotoSan',
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
