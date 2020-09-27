import 'package:flutter/foundation.dart';

class CompassEvent {
  /// A compass update event. Includes magnetic and true heading directions in degrees,
  /// the raw magnetometer values, and the timestamp for when the measurment was taken.
  CompassEvent({
    @required this.magneticHeading,
    @required this.trueHeading,
    @required this.x,
    @required this.y,
    @required this.z,
  });

  /// The magnetic heading in degrees.
  final double magneticHeading;

  /// The true heading in degrees. This compensates for magnetic declination.
  final double trueHeading;

  /// The x component of the magnetometer vector.
  final double x;

  /// The y component of the magnetometer vector.
  final double y;

  /// The z component of the magnetometer vector.
  final double z;

  @override
  String toString() => 'SensorVectorEvent('
      'magneticHeading:${magneticHeading.toStringAsPrecision(3)}, '
      'trueHeading:${trueHeading.toStringAsPrecision(3)}, '
      'x:${x.toStringAsPrecision(3)}, '
      'y:${y.toStringAsPrecision(3)}, '
      'z:${z.toStringAsPrecision(3)}, '
      ')';
}
