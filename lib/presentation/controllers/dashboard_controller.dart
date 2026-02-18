import 'package:get/get.dart';

import '../../data/fetch/attedance_api.dart';
import '../../data/model/user_model.dart';
import '../../data/shared/auth_storage.dart';

class DashboardController extends GetxController {
  final _api = AttedanceApi();
  final _storage = AuthStorage();

  final user = Rxn<UserModel>();
  final datangInfo = '- WIB'.obs;
  final pulangInfo = '- WIB'.obs;
  final isLoadingDaily = false.obs;

  final selectedDate = ''.obs; // YYYY-MM-DD
  final daily = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    selectedDate.value = _todayDate();
    await loadUser();
    await fetchDaily();
  }

  Future<void> loadUser() async {
    user.value = await _storage.getUser();
  }

  Future<void> logout() async {
    await _storage.logout();
  }

  Future<void> fetchDaily() async {
    final uid = user.value?.id;
    if (uid == null) return;

    isLoadingDaily.value = true;
    try {
      final res = await _api.getDailyAttendance(
        userId: uid,
        date: selectedDate.value,
      );

      final data = res['data'];
      if (data is Map<String, dynamic>) {
        daily.value = data;
        datangInfo.value = _formatTime(data['check_in']) == '-'
            ? '- WIB'
            : '${_formatTime(data['check_in'])} WIB Tepat Waktu';
        pulangInfo.value = _formatTime(data['check_out']) == '-'
            ? '- WIB'
            : '${_formatTime(data['check_out'])} WIB';
      } else {
        daily.value = null;
        datangInfo.value = '- WIB';
        pulangInfo.value = '- WIB';
      }
    } catch (_) {
      daily.value = null;
      datangInfo.value = '- WIB';
      pulangInfo.value = '- WIB';
    } finally {
      isLoadingDaily.value = false;
    }
  }

  void setAttendanceInfo({
    String? datang,
    String? pulang,
  }) {
    if (datang != null) {
      datangInfo.value = datang;
    }
    if (pulang != null) {
      pulangInfo.value = pulang;
    }
  }

  String _todayDate() {
    final now = DateTime.now();
    final yyyy = now.year.toString().padLeft(4, '0');
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    return '$yyyy-$mm-$dd';
  }

  String _formatTime(dynamic value) {
    if (value == null) return '-';
    final s = value.toString().trim();
    if (s.isEmpty || s == 'null') return '-';

    if (s.contains('T')) {
      try {
        final dt = DateTime.parse(s).toLocal();
        final hh = dt.hour.toString().padLeft(2, '0');
        final mm = dt.minute.toString().padLeft(2, '0');
        return '$hh:$mm';
      } catch (_) {}
    }

    final parts = s.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }

    return s;
  }
}
