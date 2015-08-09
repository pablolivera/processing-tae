package uy.mgcoders.tae;

import processing.core.PApplet;

/**
 * Created by pablo on 08/08/15.
 */
public class PieChart extends PApplet {

    int[] angles = { 30, 10, 45, 35, 60, 38, 75, 67 };

    public void setup() {
        noStroke();
        noLoop();  // Run once and stop
    }

    public void draw() {
        background(100);
        pieChart(300, angles);
    }

    /**
     * A new settings() method that is called behind the scenes. This won't affect 99% of
     * people, but if you're using Processing without its preprocessor (i.e. from Eclipse
     * or similar development environment), then put any calls to size(), fullScreen(),
     * smooth(), noSmooth(), and pixelDensity() into that method.
     * https://github.com/processing/processing/wiki/Changes-in-3.0
     */
    public void settings() {
        size(640, 360);
    }

    void pieChart(float diameter, int[] data) {
        float lastAngle = 0;
        for (int i = 0; i < data.length; i++) {
            float gray = map(i, 0, data.length, 0, 255);
            fill(gray);
            arc(width/2, height/2, diameter, diameter, lastAngle, lastAngle+radians(angles[i]));
            lastAngle += radians(angles[i]);
        }
    }
}
