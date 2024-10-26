import 'package:apps/menu/UserPages/lupapassword3Pages.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/customColor.dart';
import 'dart:async';

class LupaPassword2 extends StatefulWidget {
  const LupaPassword2({super.key});

  @override
  _LupaPassword2State createState() => _LupaPassword2State();
}

class _LupaPassword2State extends State<LupaPassword2> {
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
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
                            'assets/images/forgotpassword.png',
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width * 0.6,
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
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
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
                                  color: _isTimerRunning
                                      ? Colors.grey
                                      : CustomColors.BiruPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ElevatedButton(
                              onPressed: validateOTP,
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
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
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
                        ),
                        const SizedBox(height: 20),
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
