import 'package:sidak_desa_mobile/core/api/api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AttedanceApi {
  Future<Map<String, dynamic>> verifyAttendance({
    required String token,
    required int userId,
    String? deviceInfo,
    double? latitude,
    double? longitude,
  }) async {
    final uri = Uri.parse('${Api.baseUrl}/attendance/verify');

    final res = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'token': token,
        'user_id': userId,
        'device_info': deviceInfo, // boleh null
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (data is Map<String, dynamic>) return data;
      return {'data': data};
    }

    // Laravel biasanya kasih message + errors
    if (data is Map<String, dynamic>) {
      final msg = (data['message'] ?? 'Verifikasi absen gagal').toString();
      throw Exception(msg);
    }

    throw Exception('Verifikasi absen gagal');
  }

  /// GET /attendance/daily?user_id=1&date=2026-02-15
  Future<Map<String, dynamic>> getDailyAttendance({
    required int userId,
    required String date, // format: YYYY-MM-DD
  }) async {
    final uri = Uri.parse(
      '${Api.baseUrl}/attendance/daily',
    ).replace(queryParameters: {'user_id': userId.toString(), 'date': date});

    final res = await http.get(uri, headers: {'Accept': 'application/json'});

    final data = jsonDecode(res.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (data is Map<String, dynamic>) return data;
      return {'data': data};
    }

    if (data is Map<String, dynamic>) {
      final msg = (data['message'] ?? 'Gagal mengambil absensi harian')
          .toString();
      throw Exception(msg);
    }

    throw Exception('Gagal mengambil absensi harian');
  }
}
