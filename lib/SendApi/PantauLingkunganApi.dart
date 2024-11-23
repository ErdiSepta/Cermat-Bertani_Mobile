import 'dart:convert';
import 'package:apps/SendApi/Server.dart';
import 'package:apps/SendApi/tokenJWT.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:http/http.dart' as http;

class Pantaulingkunganapi {
  static Future<Map<String, dynamic>?> tambahPantanuLingkungan(
      String ph, String ppm, String suhu, String kelembapan, String id) async {
    String? email = await TokenJwt.getEmail();
    String? token = await TokenJwt.getToken();
    final response = await http.post(
      Server.urlLaravel("pantau-lingkungan/tambah"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token.toString()
      },
      body: json.encode({
        "ph_lingkungan": ph,
        "ppm_lingkungan": ppm,
        "suhu_lingkungan": suhu,
        "kelembapan_lingkungan": kelembapan,
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
