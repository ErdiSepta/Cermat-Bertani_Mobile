import 'dart:convert';
import 'package:apps/SendApi/Server.dart';
import 'package:apps/menu/UserPages/loginPages.dart';
import 'package:http/http.dart' as http;

class UserApi {
  static Future<Map<String, dynamic>?> GantiPasswordProfil(
      String password_old, String password, String password_confirm) async {
    final response = await http.put(
      Server.urlLaravel("users/profile/profile/password"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": Login.token
      },
      body: json.encode({
        "password_old": password_old,
        "password": password,
        "password_confirm": password_confirm,
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

  static Future<Map<String, dynamic>?> getProfil(String email) async {
    final response = await http.post(
      Server.urlLaravel("users/profile"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "${Login.token}"
      },
      body: json.encode({
        "email": email,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 400) {
      final result = json.decode(response.body);
      return result;
    } else {
      return null;
    }
  }

  static Future<String?> checkEmailAvailability(String email) async {
    try {
      final response = await http.post(
        Server.urlLaravel("users/check-email"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['status'];
        } else {
          return data['message'];
        }
      } else {
        final data = jsonDecode(response.body);
        return data['message'];
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<Map<String, dynamic>?> ForgotPassword(
      String email, String password) async {
    try {
      final response = await http.post(
        Server.urlLaravel("verify/password"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data;
        } else {
          return data;
        }
      } else {
        final data = jsonDecode(response.body);
        return data;
      }
    } catch (e) {
      print('Errorr: $e');
    }
  }

  static Future<Map<String, dynamic>?> register(
      String nik,
      String namaLengkap,
      String jenisKelamin,
      String noTelpon,
      String alamat,
      String email,
      String password,
      String passwordConfirm) async {
    final response = await http.post(
      Server.urlLaravel("users/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "nik": nik,
        "nama_lengkap": namaLengkap,
        "jenis_kelamin": jenisKelamin,
        "no_telpon": noTelpon,
        "alamat": alamat,
        "email": email,
        "password": password,
        "password_confirm": passwordConfirm,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 400) {
      final result = json.decode(response.body);
      return result;
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    final response = await http.post(
      Server.urlLaravel("users/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final jwtToken = result['data']; // ini token e
      Login.token = result['data'].toString();

      final decodedPayload = _parseJwt(jwtToken);
      return decodedPayload;
    } else if (response.statusCode == 400) {
      final result = json.decode(response.body);
      return result;
    } else {
      return null;
    }
  }

  // Fungsi untuk mendekode JWT
  static Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Token tidak valid');
    }

    final payload = _decodeBase64(parts[1]);
    return json.decode(payload);
  }

  static String _decodeBase64(String str) {
    String normalized = base64Url.normalize(str);
    return utf8.decode(base64Url.decode(normalized));
  }
}
