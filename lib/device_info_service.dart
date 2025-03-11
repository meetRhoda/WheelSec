import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class DeviceInfoService {
  static const String _deviceIdKey = 'device_id_key';
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<String> getDeviceId() async {
    // First try to get saved device ID
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);

    // If no saved device ID, generate one
    if (deviceId == null) {
      deviceId = await _generateDeviceId();
      // Save the generated ID
      await prefs.setString(_deviceIdKey, deviceId);
    }

    return deviceId;
  }

  Future<String> _generateDeviceId() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      // Combine multiple identifiers for uniqueness
      return 'android_${androidInfo.id}_${androidInfo.serialNumber ?? ''}_${androidInfo.fingerprint}';
    }

    if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      // Use identifierForVendor as it's the most reliable on iOS
      return 'ios_${iosInfo.identifierForVendor ?? ''}_${iosInfo.name}_${iosInfo.model}';
    }

    // Fallback for other platforms
    throw UnsupportedError('Unsupported platform for device ID generation');
  }
}