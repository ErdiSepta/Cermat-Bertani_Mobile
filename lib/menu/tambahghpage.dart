import 'package:apps/src/topnav.dart';
import 'package:flutter/material.dart';

class TambahGHPage extends StatelessWidget {
  const TambahGHPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Topnav(
          title: 'Tambah GH',
          showBackButton: true,
        ),
      ),
      body: Center(
        child: Text('Tambah GH'),
      ),
    );
  }
}
