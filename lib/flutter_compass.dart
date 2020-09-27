import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_compass/data/cl_heading.dart';
import 'package:rxdart/rxdart.dart';

import 'compass_event.dart';

export 'compass_event.dart';

/// [FlutterCompass] is a singleton class that provides assess to compass events
/// The heading varies from 0-360, 0 being north.
class FlutterCompass {
  static const _compassChannel =
      EventChannel('com.lukepighetti.compass/compass');
  static BehaviorSubject<CompassEvent> _compassSubject;

  /// Provides a [Stream] of compass events that can be listened to.
  static ValueStream<CompassEvent> get compassEvents =>
      _compassSubject ??= BehaviorSubject<CompassEvent>()
        ..addStream(
          _compassChannel
              .receiveBroadcastStream()
              .map<CompassEvent>(_mapPlatformCompassEvent),
        );

  /// Convert platform channel data to a compass event, typically [CompassEvent]
  static CompassEvent _mapPlatformCompassEvent(dynamic data) {
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

  void dispose() {
    _compassSubject?.close();
    _compassSubject = null;
  }
}
