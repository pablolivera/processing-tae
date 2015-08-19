package uy.mgcoders.tae;

import controlP5.ControlP5;
import processing.core.PApplet;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by pablo on 15/08/15.
 */
public class Tarea1Control extends PApplet {

    ControlP5 cp5;
    Object parent;
    int colorsNr;

    // dimensiones de la pantalla del control
    int sizeW;
    int sizeH;

    public Tarea1Control() {
    }

    public Tarea1Control(Object parent, int sizeW, int sizeH, int colorsNr) {
        this.parent = parent;
        this.sizeW = sizeW;
        this.sizeH = sizeH;
        this.colorsNr = colorsNr;
    }

    public void setup() {
        size(sizeW, sizeH);
        frameRate(25);
        cp5 = new ControlP5(this);

        // Controlar la cantidad de barras a mostrar
        cp5.addSlider("Numero de barras")
                .plugTo(parent,"colorsNr")
                .setRange(1, colorsNr)
                .setValue(colorsNr)
                .setPosition(10, 10);

        // Invierte la forma de pintar
        cp5.addToggle("Invertir Barras")
                .plugTo(parent, "toSwitch")
                .setPosition(10, 40)
                .setSize(50, 20)
                .setValue(false);

        // Controles para cambiar colores de las barras
        /*List l = new ArrayList();
        for(int i = 1; i <= colorsNr; i++) {
            l.add(String.valueOf(i));
        }

        cp5.addScrollableList("colores")
                .setPosition(10, 90)
                .plugTo(parent,"index")
                .setSize(200, 100)
                .setBarHeight(20)
                .setItemHeight(20)
                .addItems(l)
                .close();

        cp5.addColorWheel("color", 10, 140, 200)
                .setRGB(color(128, 0, 255));*/

        noStroke();
    }

    public void draw() {
        background(0);
        //fill(c);
    }

    public ControlP5 getCp5() {
        return cp5;
    }

}
