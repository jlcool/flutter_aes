import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_aes/flutter_aes.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    try {
      String _key = "f379e0b661ae4650b19169e4d93665dc";
      String _iv = "0000000000000000";
      Stopwatch stopwatch = Stopwatch()..start();

      var result = base64.encode(await FlutterAes.encrypt(utf8.encode("123"), utf8.encode(_key), _iv));
      print("encrypt 用时：${stopwatch.elapsed} result:$result");
        result = utf8.decode(await FlutterAes.decrypt(
          base64.decode(result), utf8.encode(_key), _iv));
      print("decrypt 用时：${stopwatch.elapsed} result:$result");

    } on PlatformException {}

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Center(
              child: FlatButton(
            onPressed: () {
              initPlatformState();
            },
            child: Text("test"),
          ))),
    );
  }
}
