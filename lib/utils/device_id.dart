import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceIdUtil {
  static Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      // android.id biasanya cukup untuk kebutuhan "device_id"
      return android.id;
    }

    if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      return ios.identifierForVendor ?? 'unknown-ios';
    }

    return 'unknown-device';
  }
}
