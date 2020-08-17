## 0.4.3

Use geomagnetic rotation sensor as fallback on Android

## 0.4.2+1

Minor fix

## 0.4.2

Updated rxDart to 0.24.0

## 0.4.1

Updated README.md

## 0.4.0

**Breaking change:** Uses magnetic heading by default for iOS.

Older versions used True heading and which caused deviations.

## 0.3.7

* Sensor check added on android. `null` is returned as direction when no sensor available.

## 0.3.6

* Upgrade `rxdart` version to `0.23.1` 

## 0.3.5

* Improve `README.md` 

## 0.3.4

* Add `dispose` method 

## 0.3.3

* Update `permission_handler` to 3.2.2
* Update `rxdart` to 0.22.3

## 0.3.2

* Android: The plugin will now remember the last read azimuth. This will be done
  across Isolates using a static variable. Additionally, the value is cached 
  _within_ the isolate with the introduction of a RxDart `BehaviorSubject`.
  Reading the current azimuth using `await FlutterCompass.events.first` will 
  therefore not hang anymore when th user has not moved the handset at all.
* Sample updated to cover the functional updates in Android.
* Added missing locatio permissions to the Android example which prevented the
  permission dialog from being shown.

## 0.3.1

* iOS: Remove permission request when Plugin is instantiated. Library users are
  responsible to request location permission by themselves.
* Request permission in the example directly.

## 0.3.0

* Replace kotlin code with simple java to reduce integration complexity

## 0.2.0

* Upgrade Android build components (Kotlin version)
  **Breaking change**. Migrate from the deprecated original Android Support
  Library to AndroidX. This shouldn't result in any functional changes, but it
  requires any Android apps using this plugin to [also
  migrate](https://developer.android.com/jetpack/androidx/migrate) if they're
  using the original support library.
* Upgrade iOS component to Swift 4.2

## 0.1.0

* Added example
* Added public api docs

## 0.0.3

* bug fixes

## 0.0.2

* Android emulator fix

## 0.0.1

* flutter compass plugin
