import 'package:compass/compass.dart';
import 'package:flutter/foundation.dart';

class AndroidHeading implements CompassHeading {
  AndroidHeading({
    @required this.magneticHeading,
    @required this.trueHeading,
    @required this.x,
    @required this.y,
    @required this.z,
    @required this.timestamp,
  });

  final double magneticHeading;
  final double trueHeading;
  final double x;
  final double y;
  final double z;

  final DateTime timestamp;

  @override
  String toString() => 'AndroidHeading('
      'magneticHeading:${magneticHeading.toStringAsPrecision(2)}, '
      'trueHeading:${trueHeading.toStringAsPrecision(2)}, '
      'x:${x.toStringAsPrecision(2)}, '
      'y:${y.toStringAsPrecision(2)}, '
      'z:${z.toStringAsPrecision(2)}, '
      'timestamp:$timestamp'
      ')';
}
