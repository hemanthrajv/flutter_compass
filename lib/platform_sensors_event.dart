import 'package:flutter_compass/sensor_vector_event.dart';

/// TODO: implement accelerometer data
const _skipAccelerometer = true;

class PlatformSensorsEvent {
  /// A tuple that contains sensor events for both the magnetometer
  /// and the accelerometer
  PlatformSensorsEvent({this.magnetometer, this.accelerometer});

  /// Create a [PlatformSensorsEvent] from a map containing values
  ///
  /// ```
  /// {
  ///   magnetometer: {x,y,z},
  ///   accelerometer: {x,y,z}
  /// }
  /// ```
  PlatformSensorsEvent.fromJson(Map<String, dynamic> json)
      : magnetometer = SensorVectorEvent.fromJson(json['magnetometer']),
        accelerometer = _skipAccelerometer
            ? null
            : SensorVectorEvent.fromJson(json['accelerometer']);

  /// The magnetometer sensor event, ie the magnetic north vector.
  final SensorVectorEvent magnetometer;

  /// The accelerometer sensor event, ie the gravity vector.
  final SensorVectorEvent accelerometer;

  @override
  String toString() => 'PlatformSensorsEvent('
      'magnetometer:$magnetometer, '
      'accelerometer:$accelerometer'
      ')';
}
