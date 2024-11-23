import 'dart:convert';
import 'package:apps/SendApi/Server.dart';
import 'package:apps/SendApi/tokenJWT.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:http/http.dart' as http;

class HomeApi {
  static Future<Map<String, dynamic>?> showChartHome(String jenisData,
      String tanggalAwal, String tanggalAkhir, String id) async {
    String? token = await TokenJwt.getToken();
    String? email = await TokenJwt.getEmail();
    final response = await http.post(
      Server.urlLaravel("dashboard"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token.toString()
      },
      body: json.encode({
        "jenis_data": jenisData,
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
