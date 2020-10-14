import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';

class CompassEvent {
  final double heading;
  final double headingForCameraMode;
  final double accuracy;

  CompassEvent.fromList(List<double> data)
      : heading = data[0],
        headingForCameraMode = data[1],
        accuracy = data[2] == -1 ? null : data[2];

  @override
  String toString() {
    return 'heading: $heading\nheadingForCameraMode: $headingForCameraMode\naccuracy: $accuracy';
  }
}

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

  BehaviorSubject<CompassEvent> _compassEvents;
  static StreamSubscription _sub;

  /// Provides a [Stream] of compass events that can be listened to.
  static Stream<CompassEvent> get events {
    if (_instance._compassEvents == null) {
      _instance._compassEvents = BehaviorSubject<CompassEvent>();
      if (_sub == null) {
        _sub = _compassChannel
            .receiveBroadcastStream()
            .map((dynamic data) => CompassEvent.fromList(data.cast<double>()))
            .listen(
              (event) => _instance._compassEvents.add(event),
              onError: _instance._compassEvents.addError,
            );
      }
    }

    return _instance._compassEvents;
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
    _compassEvents?.close();
    _compassEvents = null;
  }
}
