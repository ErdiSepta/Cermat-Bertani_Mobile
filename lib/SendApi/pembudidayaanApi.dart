import 'dart:convert';
import 'package:apps/SendApi/tokenJWT.dart';
import 'package:apps/SendApi/Server.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:http/http.dart' as http;

class PembudidayaanApi {
  static Future<Map<String, dynamic>?> deleteRekap(String id) async {
    String? token = await TokenJwt.getToken();
    String? email = await TokenJwt.getEmail();
    final response = await http.delete(
      Server.urlLaravel("pembudidayaan/hapus"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token.toString()
      },
      body: json.encode({
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

  static Future<Map<String, dynamic>?> showRekap(
      String jenisData, String id) async {
    String? token = await TokenJwt.getToken();
    String? email = await TokenJwt.getEmail();
    final response = await http.post(
      Server.urlLaravel("pembudidayaan/ShowRekap"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token.toString()
      },
      body: json.encode({
        "jenis_data": jenisData,
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

  static Future<Map<String, dynamic>?> tambahPembudidayaan(
      String tglAwalPerendaman,
      String tglAkhirPerendaman,
      String tglAwalSemai,
      String tglAkhirSemai,
      String tglMasukVegetatif,
      String tglMasukGeneratif,
      String tglAwalPenyiraman,
      String tglAkhirPenyiraman,
      String id) async {
    String? token = await TokenJwt.getToken();
    String? email = await TokenJwt.getEmail();
    final response = await http.post(
      Server.urlLaravel("pembudidayaan/tambah"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token.toString()
      },
      body: json.encode({
        "tgl_awal_perendaman": tglAwalPerendaman,
        "tgl_akhir_perendaman": tglAkhirPerendaman,
        "tgl_awal_semai": tglAwalSemai,
        "tgl_akhir_semai": tglAkhirSemai,
        "tgl_masuk_vegetatif": tglMasukVegetatif,
        "tgl_masuk_generatif": tglMasukGeneratif,
        "tgl_awal_penyiraman": tglAwalPenyiraman,
        "tgl_akhir_penyiraman": tglAkhirPenyiraman,
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
