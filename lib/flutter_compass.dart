import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CompassEvent {
  // The heading, in degrees, of the device around its Z
  // axis, or where the top of the device is pointing.
  final double? heading;

  // The heading, in degrees, of the device around its X axis, or
  // where the back of the device is pointing.
  final double? headingForCameraMode;

  // The deviation error, in degrees, plus or minus from the heading.
  // NOTE: for iOS this is computed by the platform and is reliable. For
  // Android several values are hard-coded, and the true error could be more
  // or less than the value here.
  final double? accuracy;

  CompassEvent.fromList(List<double>? data)
      : heading = data?[0] ?? null,
        headingForCameraMode = data?[1] ?? null,
        accuracy = (data == null) || (data[2] == -1) ? null : data[2];

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
  static Stream<CompassEvent>? _stream;

  /// Provides a [Stream] of compass events that can be listened to.
  static Stream<CompassEvent>? get events {
    if (kIsWeb) {
      return Stream.empty();
    }
    _stream ??= _compassChannel
        .receiveBroadcastStream()
        .map((dynamic data) => CompassEvent.fromList(data?.cast<double>()));
    return _stream;
  }
}
