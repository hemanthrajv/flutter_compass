package com.hemanthraj.fluttercompass;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.util.Log;


import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public final class FlutterCompassPlugin implements StreamHandler {
    // A static variable which will retain the value across Isolates.
    private static Double currentAzimuth;
    
    private double newAzimuth;
    private double filter;
    private SensorEventListener sensorEventListener;

    private final SensorManager sensorManager;
    private final Sensor sensor;
    private final float[] orientation;
    private final float[] rMat;

    public static void registerWith(Registrar registrar) {
        EventChannel channel = new EventChannel(registrar.messenger(), "hemanthraj/flutter_compass");
        channel.setStreamHandler(new FlutterCompassPlugin(registrar.context(), Sensor.TYPE_ROTATION_VECTOR, Sensor.TYPE_GEOMAGNETIC_ROTATION_VECTOR));
    }


    public void onListen(Object arguments, EventSink events) {
        // Added check for the sensor, if null then the device does not have the TYPE_ROTATION_VECTOR or TYPE_GEOMAGNETIC_ROTATION_VECTOR sensor
        if(sensor != null) {
            sensorEventListener = createSensorEventListener(events);
            sensorManager.registerListener(sensorEventListener, this.sensor, SensorManager.SENSOR_DELAY_UI);
            if (currentAzimuth != null) {
                events.success(currentAzimuth);
            }
        } else {
            // Send null to Flutter side
            events.success(null);
//                events.error("Sensor Null", "No sensor was found", "The device does not have any sensor");
        }
    }

    public void onCancel(Object arguments) {
        this.sensorManager.unregisterListener(this.sensorEventListener);
    }

    private SensorEventListener createSensorEventListener(final EventSink events) {
        return new SensorEventListener() {
            public void onAccuracyChanged(Sensor sensor, int accuracy) {
            }

            public void onSensorChanged(SensorEvent event) {
                SensorManager.getRotationMatrixFromVector(rMat, event.values);
                newAzimuth = ((Math.toDegrees((double) SensorManager.getOrientation(rMat, orientation)[0]) + (double) 360) % (double) 360 - Math.toDegrees((double) SensorManager.getOrientation(rMat, orientation)[2]) + (double) 360) % (double) 360;
                if (currentAzimuth == null || Math.abs(currentAzimuth - newAzimuth) >= filter) {
                    currentAzimuth = newAzimuth;
                    events.success(newAzimuth);
                }
            }
        };
    }

    private FlutterCompassPlugin(Context context, int sensorType, int fallbackSensorType) {
        filter = 1.0F;

        sensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
        orientation = new float[3];
        rMat = new float[9];
        Sensor defaultSensor = this.sensorManager.getDefaultSensor(sensorType);
        if (defaultSensor != null) {
            sensor = defaultSensor;
        } else {
            sensor = this.sensorManager.getDefaultSensor(fallbackSensorType);
        }
    }

}
