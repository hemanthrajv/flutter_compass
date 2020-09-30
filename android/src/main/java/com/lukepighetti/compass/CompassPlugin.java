package com.lukepighetti.compass;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import java.util.HashMap;

/**
 * CompassPlugin
 */
public class CompassPlugin implements FlutterPlugin, MethodCallHandler, SensorEventListener, StreamHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    /// Emits events to `com.lukepighetti.compass/compass`
    private EventSink sink;

    /// The sensor manager that we use to access the magnetometer and gyroscope
    private SensorManager sensorManager;

    private final float[] accelerometerReading = new float[3];
    private final float[] magnetometerReading = new float[3];
    private final float[] rotationMatrix = new float[9];
    private final float[] orientationAngles = new float[3];

    private final AngleLowpassFilter azimuthLowpass = new AngleLowpassFilter(200);

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "compass");
        channel.setMethodCallHandler(this);

        EventChannel channel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "com.lukepighetti.compass/compass");
        channel.setStreamHandler(this);

        Context context = flutterPluginBinding.getApplicationContext();
        sensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);

        // Get updates from the accelerometer and magnetometer at a constant rate.
        // To make batch operations more efficient and reduce power consumption,
        // provide support for delaying updates to the application.
        //
        // In this example, the sensor reporting delay is small enough such that
        // the application receives an update before the system checks the sensor
        // readings again.
        Sensor accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        Sensor magneticField = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);

        if (accelerometer != null) {
            sensorManager.registerListener(this, accelerometer,
                    SensorManager.SENSOR_DELAY_FASTEST, SensorManager.SENSOR_DELAY_UI);
        }

        if (magneticField != null) {
            sensorManager.registerListener(this, magneticField,
                    SensorManager.SENSOR_DELAY_FASTEST, SensorManager.SENSOR_DELAY_UI);
        }

    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        result.notImplemented();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        /// Dispose of the method call handler.
        channel.setMethodCallHandler(null);

        // Don't receive any more updates from either sensor.
        sensorManager.unregisterListener(this);
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }

    // Get readings from accelerometer and magnetometer. To simplify calculations,
    // consider storing these readings as unit vectors.
    @Override
    public void onSensorChanged(SensorEvent event) {
        if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
            System.arraycopy(event.values, 0, accelerometerReading,
                    0, accelerometerReading.length);
        } else if (event.sensor.getType() == Sensor.TYPE_MAGNETIC_FIELD) {
            System.arraycopy(event.values, 0, magnetometerReading,
                    0, magnetometerReading.length);
        }

        updateOrientationAngles();

        HashMap<String, Object> response = new HashMap<String, Object>();

        final float azimuth = orientationAngles[0];
        azimuthLowpass.add(azimuth);

        response.put("magneticHeading", Math.toDegrees(azimuthLowpass.average()));
        response.put("trueHeading", -1.0);
        response.put("x", magnetometerReading[0]);
        response.put("y", magnetometerReading[1]);
        response.put("z", magnetometerReading[2]);

        if (sink != null)
            sink.success(response);
    }

    // Compute the three orientation angles based on the most recent readings from
    // the device's accelerometer and magnetometer.
    public void updateOrientationAngles() {
        // Update rotation matrix, which is needed to update orientation angles.
        SensorManager.getRotationMatrix(rotationMatrix, null,
                accelerometerReading, magnetometerReading);
        // "rotationMatrix" now has up-to-date information.

        SensorManager.getOrientation(rotationMatrix, orientationAngles);
        // "orientationAngles" now has up-to-date information.
    }

    @Override
    public void onListen(Object arguments, EventSink events) {
        sink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        sink = null;
    }
}


