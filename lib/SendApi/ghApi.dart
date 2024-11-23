import 'dart:convert';
import 'package:apps/SendApi/Server.dart';
import 'package:apps/SendApi/tokenJWT.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:http/http.dart' as http;

class ghApi {
  static Future<Map<String, dynamic>?> getDataGh() async {
    String? email = await TokenJwt.getEmail();
    String? token = await TokenJwt.getToken();
    final response = await http.post(
      Server.urlLaravel("green-house"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token.toString()
      },
      body: json.encode({
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

  static Future<Map<String, dynamic>?> getDataGhNama() async {
    String? email = await TokenJwt.getEmail();
    String? token = await TokenJwt.getToken();
    final response = await http.post(
      Server.urlLaravel("green-house/nama"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token.toString()
      },
      body: json.encode({
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

  static Future<Map<String, dynamic>?> deleteDataGh(String idGh) async {
    String? token = await TokenJwt.getToken();
    String? email = await TokenJwt.getEmail();
    final response = await http.delete(
      Server.urlLaravel("green-house/hapus"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token.toString()
      },
      body: json.encode({"id_gh": idGh, "email": email.toString()}),
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result;
    } else if (response.statusCode == 400) {
      final result = json.decode(response.body);
      return result;
    } else {
      print("errorrrrr : ${response.body}");
      return null;
    }
  }
}
