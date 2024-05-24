import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'compass_event.dart';

/// [FlutterCompass] is a singleton class that provides assess to compass events
/// The heading varies from 0-360, 0 being north.
class FlutterCompass {
  static final FlutterCompass _instance = FlutterCompass._();

  factory FlutterCompass() {
    return _instance;
  }

  FlutterCompass._();

  static const EventChannel _compassChannel = const EventChannel(
    'hemanthraj/flutter_compass',
  );
  static Stream<CompassEvent>? _stream;

  /// Provides a [Stream] of compass events that can be listened to.
  static Stream<CompassEvent>? get events {
    if (kIsWeb) {
      return Stream.empty();
    }
    _stream ??= _compassChannel.receiveBroadcastStream().map(
          (dynamic data) => CompassEvent.fromList(
            data?.cast<double>(),
          ),
        );
    return _stream;
  }
}
