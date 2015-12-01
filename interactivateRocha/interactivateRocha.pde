import SimpleOpenNI.*;
SimpleOpenNI context;

import java.awt.Frame;
import controlP5.*;
ControlP5 cp5;
ControlFrame cf;

import punktiert.math.Vec;
import punktiert.physics.*;


// dancer position vector
PVector dPos;
boolean hasDancers = false;
// para parar la ejecuccion de draw durante del cambio de las escenas
boolean stopDraw = false;

// para cambiar fluidamente entre las escenas
SceneManager manager;

// Escena 1
int strokeCol;
boolean inColor = false;
int sWeight;
int displaceMagnitude;
// Escena 2
int sWeightFluid;
boolean gravity;
boolean lines;
boolean reject;
int influenceRadius;
int lineTransparency;
int backColFluid;
// Escena 3
PGraphics pg;
int generationFrequency;
// radio minimo y maximo de las nuevas particulas que se crea
int rMin, rMax;
boolean generateNewPoints;
int attractionRadius;
boolean showAttractionRadius;
// transparencia de los puntos creados
int pointTransparency;
// referencia cromatica del color de los puntos y del fondo
int pointsColorHands;
int backColorHands;
float attractionStrength;

// Escena 4
int meTvTransparency;
PImage backPic;

void setup(){
  size(1024, 768,P3D);
  pg = createGraphics(width, height);
  noCursor();

  cf = addControlFrame("Controladores", 450,700);
  backPic = loadImage("circulos640x480.jpg");

  manager = new SceneManager();  
  frameRate(120);

  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  context.enableDepth();
  context.enableUser();

  

  println("READY TO GO");
}


void draw(){
  if(!stopDraw) manager.actualScene.drawScene(); 
}

void keyPressed(){
  // para cambiar las escenas manualmente
  if (key == '-') manager.activatePrevScene();
  if (key == '=') manager.activateNextScene();

}

// modo pantalla entera
boolean sketchFullScreen() {   return true; }


