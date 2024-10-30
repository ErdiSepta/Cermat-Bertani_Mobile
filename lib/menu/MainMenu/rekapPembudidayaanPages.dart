import 'package:flutter/material.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/topnav.dart';
import 'package:table_calendar/table_calendar.dart';

class RekapPembudidayaanPages extends StatefulWidget {
  const RekapPembudidayaanPages({super.key});

  @override
  State<RekapPembudidayaanPages> createState() =>
      _RekapPembudidayaanPagesState();
}

class _RekapPembudidayaanPagesState extends State<RekapPembudidayaanPages> {
  String? selectedGreenhouse;
  String? selectedJenisData;
  String _greenhouseError = '';
  String _jenisDataError = '';
  String _tanggalAwalError = '';
  String _tanggalAkhirError = '';

  DateTime? startDate;
  DateTime? endDate;
  final DateTime _focusedDay = DateTime.now();

  final List<String> greenhouseList = ['GH-01', 'GH-02', 'GH-03'];
  final List<String> jenisDataList = [
    'Perendaman',
    'Fase Semai',
    'Fase Vegetatif - Generatif',
    'Penyerbukan',
    'Penyiraman',
  ];

  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  // Tambahkan map untuk menyimpan data range tanggal
  final Map<String, Map<String, DateTime>> jadwalData = {
    'Perendaman': {
      'start': DateTime(2024, 12, 18),
      'end': DateTime(2024, 12, 28),
    },
    'Fase Semai': {
      'start': DateTime(2024, 12, 10),
      'end': DateTime(2024, 12, 20),
    },
    // Tambahkan data lainnya sesuai kebutuhan
  };

  @override
  void initState() {
    super.initState();
    selectedJenisData = jenisDataList[0];
    _updateDateRange();
  }

  // Fungsi untuk update range tanggal berdasarkan jenis data yang dipilih
  void _updateDateRange() {
    if (selectedJenisData != null && jadwalData.containsKey(selectedJenisData)) {
      setState(() {
        _rangeStart = jadwalData[selectedJenisData]!['start'];
        _rangeEnd = jadwalData[selectedJenisData]!['end'];
      });
    }
  }

  // Fungsi untuk mengecek apakah tanggal yang dipilih adalah tanggal awal atau akhir
  bool isMarkedDate(DateTime date) {
    return (_rangeStart != null && isSameDay(date, _rangeStart)) ||
        (_rangeEnd != null && isSameDay(date, _rangeEnd));
  }

  // Fungsi untuk mengecek apakah tanggal berada dalam range
  bool isWithinRange(DateTime date) {
    if (_rangeStart == null || _rangeEnd == null) return false;
    return (date.isAfter(_rangeStart!) && date.isBefore(_rangeEnd!)) ||
        isSameDay(date, _rangeStart!) ||
        isSameDay(date, _rangeEnd!);
  }

  Future<void> fetchJadwalFromDatabase() async {
    // Implementasi pengambilan data dari database
    // Contoh dengan API:
    // final response = await http.get(Uri.parse('your_api_endpoint'));
    // final data = json.decode(response.body);
    // setState(() {
    //   jadwalData = data;
    //   _updateDateRange();
    // });
  }

  void _validateInputs() {
    setState(() {
      _greenhouseError = selectedGreenhouse == null ? 'Greenhouse harus dipilih' : '';
      _jenisDataError = selectedJenisData == null ? 'Jenis data harus dipilih' : '';
      _tanggalAwalError = _rangeStart == null ? 'Tanggal awal harus dipilih' : '';
      _tanggalAkhirError = _rangeEnd == null ? 'Tanggal akhir harus dipilih' : '';
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

              // Greenhouse Dropdown
              CustomDropdown(
                labelText: 'Greenhouse',
                hintText: 'Pilih Greenhouse',
                value: selectedGreenhouse ?? greenhouseList[0],
                items: greenhouseList,
                errorText: _greenhouseError.isNotEmpty ? _greenhouseError : null,
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
                        color: (_tanggalAwalError.isNotEmpty || _tanggalAkhirError.isNotEmpty) 
                          ? Colors.red 
                          : Colors.grey
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2024, 1, 1),
                      lastDay: DateTime.utc(2024, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: CalendarFormat.month,
                      selectedDayPredicate: (day) => isMarkedDate(day),
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      rangeSelectionMode: RangeSelectionMode.enforced,
                      onDaySelected: null, // Hapus onDaySelected karena tidak perlu manual selection
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
                        withinRangeTextStyle: const TextStyle(color: Colors.black),
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
}
