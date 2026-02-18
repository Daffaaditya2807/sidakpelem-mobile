import 'package:get/get.dart';
import 'package:sidak_desa_mobile/presentation/views/main_screen.dart';

import '../../data/fetch/auth_api.dart';
import '../../data/shared/auth_storage.dart';
import '../../utils/device_id.dart';

class LoginController extends GetxController {
  final AuthApi _api = AuthApi();
  final AuthStorage _storage = AuthStorage();

  final isLoading = false.obs;
  final errorMessage = RxnString();

  Future<void> login({required String email, required String password}) async {
    errorMessage.value = null;

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Email dan password wajib diisi';
      return;
    }
    isLoading.value = true;
    try {
      // ambil device id
      final deviceId = await DeviceIdUtil.getDeviceId();
      // fetch data login apss
      final user = await _api.login(
        email: email,
        password: password,
        deviceId: deviceId,
      );

      // simpan data di shared prefences
      await _storage.saveUser(user);
      // route ke main screen
      Get.offAll(MainScreen());
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar('Login Gagal', errorMessage.value ?? 'Terjadi kesalahan');
    } finally {
      isLoading.value = false;
    }
  }
}
