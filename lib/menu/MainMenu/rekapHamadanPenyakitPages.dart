import 'dart:io';

import 'package:apps/SendApi/HamaAndPenyakitApi.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart';

import 'package:apps/src/customFormfield.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:apps/SendApi/ghApi.dart';

class RekapHamadanPenyakitPages extends StatefulWidget {
  const RekapHamadanPenyakitPages({super.key});

  @override
  State<RekapHamadanPenyakitPages> createState() =>
      _RekapHamadanPenyakitPagesState();
}

class _RekapHamadanPenyakitPagesState extends State<RekapHamadanPenyakitPages> {
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
            'Warna Daun',
            'Warna Batang',
            'Serangan Hama',
            'Cara Penanganan',
            'Jumlah Pestisida',
            'Tanggal Dilaporkan',
          ];

          // Define the table rows using rekapData
          final rows = rekapData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;

            return [
              (index + 1).toString(),
              data['warna_daun'].toString(),
              data['warna_batang'].toString(),
              data['serangan_hama'].toString(),
              data['cara_penanganan'].toString(),
              data['jml_pestisida'].toString(),
              data['tanggal'].toString(),
            ];
          }).toList();

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Add title
              pw.Text(
                'REKAP HAMA DAN PENYAKIT',
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
                  0: const pw.FlexColumnWidth(0.6), // No
                  1: const pw.FlexColumnWidth(1.5), // WD
                  2: const pw.FlexColumnWidth(1.7), // WB
                  3: const pw.FlexColumnWidth(2.0), // SH
                  4: const pw.FlexColumnWidth(1.6), // CP
                  5: const pw.FlexColumnWidth(1.6), // JP
                  6: const pw.FlexColumnWidth(1.5), //TGL
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
  String _greenhouseError = '';
  String _tanggalAwalError = '';
  String _tanggalAkhirError = '';
  Future<void> loadChartData() async {
    setState(() {
      _isLoading = true;
    });

    // Contoh JSON hasil dari API
    final result = await HamaAndPenyakitApi.showRekapHamaPenyakit(
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
      List<dynamic> tabelData = result['data'];

      setState(() {
        rekapData = tabelData.asMap().entries.map((entry) {
          // Memproses setiap entry menjadi Map<String, dynamic>
          return {
            "warna_daun": entry.value['warna_daun'],
            "warna_batang": entry.value['warna_batang'],
            "serangan_hama": entry.value['serangan_hama'],
            "cara_penanganan": entry.value['cara_penanganan'],
            "rasa_buah": entry.value['rasa_buah'],
            "jml_pestisida": entry.value['jml_pestisida'],
            "tanggal": entry.value['tanggal'],
          };
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

  final String _tanggalawalError = '';
  final String _tanggalakhirError = '';
  final tanggalAwall = TextEditingController();
  final tanggalAkhirr = TextEditingController();
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
          _loadGHData(_selectedGH!);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda belum memiliki Green House ')),
      );
      print("data gh kosong");
    }
  }

  Map<String, dynamic> _ghData = {};
  void _loadGHData(String gh) {
    final data = _ghData[gh];
    // Menyimpan ID GH untuk kebutuhan lainnya
    _idGH = data['uuid'];
    RealIDGH = data['id_gh'];
  }

  String? selectedLabel;
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
    if (_tanggalAwalError.isNotEmpty) {
      setState(() => _tanggalAwalError = '');
    }
  }

  void _clearTanggalAkhirError() {
    if (_tanggalAkhirError.isNotEmpty) {
      setState(() => _tanggalAkhirError = '');
    }
  }

  void _validateInputs() async {
    setState(() {
      _greenhouseError =
          selectedGreenhouse == null ? 'Greenhouse harus dipilih' : '';
      _tanggalAwalError =
          tanggalAwall.text.isEmpty ? 'Tanggal awal harus diisi' : '';
      _tanggalAkhirError =
          tanggalAkhirr.text.isEmpty ? 'Tanggal akhir harus diisi' : '';
    });
    if (rekapData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Tabel Kosong!, Tidak ada yang bisa di Simpan! ')),
      );
    }
    if (_tanggalawalError.isEmpty &&
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
                      _loadGHData(newValue!);
                      _onFiltersChanged();
                    });
                  },
                ),
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

              // Tambahkan Tabel
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
                      DataColumn(
                        label: Text(
                          'Tanggal Dilaporkan',
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
                          DataCell(Text(data['warna_daun'] ?? '')),
                          DataCell(Text(data['warna_batang'] ?? '')),
                          DataCell(Text(data['serangan_hama'] ?? '')),
                          DataCell(Text(data['cara_penanganan'] ?? '')),
                          DataCell(Text(data['jml_pestisida'] ?? '')),
                          DataCell(Text(data['tanggal'] ?? '')),
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
