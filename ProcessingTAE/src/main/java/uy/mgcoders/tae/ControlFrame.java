package uy.mgcoders.tae;

import controlP5.ControlP5;
import processing.core.PApplet;

/**
 * Created by pablo on 15/08/15.
 */
public class ControlFrame extends PApplet {

    int w, h;
    ControlP5 cp5;
    Object parent;

    public void setup() {
        size(w, h);
        frameRate(25);
        cp5 = new ControlP5(this);

        cp5.addSlider("Numero de brazos")
                .plugTo(parent,"num")
                .setRange(2, 6)
                .setPosition(10,10);
        cp5.addSlider("Color de fondo")
                .plugTo(parent,"backCol")
                .setRange(0, 255)
                .setPosition(10,30);
        cp5.addSlider("Tamano de los circulos")
                .plugTo(parent,"extraAdd")
                .setRange(0, 45)
                .setPosition(10,50);
        cp5.addToggle("Cambio de colores")
                .plugTo(parent,"toSwitch")
                .setPosition(10,70)
                .setSize(50,20)
                .setValue(true);
    }
    public void draw() {
        background(0);
    }

    private ControlFrame() {
    }

    public ControlFrame(Object theParent, int theWidth, int theHeight) {
        parent = theParent;
        w = theWidth;
        h = theHeight;
    }

    public ControlP5 control() {
        return cp5;
    }
}
