import 'dart:convert';
import 'package:apps/SendApi/Server.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:http/http.dart' as http;

class HamaAndPenyakitApi {
  static Future<Map<String, dynamic>?> tambahHamaAndPenyakit(
      String warna_daun,
      String warna_batang,
      String serangan_hama,
      String cara_penanganan,
      String jml_pestisida,
      String id) async {
    final response = await http.post(
      Server.urlLaravel("hama-penyakit/tambah"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": Login.token
      },
      body: json.encode({
        "warna_daun": warna_daun,
        "warna_batang": warna_batang,
        "serangan_hama": serangan_hama,
        "cara_penanganan": cara_penanganan,
        "jml_pestisida": jml_pestisida,
        "id_gh": id,
        "email": Login.email,
      }),
    );
    print(
      json.encode({
        "warna_daun": warna_daun,
        "warna_batang": warna_batang,
        "serangan_hama": serangan_hama,
        "cara_penanganan": cara_penanganan,
        "jml_pestisida": jml_pestisida,
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
