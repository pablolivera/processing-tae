/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/90192*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* @pjs globalKeyEvents=true; */
import fisica.*;
import java.util.List;
import SimpleOpenNI.*;
import java.util.*;
import controlP5.*;
import ddf.minim.*;

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
PImage leaveImagePrimavera;
PImage leaveImageOtono;
PImage pelota;
int cont = 0;
float segundos;
//var curContext; // Javascript drawing context (for faster rendering)

//FISICA
Boolean[][] hayHoja; 
FCircle hoja;
int maxHojas = 1500;
int cantHojas = 0;
int probHoja = 100000;
int maxProb = 99999; //valor que encara mucho
FWorld world;
FBox f;
FPoly obstacle;
FBody handIzq;
FBody handDer;

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
int[] puntosBorde; // puntosBorde[i] < 0 : No hay user. En otro caso esta la posicion en y mas alta en la x dada del usuario. 
List<PVector> puntosBordeList; // Lista con los puntos de borde superiores del user. Escalado por fact.
boolean tracking = false;


///////////////////////////////////////////////////////////
// Init ///////////////////////////////////////////////////
///////////////////////////////////////////////////////////
void setup() {

  background(0);


  //SONIDO
  soundengine = new Minim(this);
  sonido1 = soundengine.loadSample("vivalavida.mp3", 1024);

  size(1024, 768); // Set screen size & renderer

  leaveImagePrimavera = createLeaveImage();
  leaveImageOtono = createLeaveImage2();
  pelota = crearPelota();
  createNewTree("OpenProcessing");


  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    //println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    //exit();
    //return;
  }

  // hay que habilitar estas dos opciones para poder usar la funcion userImage()
  context.enableDepth();
  context.enableUser();

  // el factor lo definimos dividiendo el ancho del proyector, por el ancho de la imagen de la kinect
  fact = float(width)/640;


  smooth();
  Fisica.init(this);
  world = new FWorld();

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
// Create leave image /////////////////////////////////////
///////////////////////////////////////////////////////////
PImage createLeaveImage() {
  PGraphics buffer = createGraphics(12, 18);
  buffer.beginDraw();
  buffer.background(#000000, 0);
  buffer.stroke(#5d6800);
  buffer.line(6, 0, 6, 6);
  buffer.noStroke();
  buffer.fill(#749600);
  buffer.beginShape();
  buffer.vertex(6, 6);
  buffer.bezierVertex(0, 12, 0, 12, 6, 18);
  buffer.bezierVertex(12, 12, 12, 12, 6, 6);
  buffer.endShape();
  buffer.fill(#8bb800);
  buffer.beginShape();
  buffer.vertex(6, 9);
  buffer.bezierVertex(0, 13, 0, 13, 6, 18);
  buffer.bezierVertex(12, 13, 12, 13, 6, 9);
  buffer.endShape();
  buffer.stroke(#659000);
  buffer.noFill();
  buffer.bezier(6, 9, 5, 11, 5, 12, 6, 15);
  buffer.endDraw();
  return buffer.get();
}

PImage crearPelota() {
  PGraphics buffer = createGraphics(12, 12);
  buffer.beginDraw();

  int n=40;
  int size=700;
  int x=0;
  int y=0;
  //Each call to drawEllipse() specifies position, size, total number of ellipses drawn
  float vortex = 255/n; //setup fill gradient
  float rays = size/n; //initiates size of each ellipse, size/number
  for (int i = 0; i < n; i++) {

    buffer.fill(i*vortex); //allows ellipses to appear as gradient
    buffer.ellipse(x, y, size - i*rays, size - i*rays); //ellipse function
  }

  buffer.endDraw();
  return buffer.get();
}

// Create leave image /////////////////////////////////////
///////////////////////////////////////////////////////////
PImage createLeaveImage2() {
  PGraphics buffer = createGraphics(12, 18);
  buffer.beginDraw();
  buffer.background(#000000, 0);
  buffer.stroke(#6E4C27);
  buffer.line(6, 0, 6, 6);
  buffer.noStroke();
  buffer.fill(#A13012);
  buffer.beginShape();
  buffer.vertex(6, 6);
  buffer.bezierVertex(0, 12, 0, 12, 6, 18);
  buffer.bezierVertex(12, 12, 12, 12, 6, 6);
  buffer.endShape();
  buffer.fill(#CC7526);
  buffer.beginShape();
  buffer.vertex(6, 9);
  buffer.bezierVertex(0, 13, 0, 13, 6, 18);
  buffer.bezierVertex(12, 13, 12, 13, 6, 9);
  buffer.endShape();
  buffer.stroke(#6E4C27);
  buffer.noFill();
  buffer.bezier(6, 9, 5, 11, 5, 12, 6, 15);
  buffer.endDraw();
  return buffer.get();
}


///////////////////////////////////////////////////////////
// Create new tree ////////////////////////////////////////
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
  //Esto es con el control.
  if (startEscena) {
    if (segundos == 0) {
      //Esto se ejecuta solo al principio.
      sonido1.trigger();
    }

    // actualizamos la kinect
    if (context.isInit()) context.update();

    background(0);
    noStroke();
    noFill();
    //windAngle += 0.001; //Con 0.01 parece que se MUEREEEE
    //tree.windForce = sin(windAngle) * 0.05;
    tree.update();
    segundos = millis()/1000;
    tree.render(1);


    if (cont > 50) cont = 0;
    cont++;



    if (context.isInit())
      findHands();
    else {
      handIzq = pelota(mouseX, mouseY);
      world.add(handIzq);
    }



    List<FBody> bodies = world.getBodies();
    for (FBody b : bodies) {

      //Color segun Controles
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


      //println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>A bu");
      if (handIzq !=null) {
        float xmin = handIzq.getX() - 50;
        float xmax = handIzq.getX() + 50;
        float ymin = handIzq.getY() - 50;
        float ymax = handIzq.getY() + 50;
        if (b.getX()>xmin && b.getX()<xmax && b.getY()>ymin && b.getY()<ymax) {
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





    if (tracking && context.isInit()) {
      actualizarVectorBordes();
      crearObstaculo();
    }



    world.draw();
    world.step();
    world.removeBody(obstacle);
    world.removeBody(handIzq);
    world.removeBody(handDer);
  } else {
    //Estaba andando
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
}

void onNewUser(SimpleOpenNI curContext, int userId) { 
  tracking = true;
  //println("tracking" + userId);
  context.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId) {
  tracking = false;
  //println("onLostUser - userId: " + userId);
}


void contactStarted(FContact c) {
}

void contactPersisted(FContact c) {
}

void contactEnded(FContact c) {
}


FBody hoja(float x, float y, float angle) {
  FBox f = new FBox(5, 5);
  f.attachImage(leaveImageOtono);
  f.setPosition(x, y);
  //float angle = random(TWO_PI);
  float magnitude = 90;
  f.setVelocity(0, magnitude);
  f.setDamping(0);
  f.setRestitution(0.5);
  f.setRotatable(true);
  f.setRotation(angle);
  return f;
}

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





///////////////////////////////////////////////////////////
// Class that handles the branches ////////////////////////
///////////////////////////////////////////////////////////
class Branch {


  ///////////////////////////////////////////////////////////
  // Variable definitions ///////////////////////////////////
  ///////////////////////////////////////////////////////////
  float x;
  float y;
  float angle;
  float angleOffset;
  float length;
  float growth = 0;
  float windForce = 0;
  float blastForce = 0;
  Branch branchA;
  Branch branchB;
  Branch parent;


  ///////////////////////////////////////////////////////////
  // Constructor ////////////////////////////////////////////
  ///////////////////////////////////////////////////////////
  Branch(Branch parent, float x, float y, float angleOffset, float length) {
    this.parent = parent;
    this.x = x;
    this.y = y;
    if (parent != null) {
      angle = parent.angle+angleOffset;
      this.angleOffset = angleOffset;
    } else {
      angle = angleOffset;
      this.angleOffset = -0.2+random(0.4);
    }
    this.length = length;
    float xB = x + sin(angle) * length;
    float yB = y + cos(angle) * length;
    if (length > 16) {
      if (length+random(length) > 55) {
        //DERECHA
        branchA = new Branch(this, xB, yB, -0.05-random(0.2) + ((angle % TWO_PI) > PI ? -1/length : +1/length), length*(0.95));//-random(0.02)));
      }
      if (length+random(length) > 29) {
        //IZQ
        branchB = new Branch(this, xB, yB, 0.2+random(0.1) + ((angle % TWO_PI) > PI ? -1/length : +1/length), length*(0.7+random(0.2)));
      }
      if (branchB != null && branchA == null) {
        branchA = branchB;
        branchB = null;
      }
    }
    minX = min(xB, minX);
    maxX = max(xB, maxX);
    minY = min(yB, minY);
    maxY = max(yB, maxY);
  }


  ///////////////////////////////////////////////////////////
  // Set scale //////////////////////////////////////////////
  ///////////////////////////////////////////////////////////
  void setScale(float scale) {
    length *= scale;
    if (branchA != null) {
      branchA.setScale(scale);
      if (branchB != null)
        branchB.setScale(scale);
    }
  }


  ///////////////////////////////////////////////////////////
  // Update /////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////
  void update() {
    if (parent != null) {
      x = parent.x + sin(parent.angle) * parent.length * parent.growth;
      y = parent.y + cos(parent.angle) * parent.length * parent.growth;
      windForce = parent.windForce * (1.0+5.0/length) + blastForce;
      blastForce = (blastForce + sin(x/2+windAngle)*0.005/length) * 0.98;
      angle = parent.angle + angleOffset + windForce + blastForce;
      growth = min(growth + 0.01*parent.growth, 1);
    } else
      growth = min(growth + 0.001, 1);
    if (branchA != null) {
      branchA.update();
      if (branchB != null)
        branchB.update();
    }
  }


  ///////////////////////////////////////////////////////////
  // Render /////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////
  void render(int maxLen) {
    if (length > maxLen) {
      if (branchB != null) {
        float xB = x;
        float yB = y;
        if (parent != null) {
          xB += (x-parent.x) * 0.4;
          yB += (y-parent.y) * 0.4;
        } else {
          xB += sin(angle+angleOffset) * length * 0.3;
          yB += cos(angle+angleOffset) * length * 0.3;
        }
        // PROCESSING WAY (slow)
        stroke(floor(1100/length));
        strokeWeight(length/5);
        beginShape();
        vertex(x, y);
        bezierVertex(xB, yB, xB, yB, branchB.x, branchB.y);
        endShape();

        /*curContext.beginPath();
         curContext.moveTo(x, y);
         curContext.bezierCurveTo(xB, yB, xB, yB, branchA.x, branchA.y);
         int branchColor = floor(1100/length);
         curContext.strokeStyle = "rgb("+branchColor+","+branchColor+","+branchColor+")";
         curContext.lineWidth = length/5;
         curContext.stroke();*/
        branchB.render(maxLen);
        if (branchA != null)
          branchA.render(maxLen);
      } else {
        pushMatrix();
        translate(x, y);
        rotate(-angle);

        if ((segundos>77)&&(random(1000)>999)&&(cantHojas<maxHojas)) {
          FBody f = circulo(x, y);
          f.setStatic(true);
          world.add(f);
          cantHojas++;
        } else {
          //println("fin hojas.");
        }


        popMatrix();
      }
    }
  }
}

