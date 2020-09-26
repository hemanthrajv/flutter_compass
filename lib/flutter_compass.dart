import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_compass/graveyard/cl_heading.dart';
import 'package:rxdart/subjects.dart';

import 'platform_sensors_event.dart';
import 'sensor_vector_event.dart';

export 'platform_sensors_event.dart';
export 'sensor_vector_event.dart';

/// [FlutterCompass] is a singleton class that provides assess to compass events
/// The heading varies from 0-360, 0 being north.
///
/// TODO: remove the singleton clutter that we don't need. Can we do this with all static fields?
class FlutterCompass {
  static final FlutterCompass _instance = FlutterCompass._();

  factory FlutterCompass() {
    return _instance;
  }

  FlutterCompass._();

  static const EventChannel _compassChannel =
      const EventChannel('hemanthraj/flutter_compass');

  BehaviorSubject<PlatformSensorsEvent> _compassEvents;

  /// Provides a [Stream] of compass events that can be listened to.
  static Stream<PlatformSensorsEvent> get events {
    if (_instance._compassEvents == null) {
      _instance._compassEvents = BehaviorSubject<PlatformSensorsEvent>();
      _instance._compassEvents.addStream(
        _compassChannel.receiveBroadcastStream().map<PlatformSensorsEvent>(
          (dynamic data) {
            print(data);

            if (Platform.isIOS) {
              return PlatformSensorsEvent(
                magnetometer: CLHeading(
                  x: data['magnetometer']['x'],
                  y: data['magnetometer']['y'],
                  z: data['magnetometer']['z'],
                  headingAccuracy: data['magnetometer']['headingAccuracy'],
                  magneticHeading: data['magnetometer']['magneticHeading'],
                  timestamp: DateTime.fromMillisecondsSinceEpoch(
                    ((data['magnetometer']['timestamp'] as double) * 1000)
                        .toInt(),
                  ),
                  trueHeading: data['magnetometer']['trueHeading'],
                ),
                accelerometer: null,
              );
            }
            return PlatformSensorsEvent.fromJson(
              Map<String, dynamic>.from(data),
            );
          },
        ),
      );
    }

    return _instance._compassEvents;
  }

  void dispose() {
    _compassEvents?.close();
    _compassEvents = null;
  }
}
