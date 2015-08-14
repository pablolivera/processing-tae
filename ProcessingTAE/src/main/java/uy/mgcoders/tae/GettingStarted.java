package uy.mgcoders.tae;

import processing.core.PApplet;
import processing.core.PImage;

public class GettingStarted extends PApplet {

    // dimensiones de la pantalla del sketch
    int sizeW = 800;
    int sizeH = 600;

    int circleX;
    int circleY;
    int directionX = 4; // "velocidad" pixeles que se mueve en cada pasada de draw

    PImage img;

    boolean drawEllipse;

    public void setup() {
        size(sizeW, sizeH);

        img = loadImage("Flower.png");

        drawEllipse = false;


        circleX = width/2;
        circleY = height/2;
    }

    public void draw() {

        background(100,100,100); // restear fondo

        image(img, 2, 2);

        noFill();
        stroke(0, 255, 0);
        rect(500, 500, 100, 100);

        stroke(255, 0, 0);
        ellipse(500, 400, 100, 100);

        // Para el circulo que se mueve
        fill(200, 0, 150);
        ellipse(circleX, circleY, 100, 100);

        if( circleX > width || circleX < 0){
            directionX = -1 * directionX;
        }
        circleX = circleX + directionX;

        // el circulo que muestra/oculta con keypressed
        if(drawEllipse) {
            stroke(255, 0, 0);
            fill(255, 0, 0);
            ellipse(400, 350, 50, 50);
        }

        textSize(42);
        text("pressing a key...", 10, 100);

    }

    public void keyPressed() {
        drawEllipse = drawEllipse ? false : true;
    }

}
