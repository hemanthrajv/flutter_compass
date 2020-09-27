import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'extensions.dart';

class VectorView extends StatelessWidget {
  const VectorView({
    @required this.x,
    @required this.y,
    @required this.z,
    this.max,
    Key key,
  }) : super(key: key);

  final double x;
  final double y;
  final double z;

  final double max;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox.fromSize(
        size: Size.square(160),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: _VectorPainter(x, y, z, max),
            ),

            /// Axis annotations
            Align(
              alignment: Alignment.topCenter,
              child: Text("Z ${z.toStringAsPrecision(2)}").nudge(y: -18),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                      width: 60, child: Text("Y ${y.toStringAsPrecision(2)}"))
                  .nudge(x: 24, y: 12),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text("X ${x.toStringAsPrecision(2)}").nudge(x: 12, y: -3),
            ),
          ],
        ),
      ),
    );
  }
}

class _VectorPainter extends CustomPainter {
  _VectorPainter(this.x, this.y, this.z, this.max);

  final double x;
  final double y;
  final double z;
  final double max;

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final valuePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;

    final zDirection = -90.degrees;
    final yDirection = 0.degrees;
    final xDirection = 135.degrees;

    /// Calculate axis extents
    final zExtent = Offset.fromDirection(zDirection, radius)
        .translate(center.dx, center.dy);

    final yExtent = Offset.fromDirection(yDirection, radius)
        .translate(center.dx, center.dy);

    final xExtent = Offset.fromDirection(xDirection, radius)
        .translate(center.dx, center.dy);

    /// Draw axes
    canvas.drawLine(center, zExtent, axisPaint);
    canvas.drawLine(center, yExtent, axisPaint);
    canvas.drawLine(center, xExtent, axisPaint);

    /// Calculate value extents
    final maxValue = max ?? math.max(math.max(x.abs(), y.abs()), z.abs());
    final zRadius = z / maxValue * radius;
    final yRadius = y / maxValue * radius;
    final xRadius = x / maxValue * radius;

    final zValueExtent = Offset.fromDirection(zDirection, zRadius)
        .translate(center.dx, center.dy);

    final yValueExtent = Offset.fromDirection(yDirection, yRadius)
        .translate(center.dx, center.dy);

    final xValueExtent = Offset.fromDirection(xDirection, xRadius)
        .translate(center.dx, center.dy);

    /// Draw values
    canvas.drawLine(center, zValueExtent, valuePaint);
    canvas.drawLine(center, yValueExtent, valuePaint);
    canvas.drawLine(center, xValueExtent, valuePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
