# flutter_compass

[![pub package](https://img.shields.io/pub/v/flutter_compass.svg)](https://pub.dartlang.org/packages/flutter_compass)

A Flutter compass. The heading varies from 0-360, 0 being north.


_Note:_
_Android Only: `null` is returned as direction on android when no sensor available._

## Usage

To use this plugin, add `flutter_compass` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). For example:

```yaml
dependencies:
  flutter_compass: '^0.4.3'
```

### iOS
Make sure to add keys with appropriate descriptions to the `Info.plist` file.

* `NSLocationWhenInUseUsageDescription`
* `NSLocationAlwaysAndWhenInUseUsageDescription`

:memo: [Reference example code](https://github.com/hemanthrajv/flutter_compass/blob/89dccd39a32af970322b237e574d2e6fa3454568/example/ios/Runner/Info.plist#L27-L30)

### Android
Make sure to add permissions to the `app/src/main/AndroidManifest.xml` file.

* `android.permission.INTERNET`
* `android.permission.ACCESS_COARSE_LOCATIO`
* `android.permission.ACCESS_FINE_LOCATION`

:memo: [Reference example code](https://github.com/hemanthrajv/flutter_compass/blob/89dccd39a32af970322b237e574d2e6fa3454568/example/android/app/src/main/AndroidManifest.xml#L4-L10)

### Recommended support plugins

* [Flutter Permission handler Plugin](https://github.com/Baseflow/flutter-permission-handler): Easy to request and check permissions in a cross-platform (iOS, Android) API.

:memo: [Reference example code](https://github.com/hemanthrajv/flutter_compass/blob/89dccd39a32af970322b237e574d2e6fa3454568/example/pubspec.yaml#L12)
