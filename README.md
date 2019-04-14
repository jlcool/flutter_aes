[![Pub](https://img.shields.io/pub/v/flutter_aes.svg?style=flat-square)](https://pub.dartlang.org/packages/flutter_aes)
# flutter_aes

一个原生实现的aes加密解密方法，本来原生可以实现，但是数据量大的时候就卡住了

dart的base64和utf8方法不比原生的慢，所以只有加密解密并返回Uint8List
### Example

```dart
import 'package:flutter_aes/flutter_aes.dart';

String _key = "f379e0b661ae4650b19169e4d93665dc";
String _iv = "0000000000000000";
Stopwatch stopwatch = Stopwatch()..start();

var result = base64.encode(await FlutterAes.encrypt(utf8.encode("123"), utf8.encode(_key), utf8.encode(_iv)));
print("encrypt 用时：${stopwatch.elapsed} result:$result");
result = utf8.decode(await FlutterAes.decrypt(
base64.decode(result), utf8.encode(_key), utf8.encode(_iv)));
print("decrypt 用时：${stopwatch.elapsed} result:$result");
```