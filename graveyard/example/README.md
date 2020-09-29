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
        body: StreamBuilder<double>(
          stream: FlutterCompass.events,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error reading heading: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            double direction = snapshot.data;

            // if direction is null, then device does not support this sensor
            // show error message
            if (direction == null)
              return Center(
                child: Text("Device does not have sensors !"),
              );

            return Container(
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: ((direction ?? 0) * (math.pi / 180) * -1),
                child: Image.asset('assets/compass.jpg'),
              ),
            );
          },
        ),
      ),
    );
  }
}

```