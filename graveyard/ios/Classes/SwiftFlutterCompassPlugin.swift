import Flutter
import UIKit
import CoreLocation
import CoreMotion

private var location: CLLocationManager = CLLocationManager();
private var motion: CMMotionManager = CMMotionManager();

public class SwiftFlutterCompassPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        /// Compass handlers
        let compassHandler = FLTCompassStreamHandler();
        let compassChannel = FlutterEventChannel.init(name: "com.lukepighetti.compass/compass", binaryMessenger: registrar.messenger());
        compassChannel.setStreamHandler(compassHandler);
        
        location.headingFilter = kCLHeadingFilterNone;
        location.delegate = compassHandler;
    }
}

class FLTCompassStreamHandler:NSObject, FlutterStreamHandler, CLLocationManagerDelegate {
    private var eventSink: FlutterEventSink?;
    
    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink;
        location.startUpdatingHeading();
        return nil;
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        location.stopUpdatingHeading();
        eventSink = nil;
        return nil;
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        eventSink?(newHeading.asOverloadedSensorVectorEvent);
    }
}

extension CLHeading {
    var asOverloadedSensorVectorEvent: [String: Any] {
        return [
            /// We technically only need {x,y,z}
            "x": self.x,
            "y": self.y,
            "z": self.z,
            
            /// But let's overload this with accuracy, magnetic heading, true heading, and timestamp
            "headingAccuracy": self.headingAccuracy,
            "magneticHeading": self.magneticHeading,
            "timestamp": self.timestamp.timeIntervalSince1970,
            "trueHeading": self.trueHeading,
        ]
    }
}
