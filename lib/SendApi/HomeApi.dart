import 'dart:convert';
import 'package:apps/SendApi/Server.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:http/http.dart' as http;

class HomeApi {
  static Future<Map<String, dynamic>?> showChartHome(String jenis_data,
      String tanggal_awal, String tanggal_akhir, String id) async {
    final response = await http.post(
      Server.urlLaravel("dashboard"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": Login.token
      },
      body: json.encode({
        "jenis_data": jenis_data,
        "tanggal_awal": tanggal_awal,
        "tanggal_akhir": tanggal_akhir,
        "id_gh": id,
        "email": Login.email,
      }),
    );
    print(
      json.encode({
        "jenis_data": jenis_data,
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
