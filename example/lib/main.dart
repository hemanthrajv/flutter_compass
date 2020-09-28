import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_compass_example/compass_view.dart';
import 'package:flutter_compass_example/vector_view.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();
    _fetchPermissionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Flutter Compass'),
        ),
        body: Builder(builder: (context) {
          if (_hasPermissions) {
            /// Compass events
            return StreamBuilder<CompassHeading>(
              stream: FlutterCompass.compassEvents,
              initialData: FlutterCompass.compassEvents.value,
              builder: (context, snapshot) {
                if (snapshot.hasData == false) return SizedBox.shrink();
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(snapshot.data.toString()),
                    ),
                    CompassView(heading: snapshot.data),
                    SizedBox(height: 12),
                    VectorView(
                      x: snapshot.data.x,
                      y: snapshot.data.y,
                      z: snapshot.data.z,
                      max: 60,
                    ),
                  ],
                );
              },
            );
          } else {
            return _buildPermissionSheet();
          }
        }),
      ),
    );
  }

  Widget _buildPermissionSheet() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Location Permission Required'),
          RaisedButton(
            child: Text('Request Permissions'),
            onPressed: () {
              PermissionHandler().requestPermissions(
                  [PermissionGroup.locationWhenInUse]).then((ignored) {
                _fetchPermissionStatus();
              });
            },
          ),
          SizedBox(height: 16),
          RaisedButton(
            child: Text('Open App Settings'),
            onPressed: () {
              PermissionHandler().openAppSettings().then((opened) {
                //
              });
            },
          )
        ],
      ),
    );
  }

  void _fetchPermissionStatus() {
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then((status) {
      if (mounted) {
        setState(() => _hasPermissions = status == PermissionStatus.granted);
      }
    });
  }
}
