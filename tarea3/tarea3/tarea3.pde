import fisica.*;
import java.util.List;
import SimpleOpenNI.*;
import java.util.*;
import controlP5.*;
import ddf.minim.*;

//variable para probar el ejemplo sin el kinect.
boolean kinectConectado = false; 

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
PImage img;
// Vectores para las manos cuando se usa la alternativa del skeleton tracking.
PVector convertedRightHand;
PVector convertedLeftHand;

//setup processing.
void setup() {

  //fondo inicial negro
  background(0);

  img = loadImage("salvador.jpg");

  //resolucion
  size(1024, 768); 

  //creamos el arbol.

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

  scale(float(width)/640, float(height)/480);
  
  //controles
  cp5 = new ControlP5(this);
  cf = addControlFrame("Controladores", 520, 500);
}





//render
void draw() {

  //fondo negro
  background(0);

  // Me fijo si esta conectado el kinect en caso contrario usamos el mouse
  if (kinectConectado && context.isInit()) {
    // Actualizamos la kinect si esta presente


    context.update();

    loadPixels();
    img.loadPixels();

    int[]   userMap = context.userMap();
    int[]   depthMap = context.depthMap(); 

    int index;
    for (int x = 0; x < context.depthWidth (); x++) {
      for (int y = 0; y < context.depthHeight (); y++) {
        index = x + (y * context.depthWidth());
        int d = depthMap[index];
        if ( d > 0) {
          int userNr = userMap[index];
          if ( userNr > 0) {
            pixels[y*width+x] = img.pixels[y*width+x];
          } else {
            pixels[y*width+x] = 255 - img.pixels[y*width+x];
          }
        } else {
          pixels[y*width+x] = 255 - img.pixels[y*width+x];
        }
      }
    }



    updatePixels();
  }
}

