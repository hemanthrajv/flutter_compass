import 'dart:async';

import 'package:flutter/services.dart';

///[FlutterCompass] is a singleton class that provides assess to compass events
///The heading varies from 0-360, 0 being north.
class FlutterCompass {
  static final FlutterCompass _instance = new FlutterCompass._();

  factory FlutterCompass() {
    return _instance;
  }

  FlutterCompass._();

  static const EventChannel _compassChannel = const EventChannel('hemanthraj/flutter_compass');

  Stream<double> _compassEvents;

  ///Provides a [Stream] of compass events that can be listened to.
  static Stream<double> get events {
    if (_instance._compassEvents == null) {
      _instance._compassEvents = _compassChannel.receiveBroadcastStream().map((dynamic data) {
        return data as double;
      });
    }

    return _instance._compassEvents;
  }
}
