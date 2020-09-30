# compass

[![pub package](https://img.shields.io/pub/v/compass.svg)](https://pub.dartlang.org/packages/compass)

A Flutter compass. The heading varies from 0-360, 0 being north.

_Note:_
_Android Only: `null` is returned as direction on android when no sensor available._

## Usage

To use this plugin, add `compass` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). For example:

```yaml
dependencies:
  compass: "^0.4.3"
```

### iOS

Make sure to add keys with appropriate descriptions to the `Info.plist` file.

- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysAndWhenInUseUsageDescription`

:memo: [Reference example code](https://github.com/hemanthrajv/compass/blob/89dccd39a32af970322b237e574d2e6fa3454568/example/ios/Runner/Info.plist#L27-L30)

### Android

Make sure to add permissions to the `app/src/main/AndroidManifest.xml` file.

- `android.permission.INTERNET`
- `android.permission.ACCESS_COARSE_LOCATION`
- `android.permission.ACCESS_FINE_LOCATION`

:memo: [Reference example code](https://github.com/hemanthrajv/compass/blob/89dccd39a32af970322b237e574d2e6fa3454568/example/android/app/src/main/AndroidManifest.xml#L4-L10)

### Recommended support plugins

- [Flutter Permission handler Plugin](https://github.com/Baseflow/flutter-permission-handler): Easy to request and check permissions in a cross-platform (iOS, Android) API.

:memo: [Reference example code](https://github.com/hemanthrajv/compass/blob/89dccd39a32af970322b237e574d2e6fa3454568/example/pubspec.yaml#L12)

### iOS Notes

- Can set the angle required for an update in degrees via `CLLocationManager.headingFilter`
- Can set the orientation to use for compass heading, via `CLLocationManager.headingOrientation`
- Cannot show the compass calibration dialog, there is no method exposed
- Can hide the compass calibration dialog via `CLLocationManager.dismissHeadingCalibrationDisplay()`
- Can enable/disable the compass calibration dialog, ref:

```swift
public func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
    return true
}
```

- `CLHeading` values `x`, `y`, `z` are not related to `CLLocationManager.deviceOrientation`. We tested default value, `faceUp`, `landscapeLeft` and `portrait` and none of them changed the `x,y,z` values. That means the magnetic vector appears to be raw sensor data.

Magnetometer tutorial: https://www.devfright.com/cmmotionmanager-tutorial-part-3-the-magnetometer/
A complete breakdown of the three different ways to get magnetometer data from iOS and how they relate to eachother: https://stackoverflow.com/a/15470571


We tried getting raw magnetometer vector from CLHeading (these were the best by far), `CMMotionManager.startMagnetometerUpdates` (these didn't appear to filter device magnetic field) and `CMMotionManager.startDeviceMotionUpdates` (which didn't provide any data, but did fire events.) We created a Stack issue to track this. https://stackoverflow.com/questions/64093436/ios-magnetometer-vector-has-unexpected-values

### Android Notes

Android only returns raw cartesian coordinate values `(x,y,z)` for geomagnetic sensor and accelerometer.

Android does make a [GeomagneticField](<https://developer.android.com/reference/android/hardware/GeomagneticField#getDeclination()>) class available which takes lat/lon, altitude and time which then provides access to declination / inclination as well as the `(x,y,z)` coordinates for the magnetic field direction.

Android appears to calibrate itself by having the user rotate their phone in a figure eight.

- https://www.youtube.com/watch?v=sP3d00Hr14o
- https://android.stackexchange.com/a/10148

### Other platforms

- web: 
  - exposes raw geomagnetic values `(x,y,z)` on [hardly any browsers](https://developer.mozilla.org/en-US/docs/Web/API/Magnetometer)
  - exposes orientation (accelerometer) rotation values on [most browsers](https://developer.mozilla.org/en-US/docs/Web/API/Detecting_device_orientation)
- windows ????
- linux ????
- macos ????

TLDR: this is going to be Android & iOS only.

### Implementation thoughts

It strikes me as interesting that iOS provides sugar around all these calculations while Android makes you implement them on your own.

I wonder if we're better off passing along the raw cartesian coordinates for geomagnetic sensor, accelerometer, and lat/long/altitude. Then we would do all the calculations in Dart. We're going to have to do the calculations in Android anyway, so might as well implement them in Dart and get feature parity across iOS and Android. This would also make it fairly trivial to add new platforms in the future like web, which only exposes the raw `(x,y,z)` magnetometer vector. (NOTE: we probably won't be supporting web any time soon)

There is an existing dart package called [geomag](https://pub.dev/packages/geomag) which is a port of [geomagJS](https://github.com/cmweiss/geomagJS) and has seemingly reasonable test coverage. This can be used to get the magnetic declination from lat/long/altitude/date allowing us to convert magnetic north to true north. It should be said that we could abdicate the responsibility there to `geomag` instead of building it into this package.

There is also a very thourough stack answer about creating a compass reading that [automatically compensates for tilt and pitch](https://stackoverflow.com/questions/16317599/android-compass-that-can-compensate-for-tilt-and-pitch/16386066#16386066)

Here's an advanced article on [fusing sensors](http://plaw.info/articles/sensorfusion/) in Android to get a real orientation vector.

More references:
  - https://android-developers.googleblog.com/2010/09/one-screen-turn-deserves-another.html
  - https://stackoverflow.com/questions/35600583/how-do-i-convert-raw-xyz-magnetometer-data-to-a-heading
  - https://stackoverflow.com/questions/7877155/how-to-make-an-accurate-compass-on-android/7877688#7877688
  - https://www.androidcode.ninja/android-compass-code-example/


### Stability

The CoreMotion iOS implementation appears to have considerably signal processing / filtering wizardry going on behind the scenes. Compared to the Android getOrientation azimuth value with a naiive low-pass filter, the iOS implementation is about 5x faster and simply cannot be thrown off with an external magnet.

Android uses the accelerometer and the magnetometer to figure out the azimuth (magneticHeading). I suspect that iOS does as well, but then also uses the gyroscope to detect rate of rotation, allowing it to essentially say "hey, this device isn't rotating, magnetic north probably shouldn't either." The result is Android implementation is easy to throw off with an external magnet, iOS is almost impossible to do so. iOS is also waaaay more responsive, so I imagine they are using the gyroscope for that initial rotation acceleration, after which the magnetometer takes over to handle the drift.

Suffice to say that unless some professional signal processing engineer shows up to help open source compass implementations, Android compasses on any platform will never perform with the incredible speed and accuracy of Apple open source compass implementations.

The author of this link http://plaw.info/articles/sensorfusion/ discusses sensor fusing and even offers an implementation in Java for Android that may be worth trying to get working.

## Inversion toggle

On iOS if you don't set a device orientation it handles device inversion very gracefully. On Android, with the implementation provided by Google's documentation, when the device goes above or below vertical it creates a violent inversion toggle that flips the compass 180°.