import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_compass/data/cl_heading.dart';
import 'package:rxdart/rxdart.dart';

import 'compass_heading.dart';

export 'compass_heading.dart';

/// [FlutterCompass] is a singleton class that provides assess to compass events
/// The heading varies from 0-360, 0 being north.
class FlutterCompass {
  static const _compassChannel =
      EventChannel('com.lukepighetti.compass/compass');
  static BehaviorSubject<CompassHeading> _compassSubject;

  /// Provides a [Stream] of compass events that can be listened to.
  static ValueStream<CompassHeading> get compassEvents =>
      _compassSubject ??= BehaviorSubject<CompassHeading>()
        ..addStream(
          _compassChannel
              .receiveBroadcastStream()
              .map<CompassHeading>(_mapPlatformCompassEvent),
        );

  /// Convert platform channel data to a compass event, typically [CompassHeading]
  static CompassHeading _mapPlatformCompassEvent(dynamic data) {
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

    /// Lazy initialized subjects should be set to null after closing
    /// so they can be recreated after being disposed.
    _compassSubject = null;
  }
}
