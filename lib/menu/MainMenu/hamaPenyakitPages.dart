import 'package:flutter/material.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/topnav.dart';

class HamaPenyakitPages extends StatefulWidget {
  const HamaPenyakitPages({super.key});

  @override
  State<HamaPenyakitPages> createState() => _HamaPenyakitPagesState();
}

class _HamaPenyakitPagesState extends State<HamaPenyakitPages> {
  String? selectedGreenhouse;
  String? selectedWarnaDaun;
  String? selectedWarnaBatang;
  String? selectedSeranganHama;
  bool isWarnaDaunLainChecked = false;
  bool isWarnaBatangLainChecked = false;
  bool isSeranganHamaLainChecked = false;

  final TextEditingController warnaDaunLainController = TextEditingController();
  final TextEditingController warnaBatangLainController = TextEditingController();
  final TextEditingController seranganHamaLainController = TextEditingController();
  final TextEditingController caraPenangananController = TextEditingController();
  final TextEditingController pestisidaController = TextEditingController();

  // Data dummy untuk dropdown
  final List<String> greenhouseList = ['GH-01', 'GH-02', 'GH-03'];
  final List<String> warnaDaunList = ['Hijau', 'Kuning', 'Coklat'];
  final List<String> warnaBatangList = ['Coklat', 'Hitam', 'Putih'];
  final List<String> seranganHamaList = ['Ulat', 'Kutu', 'Belalang'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Topnav(
          title: 'Hama & Penyakit',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/hama.png',
                  height: 200,
                ),
              ),
              const SizedBox(height: 30),
              
              // Greenhouse
              CustomDropdown(
                labelText: 'Greenhouse',
                hintText: 'Pilih Greenhouse',
                value: selectedGreenhouse ?? greenhouseList[0],
                items: greenhouseList,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGreenhouse = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Warna Daun
              CustomDropdown(
                labelText: 'Warna Daun',
                hintText: 'Pilih Warna Daun',
                value: selectedWarnaDaun ?? warnaDaunList[0],
                items: warnaDaunList,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedWarnaDaun = newValue;
                  });
                },
              ),
              
              // Checkbox dan input Warna Daun Lain
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: isWarnaDaunLainChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isWarnaDaunLainChecked = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: CustomFormField(
                      controller: warnaDaunLainController,
                      labelText: '',
                      hintText: 'Masukan Warna Daun Lain',
                      enabled: isWarnaDaunLainChecked,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Warna Batang
              CustomDropdown(
                labelText: 'Warna Batang',
                hintText: 'Pilih Warna Batang',
                value: selectedWarnaBatang ?? warnaBatangList[0],
                items: warnaBatangList,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedWarnaBatang = newValue;
                  });
                },
              ),

              // Checkbox dan input Warna Batang Lain
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: isWarnaBatangLainChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isWarnaBatangLainChecked = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: CustomFormField(
                      controller: warnaBatangLainController,
                      labelText: '',
                      hintText: 'Masukan Warna Batang Lain',
                      enabled: isWarnaBatangLainChecked,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Serangan Hama
              CustomDropdown(
                labelText: 'Serangan Hama',
                hintText: 'Tentukan Serangan Hama',
                value: selectedSeranganHama ?? seranganHamaList[0],
                items: seranganHamaList,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSeranganHama = newValue;
                  });
                },
              ),

              // Checkbox dan input Serangan Hama Lain
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: isSeranganHamaLainChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isSeranganHamaLainChecked = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: CustomFormField(
                      controller: seranganHamaLainController,
                      labelText: '',
                      hintText: 'Masukan Serangan Hama Lain',
                      enabled: isSeranganHamaLainChecked,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Cara Penanganan
              CustomFormField(
                controller: caraPenangananController,
                labelText: 'Cara Penanganan',
                hintText: 'Kosongkan Jika Belum ada',
              ),
              const SizedBox(height: 20),

              // Pestisida Yang Digunakan
              CustomFormField(
                controller: pestisidaController,
                labelText: 'Pestisida Yang Digunakan',
                hintText: 'Kosongkan Jika Belum ada',
              ),
              const SizedBox(height: 30),

              // Tombol Simpan
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      // Implementasi logika simpan
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0165FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'NotoSanSemiBold',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    warnaDaunLainController.dispose();
    warnaBatangLainController.dispose();
    seranganHamaLainController.dispose();
    caraPenangananController.dispose();
    pestisidaController.dispose();
    super.dispose();
  }
}
