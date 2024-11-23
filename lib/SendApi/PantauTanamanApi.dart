import 'dart:convert';
import 'package:apps/SendApi/Server.dart';
import 'package:apps/SendApi/tokenJWT.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:http/http.dart' as http;

class PantauTanamanApi {
  static Future<Map<String, dynamic>?> tambahPantauTanaman(String tinggiTanaman,
      String jmlDaunTanaman, String beratBuahTanaman, String id) async {
    String? token = await TokenJwt.getToken();
    String? email = await TokenJwt.getEmail();
    final response = await http.post(
      Server.urlLaravel("pantau-tanaman/tambah"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token.toString()
      },
      body: json.encode({
        "tinggi_tanaman": tinggiTanaman,
        "jml_daun_tanaman": jmlDaunTanaman,
        "berat_buah_tanaman": beratBuahTanaman,
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
