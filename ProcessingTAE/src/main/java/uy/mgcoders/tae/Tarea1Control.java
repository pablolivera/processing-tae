package uy.mgcoders.tae;

import controlP5.ControlP5;
import processing.core.PApplet;

/**
 * Created by pablo on 15/08/15.
 */
public class Tarea1Control extends PApplet {

    ControlP5 cp5;
    Object parent;
    // dimensiones de la pantalla del control
    int sizeW;
    int sizeH;

    public Tarea1Control() {
    }

    public Tarea1Control(Object parent, int sizeW, int sizeH) {
        this.parent = parent;
        this.sizeW = sizeW;
        this.sizeH = sizeH;
    }

    public void setup() {
        size(sizeW, sizeH);
        frameRate(25);
        cp5 = new ControlP5(this);

        // Sustituir num por el nombre de la variable de parent que se desee controlar
        cp5.addSlider("Numero de brazos")
                .plugTo(parent,"num")
                .setRange(2, 6)
                .setPosition(10,10);

    }

    public void draw() {
        background(0);
    }

    public ControlP5 getCp5() {
        return cp5;
    }

}
