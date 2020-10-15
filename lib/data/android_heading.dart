import 'package:compass/compass.dart';
import 'package:flutter/foundation.dart';

class AndroidHeading implements CompassHeading {
  AndroidHeading({
    @required this.magneticHeading,
    @required this.timestamp,
    @required this.trueHeading,
    @required this.x,
    @required this.y,
    @required this.z,
  });

  final double magneticHeading;
  final DateTime timestamp;
  final double trueHeading;
  final double x;
  final double y;
  final double z;

  @override
  String toString() => 'AndroidHeading('
      'magneticHeading:${magneticHeading.toStringAsPrecision(2)}, '
      'timestamp:$timestamp'
      'trueHeading:${trueHeading.toStringAsPrecision(2)}, '
      'x:${x.toStringAsPrecision(2)}, '
      'y:${y.toStringAsPrecision(2)}, '
      'z:${z.toStringAsPrecision(2)}, '
      ')';
}
