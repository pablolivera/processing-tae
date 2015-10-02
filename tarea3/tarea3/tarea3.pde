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




float pi=4*atan(1);

int stars=10000; // only ...
int Rmax=50; // galaxy radius
float speed=0.02;  // rotation speed

// stars follow elliptic orbits around the center
float eratio=.85; // ellipse ratio
float etwist=8.0/Rmax; // twisting factor (orbit axes depend on radius)

float []angle=new float[stars];
float []radius=new float[stars];

float cx; 
float cy; //center

PImage img;

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

  //scale(float(width)/640, float(height)/480);

  //cosas galaxy
  speed=speed/frameRate;

  // begin in the center
  //cx = width/2;
  //cy = height/2;
  // itit stars
  for (int i=0; i< stars; i++) {
    angle[i]= random(0, 2*pi);
    //radius[i]=random(1,Rmax);
    radius[i]=((abs(randomGauss())))*Rmax*0.6+0.0;
  }


  //controles
  cp5 = new ControlP5(this);
  cf = addControlFrame("Controladores", 520, 500);
}





//render
void draw() {

  //fondo negro
  background(0);
  //dibujarGalaxia();
  //e

  cant = 0;


  // Me fijo si esta conectado el kinect en caso contrario usamos el mouse
  if (kinectConectado && context.isInit()) {
    // Actualizamos la kinect si esta presente

    PVector realWorldPoint;
    context.update();

    // draw the skeleton if it's available
    int[] userList = context.getUsers();
    //for (int i = 0; i < userList.length; i++) {
    if ((userList.length > 0) && context.getCoM(userList[0], com)) {
      context.convertRealWorldToProjective(com, com2d);
      drawCenterOfMass(userList, 0);
      //ajuste
      //drawLineasAjuste(userList,i);
    }
    //}



    if (inicializado) {
      noSmooth();
      img=get();
      img.resize(round(width*0.5), round(height*0.5));
      img.resize(width-2, height-2);
      tint(245, 250, 255);
      image(img, 0, 0);
      //fill(0,8); rect(0,0,width,height);
      noStroke();
      float r, a, x, y, b, s, c, xx, yy, dd;
      for (int i=0; i< stars; i++) {
        r=radius[i];
        a=angle[i]+speed*(Rmax/r)*3.0; // increment angle
        angle[i]=a;
        x=r*sin(a);
        y=r*eratio*cos(a);
        b=r*etwist;
        s=sin(b);
        c=cos(b);
        xx=cx + s*x + c*y; // a bit of trigo
        yy=cy + c*x - s*y;
        //dd=(r-50.0)*7.0;
        dd=8000.0/r;
        fill(color(dd, dd, dd*0.9, 32));
        rect(xx-1.5, yy-1.5, 3.0, 3.0);
      }
      println("abu");
      cant++;
    }

    int[]   userMap = context.userMap();
    int[]   depthMap = context.depthMap(); 

    int index;
    for (int xb = 0; xb < context.depthWidth (); xb++) {
      for (int yb = 0; yb < context.depthHeight (); yb++) {
        index = xb + (yb * context.depthWidth());

        int d = depthMap[index];

        if ( d > 0) {
          int userNr = userMap[index];

          if ( userNr > 0) {

            //DENTRO DEL USUARIO
            //stroke(255);
            //fill(200, 234, 140);
            //point(xb*fact, yb*fact);

            cx = com2d.x * (float)fact; //width/2;
            cy = com2d.y * (float)fact; // height/2;
            inicializado = true;
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
  } else {
    //No kinect
    if(!stopDraw) manejador.actual.drawEscena();
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

  fill(0, 255, 100);
  //text(Integer.toString(userList[i]), com2d.x, com2d.y);
}

float dibujarGalaxia() {
  noSmooth();
  img=get();
  img.resize(round(width*0.5), round(height*0.5));
  img.resize(width-2, height-2);
  tint(245, 250, 255);
  image(img, 0, 0);
  //fill(0,8); rect(0,0,width,height);
  noStroke();
  float r, a, x, y, b, s, c, xx, yy, dd;
  for (int i=0; i< stars; i++) {
    r=radius[i];
    a=angle[i]+speed*(Rmax/r)*3.0; // increment angle
    angle[i]=a;
    x=r*sin(a);
    y=r*eratio*cos(a);
    b=r*etwist;
    s=sin(b);
    c=cos(b);
    xx=cx + s*x + c*y; // a bit of trigo
    yy=cy + c*x - s*y;
    //dd=(r-50.0)*7.0;
    dd=8000.0/r;
    fill(color(dd, dd, dd*0.9, 32));
    rect(xx-1.5, yy-1.5, 3.0, 3.0);
  }
  return 0.0;
}

float gauss(float x) { 
  return exp(-x*x/2.0) / sqrt(2*PI);
}
float gaussI(float z) { // integrated gauss [0..1]
  if (z<-8.0) return 0.0;
  if (z> 8.0) return 1.0;
  float sum=0.0, term=z;
  for (int i=3; sum+term!=sum; i+=2) {
    sum =sum+term;
    term=term*z*z/i;
  }
  return 0.5+sum*gauss(z);
}
float gaussE(float z) { 
  return gaussI(z)*2-1;
}// gauss error func==> [-1..0..1]
float randomGauss() {
  float x=0, y=0, r, c;
  do { 
    x=random(-1.0, 1.0);
    y=random(-1.0, 1.0);
    r=x*x+y*y;
  }
  while (r==0 || r>1);
  c=sqrt(-2.0*log(r)/r);
  return x*c; //return [x*c, y*c];
}
float randomGaussIn(float L, float H, float mul) { 
  return constrain( randomGauss()*(H-L)*mul + (L+H)/2.0, L, H);
}
float randomGaussAt(float L, float H, float mul) { 
  return            randomGauss()*(H-L)*mul + (L+H)/2.0;
}

void keyPressed() {
  if (keyCode == UP) { 
    eratio=eratio*1.02;
  }
  if (keyCode == DOWN) { 
    eratio=eratio/1.02;
  }
  if (keyCode == LEFT) { 
    etwist=etwist+0.001;
  }
  if (keyCode == RIGHT) { 
    etwist=etwist-0.001;
  } 
  //println("eratio="+eratio+" etwist="+etwist);
}

