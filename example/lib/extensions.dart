import 'dart:math' as math;

import 'package:flutter/widgets.dart';

extension NumX on num {
  /// Convert degrees to radians, is `compassDegrees.asRadians`
  double get asRadians => this * (2 * math.pi) / 360;

  /// Convert degrees to radians, ie `45.degrees`
  double get degrees => this.asRadians;

  /// Convert radians into degrees, ie `angle.asDegrees`
  double get asDegrees => this * 360 / (2 * math.pi);

  /// Convert turns into radians, ie `1.turns == 360.degrees`
  double get turns => this * 2 * math.pi;
}

extension WidgetX on Widget {
  /// Nudge this widget `x` and/or `y` pixels.
  Widget nudge({double x = 0.0, double y = 0.0}) =>
      Transform.translate(offset: Offset(x, y), child: this);
}

extension IterableDoubleX on Iterable<double> {
  /// The maximum value in this iterable
  double get max => reduce((a, b) => math.max(a, b));
}
