import 'package:compass/compass.dart';
import 'package:flutter/foundation.dart';

class AndroidHeading implements CompassHeading {
  AndroidHeading({
    @required this.accelerometerX,
    @required this.accelerometerY,
    @required this.accelerometerZ,
    @required this.magnetometerX,
    @required this.magnetometerY,
    @required this.magnetometerZ,
    @required this.timestamp,
  });

  final magneticHeading = -1;

  final trueHeading = -1;
  final x = -1;
  final y = -1;
  final z = -1;

  final double accelerometerX;
  final double accelerometerY;
  final double accelerometerZ;

  final double magnetometerX;
  final double magnetometerY;
  final double magnetometerZ;

  final DateTime timestamp;

  @override
  String toString() => 'AndroidHeading('
      'accelerometerX:${accelerometerX.toStringAsPrecision(2)} '
      'accelerometerY:${accelerometerY.toStringAsPrecision(2)} '
      'accelerometerZ:${accelerometerZ.toStringAsPrecision(2)} '
      'magnetometerX:${magnetometerX.toStringAsPrecision(2)} '
      'magnetometerY:${magnetometerY.toStringAsPrecision(2)} '
      'magnetometerZ:${magnetometerZ.toStringAsPrecision(2)} '
      'timestamp:$timestamp'
      ')';
}
