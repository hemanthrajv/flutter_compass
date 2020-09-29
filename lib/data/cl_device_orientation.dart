/// Enum indicating the physical orientation of the device.
enum CLDeviceOrientation {
  /// The device is held parallel to the ground with the screen facing downwards.
  faceDown,

  /// The device is held parallel to the ground with the screen facing upwards.
  faceUp,

  /// The device is in landscape mode, with the device held upright and the home button on the right side.
  landscapeLeft,

  /// The device is in landscape mode, with the device held upright and the home button on the left side.
  landscapeRight,

  /// The device is in portrait mode, with the device held upright and the home button at the bottom.
  portrait,

  /// The device is in portrait mode but upside down, with the device held upright and the home button at the top.
  portaitUpsideDown,

  /// The orientation is currently not known.
  unknown,
}
