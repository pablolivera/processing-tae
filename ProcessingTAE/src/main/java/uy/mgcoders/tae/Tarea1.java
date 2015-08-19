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
    double scale = 1.25;
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


    int circleX;
    int circleY;
    int directionX = 4; // "velocidad" pixeles que se mueve en cada pasada de draw
    int myWidth = 640;


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


        circleX = width/2;
        circleY = height/2;
/*
        stroke(100, 255, 0);
        strokeWeight(3);
        //noStroke();
        beginShape(LINES);
        vertex(320, 240 - 5);
        vertex(320, 240 + 5);

        vertex(320 - 5, 240);
        vertex(320 + 5, 240);
        endShape();*/
    }

    // esta funcion se ejecuta todo el tiempo en un loop constante
    public void draw() {
        //System.out.println(index);

        // update the cam
        context.update();

        // la funcion que creamos para dibujar el fondo ruidoso
        createNoisyBackground();
        // la funcion que dibuja las barras de colores
        // le pasamos la cantidad de barras que queremos dibujar
        drawTv(colorsNr);

        scale((float)scale);
        // draw depthImageMap
        //image(context.depthImage(),0,0);
        //image(context.userImage(),0,0);

        // draw the skeleton if it's available
        int[] userList = context.getUsers();
        for(int i=0;i<userList.length;i++) {
            if(context.isTrackingSkeleton(userList[i])) {
                //stroke(userClr[ (userList[i] - 1) % userClr.length ] ); // Dibuja lineas
                drawSkeleton(userList[i]);
            }

            // draw the center of mass
            if(context.getCoM(userList[i],com)) {
                context.convertRealWorldToProjective(com, com2d);
                if(Double.isNaN(com2d.x) || com2d.x < 0 || com2d.x > 640) {
                    myWidth = 800;
                }
                else
                    myWidth = (int)(com2d.x * (float)scale);
                /*stroke(100, 255, 0);
                strokeWeight(1);
                //noStroke();
                beginShape(LINES);
                float posx = com2d.x * (float)scale;
                float posy = com2d.y * (float)scale;
                vertex(posx, posy - 5);
                vertex(posx, posy + 5);

                vertex(posx - 5, posy);
                vertex(posx + 5, posy);
                endShape();*/
                //System.out.println("2d " + posx + "  ####  " + posy);

                //fill(0, 255,100);
                //text(Integer.toString(userList[i]), com2d.x, com2d.y);
            }
        }
        // Para el circulo que se mueve
        fill(200, 0, 150);
        ellipse(circleX, circleY, 100, 100);

        if( circleX > myWidth || circleX < 0){
            directionX = -1 * directionX;
        }
        circleX = circleX + directionX;


    }

    // draw the skeleton with the selected joints
    void drawSkeleton(int userId) {
            // to get the 3d joint data
      /*
      PVector jointPos = new PVector();
      context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
      println(jointPos);
      */

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
        //println("onVisibleUser - userId: " + userId);
    }


    public void keyPressed() {
        switch(key)
        {
            case ' ':
                context.setMirror(!context.mirror());
                break;
        }
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
            if(whichBar != i) { //(!toSwitch && whichBar != i) || (toSwitch && whichBar == i)
                if(toSwitch)
                    fill(color_bars_in[i%colorsNr]);
                else
                    fill(color_bars[i%colorsNr]);
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

}
