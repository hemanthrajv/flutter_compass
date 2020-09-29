import 'dart:io';
import 'dart:math';

import 'package:compass/compass.dart';
import 'package:compass_example/compass_view.dart';
import 'package:compass_example/extensions.dart';
import 'package:compass_example/vector_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  /// Make sure the platform binding is setup so we can use
  /// platfom channels before using [runApp]
  WidgetsFlutterBinding.ensureInitialized();

  /// Setup device orientation so it doesn't rotate to something we don't support
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

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
          /// Guard no permissions
          if (_hasPermissions == false) return _buildPermissionSheet();

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
                  if (Platform.isIOS)
                    VectorView(
                      x: snapshot.data.x,
                      y: snapshot.data.y,
                      z: snapshot.data.z,
                      max: 60,
                    )
                  else if (Platform.isAndroid)
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
            onPressed: () async {
              await Permission.locationWhenInUse.request();
              await _fetchPermissionStatus();
            },
          ),
          SizedBox(height: 16),
          RaisedButton(
            child: Text('Open App Settings'),
            onPressed: () async {
              await openAppSettings();
            },
          )
        ],
      ),
    );
  }

  /// Fetch the status of [Permission.locationWhenInUse] and
  /// update [_hasPermissions] accordingly.
  Future<void> _fetchPermissionStatus() async {
    final status = await Permission.locationWhenInUse.status;

    /// Guard this screen is not mounted
    if (!mounted) return;

    setState(() {
      _hasPermissions = status == PermissionStatus.granted;
    });
  }
}
