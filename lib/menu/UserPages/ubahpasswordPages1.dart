import 'package:apps/menu/UserPages/ubahpasswordPages2.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart';
import 'package:apps/src/customColor.dart'; // Pastikan untuk mengimpor halaman konfirmasi
import 'package:apps/src/customFormfield.dart'; // Tambahkan import ini

class UbahPasswordPage1 extends StatefulWidget {
  const UbahPasswordPage1({super.key});

  @override
  State<UbahPasswordPage1> createState() => _UbahPasswordPage1State();
}

class _UbahPasswordPage1State extends State<UbahPasswordPage1> {
  final Map<String, TextEditingController> _controllers = {
    'Password Lama': TextEditingController(),
    'Password Baru': TextEditingController(),
    'Konfirmasi Password Baru': TextEditingController(),
  };

  final Map<String, String> _errors = {
    'Password Lama': '',
    'Password Baru': '',
    'Konfirmasi Password Baru': '',
  };

  bool _passwordMatch = true;
  bool _showErrors = false;

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
      });
    });
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) {
      controller.removeListener(() {});
      controller.dispose();
    });
    super.dispose();
  }

  bool _isFormValid() {
    bool allFieldsFilled = !_controllers.values.any((controller) => controller.text.isEmpty);
    bool noErrors = _errors.values.every((error) => error.isEmpty);
    return allFieldsFilled && noErrors && _passwordMatch;
  }

  void _handleSimpanPerubahan() {
    setState(() {
      _showErrors = true;
      _controllers.keys.forEach(_validateField);
    });

    if (_isFormValid()) {
      print("Form valid, mencoba navigasi ke Ubahpasswordpages2");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Ubahpasswordpages2(
            passwordLama: _controllers['Password Lama']!.text,
            passwordBaru: _controllers['Password Baru']!.text,
          ),
        ),
      );
    } else {
      print("Form tidak valid");
    }
    // Jika form tidak valid, tidak ada aksi yang diambil
  }

  bool _obscurePasswordLama = true;
  bool _obscurePasswordBaru = true;
  bool _obscureKonfirmasiPassword = true;

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            obscureText: label == 'Password Lama' ? _obscurePasswordLama :
                         label == 'Password Baru' ? _obscurePasswordBaru :
                         _obscureKonfirmasiPassword,
            onChanged: label == 'Password Baru' ? _checkPassword : null,
            decoration: InputDecoration(
              hintText: 'Masukkan $label',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: _showErrors && _errors[label]!.isNotEmpty ? Colors.red : Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _showErrors && _errors[label]!.isNotEmpty ? Colors.red : Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _showErrors && _errors[label]!.isNotEmpty ? Colors.red : Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              suffixIcon: IconButton(
                icon: Icon(
                  (label == 'Password Lama' && _obscurePasswordLama) ||
                  (label == 'Password Baru' && _obscurePasswordBaru) ||
                  (label == 'Konfirmasi Password Baru' && _obscureKonfirmasiPassword)
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    if (label == 'Password Lama') {
                      _obscurePasswordLama = !_obscurePasswordLama;
                    } else if (label == 'Password Baru') {
                      _obscurePasswordBaru = !_obscurePasswordBaru;
                    } else {
                      _obscureKonfirmasiPassword = !_obscureKonfirmasiPassword;
                    }
                  });
                },
              ),
              errorText: _showErrors ? _errors[label] : null,
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

  void _validateField(String key) {
    setState(() {
      if (_controllers[key]!.text.isEmpty) {
        _errors[key] = '$key tidak boleh kosong';
      } else if (key == 'Password Baru' && _controllers[key]!.text.length < 6) {
        _errors[key] = 'Password baru harus minimal 6 karakter';
      } else if (key == 'Konfirmasi Password Baru' && 
                 _controllers[key]!.text != _controllers['Password Baru']!.text) {
        _errors[key] = 'Konfirmasi password tidak cocok';
        _passwordMatch = false;
      } else {
        _errors[key] = '';
        if (key == 'Konfirmasi Password Baru') {
          _passwordMatch = true;
        }
      }
    });
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
              Center(
                child: Image.asset(
                  'assets/images/changepw.png',
                  width: 307,
                  height: 347,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              
              // Password Lama
              CustomFormField(
                controller: _controllers['Password Lama']!,
                labelText: 'Password Lama',
                hintText: 'Masukkan Password Lama',
                obscureText: _obscurePasswordLama,
                errorText: _showErrors ? _errors['Password Lama'] : null,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePasswordLama ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePasswordLama = !_obscurePasswordLama;
                    });
                  },
                ),
                onChanged: (value) => _validateField('Password Lama'),
              ),
              const SizedBox(height: 16),

              // Password Baru
              CustomFormField(
                controller: _controllers['Password Baru']!,
                labelText: 'Password Baru',
                hintText: 'Masukkan Password Baru',
                obscureText: _obscurePasswordBaru,
                errorText: _showErrors ? _errors['Password Baru'] : null,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePasswordBaru ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePasswordBaru = !_obscurePasswordBaru;
                    });
                  },
                ),
                onChanged: (value) {
                  _validateField('Password Baru');
                  _checkPassword(value);
                },
              ),
              const SizedBox(height: 5),
              // Password strength indicator
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
              const SizedBox(height: 16),

              // Konfirmasi Password Baru
              CustomFormField(
                controller: _controllers['Konfirmasi Password Baru']!,
                labelText: 'Konfirmasi Password Baru',
                hintText: 'Masukkan Konfirmasi Password Baru',
                obscureText: _obscureKonfirmasiPassword,
                errorText: _showErrors ? _errors['Konfirmasi Password Baru'] : null,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureKonfirmasiPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureKonfirmasiPassword = !_obscureKonfirmasiPassword;
                    });
                  },
                ),
                onChanged: (value) => _validateField('Konfirmasi Password Baru'),
              ),
              const SizedBox(height: 50),

              // Tombol Simpan
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.BiruPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    onPressed: _handleSimpanPerubahan,
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'NotoSanSemiBold',
                        fontWeight: FontWeight.w400
                      ),
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
