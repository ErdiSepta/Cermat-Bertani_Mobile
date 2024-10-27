import 'package:flutter/material.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/topnav.dart';

class IsiPanenPages extends StatefulWidget {
  const IsiPanenPages({super.key});

  @override
  State<IsiPanenPages> createState() => _IsiPanenPagesState();
}

class _IsiPanenPagesState extends State<IsiPanenPages> {
  String? selectedGreenhouse;
  final List<String> greenhouseList = ['GH-01', 'GH-02', 'GH-03'];
  
  final TextEditingController jumlahBeratController = TextEditingController();
  final TextEditingController ukuranRataController = TextEditingController();
  final TextEditingController rasaRataController = TextEditingController();
  final TextEditingController biayaOperasionalController = TextEditingController();
  final TextEditingController pendapatanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Topnav(
          title: 'Isi Panen',
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
                  'assets/images/panen.png',
                  height: 200,
                ),
              ),
              const SizedBox(height: 30),

              // Greenhouse Dropdown
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

              // Jumlah Berat
              CustomFormField(
                controller: jumlahBeratController,
                labelText: 'Jumlah Berat',
                hintText: 'Pilih Jumlah Berat',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Ukuran Rata-rata
              CustomFormField(
                controller: ukuranRataController,
                labelText: 'Ukuran Rata - Rata',
                hintText: 'Masukan Ukuran rata - rata',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Rasa Rata-rata
              CustomFormField(
                controller: rasaRataController,
                labelText: 'Rasa Rata - Rata',
                hintText: 'Masukan Rasa Rata - Rata',
              ),
              const SizedBox(height: 20),

              // Biaya Operasional
              CustomFormField(
                controller: biayaOperasionalController,
                labelText: 'Biaya Operasional',
                hintText: 'Masukan Biaya Operasional',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Pendapatan Hasil Penjualan
              CustomFormField(
                controller: pendapatanController,
                labelText: 'Pendapatan Hasil Penjualan',
                hintText: 'Masukan Pendapatan Hasil Penjualan',
                keyboardType: TextInputType.number,
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
    jumlahBeratController.dispose();
    ukuranRataController.dispose();
    rasaRataController.dispose();
    biayaOperasionalController.dispose();
    pendapatanController.dispose();
    super.dispose();
  }
}
