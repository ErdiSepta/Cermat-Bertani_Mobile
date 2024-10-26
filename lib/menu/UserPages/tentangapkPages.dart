import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart';

class Tentangapk extends StatelessWidget {
  const Tentangapk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Topnav(
          title: 'Tentang Aplikasi',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/Logos Apps Splash.png', // Sesuaikan dengan path logo Certani
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'Aplikasi Certani (Cermat Bertani) adalah solusi inovatif dalam bentuk aplikasi mobile Android yang dikembangkan dengan teknologi Flutter, memberikan efisiensi dan performa ringan. Dirancang untuk dapat dijalankan dengan minimum RAM sebesar 2 GB dan versi Android 10, Certani menawarkan fitur pemantauan dan pendataan greenhouse yang memudahkan pengguna dalam mengelola data secara cepat dan efisien. Dengan Certani, petani dapat menggantikan metode pencatatan manual tradisional yang biasa dilakukan dengan buku besar atau pengetikan di Excel, sehingga proses pengelolaan data menjadi lebih praktis dan portabel. Aplikasi ini membantu meningkatkan produktivitas pertanian dengan mempermudah akses informasi yang diperlukan dalam setiap periode pengelolaan.',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'NotoSanSemiBold',
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 30),
              const Column(
                children: [
                  Text(
                    'Contact Developers : 089541379345',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'NotoSanSemiBold',
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Email : diamanerdi@gmail.com',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'NotoSanSemiBold',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
