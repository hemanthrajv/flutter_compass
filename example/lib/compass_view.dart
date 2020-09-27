import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'extensions.dart';

class CompassView extends StatelessWidget {
  const CompassView({
    Key key,
    @required this.heading,
  }) : super(key: key);

  /// The heading to draw a compass with.
  final CompassEvent heading;

  @override
  Widget build(BuildContext context) {
    double arrowSize = 128;

    return SizedBox.fromSize(
      size: Size.square(arrowSize * 1.2),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          /// Magnetic heading
          Transform.rotate(
            angle: -heading.magneticHeading.asRadians,
            child: Icon(
              Icons.arrow_upward,
              color: Colors.red,
              size: arrowSize,
            ),
          ),

          /// True heading
          Transform.rotate(
            angle: -heading.trueHeading.asRadians,
            child: Icon(
              Icons.arrow_upward,
              color: Colors.blue,
              size: arrowSize,
            ),
          ),
        ],
      ),
    );
  }
}
