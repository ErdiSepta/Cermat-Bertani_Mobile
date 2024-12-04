import 'package:apps/SendApi/ghApi.dart';
import 'package:apps/SendApi/pembudidayaanApi.dart';
import 'package:flutter/material.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/topnav.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/cupertino.dart';

class RekapPembudidayaanPages extends StatefulWidget {
  const RekapPembudidayaanPages({super.key});

  @override
  State<RekapPembudidayaanPages> createState() =>
      _RekapPembudidayaanPagesState();
}

class _RekapPembudidayaanPagesState extends State<RekapPembudidayaanPages> {
  // Variabel untuk Greenhouse dan Jenis Data
  String? selectedJenisData;
  final String _greenhouseError = '';
  String _jenisDataError = '';
  final String _tanggalAwalError = '';
  final String _tanggalAkhirError = '';

  // Kontroler untuk tanggal
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();

  // Variabel untuk menyimpan data Greenhouse
  String? _selectedGH;
  String? _idGH = "";
  int? _realIdGH = 0;
  List<String> _ghList = [];
  Map<String, dynamic> _ghData = {};
  Map<String, dynamic> jadwalData = {};

  // Tanggal untuk TableCalendar
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  final DateTime _focusedDay = DateTime.now();

  final List<String> jenisDataList = [
    'Perendaman',
    'Fase Semai',
    'Fase Vegetatif - Generatif',
    'Penyiraman',
  ];

  @override
  void initState() {
    super.initState();
    _fetchGreenhouseData();
    selectedJenisData = jenisDataList[0];
  }

  // Fetch Data Greenhouse
  Future<void> _fetchGreenhouseData() async {
    final result = await ghApi.getDataGhNama();
    if (result != null && result['data_gh'] != null) {
      setState(() {
        _ghData = result['data_gh'];
        _ghList = result['data_gh'].keys.toList();
        _selectedGH = _ghList.isNotEmpty ? _ghList[0] : null;

        if (_selectedGH != null) {
          _loadGHData(_selectedGH!);
        }
      });
    } else {
      _showSnackbar('Anda belum memiliki Green House');
    }
  }

  // Memuat data Greenhouse
  void _loadGHData(String gh) {
    final data = _ghData[gh];
    _idGH = data['uuid'];
    _realIdGH = data['id_gh'];
    _fetchJadwalData();
  }

  // Fetch Jadwal Data dari API
  Future<void> _fetchJadwalData() async {
    if (_idGH == null || selectedJenisData == null) return;

    final result = await PembudidayaanApi.showRekap(
      selectedJenisData.toString(),
      _idGH.toString(),
    );
    setState(() {
      print("Resultnya : $result");
      if (result != null) {
        jadwalData = result;
        if (result["status"] == "success") {
          jadwalData = result;
        } else if (result["status"] == "error") {
          jadwalData = result;
        } else {
          jadwalData = {};
        }
      } else {
        jadwalData = {};
      }
      _updateDateRange();
    });
  }

  void _updateDateRange() {
    if (selectedJenisData != null && jadwalData['status'] != "error") {
      final data = jadwalData['data'];
      // Validasi apakah tgl_awal dan tgl_akhir ada dan dalam format yang benar
      if (data.containsKey('tgl_awal') && data.containsKey('tgl_akhir')) {
        try {
          setState(() {
            // Parsing string ke DateTime jika diperlukan
            _rangeStart = DateTime.tryParse(data['tgl_awal']);
            _rangeEnd = DateTime.tryParse(data['tgl_akhir']);
          });
        } catch (e) {
          print('Error parsing tanggal: $e');
        }
      } else {
        print('Data tidak memiliki kunci tgl_awal atau tgl_akhir');
      }
    } else {
      _rangeStart = null;
      _rangeEnd = null;
      print('Jadwal Data atau data tidak tersedia');
    }
  } // Menampilkan Snackbar

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSnackbarTrue(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Fungsi Utility untuk Cek Tanggal
  bool _isMarkedDate(DateTime date) {
    return (_rangeStart != null && isSameDay(date, _rangeStart)) ||
        (_rangeEnd != null && isSameDay(date, _rangeEnd));
  }

  bool _isWithinRange(DateTime date) {
    if (_rangeStart == null || _rangeEnd == null) return false;
    return (date.isAfter(_rangeStart!) && date.isBefore(_rangeEnd!)) ||
        isSameDay(date, _rangeStart!) ||
        isSameDay(date, _rangeEnd!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Topnav(
          title: 'Rekap Pembudidayaan',
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

              const Text(
                'Green house',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

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
                    });
                  },
                ),
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
                    _fetchJadwalData();
                    _updateDateRange();
                  });
                },
              ),
              const SizedBox(height: 20),

              // Calendar dengan error message
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: (_tanggalAwalError.isNotEmpty ||
                                  _tanggalAkhirError.isNotEmpty)
                              ? Colors.red
                              : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2024, 1, 1),
                      lastDay: DateTime.utc(2025, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: CalendarFormat.month,
                      selectedDayPredicate: (day) => _isMarkedDate(day),
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      rangeSelectionMode: RangeSelectionMode.enforced,
                      onDaySelected:
                          null, // Hapus onDaySelected karena tidak perlu manual selection
                      calendarStyle: CalendarStyle(
                        selectedDecoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: const TextStyle(color: Colors.white),
                        rangeStartDecoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        rangeEndDecoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        withinRangeTextStyle:
                            const TextStyle(color: Colors.black),
                        rangeHighlightColor: Colors.blue.withOpacity(0.2),
                      ),
                    ),
                  ),
                  if (_tanggalAwalError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                      child: Text(
                        _tanggalAwalError,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  if (_tanggalAkhirError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                      child: Text(
                        _tanggalAkhirError,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              // Tampilkan tanggal yang dipilih
              if (_rangeStart != null)
                Text(
                  'Tanggal Awal: ${_rangeStart!.day}/${_rangeStart!.month}/${_rangeStart!.year}',
                  style: const TextStyle(fontSize: 16),
                ),
              if (_rangeEnd != null)
                Text(
                  'Tanggal Akhir: ${_rangeEnd!.day}/${_rangeEnd!.month}/${_rangeEnd!.year}',
                  style: const TextStyle(fontSize: 16),
                ),

              const SizedBox(height: 30),

              // Update tombol Print
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: Key('hapusJadwalButton'),
                  onPressed: () {
                    _showAlertDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Hapus Jadwal',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
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

  String removeFirstSixCharacters(String input) {
    // Periksa apakah panjang string cukup
    if (input.length <= 5) {
      return ''; // Jika kurang dari atau sama dengan 6 karakter, kembalikan string kosong
    }
    return input.substring(5); // Hapus 6 karakter pertama
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Hapus Jadwal'),
        content: Text(
          'Anda yakin ingin menghapus semua jadwal pada Greenhouse ${removeFirstSixCharacters(_selectedGH.toString())}?',
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              try {
                final result =
                    await PembudidayaanApi.deleteRekap(_idGH.toString());
                if (result != null && result['status'] == "success") {
                  Navigator.pop(context); // Tutup dialog jika sukses
                  _showSnackbarTrue(
                    "Jadwal berhasil dihapus!",
                  );
                  _fetchGreenhouseData();
                } else {
                  Navigator.pop(context); // Tutup dialog jika gagal
                  _showSnackbar(result?['message'] ?? "Kesalahan pada server");
                }
              } catch (e) {
                Navigator.pop(context); // Tutup dialog jika error
                _showSnackbar("Terjadi kesalahan: $e");
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
