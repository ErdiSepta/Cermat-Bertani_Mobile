import 'package:apps/menu/akunpage.dart';
import 'package:apps/menu/homepage.dart';
import 'package:apps/menu/pemantauanpage.dart';
import 'package:apps/menu/pendataanpage.dart';
import 'package:apps/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/bottomnav.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: const Splashscreen(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Homepage(),
    const PemantauanPage(),
    const PendataanPage(),
    const Akunpage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Bottomnav(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
