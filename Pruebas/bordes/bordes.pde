
import SimpleOpenNI.*;
import java.util.*;
import fisica.*;

FWorld world;
FPoly obstacle;
List<FLine> obstacleList;

SimpleOpenNI  context;
// variable que define el factor para escalar la imagen que nos da la kinect
float fact;
//int[] puntosBorde; // puntosBorde[i] < 0 : No hay user. En otro caso esta la posicion en y mas alta en la x dada del usuario. 
List<PVector> puntosBordeList; // Lista con los puntos de borde superiores del user. Escalado por fact.
boolean tracking = false;

int aumento = 0;
PVector firstHand = new PVector();
PVector secondHand = new PVector();


float minFR = -1;


void setup()
{
  // aca va la resolucion que se corresponde a la resolucion del proyector
  size(1024, 768);

  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }

  // hay que habilitar estas dos opciones para poder usar la funcion userImage()
  context.enableDepth();
  context.enableUser();

  // el factor lo definimos dividiendo el ancho del proyector, por el ancho de la imagen de la kinect
  fact = float(width)/640;
  //println("Rescale factor will be",fact);

  smooth(); // ?????
  Fisica.init(this);
  
  world = new FWorld();
  
  obstacleList = new ArrayList();
  
}

void draw()
{  
  println("Frame Rate " + frameRate);
  minFR = minFR == -1 || frameRate < minFR ? frameRate : minFR;
  println("MIN FR " + minFR);
  // fondo
  background(0);
  //scale(fact);
  // actualizamos la kinect
  context.update();

  if(tracking) {
    
    actualizarVectorBordes();
    
    crearObstaculoLines();
  
    if (frameCount % 5 == 0) {
      FCircle b = new FCircle(20);
      b.setPosition(width/2 + random(-50, 50), 50);
      b.setVelocity(0, 200);
      b.setRestitution(0);
      b.setNoStroke();
      b.setFill(200, 30, 90);
      
      FCircle c = new FCircle(20);
      c.setPosition(width/3 + random(-50, 50), 50);
      c.setVelocity(0, 200);
      c.setRestitution(0);
      c.setNoStroke();
      c.setFill(250, 50, 98);
      
      world.add(b);
      world.add(c);
    }
  
    world.draw();
    world.step();
  
  }
  
  for (FLine f : obstacleList) {
    world.removeBody(f);
  }
  
}

void crearObstaculoLines() {
  obstacleList = new ArrayList();
  PVector v = null;
  PVector w = null;
  FLine linea;
  int paso = 2; // Minimo 2. Indica cuantos puntos se toman para crear FLine.
  int resto = puntosBordeList.size() % paso; // Se quitan cuando sobra un resto.
  boolean first = true;
  Iterator<PVector> it = puntosBordeList.iterator();
  if(it.hasNext() && resto == 1) { // Si el resto es 1 se procesa diferente.
    v = it.next();
    first = false;
    firstHand = new PVector(v.x, v.y);
  }
  // Se ajusta el tope para el for que consume los puntos intermedios que no se dibujan.
  int tope = resto != 0 && resto != 1 ? resto : paso;  
  while(it.hasNext()) {
    v = it.next(); // Primer punto para FLine
    if(first) { // Si es el primero se toma como una mano
      firstHand = new PVector(v.x, v.y);
      first = false;
    }
    for(int i = 1; i < (tope - 1); i++) {
      it.next(); // Se avanza en la lista para saltear los puntos que no se dibujan
    }
    tope = paso;
    w = it.next(); // Segundo punto para FLine
    linea = new FLine(v.x, v.y, w.x, w.y); // Se crea el objecto que es obstaculo en el mundo.
    linea.setStatic(true);
    linea.setStroke(255);
    linea.setRestitution(0);
    obstacleList.add(linea);
    world.add(linea);
  }
  if(w != null) { // El ultimo punto se toma como la otra mano.
    secondHand = new PVector(w.x, w.y);
  }
}

void actualizarVectorBordes() {
  puntosBordeList = new ArrayList();
  int[]   userMap = context.userMap();
  int[]   depthMap = context.depthMap(); 
  //puntosBorde = new int[context.depthWidth()]; 

  int index;
  for (int x = 0; x < context.depthWidth (); x++) {
    for (int y = 0; y < context.depthHeight (); y++) {
      index = x + (y * context.depthWidth());
      int d = depthMap[index];
      if ( d > 0) {
        int userNr = userMap[index];
        if ( userNr > 0) {
          // Si hay una usuario se carga la posicion en la lista
          puntosBordeList.add(new PVector( ((x * fact) + aumento), (y * fact)));
          break; // Se corta para detectar solo el borde superior del usuario.
        }
      }
    }
  }
}

void onNewUser(SimpleOpenNI curContext, int userId) { 
  tracking = true;
  //println("tracking" + userId);
  //curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId) {
  tracking = false;
  //println("onLostUser - userId: " + userId);
}


void crearObstaculo() {
  obstacle = new FPoly();
  
  float firstX = -1; // Guardar el primer x del usuario
  float currentX = 0;
  for (PVector p : puntosBordeList) {
    if(firstX < 0) {
      firstX = p.x;
      obstacle.vertex(p.x, height); // Primer punto del poligono contra el piso.
    }
    obstacle.vertex(p.x, p.y);
    currentX = p.x;
  }
  obstacle.vertex(currentX, height); // La posicion mas lejana x del usuario
  obstacle.vertex(firstX, height); // Para cerrar el poligono
  
  obstacle.setStatic(true);
  obstacle.setFill(255);
  obstacle.setRestitution(0); // ??
  world.add(obstacle);
}

/*
void contactStarted(FContact c) {
  FBody ball = null;
  if (c.getBody1() == obstacle) {
    ball = c.getBody2();
  } else if (c.getBody2() == obstacle) {
    ball = c.getBody1();
  }

  if (ball == null) {
    return;
  }

  ball.setFill(30, 190, 200);
}

void contactPersisted(FContact c) {
  FBody ball = null;
  if (c.getBody1() == obstacle) {
    ball = c.getBody2();
  } else if (c.getBody2() == obstacle) {
    ball = c.getBody1();
  }

  if (ball == null) {
    return;
  }

  ball.setFill(30, 120, 200);

  noStroke();
  fill(255, 220, 0);
  ellipse(c.getX(), c.getY(), 10, 10);
}

void contactEnded(FContact c) {
  FBody ball = null;
  if (c.getBody1() == obstacle) {
    ball = c.getBody2();
  } else if (c.getBody2() == obstacle) {
    ball = c.getBody1();
  }
  
  if (ball == null) {
    return;
  }

  ball.setFill(200, 30, 90);
} */

