import 'package:flutter/material.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/topnav.dart';

class PembudidayaanPages extends StatefulWidget {
  const PembudidayaanPages({super.key});

  @override
  State<PembudidayaanPages> createState() => _PembudidayaanPagesState();
}

class _PembudidayaanPagesState extends State<PembudidayaanPages> {
  String? selectedGreenhouse;
  final List<String> greenhouseList = ['GH-01', 'GH-02', 'GH-03'];
  
  // Controllers untuk tanggal
  final TextEditingController perendamanAwalController = TextEditingController();
  final TextEditingController perendamanAkhirController = TextEditingController();
  final TextEditingController semaiAwalController = TextEditingController();
  final TextEditingController semaiAkhirController = TextEditingController();
  final TextEditingController vegetatifAwalController = TextEditingController();
  final TextEditingController vegetatifAkhirController = TextEditingController();
  final TextEditingController penyiramanAwalController = TextEditingController();
  final TextEditingController penyiramanAkhirController = TextEditingController();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Topnav(
          title: 'Pembudidayaan',
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
                  'assets/images/pembudidayaan.png',
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
              const SizedBox(height: 30),

              // Fase Perendaman
              const Text(
                'Fase Perendaman',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSanSemiBold',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Awal')),
                  Expanded(
                    child: CustomFormField(
                      controller: perendamanAwalController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Awal Fase',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, perendamanAwalController),
                      ),
                      enabled: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Akhir')),
                  Expanded(
                    child: CustomFormField(
                      controller: perendamanAkhirController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Akhir Fase',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, perendamanAkhirController),
                      ),
                      enabled: true,
                    ),
                  ),
                ],
              ),

              // Fase Semai
              const SizedBox(height: 10),
              const Text(
                'Fase Semai',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSanSemiBold',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Awal')),
                  Expanded(
                    child: CustomFormField(
                      controller: semaiAwalController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Awal Fase',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, semaiAwalController),
                      ),
                      enabled: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Akhir')),
                  Expanded(
                    child: CustomFormField(
                      controller: semaiAkhirController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Akhir Fase',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, semaiAkhirController),
                      ),
                      enabled: true,
                    ),
                  ),
                ],
              ),

              // Fase Vegetatif
              const SizedBox(height: 20),
              const Text(
                'Fase Vegetatif',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSanSemiBold',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Awal')),
                  Expanded(
                    child: CustomFormField(
                      controller: vegetatifAwalController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Awal Fase',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, vegetatifAwalController),
                      ),
                      enabled: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Akhir')),
                  Expanded(
                    child: CustomFormField(
                      controller: vegetatifAkhirController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Akhir Fase',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, vegetatifAkhirController),
                      ),
                      enabled: true,
                    ),
                  ),
                ],
              ),

              // Fase Penyiraman
              const SizedBox(height: 20),
              const Text(
                'Fase Penyiraman',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSanSemiBold',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Awal')),
                  Expanded(
                    child: CustomFormField(
                      controller: penyiramanAwalController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Awal Fase',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, penyiramanAwalController),
                      ),
                      enabled: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Akhir')),
                  Expanded(
                    child: CustomFormField(
                      controller: penyiramanAkhirController,
                      labelText: '',
                      hintText: 'Pilih Tanggal Akhir Fase',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, penyiramanAkhirController),
                      ),
                      enabled: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
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
    perendamanAwalController.dispose();
    perendamanAkhirController.dispose();
    semaiAwalController.dispose();
    semaiAkhirController.dispose();
    vegetatifAwalController.dispose();
    vegetatifAkhirController.dispose();
    penyiramanAwalController.dispose();
    penyiramanAkhirController.dispose();
    super.dispose();
  }
}
