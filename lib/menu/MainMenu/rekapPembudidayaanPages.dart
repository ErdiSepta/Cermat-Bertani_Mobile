import 'package:flutter/material.dart';
import 'package:apps/src/customDropdown.dart';
import 'package:apps/src/topnav.dart';
import 'package:table_calendar/table_calendar.dart';

class RekapPembudidayaanPages extends StatefulWidget {
  const RekapPembudidayaanPages({super.key});

  @override
  State<RekapPembudidayaanPages> createState() => _RekapPembudidayaanPagesState();
}

class _RekapPembudidayaanPagesState extends State<RekapPembudidayaanPages> {
  String? selectedGreenhouse;
  String? selectedJenisData;
  DateTime? startDate;
  DateTime? endDate;
  DateTime _focusedDay = DateTime.now();

  final List<String> greenhouseList = ['GH-01', 'GH-02', 'GH-03'];
  final List<String> jenisDataList = [
    'Nutrisi',
    'Air',
    'Pupuk',
    'Media Tanam',
  ];

  // Fungsi untuk mengecek apakah tanggal yang dipilih adalah tanggal awal atau akhir
  bool isMarkedDate(DateTime date) {
    return (startDate != null && isSameDay(date, startDate)) || 
           (endDate != null && isSameDay(date, endDate));
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

              // Calendar
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2024, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.month,
                  selectedDayPredicate: (day) => isMarkedDate(day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      if (startDate == null || endDate != null) {
                        startDate = selectedDay;
                        endDate = null;
                      } else {
                        endDate = selectedDay;
                      }
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: const CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tampilkan tanggal yang dipilih
              if (startDate != null)
                Text(
                  'Tanggal Awal: ${startDate!.day}/${startDate!.month}/${startDate!.year}',
                  style: const TextStyle(fontSize: 16),
                ),
              if (endDate != null)
                Text(
                  'Tanggal Akhir: ${endDate!.day}/${endDate!.month}/${endDate!.year}',
                  style: const TextStyle(fontSize: 16),
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
}
