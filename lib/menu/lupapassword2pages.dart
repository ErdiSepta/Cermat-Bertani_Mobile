import 'package:apps/menu/lupapassword3Pages.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/customColor.dart';
import 'dart:async';
// Import halaman berikutnya sesuai kebutuhan
// import 'package:apps/menu/lupapassword3pages.dart';

class LupaPassword2 extends StatefulWidget {
  const LupaPassword2({Key? key}) : super(key: key);

  @override
  _LupaPassword2State createState() => _LupaPassword2State();
}

class _LupaPassword2State extends State<LupaPassword2> {
  final int _codeLength = 5;
  List<TextEditingController> _controllers = [];
  String _otpError = '';
  int _timerSeconds = 60;
  Timer? _timer;
  bool _isTimerRunning = true;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _codeLength; i++) {
      _controllers.add(TextEditingController());
    }
    startTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _isTimerRunning = false;
          _timer?.cancel();
        }
      });
    });
  }

  void resendOTP() {
    setState(() {
      _timerSeconds = 60;
      _isTimerRunning = true;
    });
    startTimer();
  }

  bool isOTPFilled() {
    return _controllers.every((controller) => controller.text.isNotEmpty);
  }

  void validateOTP() {
    setState(() {
      if (!isOTPFilled()) {
        _otpError = 'Mohon isikan kode OTP yang dikirimkan ke email anda';
      } else {
        _otpError = '';
        // Navigasi ke halaman reset password
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Lupapassword3()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Center(
                  child: Text(
                    'Lupa Password',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontFamily: 'OdorMeanChey',
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Image.asset(
                    'assets/images/Mail Input.png',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'Email Pengguna',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'NotoSan',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Input OTP
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      _codeLength,
                      (index) => Container(
                        width: 45,
                        height: 45,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextField(
                          controller: _controllers[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) {
                            if (value.length == 1 && index < _codeLength - 1) {
                              FocusScope.of(context).nextFocus();
                            }
                            setState(() {
                              _otpError = '';
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                if (_otpError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 20),
                    child: Text(
                      _otpError,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                // Timer dan Kirim Ulang
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Waktu tersisa: ${_timerSeconds}s',
                        style: const TextStyle(fontSize: 14),
                      ),
                      TextButton(
                        onPressed: _isTimerRunning ? null : resendOTP,
                        child: Text(
                          'Kirim ulang',
                          style: TextStyle(
                            color: _isTimerRunning
                                ? Colors.grey
                                : CustomColors.BiruPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Tombol Lanjutan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isOTPFilled() ? validateOTP : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.BiruPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    child: const Text(
                      'Lanjutan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'NotoSan',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Tombol Kembali
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset('assets/images/back.png', width: 24),
                    label: const Text(
                      'Kembali',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'NotoSan',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: const BorderSide(color: Colors.black),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
