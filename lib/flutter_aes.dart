import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class FlutterAes {
  static const MethodChannel _channel = const MethodChannel('flutter_aes');
///解密
  static Future<Uint8List> decrypt(
      Uint8List data, Uint8List key, Uint8List iv) async {
    final Uint8List result = await _channel
        .invokeMethod('decrypt', {"data": data, "key": key, "iv": iv});
    return result;
  }
///加密
  static Future<Uint8List> encrypt(
      Uint8List data, Uint8List key, Uint8List iv) async {
    final Uint8List result = await _channel
        .invokeMethod('encrypt', {"data": data, "key": key, "iv": iv});
    return result;
  }
}
