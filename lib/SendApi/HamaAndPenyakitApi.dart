import 'dart:convert';
import 'package:apps/SendApi/Server.dart';
import 'package:apps/SendApi/tokenJWT.dart';
import 'package:http/http.dart' as http;

class HamaAndPenyakitApi {
  static Future<Map<String, dynamic>?> showRekapHamaPenyakit(
      String tanggalAwal, String tanggalAkhir, String id) async {
    String? token = await TokenJwt.getToken();
    String? email = await TokenJwt.getEmail();
    final response = await http.post(
      Server.urlLaravel("hama-penyakit"),
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

  static Future<Map<String, dynamic>?> tambahHamaAndPenyakit(
      String warnaDaun,
      String warnaBatang,
      String seranganHama,
      String caraPenanganan,
      String jmlPestisida,
      String id) async {
    String? token = await TokenJwt.getToken();
    String? email = await TokenJwt.getEmail();
    final response = await http.post(
      Server.urlLaravel("hama-penyakit/tambah"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token.toString()
      },
      body: json.encode({
        "warna_daun": warnaDaun,
        "warna_batang": warnaBatang,
        "serangan_hama": seranganHama,
        "cara_penanganan": caraPenanganan,
        "jml_pestisida": jmlPestisida,
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
