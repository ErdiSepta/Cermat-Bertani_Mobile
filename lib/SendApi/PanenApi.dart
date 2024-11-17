import 'dart:convert';
import 'package:apps/SendApi/Server.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:http/http.dart' as http;

class PanenApi {
  static Future<Map<String, dynamic>?> tambahIsiPanen(
      String jumlah_buah,
      String berat_buah,
      String ukuran_buah,
      String rasa_buah,
      String tanggal,
      String biaya_operasional,
      String pendapatan_penjualan,
      String id) async {
    final response = await http.post(
      Server.urlLaravel("panen/tambah"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": Login.token
      },
      body: json.encode({
        "jumlah_buah": jumlah_buah,
        "berat_buah": berat_buah,
        "ukuran_buah": ukuran_buah,
        "rasa_buah": rasa_buah,
        "tanggal": tanggal,
        "biaya_operasional": biaya_operasional,
        "pendapatan_penjualan": pendapatan_penjualan,
        "id_gh": id,
        "email": Login.email,
      }),
    );
    print(
      json.encode({
        "jumlah_buah": jumlah_buah,
        "berat_buah": berat_buah,
        "ukuran_buah": ukuran_buah,
        "rasa_buah": rasa_buah,
        "tanggal": tanggal,
        "biaya_operasional": biaya_operasional,
        "id_gh": id,
        "email": Login.email,
      }),
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);

      return result;
    } else if (response.statusCode == 400) {
      final result = json.decode(response.body);
      return result;
    } else {
      print(response.body);
      return null;
    }
  }

  static Future<Map<String, dynamic>?> showRekapPanen(
      String tanggal_awal, String tanggal_akhir, String id) async {
    final response = await http.post(
      Server.urlLaravel("panen/showRekap"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": Login.token
      },
      body: json.encode({
        "tanggal_awal": tanggal_awal,
        "tanggal_akhir": tanggal_akhir,
        "id_gh": id,
        "email": Login.email,
      }),
    );
    print(
      json.encode({
        "tanggal_awal": tanggal_awal,
        "tanggal_akhir": tanggal_akhir,
        "id_gh": id,
        "email": Login.email,
      }),
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);

      return result;
    } else if (response.statusCode == 400) {
      final result = json.decode(response.body);
      return result;
    } else {
      print(response.body);
      return null;
    }
  }
}
