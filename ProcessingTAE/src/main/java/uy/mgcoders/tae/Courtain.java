package uy.mgcoders.tae;

import com.sun.xml.internal.bind.v2.schemagen.xmlschema.Particle;
import processing.core.PApplet;
import processing.core.PFont;
import processing.core.PGraphics;
import processing.core.PVector;

import java.util.ArrayList;

/**
 * Created by raul on 17/08/15.
 */
public class Courtain extends PApplet{

    int elapsedFrames = 0;
    ArrayList points = new ArrayList();
    boolean drawing = false;

    public void setup(){
        smooth();
        size(600,600);

        background(255);
    }

    public void draw(){
        if(drawing == true){
            PVector pos = new PVector();
            pos.x = mouseX;
            pos.y = mouseY;

            PVector vel = new PVector();
            vel.x = (0);
            vel.y = (0);

            Point punt = new Point(pos, vel, 1000);
            points.add(punt);
        }


        for(int i = 0; i < points.size(); i++){
            Point localPoint = (Point) points.get(i);
            if(localPoint.isDead == true){
                points.remove(i);
            }
            localPoint.update();
            localPoint.draw();
        }

        elapsedFrames++;
    }


    public void keyPressed(){
        if(key == ' '){
            for(int i = 0; i < points.size(); i++){
                Point localPoint = (Point) points.get(i);
                localPoint.isDead = true;
            }
            noStroke();
            fill(255);
            rect(0, 0, width, height);
        }
    }

    public  void mousePressed(){
        drawing = true;
    }

    public void mouseReleased(){
        drawing = false;
    }



    class Point{

        PVector pos, vel, noiseVec;
        float noiseFloat, lifeTime, age;
        boolean isDead;

        public Point(PVector _pos, PVector _vel, float _lifeTime){
            pos = _pos;
            vel = _vel;
            lifeTime = _lifeTime;
            age = 0;
            isDead = false;
            noiseVec = new PVector();
        }

        void update(){
            noiseFloat = noise(pos.x * 0.0025f, pos.y * 0.0025f, elapsedFrames * 0.001f);
            noiseVec.x = cos(((noiseFloat -0.8f) * TWO_PI) * 120f);
            noiseVec.y = sin(((noiseFloat - 0.8f) * TWO_PI) * 120f);

            vel.add(noiseVec);
            vel.div(2);
            pos.add(vel);

            if(1.0-(age/lifeTime) == 0){
                isDead = true;
            }

            if(pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height){
                isDead = true;
            }

            age++;
        }

        void draw(){
            fill(0,20);
            noStroke();
            ellipse(pos.x, pos.y, 1-(age/lifeTime), 1-(age/lifeTime));
        }
    };




}
