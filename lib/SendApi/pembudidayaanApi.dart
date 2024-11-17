import 'dart:convert';
import 'package:apps/SendApi/Server.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:http/http.dart' as http;

class PembudidayaanApi {
  static Future<Map<String, dynamic>?> tambahPembudidayaan(
      String tgl_awal_perendaman,
      String tgl_akhir_perendaman,
      String tgl_awal_semai,
      String tgl_akhir_semai,
      String tgl_masuk_vegetatif,
      String tgl_masuk_generatif,
      String tgl_awal_penyiraman,
      String tgl_akhir_penyiraman,
      String id) async {
    final response = await http.post(
      Server.urlLaravel("pembudidayaan/tambah"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": Login.token
      },
      body: json.encode({
        "tgl_awal_perendaman": tgl_awal_perendaman,
        "tgl_akhir_perendaman": tgl_akhir_perendaman,
        "tgl_awal_semai": tgl_awal_semai,
        "tgl_akhir_semai": tgl_akhir_semai,
        "tgl_masuk_vegetatif": tgl_masuk_vegetatif,
        "tgl_masuk_generatif": tgl_masuk_generatif,
        "tgl_awal_penyiraman": tgl_awal_penyiraman,
        "tgl_akhir_penyiraman": tgl_akhir_penyiraman,
        "id_gh": id,
        "email": Login.email,
      }),
    );
    print(
      json.encode({
        "tgl_awal_perendaman": tgl_awal_perendaman,
        "tgl_akhir_perendaman": tgl_akhir_perendaman,
        "tgl_awal_semai": tgl_awal_semai,
        "tgl_akhir_semai": tgl_akhir_semai,
        "tgl_masuk_vegetatif": tgl_masuk_vegetatif,
        "tgl_masuk_generatif": tgl_masuk_generatif,
        "tgl_awal_penyiraman": tgl_awal_penyiraman,
        "tgl_akhir_penyiraman": tgl_akhir_penyiraman,
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
