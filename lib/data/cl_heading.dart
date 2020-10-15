import 'package:flutter/foundation.dart';
import 'package:compass/compass_heading.dart';

class CLHeading implements CompassHeading {
  /// A carbon copy of `CLHeading` data fields from Apple's `CoreLocation` library.
  CLHeading({
    @required this.headingAccuracy,
    @required this.magneticHeading,
    @required this.timestamp,
    @required this.trueHeading,
    @required this.x,
    @required this.y,
    @required this.z,
  });

  /// The maximum deviation (measured in degrees) between the reported heading
  /// and the true geomagnetic heading.
  ///
  /// A positive value in this property represents the potential error between
  /// the value reported by the [magneticHeading] property and the actual direction
  /// of magnetic north. Thus, the lower the value of this property, the more
  /// accurate the heading. A negative value means that the reported heading is
  /// invalid, which can occur when the device is uncalibrated or there is strong
  /// interference from local magnetic fields.
  final double headingAccuracy;

  /// The heading (measured in degrees) relative to magnetic north.
  ///
  /// The value in this property represents the heading relative to the magnetic
  /// North Pole, which is different from the geographic North Pole. The value 0
  /// means the device is pointed toward magnetic north, 90 means it is pointed
  /// east, 180 means it is pointed south, and so on. The value in this property
  /// should always be valid.
  final double magneticHeading;

  /// The time at which this heading was determined.
  final DateTime timestamp;

  /// The heading (measured in degrees) relative to true north.
  ///
  /// The value in this property represents the heading relative to the geographic
  /// North Pole. The value 0 means the device is pointed toward true north, 90 means
  /// it is pointed due east, 180 means it is pointed due south, and so on. A negative
  /// value indicates that the heading could not be determined.
  ///
  /// This property contains a valid value only if location updates are also enabled
  /// for the corresponding location manager object. Because the position of true
  /// north is different from the position of magnetic north on the Earth’s surface,
  /// Core Location needs the current location of the device to compute the value
  /// of this property.
  final double trueHeading;

  /// The geomagnetic data (measured in microteslas) for the x-axis.
  ///
  /// This value represents the x-axis deviation from the magnetic field lines being tracked by the device.
  final double x;

  /// The geomagnetic data (measured in microteslas) for the y-axis.
  ///
  /// This value represents the y-axis deviation from the magnetic field lines being tracked by the device.
  final double y;

  /// The geomagnetic data (measured in microteslas) for the z-axis.
  ///
  /// This value represents the z-axis deviation from the magnetic field lines being tracked by the device.
  final double z;

  @override
  String toString() => 'CLHeading('
      'headingAccuracy:${headingAccuracy.toStringAsPrecision(3)},'
      'magneticHeading:${magneticHeading.toStringAsPrecision(3)}, '
      'timestamp:$timestamp'
      'trueHeading:${trueHeading.toStringAsPrecision(3)}, '
      'x:${x.toStringAsPrecision(3)}, '
      'y:${y.toStringAsPrecision(3)}, '
      'z:${z.toStringAsPrecision(3)}, '
      ')';
}
