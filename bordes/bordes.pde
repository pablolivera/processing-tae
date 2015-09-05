
import SimpleOpenNI.*;
import java.util.*;
import fisica.*;

FWorld world;
FPoly obstacle;

SimpleOpenNI  context;
// variable que define el factor para escalar la imagen que nos da la kinect
float fact;
int[] puntosBorde; // puntosBorde[i] < 0 : No hay user. En otro caso esta la posicion en y mas alta en la x dada del usuario. 
List<PVector> puntosBordeList; // Lista con los puntos de borde superiores del user. Escalado por fact.
boolean tracking = false;
boolean hayObstaculo = false;


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
  
}

void draw()
{
  // fondo
  background(0);
  //scale(fact);
  // actualizamos la kinect
  context.update();

  if(tracking) {
    
    actualizarVectorBordes();
    
    crearObstaculo();
  
    if (frameCount % 5 == 0) {
      FCircle b = new FCircle(20);
      b.setPosition(width/2 + random(-50, 50), 50);
      b.setVelocity(0, 200);
      b.setRestitution(0);
      b.setNoStroke();
      b.setFill(200, 30, 90);
      world.add(b);
    }
  
    world.draw();
    world.step();
  
    strokeWeight(1);
    stroke(255);
    ArrayList contacts = obstacle.getContacts();
    System.out.println("Esto es el tamanio de contacts" + contacts.size());
    for (int i=0; i<contacts.size (); i++) {
      FContact c = (FContact)contacts.get(i);
      //line(c.getBody1().getX(), c.getBody1().getY(), c.getBody2().getX(), c.getBody2().getY());
    }    
  }
  
  world.removeBody(obstacle);
  
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

void actualizarVectorBordes() {
  puntosBordeList = new ArrayList();
  int[]   userMap = context.userMap();
  int[]   depthMap = context.depthMap(); 
  puntosBorde = new int[context.depthWidth()]; 

  int index;
  for (int x = 0; x < context.depthWidth (); x++) {
    for (int y = 0; y < context.depthHeight (); y++) {
      index = x + (y * context.depthWidth());
      int d = depthMap[index];
      // si no hay usuarios se pone posicion en -1
      puntosBorde[x] = -1;
      if ( d > 0) {
        int userNr = userMap[index];
        if ( userNr > 0) {
          // Si hay una usuario se carga la posicion en el array          
          puntosBordeList.add(new PVector( (x * fact), (y * fact)));
          puntosBorde[x] = y;
          break; // Se corta para detectar solo el borde superior del usuario.
        }
      }
    }
  }
  /*for(int posX = 0; posX < puntosBorde.length; posX++) {
   if(puntosBorde[posX] >= 0) {
   puntosBorderList.add(new PVector(posX, puntosBorde[posX]));
   //stroke(255);
   //ellipse(posX, puntosBorde[posX], 3, 3);
   }
   }
  for (PVector p : puntosBordeList) {
    stroke(255);
    ellipse(p.x, p.y, 3, 3);
  }*/
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

synchronized void setTracking(boolean value) {
  tracking = value;
}

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
}

