package uy.mgcoders.tae;


import controlP5.ControlP5;
import processing.core.PApplet;

import java.awt.*;

/**
 * Created by pablo on 15/08/15.
 */
public class Caleidoscopio extends PApplet {

    private ControlP5 cp5;

    ControlFrame cf;

    // color del fondo (0-255)
    int backCol;
    //numero de los brazos (y la profundidad) del fractal
    int num;
    // para modelar el tamano de los circulos
    int extraAdd;

    //define que tanto se acerca al centro la "apertura" de cada parte del fractal
    float power = 4;
    //angulo de la apertura
    float angle = TWO_PI;
    // define
    boolean toSwitch = true;


    public void setup() {
        size(1024, 768);
        cp5 = new ControlP5(this);
        cf = addControlFrame("Controladores", 250,200);
        backCol = 0;
        num = 6;
        extraAdd =0;
    }

    public void draw() {
        if(toSwitch){
            background(backCol); // wipe the background
            fill(255-backCol,100);
            stroke(255-backCol,100);
        }
        else {
            background(255-backCol);
            fill(backCol,100);
            stroke(backCol,100);
        }

        // la apertura del fractal cambia segun la posicion x
        // cerca del centro = abierto
        // lejos del centro = cerrado
        angle = TWO_PI * (width/2 - abs(width/2 -mouseX))/width;

        // acerca las aperturas al centro si nos paramos en la mitad de la altura
        power = abs(height/2 -mouseY)*1/50;

        pushMatrix();
        // movemos al centro
        translate(width/2, height/2);
        // rotacion por defecto
        rotate(map(frameCount%1000,0,1000,0 ,2*PI));
        // dibujamos el fractal pasando "la profundidad"
        plotFrac(0,0,num,PI,TWO_PI);
        popMatrix();
    }

    void plotFrac( float x, float y, int n, float stem, float range ) {

        float r; // distancia entre nodos
        float t; // angulo entre nodos
        // calcula la distancia entre nodod
        r = (power/2+2) * 45 * pow(n,power) * pow(num,-power);
        // dibuja el circulo en el medio del fractal
        if( n == num ) {
            ellipse(x,y,n+extraAdd,n+extraAdd);
        }

        if( n>1 ) {
            //dibujamos cada nodo
            for( int i=0; i<n; i++ ) {
                // calculamos el angulo
                t = stem + range * (i+1/2)/n - range/2;
                // dibujamos la linea
                line( x, y, x+r*cos(t), y+r*sin(t) );
                // dibujamos el circulo
                ellipse(x+r*cos(t), y+r*sin(t), n+extraAdd, n+extraAdd);

                // spread nodes across PI radians
                plotFrac(x+r*cos(t),y+r*sin(t),n-1,t,PI);

                // spread nodes across "angle" radians
                //plotFrac(x+r*cos(t),y+r*sin(t),n-1,t,angle);
            }
        }
    }

    ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
        Frame f = new Frame(theName);
        ControlFrame p = new ControlFrame(this, theWidth, theHeight);
        f.add(p);
        p.init();
        f.setTitle(theName);
        f.setSize(p.w, p.h);
        f.setLocation(100, 100);
        f.setResizable(false);
        f.setVisible(true);
        return p;
    }

}
