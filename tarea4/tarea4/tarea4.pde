import fisica.*;
import java.util.List;
import SimpleOpenNI.*;
import java.util.*;
import controlP5.*;
import ddf.minim.*;
import processing.video.*;

//variable para probar el ejemplo sin el kinect.
boolean kinectConectado = false; 
PVector com = new PVector();
PVector com2d = new PVector();


//controles
ControlP5 cp5;
ControlFrame cf;
boolean toSwitch = false;      //indica cambio de escena.

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

//Coordenadas centro de masa
float cx; 
float cy; 

//para ver silueta
boolean debugBody;

ManejadorEscenas manejador;
boolean stopDraw = false;

void setup() {

  // Manejador Escenas
  manejador = new ManejadorEscenas();

  //fondo inicial negro
  background(0);

  //resolucion
  size(1024, 768); 

  //controlo que este conectada la camara
  if (kinectConectado) {
    context = new SimpleOpenNI(this);
    context.setMirror(false);

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

  	if (!stopDraw && manejador.actual!=null) {
  		manejador.actual.drawEscena();
  	}

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
        	// Busca las manos y si las encuentra llama a drawHand para dibujarlas, esto usa skeleton tracking.
        	if (context.isTrackingSkeleton(userList[0])) {
          		drawHand(userList[0]);
          	}
      	}

      	int[]   userMap = context.userMap();
      	int[]   depthMap = context.depthMap(); 

      	// El for del kinnect para tapar la silueta.
      	int index;
      	if (debugBody) {
        	for (int xb = 0; xb < context.depthWidth (); xb+=10) {
          		for (int yb = 0; yb < context.depthHeight (); yb+=10) {
            		index = xb + (yb * context.depthWidth());

            		int d = depthMap[index];

            		if ( d > 0) {
              			int userNr = userMap[index];
              			if ( userNr > 0) {
                			//Ver la silueta
                			noStroke();
			                fill(178);
                			ellipse(xb*fact, yb*fact, 15, 15);
              			}
            		}
          		}
        	}
      	}
	} 
    else { // Si no tenemos el kinect usamos el mouse
      cx = mouseX;
      cy = mouseY;
      convertedRightHand = new PVector();
      convertedRightHand.x = mouseX;
      convertedRightHand.y = mouseY;
      convertedLeftHand = new PVector();
      convertedLeftHand.x = mouseX;
      convertedLeftHand.y = mouseY;
    }
 }

 // Dibuja las manos, esto usa skeleton tracking.
void drawHand(int userId) {

  PVector rightHand = new PVector(); 
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, rightHand);  
  convertedRightHand = new PVector();
  context.convertRealWorldToProjective(rightHand, convertedRightHand);
  // Se escala la coordenada.
  convertedRightHand.x = convertedRightHand.x * fact;
  convertedRightHand.y = convertedRightHand.y  * fact;


  PVector leftHand = new PVector(); 
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, leftHand);
  convertedLeftHand = new PVector();
  context.convertRealWorldToProjective(leftHand, convertedLeftHand);
  convertedLeftHand.x = convertedLeftHand.x  * fact;
  convertedLeftHand.y = convertedLeftHand.y * fact;

  if (debugBody) {
    fill(255, 0, 30);
    ellipse( convertedRightHand.x, convertedRightHand.y, 40, 40);
    fill(0, 255, 30);
    ellipse(convertedLeftHand.x, convertedLeftHand.y, 40, 40); // Se escala la coordenada.
    println("Hand left :"+convertedLeftHand.x+","+convertedLeftHand.y);
    println("Hand right :"+convertedRightHand.x+","+convertedRightHand.y);
  }
}

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  context.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}
