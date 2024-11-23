import 'package:apps/SendApi/HomeApi.dart';
import 'package:apps/SendApi/ghApi.dart';
import 'package:apps/SendApi/tokenJWT.dart';
import 'package:apps/SendApi/userApi.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:apps/src/customFormfield.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String DP_ph_tanaman = "0";
  String DP_ppm_tanaman = "0";
  String DP_suhu_tanaman = "0";
  String DP_kelembapan_tanaman = "0";
  final String _tanggalawalError = '';
  final String _tanggalakhirError = '';
  String? selectedJenisData;
  final tanggalAwall = TextEditingController();
  final tanggalAkhirr = TextEditingController();
  @override
  void initState() {
    super.initState();

    showProfil();
    showDataGh();
  }

// Deklarasi untuk menyimpan data chart
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

    if (result != null && result['status'] == 'success') {
      List<dynamic> data = result['data'];
      Map<String, dynamic> dataPemantauan = result['total_summary'];

      setState(() {
        DP_ph_tanaman = dataPemantauan['ph_lingkungan'] ?? "0";
        DP_ppm_tanaman = dataPemantauan['ppm_lingkungan'] ?? "0";
        DP_suhu_tanaman = dataPemantauan['suhu_lingkungan'] ?? "0";
        DP_kelembapan_tanaman = dataPemantauan['kelembapan_lingkungan'] ?? "0";
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
        SnackBar(content: Text('${result?['message']}')),
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
  String nama = "...";
  Future<void> showProfil() async {
    String? email = await TokenJwt.getEmail();
    final result = await UserApi.getProfil(email.toString());
    if (result != null) {
      if (result['status'] == "success") {
        nama = result['data']['nama_lengkap'];
      } else if (result['status'] == "error") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Pengambilan data gagal : ${result['message']}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Pengambilan data: ada kesalahan pengiriman data')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Pengambilan data gagal: ada kesalahan pengiriman data')),
      );
    }
    setState(() {
      _isLoading = false; // Menyembunyikan loading setelah permintaan selesai
    });
  }

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                'Selamat Datang, $nama',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pemantauan',
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
                  const SizedBox(height: 16),
                  const Text(
                    'Greenhouse',
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _selectDateAwal(context),
                              child: AbsorbPointer(
                                child: CustomFormField(
                                  controller: tanggalAwall,
                                  labelText: 'Tanggal Awal',
                                  hintText: 'Pilih Tanggal Awal',
                                  errorText: _tanggalawalError.isNotEmpty
                                      ? _tanggalawalError
                                      : null,
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _selectDateAkhir(context),
                              child: AbsorbPointer(
                                child: CustomFormField(
                                  controller: tanggalAkhirr,
                                  labelText: ' Tanggal Akhir',
                                  hintText: 'Pilih Tanggal akhir',
                                  errorText: _tanggalakhirError.isNotEmpty
                                      ? _tanggalakhirError
                                      : null,
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
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
                                  if (index == 0 && tanggalLabels.isNotEmpty) {
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
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data Pemantauan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(30),
                    margin: const EdgeInsets.only(bottom: 80),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildDataCard('PH TANAMAN',
                                  DP_ph_tanaman ?? "0", Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDataCard('PPM TANAMAN',
                                  DP_ppm_tanaman.toString(), Colors.blue),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDataCard(
                                  'SUHU', DP_suhu_tanaman, Colors.blue),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDataCard('KELEMBAPAN',
                                  DP_kelembapan_tanaman, Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(double height) {
    return Container(
      width: 30,
      height: 120 * height,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildDataCard(String title, String value, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: bgColor == Colors.blue ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: bgColor == Colors.blue ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
