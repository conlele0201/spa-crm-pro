import 'dart:convert';
import 'dart:html' as html;
import 'package:crypto/crypto.dart';

class DeviceFingerprint {
  static String? _cachedHash;

  /// Tạo fingerprint duy nhất cho thiết bị Web
  static String generate() {
    if (_cachedHash != null) return _cachedHash!;

    final userAgent = html.window.navigator.userAgent;
    final platform = html.window.navigator.platform;
    final width = html.window.screen?.width.toString() ?? "";
    final height = html.window.screen?.height.toString() ?? "";
    final timezone = DateTime.now().timeZoneOffset.inHours.toString();

    // random id lưu vào localStorage → chống làm giả thiết bị
    final randKey = _getOrCreateRandomKey();

    final raw = "$userAgent|$platform|$width|$height|$timezone|$randKey";

    final bytes = utf8.encode(raw);
    final hash = sha256.convert(bytes).toString();

    _cachedHash = hash;
    return hash;
  }

  /// Lấy hoặc tạo random key
  static String _getOrCreateRandomKey() {
    const keyName = "device_rand_key";

    final storage = html.window.localStorage;

    if (storage.containsKey(keyName)) {
      return storage[keyName]!;
    }

    final randomKey = DateTime.now().millisecondsSinceEpoch.toString();
    storage[keyName] = randomKey;
    return randomKey;
  }
}

