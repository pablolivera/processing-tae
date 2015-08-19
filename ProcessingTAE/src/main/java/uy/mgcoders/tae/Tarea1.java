package uy.mgcoders.tae;

import controlP5.ControlP5;
import processing.core.PApplet;
import SimpleOpenNI.*;
import processing.core.PVector;

import java.awt.*;

/**
 * Created by raul on 10/08/15.
 */
public class Tarea1 extends PApplet {

    // dimensiones de la pantalla del sketch
    int sizeW = 800;
    int sizeH = 600;
    double scale = sizeW / 640;
    double barraAnterior = 0;

    // dimensiones de la pantalla del sketch de los controles
    int sizeCW = 250;
    int sizeCH = 400;

    SimpleOpenNI  context;
    PVector com = new PVector();
    PVector com2d = new PVector();
    ControlP5 cp5;
    Tarea1Control tarea1Control;

    int[] userClr = { color(255,0,0),
            color(0,255,0),
            color(0,0,255),
            color(255,255,0),
            color(255,0,255),
            color(0,255,255)
    };

    // aca estan los colores de las barras
    // definidos en el colorMode RGB -> https://processing.org/reference/colorMode_.html
    // color( R, G, B)
    int[] color_bars = {
            color(192,192,192),
            color(192,192,0),
            color(0,192,192),
            color(0,192,0),
            color(192,0,192),
            color(192,0,0),
            color(0,0,192)
    };

    int[] color_bars_in = {
            color(255 - 192,255 - 192,255 - 192),
            color(255 - 192,255 - 192,255 - 0),
            color(255 - 0,255 - 192,255 - 192),
            color(255 - 0,255 - 192,255 - 0),
            color(255 - 192,255 - 0,255 - 192),
            color(255 - 192,255 - 0,255 - 0),
            color(255 - 0,255 - 0,255 - 192)
    };

    // aca se guarda el nro total de los colores definidos
    int colorsNr = color_bars.length;

    boolean toSwitch = false;
    int index = 1;

    // esta funcion se ejecuta una vez sola, al principio
    public void setup(){
        size(sizeW, sizeH);

        cp5 = new ControlP5(this);
        tarea1Control = addControlFrame("Controladores", sizeCW, sizeCH, colorsNr);

        context = new SimpleOpenNI(this);
        if(context.isInit() == false)
        {
            println("Can't init SimpleOpenNI, maybe the camera is not connected!");
            exit();
            return;
        }

        // enable depthMap generation
        context.enableDepth();

        // enable skeleton generation for all joints
        context.enableUser();

        background(255);

        noStroke();
        smooth();
    }

    public void draw() {
        // update the cam
        context.update();

        // draw the skeleton if it's available
        int[] userList = context.getUsers();
        for(int i = 0; i < userList.length; i++) {
            /*if(context.isTrackingSkeleton(userList[i])) {
                stroke(userClr[ (userList[i] - 1) % userClr.length ] ); // Dibuja lineas
                drawSkeleton(userList[i]);
            }*/

            if(context.getCoM(userList[i], com)) {
                context.convertRealWorldToProjective(com, com2d);
                //drawCenterOfMass(userList, i);
            }
        }

        // la funcion que creamos para dibujar el fondo ruidoso
        createNoisyBackground();
        // la funcion que dibuja las barras de colores
        // le pasamos la cantidad de barras que queremos dibujar
        drawTv(colorsNr);
    }

    void createNoisyBackground() {
        // una función ya dada que carga los datos de los píxeles de la pantalla de visualización en el pixels [] array
        // siempre debe ser llamada antes de leer o escribir en pixels [].
        loadPixels();

        // recorremos todos los pixeles
        for (int i = 0; i < pixels.length; i++) {
            // y si el numero que fue "sorteado" en la funcion random(x) es mayor de 50 el pixel va a ser blanco
            if(random(100)>50) pixels[i] = color(255);
                // en el caso contrario, sera negro
            else pixels[i] = color(40);
        }
        // una función ya dada que actualiza la ventana de la pantalla con los datos de los pixels [] array
        updatePixels();
    }

    void drawTv( int bars_nr) {
        // definimos el ancho de las barras
        // por el tema del redondeo hacemos +1 para cubrir toda la pantalla
        int bar_width = width / bars_nr + 1;

        double posX = com2d.x;
        if(Double.isNaN(posX) || posX < 0 || posX > 640) {
            posX = barraAnterior;
        }
        else {
            barraAnterior = posX;
        }

        int whichBar = (int)((posX * scale) / bar_width);

        // dibujamos las barras
        for (int i = 0; i < bars_nr; i ++) {
            if((!toSwitch && whichBar != i) || (toSwitch && whichBar == i)) {
                fill(color_bars[i % colorsNr]);
                rect(i * bar_width, 0, bar_width, height);
            }

        }
    }

    Tarea1Control addControlFrame(String name, int width, int height, int colorsLength) {
        Frame frame = new Frame(name);
        Tarea1Control control = new Tarea1Control(this, width, height, colorsLength);
        frame.add(control);
        control.init();
        frame.setTitle(name);
        frame.setSize(control.sizeW, control.sizeH);
        frame.setLocation(100, 100);
        frame.setResizable(false);
        frame.setVisible(true);
        return control;
    }


    /**********************
     *
     * FUNCIONES AUXILIARES
     *
     **********************/

    void drawCenterOfMass(int[] userList, int i) {
        stroke(100, 255, 0);
        strokeWeight(1);
        beginShape(LINES);
        float posx = com2d.x * (float)scale;
        float posy = com2d.y * (float)scale;
        vertex(posx, posy - 5);
        vertex(posx, posy + 5);

        vertex(posx - 5, posy);
        vertex(posx + 5, posy);
        endShape();

        System.out.println("x: " + posx + " ###  y: " + posy);

        fill(0, 255, 100);
        text(Integer.toString(userList[i]), com2d.x, com2d.y);
    }

    // draw the skeleton with the selected joints
    void drawSkeleton(int userId) {

        context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

        context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
        context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
        context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

        context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
        context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
        context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

        context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
        context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

        context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
        context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
        context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

        context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
        context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
        context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
    }

    // -----------------------------------------------------------------
    // SimpleOpenNI events

    public void onNewUser(SimpleOpenNI curContext, int userId) {
        System.out.println("onNewUser - userId: " + userId);
        System.out.println("\tstart tracking skeleton");
        curContext.startTrackingSkeleton(userId);
    }

    public void onLostUser(SimpleOpenNI curContext, int userId) {
        System.out.println("onLostUser - userId: " + userId);
    }

    public void onVisibleUser(SimpleOpenNI curContext, int userId) {
        //System.out.println("onVisibleUser - userId: " + userId);
    }

    public void keyPressed() {
        switch(key)
        {
            case ' ':
                context.setMirror(!context.mirror());
                break;
        }
    }

}
