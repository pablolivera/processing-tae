import fisica.*;
import java.util.List;
import SimpleOpenNI.*;
import java.util.*;
import controlP5.*;
import ddf.minim.*;

//variable para probar el ejemplo sin el kinect.
boolean kinectConectado = false; 

//variables usadas por los controles.
private ControlP5 cp5;
ControlFrame cf;
boolean toSwitch = false;      //indica cambio de estacion.
boolean tirarHojas = false;    //indica si hay que tirar las hojas que queden.
int velocidadx = 0;            //velocidad de las hojas en x.
int velocidady = 200;          //velocidad de las hojas en Y.      
boolean esVerano1 = false;     //escena verano 1
boolean esVerano2 = false;     //escena verano 2
boolean esPrimavera = false;   //escena primavera
boolean esOtono1 = false;      //escena otono 1
boolean esOtono2 = false;      //escena otono 2
boolean esInvierno = false;    //escena invierno
boolean contornoSiluetaActivado = true;      //silueta activada

//variables para cargar y controlar la cancion
Minim soundengine;
AudioSample sonido1;

//variables para el arbol
Branch tree;
float windAngle = 0;
float minX;
float maxX;
float minY;
float maxY;

//variables auxiliares
float segundos;       //variable que indica en que segundo de la cancion estamos
int alpha = 0;        //transparencia del arcoiris
int[][] col = {
  { 
    0, 0
  }
  , 
  { 
    0, 0
  }
  , 
  { 
    0, 0
  }
};                  //matriz de colores, maximo y minimo para r,g,b
int[][] colanterior = {
  { 
    0, 0
  }
  , 
  { 
    0, 0
  }
  , 
  { 
    0, 0
  }
};                //matriz de colores anterior, maximo y minimo para r,g,b


//variables para controlar el mundo "fisico"
int maxHojas = 500;    //maximo cantidad de hojas en el mundo.
int cantHojas = 0;     //cantidad de hojas hasta el momento.
int probHoja = 0;      //variable para controlar la probabilidad de que cambie el color de las hojas.
int maxProb = 50999;   //valor para controlar la probabilidad de que cambie el color de las hojas.
FWorld world;          //mundo fisico.
FBody handIzq;         //representa a la mano que se encuentre mas a la izquierda.
FBody handDer;         //representa a la mano que se encuentre mas a la derecha.
List<FLine> obstacleList; // Lista con obstaculos para la hoja.

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

//setup processing.
void setup() {

  //fondo inicial negro
  background(0);

  //cargamos la cancion.
  soundengine = new Minim(this);
  sonido1 = soundengine.loadSample("vivalavida.mp3", 1024);

  //resolucion
  size(1024, 768); 

  //creamos el arbol.
  createNewTree("OpenProcessing");

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

  //libreria fisica
  Fisica.init(this);
  world = new FWorld();
  //iniciar la lista de obstaculos.
  obstacleList = new ArrayList(); 

  //controles
  cp5 = new ControlP5(this);
  cf = addControlFrame("Controladores", 520, 500);
}


//crear el arbol
void createNewTree(String seed) {
  randomSeed(seed.hashCode()); 
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
      //valor experimental para ubicar el arbol
      scale = 1100/xSize;
  } else {
    if (ySize > 500)
      //valor experimental para ubicar el arbol
      scale = 1100/ySize;
  }
  tree.setScale(scale);
  tree.x = width/5;
  tree.y = height;
}


//render
void draw() {

  //fondo negro
  background(0);

  // Me fijo si esta conectado el kinect en caso contrario usamos el mouse
  if (kinectConectado && context.isInit()) {
    // Actualizamos la kinect si esta presente

    context.update();

    //actualiza vector de bordes de silueta superior del usuario.
    actualizarVectorBordes();
    crearObstaculoLines();

    //la alternativa para las manos con skeleton tracking:
    //findHands();
    //alternativa con depth map para las manos:
    handIzq = pelota(firstHand.x, firstHand.y);
    //println("x izq "+firstHand.x+" y izq "+firstHand.y);
    handDer = pelota(secondHand.x, secondHand.y);
    //println("x der "+secondHand.x+" y der "+secondHand.y);


    //agrego las manos al mundo.
    world.add(handIzq);
    world.add(handDer);
  } else {
    //agrego una mano al mundo que es el mouse.
    handIzq = pelota(mouseX, mouseY);
    world.add(handIzq);
  }


  // estaciones con el control.
  if (esInvierno || esVerano1 || esVerano2 || esOtono1 || esOtono2 || esPrimavera) {
    if (segundos == 0) {
      //Esto se ejecuta solo al principio.
      sonido1.trigger();
    }


    //si es verano 2 aparece arcoiris
    if (esVerano2) {
      background(0, alpha);
      noStroke();
      if ((random(10) > 8)&&(alpha < 255)) {
        alpha+=3;
      }
      crearArcoiris();
    } 
    //si es otono 1 desaparece arcoiris
    else if (esOtono1) {
      background(0, alpha);
      noStroke();
      if ((random(10) > 8)&&(alpha > 0)) {
        alpha-=10;
      }
      crearArcoiris();
    }

    noStroke();
    noFill();

    //actualizamos y mostramos el arbol
    tree.windForce = sin(windAngle) * 0.06;
    tree.update();
    segundos = millis()/1000;
    tree.render(1);





    // Actualizamos las "hojas"
    List<FBody> bodies = world.getBodies();
    for (FBody b : bodies) {

      //velocidad de las hojas.
      b.setVelocity(random(-velocidadx, velocidadx), velocidady);

      //color de las hojas segun los Controles
      int transparency = 255;

      //si cambio la estacion
      if (toSwitch) {
        for (int i=0; i<3; i++) {
          for (int j=0; j<2; j++) {
            colanterior[i][j] = col[i][j];
          }
        }
      }

      //colores de las hojas segun estacion
      if (esPrimavera) {
        transparency = 0;
        col[0][0] = 48;
        col[0][1] = 181;
        col[1][0] = 202;
        col[1][1] = 255;
        col[2][0] = 0;
        col[2][1] = 135;
      } else if (esVerano1) {
        col[0][0] = 48;
        col[0][1] = 181;
        col[1][0] = 202;
        col[1][1] = 255;
        col[2][0] = 0;
        col[2][1] = 135;
      } else if (esVerano2) {
        col[0][0] = 0;
        col[0][1] = 255;
        col[1][0] = 0;
        col[1][1] = 255;
        col[2][0] = 0;
        col[2][1] = 255;
      } else if (esOtono1 || esOtono1) {
        col[0][0] = 236;
        col[0][1] = 255;
        col[1][0] = 118;
        col[1][1] = 140;
        col[2][0] = 0;
        col[2][1] = 66;
      } else if (esInvierno) {
        transparency = 0;
      } 

      //si es verano1 o cambio la estacion, con cierta probabilidad cambio de color las hojas.
      if ((esVerano1)||(random(maxProb) < probHoja)) {
        b.setFill(random(col[0][0], col[0][1]), random(col[1][0], col[1][1]), random(col[2][0], col[2][1]), random(transparency));
        if (esOtono1) {
          FCircle c = (FCircle)b;
          c.setSize(10);
        }
      } else {
        b.setFill(random(colanterior[0][0], colanterior[0][1]), random(colanterior[1][0], colanterior[1][1]), random(colanterior[2][0], colanterior[2][1]), random(transparency));
      }



      //hago que sea cada vez mas probable cambiar el color de las hojas.
      if (probHoja < maxProb) {
        probHoja++;
      }

      //reseteo control de probabilidades.
      if (toSwitch) {
        toSwitch = false;
        probHoja = 0;
      }

      //interaccion de las hojas con la mano izq.
      if (handIzq != null) {
        //defino un cuadrante de influencia de la mano
        float xmin = handIzq.getX() - 50;
        float xmax = handIzq.getX() + 50;
        float ymin = handIzq.getY() - 350;
        float ymax = handIzq.getY() + 50;
        FCircle c = (FCircle)b;
        //si la hoja cae en el cuadrante
        if (b.getX() > xmin && b.getX() < xmax && b.getY()>ymin && b.getY()<ymax) {
          //si es verano 2
          if (esVerano2) {
            //cambio su tamano
            c.setSize(random(30));
          } 


          //si es otono 2 hago que caigan.
          if (esOtono2) {
            b.setStatic(false);
            b.wakeUp();
          }
        }
        //si ya no esta en la zonade influencia la vuelvo al tamano normal
        //else c.setSize(10);
      }
      //interaccion de las hojas con la mano der.
      if (handDer !=null) {
        //defino un cuadrante de influencia de la mano
        float xmin = handDer.getX() - 50;
        float xmax = handDer.getX() + 50;
        float ymin = handDer.getY() - 350;
        float ymax = handDer.getY() + 50;
        FCircle c = (FCircle)b;
        //si la hoja cae en el cuadrante
        if (b.getX()>xmin && b.getX()<xmax && b.getY()>ymin && b.getY()<ymax) {
          //si es verano 2
          if (esVerano2) {
            //cambio su tamano
            c.setSize(random(30));
          }

          //si es otono 2 hago que caigan.
          if (esOtono2) {
            b.setStatic(false);
            b.wakeUp();
          }
        }
        //si ya no esta en la zonade influencia la vuelvo al tamano normal
        //else c.setSize(10);
      }

      //tiro las hojas desde el control
      if (tirarHojas) {
        b.setStatic(false);
        b.wakeUp();
      }

      //hoja se fue de plano o quedo adentro de la silueta.
      float y = b.getY()-10;
      float x = b.getX()-10;
      if (y>height || y<0 || x>width || x<0)
        world.remove(b);
    }
  } else {
    //ninguna estacion activa
    if (segundos > 0) {
      //RESETEO TODO COMO AL INICIO
      segundos = 0;
      createNewTree("OpenProcessing");
      world.clear();
      sonido1.stop();
      background(0);
    }
  }

  //muestro elementos del mundo fisico.
  world.draw();
  world.step();

  //limpio el mundo en cada loop para no sobrecargarlo
  for (FLine f : obstacleList) {
    world.removeBody(f);
  } 
  world.removeBody(handIzq);
  world.removeBody(handDer);
}

// Busca las manos y si las encuentra llama a drawHand para dibujarlas, esto usa skeleton tracking.
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

// Dibuja las manos, esto usa skeleton tracking.
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



// Crea una lista de FLine que sirven de obstaculos para las hojas.
void crearObstaculoLines() {
  obstacleList = new ArrayList();
  PVector v = null;
  PVector w = null;
  FLine linea;
  int paso = 4; // Minimo 2. Indica cuantos puntos se toman para crear FLine.
  int resto = puntosBordeList.size() % paso; // Se quitan cuando sobra un resto.
  boolean first = true;
  Iterator<PVector> it = puntosBordeList.iterator();
  if (it.hasNext() && resto == 1) { // Si el resto es 1 se procesa diferente.
    v = it.next();
    first = false;
    firstHand = new PVector(v.x, v.y);
  }
  // Se ajusta el tope para el for que consume los puntos intermedios que no se dibujan.
  int tope = resto != 0 && resto != 1 ? resto : paso;  
  while (it.hasNext ()) {
    v = it.next(); // Primer punto para FLine
    if (first) { // Si es el primero se toma como una mano
      firstHand = new PVector(v.x, v.y);
      first = false;
    }
    for (int i = 1; i < (tope - 1); i++) {
      it.next(); // Se avanza en la lista para saltear los puntos que no se dibujan
    }
    tope = paso;
    w = it.next(); // Segundo punto para FLine
    linea = new FLine(v.x, v.y, w.x, w.y); // Se crea el objecto que es obstaculo en el mundo.
    linea.setStatic(true);
    if (contornoSiluetaActivado) {
      linea.setStroke(255);
    } else {
      linea.setNoStroke();
    }
    linea.setRestitution(0);
    obstacleList.add(linea);
    world.add(linea);
  }
  if (w != null) { // El ultimo punto se toma como la otra mano.
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
          puntosBordeList.add(new PVector( (x * fact), (y * fact)+ aumento));
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



//CIRCULO PARA LAS MANOS O EL MOUSE
FBody pelota(float x, float y) {
  FCircle f = new FCircle(50);
  f.setPosition(x, y);
  f.setDamping(0);
  f.setDensity(30);
  f.setRestitution(0.5);
  if (contornoSiluetaActivado) {
    f.setFill(200);
  } else {
    f.setNoFill();
  }
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
  if (esOtono1)
    hoja.setFill(random(236, 255), random(118, 140), random(66), random(255));
  else 
    hoja.setFill(random(48, 181), random(202, 255), random(135), random(255));
  return hoja;
}

//creamos el arcoiris
void crearArcoiris() {
  fill(#FF0000, alpha);
  ellipse(2*width/3, height, 1480, 1140);
  fill(#FF8D00, alpha);
  ellipse(2*width/3, height, 1460, 1100);
  fill(#FEEE00, alpha);
  ellipse(2*width/3, height, 1440, 1060);
  fill(#10C10E, alpha);
  ellipse(2*width/3, height, 1420, 1020);
  fill(#398DFF, alpha);
  ellipse(2*width/3, height, 1400, 980);
  fill(#164B93, alpha);
  ellipse(2*width/3, height, 1380, 940);
  fill(#4B0295, alpha);
  ellipse(2*width/3, height, 1360, 900);
  fill(#9900BC, alpha);
  ellipse(2*width/3, height, 1340, 860);
  fill(0);
  ellipse(2*width/3, height, 1320, 820);
}

