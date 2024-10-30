import 'package:flutter/material.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/topnav.dart';
import 'package:fl_chart/fl_chart.dart';

class RekapPemantauanPages extends StatefulWidget {
  const RekapPemantauanPages({super.key});

  @override
  State<RekapPemantauanPages> createState() => _RekapPemantauanPagesState();
}

class _RekapPemantauanPagesState extends State<RekapPemantauanPages> {
  String? selectedGreenhouse;
  String? selectedJenisData;
  String _greenhouseError = '';
  String _jenisDataError = '';
  String _tanggalAwalError = '';
  String _tanggalAkhirError = '';

  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();

  final List<String> greenhouseList = ['GH-01', 'GH-02', 'GH-03'];
  final List<String> jenisDataList = [
    'PH',
    'PPM',
    'Suhu',
    'Kelembapan',
    'Tinggi Tanaman',
    'Jumlah Daun',
    'Berat Buah'
  ];

  // Data dummy untuk chart
  final List<double> chartData = [4.5, 6.0, 3.5, 7.0, 2.5, 6.5, 2.0];
  final List<String> days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  // Tambahkan data dummy untuk tabel
  final List<Map<String, dynamic>> rekapData = [
    {
      'tanggal': '01/12/2024',
      'ph': 6.5,
      'ppm': 850,
      'suhu': 28,
      'kelembapan': 75,
      'tinggiTanaman': 25,
      'jumlahDaun': 8,
      'beratBuah': 150
    },
    {
      'tanggal': '02/12/2024',
      'ph': 6.8,
      'ppm': 900,
      'suhu': 27,
      'kelembapan': 78,
      'tinggiTanaman': 27,
      'jumlahDaun': 10,
      'beratBuah': 180
    },
    // Tambahkan data dummy lainnya sesuai kebutuhan
  ];

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
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
  void initState() {
    super.initState();
    tanggalAwalController.addListener(_clearTanggalAwalError);
    tanggalAkhirController.addListener(_clearTanggalAkhirError);
  }

  // Clear error functions
  void _clearTanggalAwalError() {
    if (_tanggalAwalError.isNotEmpty) setState(() => _tanggalAwalError = '');
  }

  void _clearTanggalAkhirError() {
    if (_tanggalAkhirError.isNotEmpty) setState(() => _tanggalAkhirError = '');
  }

  void _validateInputs() {
    setState(() {
      _greenhouseError =
          selectedGreenhouse == null ? 'Greenhouse harus dipilih' : '';
      _jenisDataError =
          selectedJenisData == null ? 'Jenis data harus dipilih' : '';
      _tanggalAwalError =
          tanggalAwalController.text.isEmpty ? 'Tanggal awal harus diisi' : '';
      _tanggalAkhirError = tanggalAkhirController.text.isEmpty
          ? 'Tanggal akhir harus diisi'
          : '';
    });

    if (_greenhouseError.isEmpty &&
        _jenisDataError.isEmpty &&
        _tanggalAwalError.isEmpty &&
        _tanggalAkhirError.isEmpty) {
      print('Semua data valid, siap untuk disimpan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Topnav(
          title: 'Rekap pemantauan',
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
                  'assets/images/pantau tanaman.png',
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
                errorText:
                    _greenhouseError.isNotEmpty ? _greenhouseError : null,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGreenhouse = newValue;
                    _greenhouseError = '';
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
                errorText: _jenisDataError.isNotEmpty ? _jenisDataError : null,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedJenisData = newValue;
                    _jenisDataError = '';
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
                          onPressed: () =>
                              _selectDate(context, tanggalAwalController),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorText: _tanggalAwalError.isNotEmpty
                            ? _tanggalAwalError
                            : null,
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
                          onPressed: () =>
                              _selectDate(context, tanggalAkhirController),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorText: _tanggalAkhirError.isNotEmpty
                            ? _tanggalAkhirError
                            : null,
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Chart
              Container(
                height: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 8,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              days[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: chartData.asMap().entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value,
                            color: Colors.blue,
                            width: 20,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
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
                    headingRowColor: WidgetStateProperty.all(Colors.blue[50]),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'No',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Tanggal',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'PH',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'PPM',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Suhu (°C)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Kelembapan (%)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Tinggi Tanaman (cm)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Jumlah Daun',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Berat Buah (gr)',
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
                          DataCell(Text(data['tanggal'].toString())),
                          DataCell(Text(data['ph'].toString())),
                          DataCell(Text(data['ppm'].toString())),
                          DataCell(Text(data['suhu'].toString())),
                          DataCell(Text(data['kelembapan'].toString())),
                          DataCell(Text(data['tinggiTanaman'].toString())),
                          DataCell(Text(data['jumlahDaun'].toString())),
                          DataCell(Text(data['beratBuah'].toString())),
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
                  onPressed: _validateInputs,
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
    tanggalAwalController.removeListener(_clearTanggalAwalError);
    tanggalAkhirController.removeListener(_clearTanggalAkhirError);
    super.dispose();
  }
}
