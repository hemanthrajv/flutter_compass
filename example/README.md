# flutter_compass_example

Demonstrates how to use the flutter_compass plugin.

## Usage

```dart

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
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
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Flutter Compass'),
        ),
        body: new Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: new Transform.rotate(
            angle: ((_direction ?? 0) * (math.pi / 180) * -1),
            child: new Image.asset('assets/compass.jpg'),
          ),
        ),
      ),
    );
  }
}

```