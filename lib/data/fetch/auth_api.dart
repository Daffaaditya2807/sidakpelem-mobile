import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/api/api.dart';
import '../model/user_model.dart';

class AuthApi {
  // Pastikan device kamu bisa akses IP ini (1 jaringan)

  Future<UserModel> login({
    required String email,
    required String password,
    required String deviceId,
  }) async {
    final uri = Uri.parse('${Api.baseUrl}/mobile/login');

    final res = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'device_id': deviceId,
      }),
    );

    final Map<String, dynamic> data =
        jsonDecode(res.body) as Map<String, dynamic>;

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final usersJson = data['users'];
      if (usersJson is! Map<String, dynamic>) {
        throw Exception('Format response "users" tidak sesuai');
      }
      return UserModel.fromJson(usersJson);
    }

    // Kalau server kirim message error
    final msg = (data['message'] ?? 'Login gagal').toString();
    throw Exception(msg);
  }
}
