/// A compass heading with the magnetic heading, true heading, and magnetic
/// field vector `(x,y,z)` components.
abstract class CompassHeading {
  /// The magnetic heading in degrees.
  double get magneticHeading;

  /// The true heading in degrees. This compensates for magnetic declination.
  double get trueHeading;

  /// The x component of the magnetometer vector.
  double get x;

  /// The y component of the magnetometer vector.
  double get y;

  /// The z component of the magnetometer vector.
  double get z;
}
