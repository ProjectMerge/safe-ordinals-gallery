import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

class SecureStorage {
  static Future<String?> read({required String key}) async {
    try {
      if (Platform.isMacOS) {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString(key);
      } else {
        const FlutterSecureStorage mstorage = FlutterSecureStorage();
        const optionsApple = IOSOptions(accessibility: KeychainAccessibility.first_unlock);
        const macOptions = MacOsOptions(groupId: "D2VD7YVAQ5", accessibility: KeychainAccessibility.first_unlock);
        const optionsAndroid = AndroidOptions(encryptedSharedPreferences: true);
        const webOptions = WebOptions(dbName: "CNliCGCAgu", publicKey: "6i81ge6Fc3bqgxbtc1Wl");
        return mstorage.read(key: key, iOptions: optionsApple, aOptions: optionsAndroid, webOptions: webOptions, mOptions: macOptions);
      }
    } catch (e) {
      return Future.value(null);
    }
  }

  static Future<void> write({required String key, required String value}) async {
    try {
      if (Platform.isMacOS) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(key, value);
      } else {
        const FlutterSecureStorage mstorage = FlutterSecureStorage();
        const optionsApple = IOSOptions(accessibility: KeychainAccessibility.first_unlock);
        const optionsAndroid = AndroidOptions(encryptedSharedPreferences: true);
        const macOptions = MacOsOptions(groupId: "D2VD7YVAQ5", accessibility: KeychainAccessibility.first_unlock);
        const webOptions = WebOptions(dbName: "CNliCGCAgu", publicKey: "6i81ge6Fc3bqgxbtc1Wl");
        return mstorage.write(key: key, value: value, iOptions: optionsApple, aOptions: optionsAndroid, webOptions: webOptions, mOptions: macOptions);
      }
    } catch (e) {
      return Future.value(null);
    }
  }

  static Future<void> deleteStorage({required String key}) async {
    try {
      if (Platform.isMacOS) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(key);
      } else {
        const FlutterSecureStorage mstorage = FlutterSecureStorage();
        const optionsApple = IOSOptions(accessibility: KeychainAccessibility.first_unlock);
        const optionsAndroid = AndroidOptions(encryptedSharedPreferences: true);
        const webOptions = WebOptions(dbName: "CNliCGCAgu", publicKey: "6i81ge6Fc3bqgxbtc1Wl");
        const macOptions = MacOsOptions(groupId: "D2VD7YVAQ5", accessibility: KeychainAccessibility.first_unlock);
        return mstorage.delete(key: key, iOptions: optionsApple, aOptions: optionsAndroid, webOptions: webOptions, mOptions: macOptions);
      }
    } catch (e) {
      return Future.value(null);
    }
  }

  static Future<void> deleteAllStorage() async {
    try {
      if (Platform.isMacOS) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
      } else {
        const FlutterSecureStorage mstorage = FlutterSecureStorage();
        const optionsApple = IOSOptions(accessibility: KeychainAccessibility.first_unlock);
        const optionsAndroid = AndroidOptions(encryptedSharedPreferences: true);
        const webOptions = WebOptions(dbName: "CNliCGCAgu", publicKey: "6i81ge6Fc3bqgxbtc1Wl");
        const macOptions = MacOsOptions(groupId: "D2VD7YVAQ5", accessibility: KeychainAccessibility.first_unlock);
        return mstorage.deleteAll(iOptions: optionsApple, aOptions: optionsAndroid, webOptions: webOptions, mOptions: macOptions);
      }
    } catch (e) {
      return Future.value(null);
    }
  }
}
