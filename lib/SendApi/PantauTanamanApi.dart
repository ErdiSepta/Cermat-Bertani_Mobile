import 'dart:convert';
import 'package:apps/SendApi/Server.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:http/http.dart' as http;

class PantauTanamanApi {
  static Future<Map<String, dynamic>?> tambahPantauTanaman(
      String tinggi_tanaman,
      String jml_daun_tanaman,
      String berat_buah_tanaman,
      String id) async {
    final response = await http.post(
      Server.urlLaravel("pantau-tanaman/tambah"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": Login.token
      },
      body: json.encode({
        "tinggi_tanaman": tinggi_tanaman,
        "jml_daun_tanaman": jml_daun_tanaman,
        "berat_buah_tanaman": berat_buah_tanaman,
        "id_gh": id,
        "email": Login.email,
      }),
    );
    print(
      json.encode({
        "tinggi_tanaman": tinggi_tanaman,
        "jml_daun_tanaman": jml_daun_tanaman,
        "berat_buah_tanaman": berat_buah_tanaman,
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
