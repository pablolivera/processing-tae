package uy.mgcoders.tae;

import SimpleOpenNI.SimpleOpenNI;
import processing.core.PApplet;
import processing.core.PVector;

/**
 * Created by pablo on 17/08/15.
 */
public class BasicPong extends PApplet {

    // dimensiones de la pantalla del sketch
    int sizeW = 800;
    int sizeH = 600;

    int circleX;
    int circleY;
    int directionX = 4; // "velocidad" pixeles que se mueve en cada pasada de draw

    SimpleOpenNI context;
    PVector com = new PVector();
    PVector com2d = new PVector();

    public void setup() {
        size(sizeW, sizeH);

        circleX = width/2;
        circleY = height/2;

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

    }

    public void draw() {

        background(100,100,100); // restear fondo

        context.update();

        // draw the skeleton if it's available
        int[] userList = context.getUsers();
        for(int i = 0; i < userList.length; i++) {
            if(context.getCoM(userList[i], com)) {
                context.convertRealWorldToProjective(com, com2d);
            }
        }

        double posX = com2d.x;
        if(Double.isNaN(posX) || posX <= 0 || posX > 640 || posX < 200) {
            posX = sizeW;
        }
        System.out.println(posX);

        // Para el circulo que se mueve
        fill(200, 0, 150);
        ellipse(circleX, circleY, 100, 100);

        if( circleX > (posX * 1.25) || circleX < 0){
            directionX = -1 * directionX;
        }
        circleX = circleX + directionX;

    }


}
