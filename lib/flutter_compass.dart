import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_compass/graveyard/cl_heading.dart';
import 'package:rxdart/subjects.dart';

import 'sensor_vector_event.dart';

export 'sensor_vector_event.dart';

/// [FlutterCompass] is a singleton class that provides assess to compass events
/// The heading varies from 0-360, 0 being north.
class FlutterCompass {
  static const _compassChannel =
      EventChannel('com.lukepighetti.compass/compass');
  static BehaviorSubject<SensorVectorEvent> _compassSubject;

  /// Provides a [Stream] of compass events that can be listened to.
  static Stream<SensorVectorEvent> get compassEvents =>
      _compassSubject ??= BehaviorSubject<SensorVectorEvent>()
        ..addStream(
          _compassChannel
              .receiveBroadcastStream()
              .map<SensorVectorEvent>(_mapPlatformCompassEvent),
        );

  /// Convert platform channel data to a compass event, typically [SensorVectorEvent]
  static SensorVectorEvent _mapPlatformCompassEvent(dynamic data) {
    if (Platform.isIOS) {
      return CLHeading(
        x: data['x'],
        y: data['y'],
        z: data['z'],
        headingAccuracy: data['headingAccuracy'],
        magneticHeading: data['magneticHeading'],
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          ((data['timestamp'] as double) * 1000).toInt(),
        ),
        trueHeading: data['trueHeading'],
      );
    } else {
      throw UnimplementedError("This platform is not yet implemented.");
    }
  }

  static const _magnetometerChannel =
      EventChannel('com.lukepighetti.compass/magnetometer');
  static BehaviorSubject<SensorVectorEvent> _magnetometerSubject;

  /// Provides a [Stream] of magnetometer events that can be listened to.
  static Stream<SensorVectorEvent> get magnetometerEvents =>
      _magnetometerSubject ??= BehaviorSubject<SensorVectorEvent>()
        ..addStream(
          _magnetometerChannel
              .receiveBroadcastStream()
              .map<SensorVectorEvent>(_mapPlatformMagnetometerEvent),
        );

  /// Convert platform channel data to a magnetometer event, typically [SensorVectorEvent]
  static SensorVectorEvent _mapPlatformMagnetometerEvent(dynamic data) {
    if (Platform.isIOS) {
      return SensorVectorEvent(
        x: data['x'],
        y: data['y'],
        z: data['z'],
      );
    } else {
      throw UnimplementedError("This platform is not yet implemented.");
    }
  }

  void dispose() {
    _compassSubject?.close();
    _magnetometerSubject?.close();
    _compassSubject = null;
    _magnetometerSubject = null;
  }
}
