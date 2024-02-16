package com.hemanthraj.fluttercompass.util

import java.util.GregorianCalendar
import kotlin.math.atan2
import kotlin.math.sqrt

object CompassHelper {
    //0 ≤ ALPHA ≤ 1
    //smaller ALPHA results in smoother sensor data but slower updates
    private const val ALPHA = 0.15f
    fun calculateHeading(accelerometerReading: FloatArray, magnetometerReading: FloatArray): Float {
        var Ax = accelerometerReading[0]
        var Ay = accelerometerReading[1]
        var Az = accelerometerReading[2]
        val Ex = magnetometerReading[0]
        val Ey = magnetometerReading[1]
        val Ez = magnetometerReading[2]

        //cross product of the magnetic field vector and the gravity vector
        var Hx = Ey * Az - Ez * Ay
        var Hy = Ez * Ax - Ex * Az
        var Hz = Ex * Ay - Ey * Ax

        //normalize the values of resulting vector
        val invH = 1.0f / sqrt((Hx * Hx + Hy * Hy + Hz * Hz).toDouble()).toFloat()
        Hx *= invH
        Hy *= invH
        Hz *= invH

        //normalize the values of gravity vector
        val invA = 1.0f / sqrt((Ax * Ax + Ay * Ay + Az * Az).toDouble()).toFloat()
        Ax *= invA
        Ay *= invA
        Az *= invA

        //cross product of the gravity vector and the new vector H
        val Mx = Ay * Hz - Az * Hy
        val My = Az * Hx - Ax * Hz
        val Mz = Ax * Hy - Ay * Hx

        //arctangent to obtain heading in radians
        return atan2(Hy.toDouble(), My.toDouble()).toFloat()
    }

    fun calculateMagneticDeclination(latitude: Double, longitude: Double, altitude: Double): Float {
        val geoMag = TSAGeoMag()
        return geoMag
                .getDeclination(latitude, longitude, geoMag.decimalYear(GregorianCalendar()), altitude).toFloat()
    }

    fun convertRadtoDeg(rad: Float): Float {
        return (rad / Math.PI).toFloat() * 180
    }

    //map angle from [-180,180] range to [0,360] range
    fun map180to360(angle: Float): Float {
        return (angle + 360) % 360
    }

    fun lowPassFilter(input: FloatArray, output: FloatArray?): FloatArray {
        if (output == null) return input
        for (i in input.indices) {
            output[i] = output[i] + ALPHA * (input[i] - output[i])
        }
        return output
    }
}
