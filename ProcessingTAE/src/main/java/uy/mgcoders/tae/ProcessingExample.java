package uy.mgcoders.tae;

import processing.core.PApplet;

/**
 * Created by pablo on 08/08/15.
 */
public class ProcessingExample extends PApplet {

    public void setup() {
        background(0);
    }

    public void draw() {
        stroke(255);
        if(mousePressed) {
            line(mouseX, mouseY, pmouseX, pmouseY);
        }
    }

    /**
     * A new settings() method that is called behind the scenes. This won't affect 99% of
     * people, but if you're using Processing without its preprocessor (i.e. from Eclipse
     * or similar development environment), then put any calls to size(), fullScreen(),
     * smooth(), noSmooth(), and pixelDensity() into that method.
     * https://github.com/processing/processing/wiki/Changes-in-3.0
     */
    public void settings() {
        size(400, 400);
    }
}
