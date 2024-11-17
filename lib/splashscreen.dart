import 'package:apps/SendApi/userApi.dart';
import 'package:apps/main.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:apps/src/pageTransition.dart';
import 'package:flutter/material.dart';
import 'src/customColor.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(() {
        setState(() {
          _currentIndex = (_controller.value * 5).floor();
        });
      });
    _controller.repeat();

    // Logika navigasi
    Future.delayed(const Duration(seconds: 3), () {
      if (Login.email.isNotEmpty) {
        showProfil();
      } else {
        Navigator.of(context).pushReplacement(
          SmoothPageTransition(page: const Login()),
        );
      }
    });
  }

  Future<void> showProfil() async {
    final result = await UserApi.getProfil(Login.email);
    if (result == null) {
      Navigator.of(context).pushReplacement(
        SmoothPageTransition(page: const Login()),
      );
    } else if (result['status'] == "success") {
      Navigator.of(context).pushReplacement(
        SmoothPageTransition(page: const MainPage()),
      );
    } else if (result['status'] == "error" &&
        result['message'] == "token error must login") {
      Navigator.of(context).pushReplacement(
        SmoothPageTransition(page: const Login()),
      );
    } else {
      print("Kesalahan Server");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Logos Apps Splash.png',
                width: 180, height: 180),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? CustomColors.BiruPrimary
                        : CustomColors.abupudar,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
