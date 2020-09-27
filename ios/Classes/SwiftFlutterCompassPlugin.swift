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
        
        /// Magnetometer handlers
        let magnetometerHandler = FLTMagnetometerStreamHandler();
        let magnetometerChannel = FlutterEventChannel.init(name: "com.lukepighetti.compass/magnetometer", binaryMessenger: registrar.messenger());
        magnetometerChannel.setStreamHandler(magnetometerHandler);
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



class FLTMagnetometerStreamHandler:NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?;
    
    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink;
        motion.startMagnetometerUpdates(to: OperationQueue(), withHandler: { (data:CMMagnetometerData?, error:Error?) in
            let field = data?.magneticField;
            eventSink(field?.asSensorVectorEvent);
          })
        return nil;
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motion.stopMagnetometerUpdates();
        eventSink = nil;
        return nil;
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

extension CMMagneticField {
    var asSensorVectorEvent: [String: Any] {
        return [
            "x": self.x,
            "y": self.y,
            "z": self.z,
        ]
    }
}




