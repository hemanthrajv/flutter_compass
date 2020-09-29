package com.lukepighetti.compass;

import java.util.ArrayDeque;

// This is a copy-pasta from https://stackoverflow.com/a/18911252/1130342
//
// It uses trig functions to convert radians into a vector, thus avoiding
// angle toggles (ie NW => NE, NE => NW). It then averages the vector components
// over LENGTH iterations, and then uses trig to pull it back into a radian value.
public class AngleLowpassFilter {
    private final int LENGTH = 10;
    private float sumSin, sumCos;
    private ArrayDeque<Float> queue = new ArrayDeque<Float>();

    public void add(float radians) {
        sumSin += (float) Math.sin(radians);
        sumCos += (float) Math.cos(radians);

        queue.add(radians);

        if (queue.size() > LENGTH) {
            float old = queue.poll();
            sumSin -= Math.sin(old);
            sumCos -= Math.cos(old);
        }
    }

    public float average() {
        int size = queue.size();
        return (float) Math.atan2(sumSin / size, sumCos / size);
    }
}
