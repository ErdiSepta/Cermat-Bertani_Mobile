import 'package:apps/menu/UserPages/register3Pages.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/customColor.dart';
import 'dart:async';
import 'package:pinput/pinput.dart';
import 'package:lottie/lottie.dart';

class Register2 extends StatefulWidget {
  const Register2({super.key});

  @override
  _Register2State createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  String _otpError = '';
  int _timerSeconds = 60;
  Timer? _timer;
  bool _isTimerRunning = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
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
    return pinController.text.length == 5;
  }

  void validateOTP() {
    setState(() {
      if (pinController.text.length < 5) {
        _otpError = 'Mohon isikan kode OTP yang dikirimkan ke email anda';
      } else {
        _otpError = '';
        setState(() => _isLoading = true);
        // Simulasi loading 2 detik
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Register3()),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: CustomColors.BiruPrimary),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top,
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
                          child: Image.asset('assets/images/Mail Input.png',
                              height: 180),
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
                        Center(
                          child: Pinput(
                            length: 5,
                            controller: pinController,
                            focusNode: focusNode,
                            defaultPinTheme: defaultPinTheme,
                            separatorBuilder: (index) =>
                                const SizedBox(width: 8),
                            validator: (value) {
                              return value?.length == 5
                                  ? null
                                  : 'Pin tidak lengkap';
                            },
                            onCompleted: (pin) {
                              setState(() => _otpError = '');
                            },
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
                                  color: _isTimerRunning
                                      ? Colors.grey
                                      : CustomColors.BiruPrimary,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
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
                            icon: Image.asset('assets/images/back.png',
                                width: 24),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
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
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/animations/loading.json',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Mohon Tunggu...',
                      style: TextStyle(
                        fontFamily: 'NotoSanSemiBold',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
