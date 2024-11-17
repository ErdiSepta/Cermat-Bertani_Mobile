import 'dart:convert';
import 'package:apps/SendApi/Server.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:http/http.dart' as http;

class ghApi {
  static Future<Map<String, dynamic>?> getDataGh() async {
    final response = await http.post(
      Server.urlLaravel("green-house"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": Login.token
      },
      body: json.encode({
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

  static Future<Map<String, dynamic>?> getDataGhNama() async {
    final response = await http.post(
      Server.urlLaravel("green-house/nama"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": Login.token
      },
      body: json.encode({
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

  static Future<Map<String, dynamic>?> deleteDataGh(String id_gh) async {
    final response = await http.delete(
      Server.urlLaravel("green-house/hapus"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": Login.token
      },
      body: json.encode({"id_gh": id_gh, "email": Login.email}),
    );
    print("kode : " + json.encode({"id_gh": id_gh, "email": Login.email}));
    print("kode : " + response.statusCode.toString());
    print("body : " + response.body);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result;
    } else if (response.statusCode == 400) {
      final result = json.decode(response.body);
      return result;
    } else {
      print("errorrrrr : " + response.body.toString());
      return null;
    }
  }
}
