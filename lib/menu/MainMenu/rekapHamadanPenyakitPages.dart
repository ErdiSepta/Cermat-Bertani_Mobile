import 'package:flutter/material.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/topnav.dart';

class RekapHamadanPenyakitPages extends StatefulWidget {
  const RekapHamadanPenyakitPages({super.key});

  @override
  State<RekapHamadanPenyakitPages> createState() => _RekapHamadanPenyakitPagesState();
}

class _RekapHamadanPenyakitPagesState extends State<RekapHamadanPenyakitPages> {
  String? selectedGreenhouse;
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();

  final List<String> greenhouseList = ['GH-01', 'GH-02', 'GH-03'];

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

  // Tambahkan data dummy untuk tabel
  final List<Map<String, String>> rekapData = [
    {
      'warnaDaun': 'Hijau Kekuningan',
      'warnaBatang': 'Coklat',
      'seranganHama': 'Ulat Daun',
      'caraPenanganan': 'Penyemprotan Pestisida',
      'pestisida': 'Decis'
    },
    {
      'warnaDaun': 'Kuning',
      'warnaBatang': 'Hitam',
      'seranganHama': 'Kutu Putih',
      'caraPenanganan': 'Penyemprotan Pestisida',
      'pestisida': 'Curacron'
    },
    // Tambahkan data dummy lainnya jika diperlukan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Topnav(
          title: 'Rekap Hama Penyakit',
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

              // Tanggal
              const Text(
                'Tanggal',
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
                    child: TextField(
                      controller: tanggalAwalController,
                      decoration: InputDecoration(
                        hintText: 'Pilih Tanggal Awal',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context, tanggalAwalController),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Akhir')),
                  Expanded(
                    child: TextField(
                      controller: tanggalAkhirController,
                      decoration: InputDecoration(
                        hintText: 'Pilih Tanggal Akhir',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context, tanggalAkhirController),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Tambahkan Tabel
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.blue[50]),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'No',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Warna Daun',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Warna Batang',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Serangan Hama',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Cara Penanganan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Pestisida',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: rekapData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Text(data['warnaDaun'] ?? '')),
                          DataCell(Text(data['warnaBatang'] ?? '')),
                          DataCell(Text(data['seranganHama'] ?? '')),
                          DataCell(Text(data['caraPenanganan'] ?? '')),
                          DataCell(Text(data['pestisida'] ?? '')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),

              // Tombol Print
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Implementasi fungsi print
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Print',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'NotoSanSemiBold',
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
    tanggalAwalController.dispose();
    tanggalAkhirController.dispose();
    super.dispose();
  }
}
