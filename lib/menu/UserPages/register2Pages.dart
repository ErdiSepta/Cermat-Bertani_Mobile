import 'package:apps/menu/UserPages/register3Pages.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/pageTransition.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/customColor.dart';
import 'dart:async';

class Register2 extends StatefulWidget {
  const Register2({super.key});

  @override
  _Register2State createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  final int _codeLength = 5;
  final List<TextEditingController> _controllers = [];
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    // Implementasi logika pengiriman ulang OTP
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
        // Implementasi logika verifikasi OTP
        // Jika verifikasi berhasil, arahkan ke Register3
        Navigator.push(
          context,
          SmoothPageTransition(page: const Register3()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    const Center(
                      child: Text(
                        'Buat Akun',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.black,
                          fontFamily: 'OdorMeanChey',
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Image.asset('assets/images/Mail Input.png', height: 180),
                    ),
                    const SizedBox(height: 30),
                    const Center(
                      child: Text(
                        'Verifikasi Email Pengguna',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'NotoSanSemiBold',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        _codeLength,
                        (index) => SizedBox(
                          width: 50,
                          height: 50,
                          child: CustomFormField(
                            controller: _controllers[index],
                            hintText: '',
                            labelText: '',
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
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
                    if (_otpError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _otpError,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 30),
                    Row(
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
                              color: _isTimerRunning ? Colors.grey : CustomColors.BiruPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
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
                            fontFamily: 'NotoSanSemiBold',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                            fontFamily: 'NotoSanSemiBold',
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
        ),
      ),
    );
  }
}
