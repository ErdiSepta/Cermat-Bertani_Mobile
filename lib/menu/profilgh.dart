import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart'; // Pastikan path import ini benar

class ProfilGHPage extends StatelessWidget {
  const ProfilGHPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Topnav(
          title: 'Profil GH',
          showBackButton: true,
        ),
      ),
      body: Center(
        child: Text('Profil GH'),
      ),
    );
  }
}
