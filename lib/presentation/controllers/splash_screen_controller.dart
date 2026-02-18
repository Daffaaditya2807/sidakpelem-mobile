import 'package:get/get.dart';
import 'package:sidak_desa_mobile/data/shared/auth_storage.dart';
import 'package:sidak_desa_mobile/presentation/views/login_screen.dart';
import 'package:sidak_desa_mobile/presentation/views/main_screen.dart';

class SplashScreenController extends GetxController {
  final AuthStorage _authStorage = AuthStorage();

  @override
  void onInit() {
    super.onInit();
    _checkAuthSession();
  }

  Future<void> _checkAuthSession() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final isLoggedIn = await _authStorage.isLoggedIn();
      final user = await _authStorage.getUser();

      if (isLoggedIn && user != null) {
        Get.offAll(() => const MainScreen());
        return;
      }
    } catch (_) {
      // Fallback to login when local session data cannot be read.
    }

    Get.offAll(() => LoginScreen());
  }
}
