import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';

/// [FlutterCompass] is a singleton class that provides assess to compass events
/// The heading varies from 0-360, 0 being north.
class FlutterCompass {
  static final FlutterCompass _instance = FlutterCompass._();

  factory FlutterCompass() {
    return _instance;
  }

  FlutterCompass._();

  static const EventChannel _compassChannel =
      const EventChannel('hemanthraj/flutter_compass');

  BehaviorSubject<double> _compassEvents;

  /// Provides a [Stream] of compass events that can be listened to.
  static Stream<double> get events {
    if (_instance._compassEvents == null) {
      _instance._compassEvents = BehaviorSubject<double>();
      _instance._compassEvents.addStream(_compassChannel
          .receiveBroadcastStream()
          .map<double>((dynamic data) => data));
    }

    return _instance._compassEvents;
  }

  void dispose() {
    _compassEvents?.close();
    _compassEvents = null;
  }
}
