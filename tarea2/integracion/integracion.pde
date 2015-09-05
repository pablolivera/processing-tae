/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/90192*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* @pjs globalKeyEvents=true; */
import fisica.*;
import java.util.List;
import SimpleOpenNI.*;
import java.util.*;

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
int cont = 0;
//var curContext; // Javascript drawing context (for faster rendering)

//FISICA
Boolean[][] hayHoja; 
FCircle hoja;
int maxHojas = 1000;
int cantHojas = 0;
FWorld world;
FBox f;
FPoly obstacle;

//KINECT
SimpleOpenNI  context;

//CONTROLES
boolean mostrarSilueta = false;

// variable que define el factor para escalar la imagen que nos da la kinect
float fact;
int[] puntosBorde; // puntosBorde[i] < 0 : No hay user. En otro caso esta la posicion en y mas alta en la x dada del usuario. 
List<PVector> puntosBordeList; // Lista con los puntos de borde superiores del user. Escalado por fact.
boolean tracking = false;


///////////////////////////////////////////////////////////
// Init ///////////////////////////////////////////////////
///////////////////////////////////////////////////////////
void setup() {
  size(1024, 768); // Set screen size & renderer

  leaveImagePrimavera = createLeaveImage();
  leaveImageOtono = createLeaveImage2();
  createNewTree("OpenProcessing");


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


  smooth();
  Fisica.init(this);
  world = new FWorld();
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
  // actualizamos la kinect
  context.update();

  background(0);
  //fill(200); 
  noStroke();
  //rect(120, 120, width-240, height-240);
  noFill();
  //windAngle += 0.001; //Con 0.01 parece que se MUEREEEE
  //tree.windForce = sin(windAngle) * 0.05;
  tree.update();
  if (frameCount >= 0 && frameCount < 50)
    tree.render(80);
  else if (frameCount >= 50 && frameCount < 100)
    tree.render(60);
  else if (frameCount >= 100 && frameCount < 150)
    tree.render(40);
  else if (frameCount >= 150 && frameCount < 200)
    tree.render(30);
  else tree.render(0);
  //fill(#d7d7d7); 
  //noStroke();
  //rect(tree.x-80, height-120, 160, 120);

  if (cont > 50) cont = 0;
  cont++;


  //FISICA
  //if (frameCount%1==0) {
  List<FBody> bodies = world.getBodies();
  for (FBody b : bodies) {
    float xmin = mouseX - 50;
    float xmax = mouseX + 50;
    float ymin = mouseY - 50;
    float ymax = mouseY + 50;
    if (b.getX()>xmin && b.getX()<xmax && b.getY()>ymin && b.getY()<ymax) {
      b.setStatic(false);
      b.wakeUp();
    }
    //}
  }

  if (tracking) {

    actualizarVectorBordes();

    crearObstaculo();

    strokeWeight(1);
    stroke(255);
    ArrayList contacts = obstacle.getContacts();
    System.out.println("Esto es el tamanio de contacts" + contacts.size());
    for (int i=0; i<contacts.size (); i++) {
      FContact c = (FContact)contacts.get(i);
      //line(c.getBody1().getX(), c.getBody1().getY(), c.getBody2().getX(), c.getBody2().getY());
    }
  }



  world.draw();
  world.step();
  world.removeBody(obstacle);
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
  //curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId) {
  tracking = false;
  //println("onLostUser - userId: " + userId);
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

FBody circulo(float x, float y) {
  FCircle hoja = new FCircle(10);
  hoja.setPosition(x, y);
  hoja.setVelocity(0, 200);
  hoja.setRestitution(0);
  hoja.setNoStroke();
  hoja.setFill(200, 30, 90);
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
      growth = min(growth + 0.1*parent.growth, 1);
    } else
      growth = min(growth + 0.1, 1);
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

        if ((random(10)>9)&&(cantHojas<maxHojas)) {
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

