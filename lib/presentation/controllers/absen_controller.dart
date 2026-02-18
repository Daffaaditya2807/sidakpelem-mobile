import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../data/fetch/attedance_api.dart';
import '../../data/model/user_model.dart';
import '../../data/shared/auth_storage.dart';
import '../../utils/device_id.dart';
import '../views/main_screen.dart';

class AbsenController extends GetxController {
  AbsenController({required Map<String, dynamic> qrData}) {
    this.qrData.value = qrData;
  }

  final _api = AttedanceApi();
  final _storage = AuthStorage();

  final user = Rxn<UserModel>();
  final qrData = <String, dynamic>{}.obs;
  final nameController = TextEditingController();

  final isSubmitting = false.obs;
  final isLoadingDaily = false.obs;
  final isLoadingLocation = false.obs;
  final latitude = RxnDouble();
  final longitude = RxnDouble();
  final locationError = RxnString();

  // absensi hari ini
  final selectedDate = ''.obs; // "YYYY-MM-DD"
  final daily =
      Rxn<Map<String, dynamic>>(); // data absensi (bisa null kalau belum absen)

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  Future<void> _init() async {
    selectedDate.value = _todayDate();
    await loadUser();
    await fetchDaily();
    await getCurrentLocation();
  }

  Future<void> loadUser() async {
    user.value = await _storage.getUser();
    nameController.text = user.value?.name ?? '';
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  String get checkInText => _formatTime(daily.value?['check_in']);
  String get checkOutText => _formatTime(daily.value?['check_out']);

  Future<void> fetchDaily() async {
    final uid = user.value?.id;
    if (uid == null) return;

    isLoadingDaily.value = true;
    try {
      final res = await _api.getDailyAttendance(
        userId: uid,
        date: selectedDate.value,
      );

      // API kamu sebelumnya: { ok: true, data: {...} } atau data:null
      final data = res['data'];
      if (data is Map<String, dynamic>) {
        daily.value = data;
      } else {
        daily.value = null;
      }
    } catch (e) {
      // kalau mau, tampilkan snackbar
      // Get.snackbar('Info', e.toString(), snackPosition: SnackPosition.BOTTOM);
      daily.value = null;
    } finally {
      isLoadingDaily.value = false;
    }
  }

  Future<void> submitAbsen() async {
    if (isSubmitting.value) return;

    // token dari QR
    final token = (qrData['raw'] ?? '').toString().trim();
    if (token.isEmpty) {
      Get.snackbar(
        'Gagal',
        'Token QR tidak valid',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // user_id dari storage
    final uid = user.value?.id;
    if (uid == null) {
      Get.snackbar(
        'Gagal',
        'User belum login / data user tidak ditemukan',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSubmitting.value = true;
    try {
      final deviceId = await DeviceIdUtil.getDeviceId();
      await _api.verifyAttendance(
        token: token,
        userId: uid,
        deviceInfo: deviceId,
        latitude: latitude.value,
        longitude: longitude.value,
      );

      Get.offAll(const MainScreen());
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar('Gagal', msg, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> getCurrentLocation() async {
    isLoadingLocation.value = true;
    locationError.value = null;

    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        locationError.value = 'Layanan lokasi tidak aktif';
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        locationError.value = 'Izin lokasi ditolak';
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;
    } catch (_) {
      locationError.value = 'Gagal mengambil lokasi terkini';
    } finally {
      isLoadingLocation.value = false;
    }
  }

  String _todayDate() {
    final now = DateTime.now();
    final yyyy = now.year.toString().padLeft(4, '0');
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    return '$yyyy-$mm-$dd';
  }

  /// Support time string "08:01:22" atau ISO "2026-02-15T08:01:22Z"
  String _formatTime(dynamic value) {
    if (value == null) return '-';
    final s = value.toString().trim();
    if (s.isEmpty || s == 'null') return '-';

    // ISO?
    if (s.contains('T')) {
      try {
        final dt = DateTime.parse(s).toLocal();
        final hh = dt.hour.toString().padLeft(2, '0');
        final mm = dt.minute.toString().padLeft(2, '0');
        return '$hh:$mm';
      } catch (_) {}
    }

    // "HH:mm:ss" atau "HH:mm"
    final parts = s.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }

    return s;
  }
}
