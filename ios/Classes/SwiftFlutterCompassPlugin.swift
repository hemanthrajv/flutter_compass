import Flutter
import UIKit
import CoreLocation

public class SwiftFlutterCompassPlugin: NSObject, FlutterPlugin, FlutterStreamHandler, CLLocationManagerDelegate {

    private var eventSink: FlutterEventSink?;
    private var location: CLLocationManager = CLLocationManager();

    
    init(channel: FlutterEventChannel) {
        super.init()
        location.delegate = self;
        location.headingFilter = kCLHeadingFilterNone;
        
        channel.setStreamHandler(self);
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterEventChannel.init(name: "hemanthraj/flutter_compass", binaryMessenger: registrar.messenger())
        _ = SwiftFlutterCompassPlugin(channel: channel);
    }

    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink;
        location.startUpdatingHeading();
        return nil;
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil;
        location.stopUpdatingHeading();
        return nil;
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        eventSink?([
            "magnetometer": newHeading.asOverloadedSensorVectorEvent,
        ]);
    }
}

extension CLHeading {
    var asOverloadedSensorVectorEvent: [String: Any] {
        return [
            /// We technically only need {x,y,z}
            "x": self.x,
            "y": self.y,
            "z": self.z,
            
            /// But let's overload this dictionary with accuracy, magnetic heading, true heading, and timestamp
            "headingAccuracy": self.headingAccuracy,
            "magneticHeading": self.magneticHeading,
            "timestamp": self.timestamp.timeIntervalSince1970,
            "trueHeading": self.trueHeading,
        ]
    }
}
