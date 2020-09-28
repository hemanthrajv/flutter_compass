import 'dart:math' as math;

import 'package:flutter/widgets.dart';

extension NumX on num {
  /// Convert degrees to radians
  double get asRadians => this * (2 * math.pi) / 360;

  /// Convert degrees to radians
  double get degrees => this.asRadians;
}

extension WidgetX on Widget {
  /// Nudge this widget `x` and/or `y` pixels.
  Widget nudge({double x = 0.0, double y = 0.0}) =>
      Transform.translate(offset: Offset(x, y), child: this);
}

extension ListDoubleX on Iterable<double> {
  /// The maximum value in this iterable
  double get max => reduce((a, b) => math.max(a, b));
}
