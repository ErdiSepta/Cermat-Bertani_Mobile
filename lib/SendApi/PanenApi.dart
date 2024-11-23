import 'dart:convert';
import 'package:apps/SendApi/Server.dart';
import 'package:apps/SendApi/tokenJWT.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:http/http.dart' as http;

class PanenApi {
  static Future<Map<String, dynamic>?> tambahIsiPanen(
      String jumlahBuah,
      String beratBuah,
      String ukuranBuah,
      String rasaBuah,
      String tanggal,
      String biayaOperasional,
      String pendapatanPenjualan,
      String id) async {
    String? token = await TokenJwt.getToken();
    String? email = await TokenJwt.getEmail();
    final response = await http.post(
      Server.urlLaravel("panen/tambah"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token.toString()
      },
      body: json.encode({
        "jumlah_buah": jumlahBuah,
        "berat_buah": beratBuah,
        "ukuran_buah": ukuranBuah,
        "rasa_buah": rasaBuah,
        "tanggal": tanggal,
        "biaya_operasional": biayaOperasional,
        "pendapatan_penjualan": pendapatanPenjualan,
        "id_gh": id,
        "email": email.toString(),
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
      String tanggalAwal, String tanggalAkhir, String id) async {
    String? token = await TokenJwt.getToken();
    String? email = await TokenJwt.getEmail();
    final response = await http.post(
      Server.urlLaravel("panen/showRekap"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token.toString()
      },
      body: json.encode({
        "tanggal_awal": tanggalAwal,
        "tanggal_akhir": tanggalAkhir,
        "id_gh": id,
        "email": email.toString(),
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
