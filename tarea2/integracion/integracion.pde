/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/90192*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* @pjs globalKeyEvents=true; */
import fisica.*;
import java.util.List;
import SimpleOpenNI.*;
import java.util.*;
import controlP5.*;
import ddf.minim.*;

// DEBUG VARIABLES
boolean kinectConectado = false; 

//CONTROLS
private ControlP5 cp5;
ControlFrame cf;
boolean toSwitch = false;
boolean startEscena = false;

//SONIDO
Minim soundengine;
AudioSample sonido1;

///////////////////////////////////////////////////////////
// Variable definitions ///////////////////////////////////
///////////////////////////////////////////////////////////
Branch tree;
float windAngle = 0;
float minX;
float maxX;
float minY;
float maxY;
int blinkUpdate;
String typedText;
String lastSeed;
float segundos; // Variable que indicara en que segundo de la cancion estamos


//FISICA
Boolean[][] hayHoja; 
FCircle hoja;
int maxHojas = 1500;
int cantHojas = 0;
int probHoja = 100000;
int maxProb = 99999; // valor que encara mucho, ????? 

FWorld world;
FBox f;
FPoly obstacle;
FBody handIzq;
FBody handDer;
List<FLine> obstacleList; // Lista con obstaculos para la hoja.

//KINECT
SimpleOpenNI  context = null;

//CONTROLES
boolean mostrarSilueta = false;
// Vectores para las manos.
PVector convertedRightHand;
PVector convertedLeftHand;
boolean backToSwitch = false;

// variable que define el factor para escalar la imagen que nos da la kinect
float fact; 
List<PVector> puntosBordeList; // Lista con los puntos de borde superiores del user. Escalado por fact.
boolean tracking = false;
PVector firstHand = new PVector();
PVector secondHand = new PVector();
int aumento = 0;


///////////////////////////////////////////////////////////
// Init ///////////////////////////////////////////////////
///////////////////////////////////////////////////////////
void setup() {

  //FONDO INICIAL NEGRO
  background(0);

  //SONIDO
  soundengine = new Minim(this);
  sonido1 = soundengine.loadSample("vivalavida.mp3", 1024);

  size(1024, 768); // Set screen size & renderer

  //CREAMOS EL ARBOL
  createNewTree("OpenProcessing");

  // Controlo que este conectada la camara
  if (kinectConectado) {
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
  }

  // el factor lo definimos dividiendo el ancho del proyector, por el ancho de la imagen de la kinect
  fact = float(width)/640;


  smooth();
  
  //LIBRERIA FISICA
  Fisica.init(this);
  world = new FWorld();
  obstacleList = new ArrayList(); // Iniciar la lista de obstaculos.

  //CONTROLES
  cp5 = new ControlP5(this);
  cf = addControlFrame("Controladores", 250, 200);
}


///////////////////////////////////////////////////////////
// Return a random string /////////////////////////////////
///////////////////////////////////////////////////////////
String getRandomSeed() {
  randomSeed(millis());
  return ((int)(random(9999999)+random(999999)+random(99999)))+"";
}


///////////////////////////////////////////////////////////
// CREAMOS EL ARBOL ///////////////////////////////////////
///////////////////////////////////////////////////////////
void createNewTree(String seed) {
  lastSeed = seed;
  randomSeed(seed.hashCode()); // Set seed
  minX = width/2;
  maxX = width/2;
  minY = height;
  maxY = height;
  tree = new Branch(null, width/2, height, PI, 110);
  float xSize = maxX-minX;
  float ySize = maxY-minY;
  float scale = 1;
  if (xSize > ySize) {
    if (xSize > 500)
      scale = 1100/xSize;
  } else {
    if (ySize > 500)
      scale = 1100/ySize;
  }
  tree.setScale(scale);
  tree.x = width/5;// - xSize/2*scale + (tree.x-minX)*scale;
  tree.y = height;///2 + ySize/2*scale + (tree.y-maxY)*scale;
  blinkUpdate = -1; // Set/reset variables
  typedText = "";
}


///////////////////////////////////////////////////////////
// Render /////////////////////////////////////////////////
///////////////////////////////////////////////////////////
void draw() {
  
  // Esto es con el control.
  if (startEscena) {
    if (segundos == 0) {
      //Esto se ejecuta solo al principio.
      sonido1.trigger();
    }

    // Actualizamos la kinect si esta presente
    if (kinectConectado && context.isInit()) { 
      context.update();
    }

    background(0);
    noStroke();
    noFill();

    //ACTUALIZAMOS Y MOSTRAMOS EL ARBOL
    tree.update();
    segundos = millis()/1000;
    tree.render(1);


    // Me fijo si esta conectado el kinect en caso contrario usamos el mouse
    if (kinectConectado && context.isInit()) {
      findHands();
    }
    else {
      handIzq = pelota(mouseX, mouseY);
      world.add(handIzq);
    }

    // Actualizamos las "hojas"
    List<FBody> bodies = world.getBodies();
    for (FBody b : bodies) {

      // Color de las hojas segun los Controles
      if (toSwitch) {        
        if ((random(maxProb) >= probHoja)) {
          b.setFill(random(48, 181), random(202, 255), random(135), random(255));
        } else {
          b.setFill(random(236, 255), random(118, 140), random(66), random(255));
        }
      } else {        
        if ((random(maxProb) >= probHoja)) {
          b.setFill(random(236, 255), random(118, 140), random(66), random(255));
        } else {
          b.setFill(random(48, 181), random(202, 255), random(135), random(255));
        }
      }
      if (probHoja <= maxProb) 
        probHoja++;
      if (toSwitch != backToSwitch)
        probHoja = 0;
        
      backToSwitch = toSwitch;

      // Despierto las hojas con las manos 
      if (handIzq != null) {
        float xmin = handIzq.getX() - 50;
        float xmax = handIzq.getX() + 50;
        float ymin = handIzq.getY() - 50;
        float ymax = handIzq.getY() + 50;
        if (b.getX() > xmin && b.getX() < xmax && b.getY()>ymin && b.getY()<ymax) {
          b.setStatic(false);
          b.wakeUp();
        }
      }
      if (handDer !=null) {
        float xmin = handDer.getX() - 50;
        float xmax = handDer.getX() + 50;
        float ymin = handDer.getY() - 50;
        float ymax = handDer.getY() + 50;
        if (b.getX()>xmin && b.getX()<xmax && b.getY()>ymin && b.getY()<ymax) {
          b.setStatic(false);
          b.wakeUp();
        }
      }
    }

    if (kinectConectado && tracking && context.isInit()) {
      actualizarVectorBordes();
      crearObstaculoLines();
      //crearObstaculo();
    }

    //MUESTRO LOS ELEMENTOS DEL MUNDO FISICO
    world.draw();
    world.step();
    
    // Limpio el mundo en cada loop para no sobrecargarlo
    world.removeBody(obstacle);
   
    for (FLine f : obstacleList) {
      world.removeBody(f);
    } 
    world.removeBody(handIzq);
    world.removeBody(handDer);

  } else {
    //STOP DE LA ESCENA CON EL CONTROL
    if (segundos > 0) {
      //RESETEO TODO COMO AL INICIO
      segundos = 0;
      createNewTree("OpenProcessing");
      world.clear();
      sonido1.stop();
      background(0);
    }
  }
}

// Busca las manos y si las encuentra llama a drawHand para dibujarlas
void findHands() {
  // Dibujar manos si están disponibles
  int[] userList = context.getUsers();
  for (int i = 0; i < userList.length; i++) {
    if (context.isTrackingSkeleton(userList[i])) {
      stroke(230);
      drawHand(userList[i]);
    }
  }
}

// Dibuja las manos
void drawHand(int userId) {

  PVector rightHand = new PVector(); 
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, rightHand);  
  convertedRightHand = new PVector();
  context.convertRealWorldToProjective(rightHand, convertedRightHand);
  // Se escala la coordenada.
  convertedRightHand.x = convertedRightHand.x * fact;
  convertedRightHand.y = convertedRightHand.y  * fact;
  ellipse( convertedRightHand.x, convertedRightHand.y, 40, 40);

  PVector leftHand = new PVector(); 
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, leftHand);
  convertedLeftHand = new PVector();
  context.convertRealWorldToProjective(leftHand, convertedLeftHand);
  convertedLeftHand.x = convertedLeftHand.x  * fact;
  convertedLeftHand.y = convertedLeftHand.y * fact;
  ellipse(convertedLeftHand.x, convertedLeftHand.y, 40, 40); // Se escala la coordenada.

  handIzq = pelota(convertedLeftHand.x, convertedLeftHand.y);
  handDer = pelota(convertedRightHand.x, convertedRightHand.y);

  world.add(handIzq);
  world.add(handDer);
}

void crearObstaculo() {
  obstacle = new FPoly();

  float firstX = -1; // Guardar el primer x del usuario
  float currentX = 0;
  for (PVector p : puntosBordeList) {
    if (firstX < 0) {
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
  if (!mostrarSilueta) {
    obstacle.setNoStroke();
    obstacle.setNoFill();
  }

  obstacle.setRestitution(0); // ??
  world.add(obstacle);
}

// Crea una lista de FLine que sirven de obstaculos para las hojas.
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

// Cuando encuentre un usuario que lo empiece a sensar
void onNewUser(SimpleOpenNI curContext, int userId) { 
  tracking = true;
  //println("tracking" + userId);
  context.startTrackingSkeleton(userId);
}

// Marco cuando pierdo el usuario
void onLostUser(SimpleOpenNI curContext, int userId) {
  tracking = false;
  //println("onLostUser - userId: " + userId);
}



/*void contactStarted(FContact c) {
}

void contactPersisted(FContact c) {
}

void contactEnded(FContact c) {
}*/

// Funcion que retorna los segundos para el cambio de escena
// 
// TODO podriamos ya poner el codigo aca de cada escena asi queda bien separada
// 
// 1 - Inicio, crecimiento del arbol
// 2 - Termina de crecer el arbol y aparecen las primeras hojas (PRIMAVERA)
// 3 - Comienzo del verano
// 4 - Comienzo del otoño
// 5 - Caen la hojas (OTOÑO)
// 6 - Comienza el invierno 
int obtenerSegundoEscena(int escenaId) {
    switch(escenaId) {
      case 1: 
        return 0;
      case 2:
        return 66; // 1m 06s
      case 3:
        return 121; // 2m 01s
      case 4:
        return 191; // 3m 11s
      case 5:
        return 204; // 3m 24s
      case 6:
        return 233; // 3m 53s
      default: 
        println("No existe la escena " + escenaId); 
        exit();
        return -1;
    }        
}



//CIRCULO PARA LAS MANOS O EL MOUSE
FBody pelota(float x, float y) {
  FCircle f = new FCircle(50);
  f.setPosition(x, y);
  f.setDamping(0);
  f.setDensity(30);
  f.setRestitution(0.5);
  f.setFill(200);
  f.setNoStroke();
  return f;
}

//CIRCULO PARA LAS HOJAS
FBody circulo(float x, float y) {
  FCircle hoja = new FCircle(10);
  hoja.setPosition(x, y);
  hoja.setVelocity(0, 200);
  hoja.setRestitution(0);
  hoja.setNoStroke();
  //Otono
  if (toSwitch)
    hoja.setFill(random(236, 255), random(118, 140), random(66), random(255));
  else 
    hoja.setFill(random(48, 181), random(202, 255), random(135), random(255));
  return hoja;
}








