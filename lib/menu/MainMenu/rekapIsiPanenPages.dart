import 'dart:io';
import 'package:intl/intl.dart';

import 'package:apps/SendApi/PanenApi.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/topnav.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:apps/SendApi/ghApi.dart';

class RekapIsiPanenPages extends StatefulWidget {
  const RekapIsiPanenPages({super.key});

  @override
  State<RekapIsiPanenPages> createState() => _RekapIsiPanenPagesState();
}

class _RekapIsiPanenPagesState extends State<RekapIsiPanenPages> {
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
            'Tanggal Panen',
            'Jumlah Buah',
            'Berat Buah',
            'Ukuran Buah',
            'Rasa Buah',
            'Biaya Operasional',
            'Pendapatan Penjualan',
          ];

          // Define the table rows using rekapData
          final rows = rekapData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;

            return [
              (index + 1).toString(),
              data['tanggal_panen'].toString(),
              data['jumlah_buah'].toString(),
              data['berat_buah'].toString(),
              data['ukuran_buah'].toString(),
              data['rasa_buah'].toString(),
              (formatRupiah(data['biaya_operasional'].toString())),
              (formatRupiah(data['pendapatan_penjualan'].toString())),
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
                  2: const pw.FlexColumnWidth(1), // jml b
                  3: const pw.FlexColumnWidth(1), // brt b
                  4: const pw.FlexColumnWidth(1), // uk b
                  5: const pw.FlexColumnWidth(1), // rs b
                  6: const pw.FlexColumnWidth(1.5), //biaya
                  7: const pw.FlexColumnWidth(1.5), // pendapatan
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
    final result = await PanenApi.showRekapPanen(
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
            "tanggal_panen": entry.value['tanggal_panen'],
            "jumlah_buah": entry.value['jumlah_buah'],
            "berat_buah": entry.value['berat_buah'],
            "ukuran_buah": entry.value['ukuran_buah'],
            "rasa_buah": entry.value['rasa_buah'],
            "biaya_operasional": entry.value['biaya_operasional'],
            "pendapatan_penjualan": entry.value['pendapatan_penjualan'],
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

  String _tanggalawalError = '';
  String _tanggalakhirError = '';
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

              const Text(
                'Greenhouse',
                style: TextStyle(
                  fontSize: 16,
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
                          'Jumlah Buah',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Berat Buah',
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
                    rows: rekapData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Text(data['tanggal_panen'] ?? '')),
                          DataCell(Text(data['jumlah_buah'] ?? '')),
                          DataCell(Text(data['berat_buah'] ?? '')),
                          DataCell(Text(data['ukuran_buah'] ?? '')),
                          DataCell(Text(data['rasa_buah'] ?? '')),
                          DataCell(Text(
                              formatRupiah(data['biaya_operasional']) ?? '')),
                          DataCell(Text(
                              formatRupiah(data['pendapatan_penjualan']) ??
                                  '')),
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

  String formatRupiah(String? amount) {
    if (amount == null || amount.isEmpty) return 'Rp. 0';

    final formatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp.', decimalDigits: 0);
    return formatter.format(int.parse(amount));
  }

  @override
  void dispose() {
    tanggalAwall.removeListener(_clearTanggalAwalError);
    tanggalAkhirr.removeListener(_clearTanggalAkhirError);
    super.dispose();
  }
}
