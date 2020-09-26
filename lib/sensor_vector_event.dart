class SensorVectorEvent {
  /// An event from the platform that contains a sensor vector.
  ///
  /// Typically used for magnetometer (magnetic north vector sensor) and
  /// accelerometer (gravity vector sensor).
  SensorVectorEvent(this.x, this.y, this.z);

  /// Create a [SensorVectorEvent] from a map containing values `{x,y,z}`.
  SensorVectorEvent.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'],
        z = json['z'];

  /// The x component of the sensor vector.
  final double x;

  /// The y component of the sensor vector.
  final double y;

  /// The z component of the sensor vector.
  final double z;

  @override
  String toString() => 'SensorVectorEvent('
      '${x.toStringAsPrecision(3)}, '
      '${y.toStringAsPrecision(3)}, '
      '${z.toStringAsPrecision(3)}'
      ')';
}
