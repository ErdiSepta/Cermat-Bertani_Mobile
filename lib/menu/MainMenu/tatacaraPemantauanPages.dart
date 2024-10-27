import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart';
import 'package:apps/src/customDropdown.dart'; // Tambahkan import ini

class tatacaraPemantauanPages extends StatefulWidget {
  const tatacaraPemantauanPages({super.key});

  @override
  State<tatacaraPemantauanPages> createState() => tatacaraPemantauanPagesState();
}

class tatacaraPemantauanPagesState extends State<tatacaraPemantauanPages> {
  String selectedGuide = 'Pantau Lingkungan';

  final Map<String, Map<String, dynamic>> guideContents = {
    'Pantau Lingkungan': {
      'image': 'assets/images/pantau lingkungan.png',
      'sections': [
        {
          'title': 'Pilih Greenhouse (GH)',
          'points': [
            '• Di menu utama, cari dan pilih opsi "Greenhouse" atau "GH."',
            '• Anda akan melihat daftar greenhouse yang telah terdaftar di aplikasi.',
          ],
        },
        {
          'title': 'Isi Formulir',
          'points': [
            '• Pilih greenhouse yang ingin Anda pantau.',
            '• Anda akan diarahkan ke halaman formulir pemantauan.',
            '• Isi kolom-kolom berikut:',
            '  • PH: Masukkan nilai pH tanah atau media tanam.',
            '  • PPM: Masukkan nilai Part Per Million (PPM) untuk menunjukkan konsentrasi nutrisi.',
            '  • Suhu: Masukkan suhu lingkungan di dalam greenhouse.',
            '  • Kelembapan Polibag: Masukkan tingkat kelembapan dalam polibag tempat tanaman berada.',
          ],
        },
        {
          'title': 'Simpan Data',
          'points': [
            '• Setelah mengisi semua kolom, periksa kembali data yang telah Anda masukkan untuk memastikan keakuratannya.',
            '• Klik tombol "Simpan" untuk menyimpan data yang telah diinput.',
            '• Aplikasi akan menampilkan notifikasi bahwa data telah berhasil disimpan.',
          ],
        },
      ],
    },
    'Pantau Tanaman': {
      'image': 'assets/images/pantau tanaman.png',
      'sections': [
        {
          'title': 'Pilih Greenhouse (GH)',
          'points': [
            '• Di menu utama, cari dan pilih opsi "Greenhouse" atau "GH."',
            '• Anda akan melihat daftar greenhouse yang telah terdaftar di aplikasi.',
          ],
        },
        {
          'title': 'Isi Formulir Data Tanaman',
          'points': [
            '• Pilih greenhouse yang ingin Anda catat datanya.',
            '• Anda akan diarahkan ke halaman formulir pemantauan tanaman.',
            '• Isi kolom-kolom berikut:',
            '  • Tinggi Tanaman: Masukkan tinggi tanaman dalam satuan yang sesuai (misalnya, cm).',
            '  • Jumlah Daun: Masukkan jumlah daun yang terdapat pada tanaman.',
            '  • Berat Buah: Masukkan berat buah yang telah dipanen dalam satuan yang sesuai (misalnya, gram atau kg).',
          ],
        },
        {
          'title': 'Simpan Data',
          'points': [
            '• Setelah mengisi semua kolom, periksa kembali data yang telah Anda masukkan untuk memastikan keakuratannya.',
            '• Klik tombol "Simpan" untuk menyimpan data yang telah diinput.',
            '• Aplikasi akan menampilkan notifikasi bahwa data telah berhasil disimpan.',
          ],
        },
      ],
    },
    
    'Hama & Penyakit': {
      'image': 'assets/images/hama.png',
      'sections': [
        {
          'title': 'Pilih Greenhouse (GH)',
          'points': [
            '• Di menu utama, cari dan pilih opsi "Greenhouse" atau "GH."',
            '• Anda akan melihat daftar greenhouse yang telah terdaftar di aplikasi.',
          ],
        },
        {
          'title': 'Centang Checkbox Warna Daun',
          'points': [
            '• Jika Anda melihat perubahan warna pada daun tanaman, centang checkbox yang sesuai.',
            '• Pilih Warna Daun dari daftar pilihan, jika warna yang sesuai tidak ada, Anda dapat mengisi tanda-tanda masalah lain di kolom yang disediakan.',
          ],
        },
        {
          'title': 'Centang Checkbox Tanda Penyakit',
          'points': [
            '• Jika ada tanda-tanda penyakit pada batang, centang checkbox yang sesuai.',
            '• Pilih Warna Batang dari daftar pilihan, jika tidak ada warna yang sesuai, Anda dapat mengisi tanda-tanda masalah lain yang terlihat.',
          ],
        },
        {
          'title': 'Isi Form Pestisida yang Digunakan',
          'points': [
            '• Di kolom yang disediakan, tuliskan cara mengatasi masalah yang terdeteksi.',
            '• Masukkan informasi mengenai pestisida yang digunakan, termasuk nama dan dosis yang diterapkan.',
          ],
        },
      ],
    },
    'Pembudidayaan': {
      'image': 'assets/images/pembudidayaan.png',
      'sections': [
        {
          'title': 'Pilih Greenhouse (GH)',
          'points': [
            '• Di menu utama, cari dan pilih opsi "Greenhouse" atau "GH."',
            '• Anda akan melihat daftar greenhouse yang telah terdaftar di aplikasi.',
          ],
        },
        {
          'title': 'Pilih Tanggal Awal Perendaman',
          'points': [
            '• Temukan opsi untuk mencatat fase perendaman.',
            '• Pilih Tanggal Awal Perendaman dari kalender yang muncul.',
          ],
        },
        {
          'title': 'Pilih Tanggal Akhir Perendaman',
          'points': [
            '• Pilih Tanggal Akhir Perendaman dari kalender yang sama.',
            '• Klik tombol "Simpan" untuk menyimpan data perendaman.',
          ],
        },
        {
          'title': 'Pilih Tanggal Awal Semai',
          'points': [
            '• Setelah menyimpan data perendaman, temukan opsi untuk mencatat fase semai.',
            '• Pilih Tanggal Awal Semai dari kalender yang muncul.',
          ],
        },
        {
          'title': 'Pilih Tanggal Akhir Semai',
          'points': [
            '• Pilih Tanggal Akhir Semai dari kalender yang sama.',
            '• Klik tombol "Simpan" untuk menyimpan data semai.',
          ],
        },
        {
          'title': 'Pilih Tanggal Masuk Fase Vegetatif',
          'points': [
            '• Temukan opsi untuk mencatat fase vegetatif.',
            '• Pilih Tanggal Masuk Fase Vegetatif dari kalender yang muncul.',
            '• Klik tombol "Simpan" untuk menyimpan data fase vegetatif.',
          ],
        },
        {
          'title': 'Pilih Tanggal Masuk Fase Generatif',
          'points': [
            '• Temukan opsi untuk mencatat fase generatif.',
            '• Pilih Tanggal Masuk Fase Generatif dari kalender yang muncul.',
            '• Klik tombol "Simpan" untuk menyimpan data fase generatif.',
          ],
        },
        {
          'title': 'Pilih Tanggal Awal Fase Penyerbukan',
          'points': [
            '• Temukan opsi untuk mencatat fase penyerbukan.',
            '• Pilih Tanggal Awal Fase Penyerbukan dari kalender yang muncul.',
          ],
        },
        {
          'title': 'Pilih Tanggal Akhir Fase Penyerbukan',
          'points': [
            '• Pilih Tanggal Akhir Fase Penyerbukan dari kalender yang sama.',
            '• Klik tombol "Simpan" untuk menyimpan data penyerbukan.',
          ],
        },
        {
          'title': 'Pilih Tanggal Awal Fase Penyiraman',
          'points': [
            '• Temukan opsi untuk mencatat fase penyiraman.',
            '• Pilih Tanggal Awal Fase Penyiraman dari kalender yang muncul.',
          ],
        },
        {
          'title': 'Pilih Tanggal Akhir Fase Penyiraman',
          'points': [
            '• Pilih Tanggal Akhir Fase Penyiraman dari kalender yang sama.',
            '• Klik tombol "Simpan" untuk menyimpan data penyiraman.',
          ],
        },
      ],
    },
    'Isi Panen': {
      'image': 'assets/images/panen.png',
      'sections': [
        {
          'title': 'Pilih Greenhouse (GH)',
          'points': [
            '• Di menu utama, cari dan pilih opsi "Greenhouse" atau "GH."',
            '• Anda akan melihat daftar greenhouse yang telah terdaftar di aplikasi.',
          ],
        },
        {
          'title': 'Isi Form Data Hasil Panen',
          'points': [
            '• Pilih greenhouse yang ingin Anda catat hasil panennya.',
            '• Anda akan diarahkan ke halaman formulir untuk mencatat data hasil panen.',
            '• Isi kolom-kolom berikut:',
            '  • Jumlah: Masukkan jumlah produk yang dipanen.',
            '  • Berat: Masukkan berat total hasil panen dalam satuan yang sesuai (misalnya, kg).',
            '  • Ukuran Rata-rata: Masukkan ukuran rata-rata produk yang dipanen (misalnya, dalam cm atau gram).',
            '  • Rasa Rata-rata: Berikan penilaian mengenai rasa produk, jika memungkinkan.',
            '  • Biaya Operasional: Masukkan total biaya operasional yang dikeluarkan untuk proses budidaya.',
            '  • Pendapatan Hasil Penjualan: Masukkan total pendapatan dari hasil penjualan produk.',
          ],
        },
        {
          'title': 'Simpan Data',
          'points': [
            '• Setelah mengisi semua kolom, periksa kembali data yang telah Anda masukkan untuk memastikan keakuratannya.',
            '• Klik tombol "Simpan" untuk menyimpan data hasil panen.',
            '• Aplikasi akan menampilkan notifikasi bahwa data telah berhasil disimpan.',
          ],
        },
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Topnav(
          title: selectedGuide,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  guideContents[selectedGuide]?['image'] ?? 'assets/images/tatacara.png',
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              
              // Ganti Container dropdown dengan CustomDropdown
              CustomDropdown(
                labelText: 'Pilih Panduan',
                hintText: 'Pilih jenis panduan',
                value: selectedGuide,
                items: guideContents.keys.toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedGuide = newValue;
                    });
                  }
                },
              ),
              
              const SizedBox(height: 20),
              
              ...buildGuideContent(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildGuideContent() {
    final sections = guideContents[selectedGuide]?['sections'] as List<Map<String, dynamic>>?;
    if (sections == null) return [const Text('Konten belum tersedia')];

    return sections.expand((section) {
      return [
        Text(
          section['title'],
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'NotoSanSemiBold',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (String point in section['points'])
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    point,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'NotoSanSemiBold',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ];
    }).toList();
  }
}
