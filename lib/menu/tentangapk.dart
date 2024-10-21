import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart'; // Pastikan path import ini benar

class TentangAplikasiPage extends StatelessWidget {
  const TentangAplikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Topnav(
          title: 'Tentang Aplikasi',
          showBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Center(
              child: Image.asset(
                'assets/images/Logo Aplikasi.png',
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),
            _buildInfoSection('Informasi Aplikasi', [
              'Nama Aplikasi: [Nama Aplikasi]',
              'Versi: 1.0.0',
              'Deskripsi: [Deskripsi singkat aplikasi]',
            ]),
            const SizedBox(height: 16),
            _buildInfoSection('Kontak Dinas', [
              'Nama Dinas: [Nama Dinas]',
              'Alamat: [Alamat Dinas]',
              'Telepon: [Nomor Telepon]',
              'Email: [Alamat Email]',
            ]),
            const SizedBox(height: 16),
            _buildInfoSection('Personal Business', [
              'Nama: [Nama Personal/Perusahaan]',
              'Alamat: [Alamat]',
              'Telepon: [Nomor Telepon]',
              'Email: [Alamat Email]',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(item),
            )),
      ],
    );
  }
}
