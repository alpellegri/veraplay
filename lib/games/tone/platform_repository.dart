import 'package:flutter/services.dart';

class PlatformRepository {
  static const platform = MethodChannel('flutter.native/helper');

  Future<void> waveform(String w) async {
    try {
      final String result = await platform.invokeMethod('waveform', {
        'waveform': w,
      });
      print('RESULT -> $result');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> frequency(int f) async {
    try {
      final String result = await platform.invokeMethod('frequency', {
        'frequency': f,
      });
      // print('RESULT -> $result');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> play() async {
    try {
      final String result = await platform.invokeMethod('play');
      print('RESULT -> $result');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> stop() async {
    try {
      final String result = await platform.invokeMethod('stop');
      print('RESULT -> $result');
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
