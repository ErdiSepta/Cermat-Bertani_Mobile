import 'package:apps/menu/UserPages/akunPages.dart';
import 'package:apps/menu/MainMenu/homePages.dart';
import 'package:apps/menu/MainMenu/pemantauan1Pages.dart';
import 'package:apps/menu/MainMenu/pendataan1Pages.dart';
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
  final int initialIndex;

  const MainPage({super.key, this.initialIndex = 0});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    const Homepage(),
    const Pemantauan1pages(),
    const Pendataan1pages(),
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
