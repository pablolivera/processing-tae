import fisica.*;
import java.util.List;
import SimpleOpenNI.*;
import java.util.*;
import controlP5.*;
import ddf.minim.*;

//variable para probar el ejemplo sin el kinect.
boolean kinectConectado = false; 
PVector com = new PVector();
PVector com2d = new PVector();

//controles
ControlP5 cp5;
ControlFrame cf;
boolean toSwitch = false;      //indica cambio de escena.
boolean estrellas = false;
boolean movimiento = false;
boolean bigbang = false;
boolean galaxia = false;
boolean end = false;


//kinect
SimpleOpenNI  context = null;
float fact;                           //variable con el factor para escalar la imagen del kinect.
List<PVector> puntosBordeList;        //Lista con los puntos de borde superiores del user. Escalado por fact.
boolean tracking = false;             //true cuando se esta trackeando a un usuario. 
int aumento = 0;                      //pixeles extra al dibujar el contorno.

// Vectores para las manos cuando se usa la alternativa del depth map.
PVector firstHand = new PVector();    
PVector secondHand = new PVector();
// Vectores para las manos cuando se usa la alternativa del skeleton tracking.
PVector convertedRightHand;
PVector convertedLeftHand;

//Cosas para el fondo

float cx; 
float cy; //center
int Rmax=50; // galaxy radius
float eratio=.85; // ellipse ratio
float etwist=8.0/Rmax; // twisting factor (orbit axes depend on radius)

//PImage img;

boolean inicializado = false;
int cant = 0;

ManejadorEscenas manejador;
boolean stopDraw = false;

//setup processing.
void setup() {

  //Manejador Escenas
  manejador = new ManejadorEscenas();
  manejador.actual.setupEscena();

  //fondo inicial negro
  background(0);

  //resolucion
  size(1024, 768); 

  //controlo que este conectada la camara
  if (kinectConectado) {
    context = new SimpleOpenNI(this);
    if (context.isInit() == false)
    {
      println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
      exit();
      return;
    }

    //hay que habilitar estas dos opciones para poder usar la funcion userImage()
    context.enableDepth();
    context.enableUser();
  }

  //el factor lo definimos dividiendo el ancho del proyector, por el ancho de la imagen de la kinect
  fact = float(width)/640;

  //bordes anti alias
  smooth();

  //controles
  cp5 = new ControlP5(this);
  cf = addControlFrame("Controladores", 520, 500);
}





//render
void draw() {

  //fondo negro
  background(0);

  if (!stopDraw) manejador.actual.drawEscena();

  // Me fijo si esta conectado el kinect en caso contrario usamos el mouse
  if (kinectConectado && context.isInit()) {
    // Actualizamos la kinect si esta presente
    context.update();

    // draw the skeleton if it's available
    int[] userList = context.getUsers();
    if ((userList.length > 0) && context.getCoM(userList[0], com)) {
      context.convertRealWorldToProjective(com, com2d);
      cx = com2d.x * (float)fact;
      cy = com2d.y * (float)fact;
      
      //drawCenterOfMass(userList, 0);
    }

    int[]   userMap = context.userMap();
    int[]   depthMap = context.depthMap(); 

    int index;
    for (int xb = 0; xb < context.depthWidth (); xb+=10) {
      for (int yb = 0; yb < context.depthHeight (); yb+=10) {
        index = xb + (yb * context.depthWidth());

        int d = depthMap[index];

        if ( d > 0) {
          int userNr = userMap[index];

          if ( userNr > 0) {

            //DENTRO DEL USUARIO relleno de negro para que tape la escena? esto no va con lo de la imagen.
            stroke(0);
            fill(0);
            ellipse(xb*fact, yb*fact, 20, 20);

            // cx = com2d.x * (float)fact; //width/2;
            //cy = com2d.y * (float)fact; // height/2;
            //inicializado = true;
          } else {
            //RESTO
            //println("entro no se que es esto");
            //inicializado = false;
          }
        } else {
          //RESTO
          //inicializado = false;
          //println("entro estrellas");
        }
      }
    }
  }
  else {
    cx = mouseX;
    cy = mouseY;
  }
}


void drawCenterOfMass(int[] userList, int i) {
  //background(255);
  stroke(100, 255, 0);
  strokeWeight(1);
  beginShape(LINES);
  float posx = com2d.x * (float)fact;
  float posy = com2d.y * (float)fact;
  vertex(posx, posy - 5);
  vertex(posx, posy + 5);

  vertex(posx - 5, posy);
  vertex(posx + 5, posy);
  endShape();

  //System.out.println("x: " + com2d.x + " ###  y: " + com2d.y);
  System.out.println("x: " + posx + " ###  y: " + posy);

  //fill(0, 255, 100);
  //text(Integer.toString(userList[i]), com2d.x, com2d.y);
}



