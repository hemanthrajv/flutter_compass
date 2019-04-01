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
