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
    private int lastAccuracy;
    private SensorEventListener sensorEventListener;

    private final SensorManager sensorManager;
    private final Sensor sensor;
    private final float[] orientation;
    private final float[] rMat;

    // Alternative sensors
    private final Sensor gsensor;
    private final Sensor msensor;
    private float[] mGravity = new float[3];
    private float[] mGeomagnetic = new float[3];
    private float[] R = new float[9];
    private float[] I = new float[9];

    public static void registerWith(Registrar registrar) {
        EventChannel channel = new EventChannel(registrar.messenger(), "hemanthraj/flutter_compass");
        channel.setStreamHandler(new FlutterCompassPlugin(registrar.context()));
    }

    public void onListen(Object arguments, EventSink events) {
        // Added check for the sensor, if null then the device does not have the TYPE_ROTATION_VECTOR or TYPE_GEOMAGNETIC_ROTATION_VECTOR sensor
        if(sensor != null) {
            sensorEventListener = createSensorEventListener(events);
            sensorManager.registerListener(sensorEventListener, this.sensor, SensorManager.SENSOR_DELAY_UI);
        } else if (gsensor != null && msensor != null) {
            sensorEventListener = createSensorEventListener(events);
            sensorManager.registerListener(sensorEventListener, this.gsensor, SensorManager.SENSOR_DELAY_UI);
            sensorManager.registerListener(sensorEventListener, this.msensor, SensorManager.SENSOR_DELAY_UI);
        } else {
            // Send null to Flutter side
            events.success(null);
            // events.error("Sensor Null", "No sensor was found", "The device does not have any sensor");
        }
    }

    public void onCancel(Object arguments) {
        this.sensorManager.unregisterListener(this.sensorEventListener);
    }

    private SensorEventListener createSensorEventListener(final EventSink events) {
        return new SensorEventListener() {
            public void onAccuracyChanged(Sensor sensor, int accuracy) {
                lastAccuracy = accuracy;
            }

            public void onSensorChanged(SensorEvent event) {
                boolean newVal = false;

                if (event.sensor.getType() == Sensor.TYPE_ROTATION_VECTOR
                        || event.sensor.getType() == Sensor.TYPE_GEOMAGNETIC_ROTATION_VECTOR) {
                    SensorManager.getRotationMatrixFromVector(rMat, event.values);
                    newAzimuth = (Math.toDegrees((double) SensorManager.getOrientation(rMat, orientation)[0]) + (double) 360) % (double) 360;
                    newVal = true;
                } else { //Alternative way
                    // from (https://github.com/iutinvg/compass/blob/48347d7ab23f1bf1801791d561fb5ae452217046/app/src/main/java/com/sevencrayons/compass/Compass.java)
                    final float alpha = 0.97f;

                    synchronized (this) {
                        if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
                            mGravity[0] = alpha * mGravity[0] + (1 - alpha)
                                    * event.values[0];
                            mGravity[1] = alpha * mGravity[1] + (1 - alpha)
                                    * event.values[1];
                            mGravity[2] = alpha * mGravity[2] + (1 - alpha)
                                    * event.values[2];
                        }

                        if (event.sensor.getType() == Sensor.TYPE_MAGNETIC_FIELD) {
                            mGeomagnetic[0] = alpha * mGeomagnetic[0] + (1 - alpha)
                                    * event.values[0];
                            mGeomagnetic[1] = alpha * mGeomagnetic[1] + (1 - alpha)
                                    * event.values[1];
                            mGeomagnetic[2] = alpha * mGeomagnetic[2] + (1 - alpha)
                                    * event.values[2];
                        }

                        boolean success = SensorManager.getRotationMatrix(R, I, mGravity,
                                mGeomagnetic);
                        if (success) {
                            float orientation[] = new float[3];
                            SensorManager.getOrientation(R, orientation);
                            newAzimuth = (float) Math.toDegrees(orientation[0]); // orientation
                            newAzimuth = (newAzimuth + 360) % 360;
                            newVal = true;
                        }
                    }
                }

                if (newVal) {
                    if (currentAzimuth == null || Math.abs(currentAzimuth - newAzimuth) >= filter) {
                        currentAzimuth = newAzimuth;

                        // Compute the orientation relative to the Z axis (out the back of the device).
                        float[] zAxisRmat = new float[9];
                        SensorManager.remapCoordinateSystem(
                            rMat,
                            SensorManager.AXIS_X,
                            SensorManager.AXIS_Z,
                            zAxisRmat);
                        float[] dv = new float[3];
                        SensorManager.getOrientation(zAxisRmat, dv);
                        double azimuthForCameraMode = (Math.toDegrees((double) dv[0]) + (double) 360) % (double) 360;

                        double[] v = new double[3];
                        v[0] = newAzimuth;
                        v[1] = azimuthForCameraMode;
                        // Include reasonable compass accuracy numbers. These are not representative
                        // of the real error.
                        if (lastAccuracy == SensorManager.SENSOR_STATUS_ACCURACY_HIGH) {
                            v[2] = 15;
                        } else if (lastAccuracy == SensorManager.SENSOR_STATUS_ACCURACY_MEDIUM) {
                            v[2] = 30;
                        } else if (lastAccuracy == SensorManager.SENSOR_STATUS_ACCURACY_LOW) {
                            v[2] = 45;
                        } else {
                            v[2] = -1; // unknown
                        }
                        events.success(v);
                    }
                }
            }
        };
    }

    private FlutterCompassPlugin(Context context) {
        filter = 0.1F;
        lastAccuracy = 1; // SENSOR_STATUS_ACCURACY_LOW

        sensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
        orientation = new float[3];
        rMat = new float[9];
        Sensor defaultSensor = null;
        Sensor defaultSensor2 = null;
        if (defaultSensor == null) { //Alternative sensor
            defaultSensor = this.sensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR);
        }
        if (defaultSensor == null) { //Alternative sensor
            defaultSensor = this.sensorManager.getDefaultSensor(Sensor.TYPE_GEOMAGNETIC_ROTATION_VECTOR);
        }
        if (defaultSensor == null) { // Alternative way
            defaultSensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
            defaultSensor2 = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);
        }

        if (defaultSensor != null) {
            if (defaultSensor2 == null) {
                sensor = defaultSensor;
                gsensor = null;
                msensor = null;
            } else {
                sensor = null;
                gsensor = defaultSensor;
                msensor = defaultSensor2;
            }
        } else {
            sensor = null;
            gsensor = null;
            msensor = null;
        }
    }
}
