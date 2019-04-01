import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _direction;

  @override
  void initState() {
    super.initState();
    FlutterCompass.events.listen((double direction) {
      setState(() {
        _direction = direction;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Compass'),
        ),
        body: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: Transform.rotate(
            angle: ((_direction ?? 0) * (math.pi / 180) * -1),
            child: Image.asset('assets/compass.jpg'),
          ),
        ),
      ),
    );
  }
}
