import 'package:flutter/material.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/topnav.dart';

class RekapIsiPanenPages extends StatefulWidget {
  const RekapIsiPanenPages({super.key});

  @override
  State<RekapIsiPanenPages> createState() => _RekapIsiPanenPagesState();
}

class _RekapIsiPanenPagesState extends State<RekapIsiPanenPages> {
  String? selectedGreenhouse;
  String? selectedJenisData;
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();

  final List<String> greenhouseList = ['GH-01', 'GH-02', 'GH-03'];
  final List<String> jenisDataList = [
    'Jumlah Panen',
    'Berat Panen',
    'Kualitas Panen'
  ];

  // Update data dummy untuk tabel tahunan
  final List<Map<String, String>> rekapData = [
    {
      'tahun': '2024',
      'jumlahBerat': '1200 kg',
      'ukuranRata': '250 gram',
      'rasaRata': 'Manis',
      'biayaOperasional': 'Rp 60.000.000',
      'pendapatan': 'Rp 96.000.000'
    },
    {
      'tahun': '2023',
      'jumlahBerat': '1000 kg',
      'ukuranRata': '200 gram',
      'rasaRata': 'Manis Sedang',
      'biayaOperasional': 'Rp 54.000.000',
      'pendapatan': 'Rp 84.000.000'
    },
    {
      'tahun': '2022',
      'jumlahBerat': '950 kg',
      'ukuranRata': '225 gram',
      'rasaRata': 'Manis',
      'biayaOperasional': 'Rp 48.000.000',
      'pendapatan': 'Rp 76.000.000'
    },
  ];

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
          title: 'Rekap Isi Panen',
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

              // Jenis Data Dropdown
              CustomDropdown(
                labelText: 'Jenis Data',
                hintText: 'Pilih Jenis Data',
                value: selectedJenisData ?? jenisDataList[0],
                items: jenisDataList,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedJenisData = newValue;
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

              // Tabel
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
                          'Tahun',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Jumlah Berat',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Ukuran Rata-rata',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Rasa Rata-rata',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Biaya Operasional',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Pendapatan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: rekapData.map((data) {
                      return DataRow(
                        cells: [
                          DataCell(Text(data['tahun'] ?? '')),
                          DataCell(Text(data['jumlahBerat'] ?? '')),
                          DataCell(Text(data['ukuranRata'] ?? '')),
                          DataCell(Text(data['rasaRata'] ?? '')),
                          DataCell(Text(data['biayaOperasional'] ?? '')),
                          DataCell(Text(data['pendapatan'] ?? '')),
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
