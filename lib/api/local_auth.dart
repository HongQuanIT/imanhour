import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      // print('hasBiometrics: false');
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return <BiometricType>[];
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      // print('ok');
      final isDeviceSupported = await _auth.isDeviceSupported();
      if (kDebugMode) {
        print(isDeviceSupported);
      }
      // ignore: deprecated_member_use
      return await _auth.authenticate(
          localizedReason: 'Let OS determine authentication method',
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      print('hihi');
      print(e);
      return false;
    }
  }
}
