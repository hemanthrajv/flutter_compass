import Flutter
import UIKit
import CoreLocation
import CoreMotion

public class SwiftFlutterCompassPlugin: NSObject, FlutterPlugin, FlutterStreamHandler, CLLocationManagerDelegate {

    private var eventSink: FlutterEventSink?;
    private var location: CLLocationManager = CLLocationManager();
    private var motion: CMMotionManager = CMMotionManager();


    init(channel: FlutterEventChannel) {
        super.init()
        location.delegate = self
        location.headingFilter = 0.1;
        channel.setStreamHandler(self);

        motion.accelerometerUpdateInterval = 1.0 / 30.0;
        motion.startAccelerometerUpdates();
    }


  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterEventChannel.init(name: "hemanthraj/flutter_compass", binaryMessenger: registrar.messenger())
    _ = SwiftFlutterCompassPlugin(channel: channel);
  }

    public func onListen(withArguments arguments: Any?,
                         eventSink: @escaping FlutterEventSink) -> FlutterError? {
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
        if (newHeading.headingAccuracy>0){
            var headingForCameraMode = newHeading.magneticHeading;
            if let data = self.motion.accelerometerData {
                headingForCameraMode = newHeading.magneticHeading + atan2(-data.acceleration.x, -data.acceleration.y) 
                    * 180.0 / Double.pi;
                while (headingForCameraMode >= 360.0) {
                    headingForCameraMode -= 360.0;
                }
                while (headingForCameraMode < 360.0) {
                    headingForCameraMode += 360.0;
                }
            }
            eventSink?([newHeading.magneticHeading, headingForCameraMode, newHeading.headingAccuracy]);
        }
    }
}
