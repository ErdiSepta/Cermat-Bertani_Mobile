import 'dart:io';

import 'package:apps/SendApi/HomeApi.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:apps/SendApi/ghApi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class RekapPemantauanPages extends StatefulWidget {
  const RekapPemantauanPages({super.key});

  @override
  State<RekapPemantauanPages> createState() => _RekapPemantauanPagesState();
}

class _RekapPemantauanPagesState extends State<RekapPemantauanPages> {
  final pdf = pw.Document();
  Future<void> printAndSavePdf(
    List<Map<String, dynamic>> rekapData,
    String tanggalawall,
    String tanggalakhirr,
  ) async {
    final pdf = pw.Document();

    // Tambahkan halaman ke dokumen PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          // Define the table headers
          final headers = [
            'No',
            'Tanggal',
            'PH',
            'PPM',
            'Suhu',
            'Kelembapan',
            'Tinggi Tanaman',
            'Jumlah Daun',
            'Berat Buah',
          ];

          // Define the table rows using rekapData
          final rows = rekapData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;

            return [
              (index + 1).toString(),
              data['tanggal'].toString(),
              data['ph'].toString(),
              data['ppm'].toString(),
              data['suhu'].toString(),
              data['kelembapan'].toString(),
              data['tinggiTanaman'].toString(),
              data['jumlahDaun'].toString(),
              data['beratBuah'].toString(),
            ];
          }).toList();

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Add title
              pw.Text(
                'REKAP ISI PANEN',
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),

              // Add date range
              pw.Text(
                'Rentang Waktu: $tanggalawall - $tanggalakhirr',
                style:
                    pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic),
              ),
              pw.SizedBox(height: 16),

              // Create the table in PDF format
              pw.Table.fromTextArray(
                headers: headers,
                data: rows,
                border: pw.TableBorder.all(width: 0.5),
                headerStyle:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                // headerDecoration: pw.BoxDecoration(
                //     color: const pw.PdfColor(0.85, 0.85, 0.85)),
                cellAlignment: pw.Alignment.center,
                cellStyle: pw.TextStyle(fontSize: 8),
                cellPadding: const pw.EdgeInsets.all(4),
                columnWidths: {
                  0: const pw.FlexColumnWidth(0.5), // No
                  1: const pw.FlexColumnWidth(1.5), // Tanggal
                  2: const pw.FlexColumnWidth(1), // PH
                  3: const pw.FlexColumnWidth(1), // PPM
                  4: const pw.FlexColumnWidth(1), // Suhu
                  5: const pw.FlexColumnWidth(1.5), // Kelembapan
                  6: const pw.FlexColumnWidth(1.3), // Tinggi Tanaman
                  7: const pw.FlexColumnWidth(1.3), // Jumlah Daun
                  8: const pw.FlexColumnWidth(1.3), // Berat Buah
                },
              ),
            ],
          );
        },
      ),
    );

    // Cetak dan simpan PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory newDirectory =
        await Directory('${appDocDirectory.path}/dir').create(recursive: true);
    final file = File('${newDirectory.path}/rekap_data.pdf');
    await file.writeAsBytes(await pdf.save());
  }

  String? selectedGreenhouse;
  String? selectedJenisData;
  String _greenhouseError = '';
  String _jenisDataError = '';
  String _tanggalawalError = '';
  String _tanggalakhirError = '';
  final tanggalAwall = TextEditingController();
  final tanggalAkhirr = TextEditingController();
  List<BarChartGroupData> barData = [];
  List<String> tanggalLabels = []; // Untuk menyimpan label tanggal

  Future<void> loadChartData() async {
    setState(() {
      _isLoading = true;
    });

    // Contoh JSON hasil dari API
    final result = await HomeApi.showChartHome(
      selectedJenisData.toString(),
      tanggalAwall.text.toString(),
      tanggalAkhirr.text.toString(),
      _idGH.toString(),
    );

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Tidak ada data pada tanggal dan Green house yang di pilih')),
      );
    } else if (result['status'] == 'success') {
      List<dynamic> data = result['data'];
      List<dynamic> tabelData = result['tabel_data'];

      setState(() {
        rekapData = tabelData.asMap().entries.map((entry) {
          // Memproses setiap entry menjadi Map<String, dynamic>
          return {
            "tanggal": entry.value['tanggal'],
            "ph": entry.value['ph'],
            "ppm": entry.value['ppm'],
            "suhu": entry.value['suhu'],
            "kelembapan": entry.value['kelembapan'],
            "tinggiTanaman": entry.value['tinggiTanaman'],
            "jumlahDaun": entry.value['jumlahDaun'],
            "beratBuah": entry.value['beratBuah'],
          };
        }).toList();

        barData = data.asMap().entries.map((entry) {
          int index = entry.key;
          var value = entry.value;

          // Simpan label tanggal
          tanggalLabels.add(value['tanggal'].toString());

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: double.parse(value['value'].toString()),
                color: Colors.blue,
              ),
            ],
          );
        }).toList();
        _isLoading = false;
      });
    } else {
      // Handle error ketika gagal memuat data
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result['message']}')),
      );
    }
  }

  // Panggil `loadChartData` setelah dropdown atau tanggal berubah
  void _onFiltersChanged() {
    loadChartData();
  }

  DateTime? _selectedDateAw;
  DateTime? _selectedDateAk;
  Future<void> _selectDateAwal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateAw ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDateAw) {
      setState(() {
        _selectedDateAw = picked;
        tanggalAwall.text = "${picked.year}-${picked.month}-${picked.day}";
        _onFiltersChanged();
      });
    }
  }

  Future<void> _selectDateAkhir(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateAk ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDateAk) {
      setState(() {
        _selectedDateAk = picked;
        tanggalAkhirr.text = "${picked.year}-${picked.month}-${picked.day}";
        _onFiltersChanged();
      });
    }
  }

  bool _isLoading = false;
  String? _selectedGH;
  String? _idGH = "";
  int? RealIDGH = 0;
  List<String> _ghList = [];
  void showDataGh() async {
    final result = await ghApi.getDataGhNama();
    if (result != null) {
      setState(() {
        // Pastikan ini di dalam setState untuk memperbarui UI
        _ghData = result['data_gh'];
        _ghList = result['data_gh'].keys.toList();
        _selectedGH = _ghList[0].toString();
        if (_selectedGH != null) {
          _loadGHData(_selectedGH!); // Panggil fungsi untuk memuat data GH
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda belum memiliki Green House ')),
      );
      print("data gh kosong");
    }
  }

  // Data dummy untuk setiap GH
  Map<String, dynamic> _ghData = {};
  void _loadGHData(String gh) {
    final data = _ghData[gh];
    // Menyimpan ID GH untuk kebutuhan lainnya
    _idGH = data['uuid'];
    RealIDGH = data['id_gh'];
  }

  String? selectedLabel; // variabel untuk label yang dipilih
  final Map<String, String> jenisDataMap = {
    'pH Lingkungan': 'ph_lingkungan',
    'PPM Lingkungan': 'ppm_lingkungan',
    'Suhu Lingkungan': 'suhu_lingkungan',
    'Kelembapan Lingkungan': 'kelembapan_lingkungan',
    'Tinggi Tanaman': 'tinggi_tanaman',
    'Jumlah Daun Tanaman': 'jml_daun_tanaman',
    'Berat Buah Tanaman': 'berat_buah_tanaman',
  };

  // Tambahkan data dummy untuk tabel
  List<Map<String, dynamic>> rekapData = [];

  @override
  void initState() {
    super.initState();
    showDataGh();
    tanggalAwall.addListener(_clearTanggalAwalError);
    tanggalAkhirr.addListener(_clearTanggalAkhirError);
  }

  // Clear error functions
  void _clearTanggalAwalError() {
    if (_tanggalawalError.isNotEmpty) setState(() => _tanggalawalError = '');
  }

  void _clearTanggalAkhirError() {
    if (_tanggalakhirError.isNotEmpty) setState(() => _tanggalakhirError = '');
  }

  void _validateInputs() async {
    setState(() {
      _greenhouseError =
          selectedGreenhouse == null ? 'Greenhouse harus dipilih' : '';
      _jenisDataError =
          selectedJenisData == null ? 'Jenis data harus dipilih' : '';
      _tanggalawalError =
          tanggalAwall.text.isEmpty ? 'Tanggal awal harus diisi' : '';
      _tanggalakhirError =
          tanggalAkhirr.text.isEmpty ? 'Tanggal akhir harus diisi' : '';
    });
    if (rekapData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Tabel Kosong!, Tidak ada yang bisa di Simpan! ')),
      );
    }
    if (_jenisDataError.isEmpty &&
        _tanggalawalError.isEmpty &&
        _tanggalakhirError.isEmpty &&
        rekapData.isNotEmpty) {
      await printAndSavePdf(rekapData, tanggalAwall.text, tanggalAkhirr.text);
      print('Semua data valid, siap untuk disimpan');
    } else {
      print("ADA YANG KOSONG");
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
              const Text(
                'Greenhouse',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Greenhouse Dropdown
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: Container(),
                  hint: const Text('Pilih Greenhouse'),
                  value: _selectedGH,
                  items: _ghList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGH = newValue;
                      _loadGHData(newValue!); // Load data ketika GH dipilih
                      _onFiltersChanged();
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Jenis Data',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    underline: Container(),
                    hint: const Text('Pilih Jenis Data'),
                    value: selectedLabel,
                    items: jenisDataMap.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.key),
                      );
                    }).toList(),
                    onChanged: (label) {
                      setState(() {
                        selectedLabel = label;
                        // Ambil nilai untuk dikirim ke API
                        selectedJenisData = jenisDataMap[selectedLabel];
                        loadChartData();
                      });
                    },
                  )),
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
                    child: GestureDetector(
                      onTap: () => _selectDateAwal(context),
                      child: AbsorbPointer(
                        child: CustomFormField(
                          controller: tanggalAwall,
                          labelText: '',
                          hintText: 'Pilih Tanggal Awal',
                          errorText: _tanggalawalError.isNotEmpty
                              ? _tanggalawalError
                              : null,
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 60, child: Text('Akhir')),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDateAkhir(context),
                      child: AbsorbPointer(
                        child: CustomFormField(
                          controller: tanggalAkhirr,
                          labelText: '',
                          hintText: 'Pilih Tanggal akhir',
                          errorText: _tanggalakhirError.isNotEmpty
                              ? _tanggalakhirError
                              : null,
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Chart
              Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : BarChart(
                          BarChartData(
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    int index = value.toInt();
                                    if (index == 0 &&
                                        tanggalLabels.isNotEmpty) {
                                      // Tampilkan tanggal pertama
                                      return Text(tanggalLabels.first);
                                    } else if (index == barData.length - 1 &&
                                        tanggalLabels.isNotEmpty) {
                                      // Tampilkan tanggal terakhir
                                      return Text(tanggalLabels.last);
                                    } else {
                                      // Sembunyikan label tanggal untuk data lainnya
                                      return const Text('');
                                    }
                                  },
                                ),
                              ),
                            ),
                            barGroups: barData,
                          ),
                        )),
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
    tanggalAwall.removeListener(_clearTanggalAwalError);
    tanggalAkhirr.removeListener(_clearTanggalAkhirError);
    super.dispose();
  }
}
