import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
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
  double _lastRead = 0;
  DateTime _lastReadAt;

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
            return Column(
              children: <Widget>[
                _buildManualReader(),
                Expanded(child: _buildCompass()),
              ],
            );
          } else {
            return _buildPermissionSheet();
          }
        }),
      ),
    );
  }

  Widget _buildManualReader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          RaisedButton(
            child: Text('Read Value'),
            onPressed: () async {
              final double tmp = await FlutterCompass.events.first;
              setState(() {
                _lastRead = tmp;
                _lastReadAt = DateTime.now();
              });
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '$_lastRead',
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  '$_lastReadAt',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompass() {
    return StreamBuilder<double>(
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
