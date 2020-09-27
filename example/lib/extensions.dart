import 'dart:math';

import 'package:flutter/widgets.dart';

extension NumX on num {
  double get asRadians => this * (2 * pi) / 360;
  double get degrees => this.asRadians;
}

extension WidgetX on Widget {
  Widget nudge({double x = 0.0, double y = 0.0}) =>
      Transform.translate(offset: Offset(x, y), child: this);
}
