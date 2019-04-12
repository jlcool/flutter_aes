import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class FlutterAes {
  static const MethodChannel _channel = const MethodChannel('flutter_aes');

  static Future<Uint8List> decrypt(
      Uint8List data, Uint8List key, String iv) async {
    final Uint8List result = await _channel
        .invokeMethod('decrypt', {"data": data, "key": key, "iv": iv});
    return result;
  }
  static Future<String> decryptString(
      String data, String key, String iv) async {
    final String result = await _channel
        .invokeMethod('decryptString', {"dataString": data, "keyString": key, "iv": iv});
    return result;
  }
  static Future<Uint8List> encrypt(
      Uint8List data, Uint8List key, String iv) async {
    final Uint8List result = await _channel
        .invokeMethod('encrypt', {"data": data, "key": key, "iv": iv});
    return result;
  }
}
