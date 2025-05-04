import 'package:device_info_plus/device_info_plus.dart';

Future<bool> isTv() async {
  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    bool isTv = androidInfo.systemFeatures.contains(
      'android.software.leanback',
    );
    return isTv;
  } catch (e) {
    return false;
  }
}
