
import controlP5.*;
import processing.core.PApplet;

public class Tarea1Control extends PApplet {

    ControlP5 cp5;
    Object parent;
    int colorsNr;
    CheckBox checkbox;
    int velocidad = 0;

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

        cp5.addToggle("Imagen en fondo")
                .plugTo(parent, "cambiarFondo")
                .setPosition(10, 80)
                .setSize(50, 20)
                .setValue(false);

        checkbox = cp5.addCheckBox("checkBox")
                .setPosition(10, 120)
                .setSize(40, 40)
                .setItemsPerRow(3)
                .setSpacingColumn(30)
                .setSpacingRow(20)
                .addItem("4", 4)
                .addItem("6", 6)
                .addItem("8", 8);
        noStroke();
    }

    public void controlEvent(ControlEvent theEvent) {
        if (theEvent.isFrom(checkbox)) {
            velocidad = 0;
            for (int i = 0; i < checkbox.getArrayValue().length;i++) {
                int n = (int)checkbox.getArrayValue()[i];
                if( n == 1) {
                    velocidad += checkbox.getItem(i).internalValue();
                }
            }
        }
    }


    public void draw() {
        background(0);
        //fill(c);
    }

    public ControlP5 getCp5() {
        return cp5;
    }

    public CheckBox getCheckbox() {
        return checkbox;
    }

    public int getVelocidad() {
        return velocidad;
    }
}

