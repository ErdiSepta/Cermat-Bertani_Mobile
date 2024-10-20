import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart'; // Pastikan path import ini benar

class TentangAplikasiPage extends StatelessWidget {
  const TentangAplikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Topnav(
          title: 'Tentang Aplikasi',
          showBackButton: true,
        ),
      ),
      body: Center(
        child: Text('Tentang Aplikasi'),
      ),
    );
  }
}
