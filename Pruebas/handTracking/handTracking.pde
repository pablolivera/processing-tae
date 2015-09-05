
import SimpleOpenNI.*;
import fisica.*;

FBox boxButton;
FCircle circleButton;
FPoly polyButton;

FWorld world;
color buttonColor = #155AAD;
color bodyColor = #6E0595;

SimpleOpenNI  context;
color[]       userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };

float fact;

// Vectores para las manos.
PVector convertedRightHand;
PVector convertedLeftHand;

void setup()
{
  size(1024, 768);
  
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }

  context.setMirror(true);
  
  // enable depthMap generation 
  context.enableDepth();
   
  // enable skeleton generation for all joints
  context.enableUser();
 
  background(0);

  fact = float(width)/640;
  
  
  Fisica.init(this);

  world = new FWorld();
  world.setEdges();
  world.remove(world.left);
  world.remove(world.right);
  world.remove(world.top);

  boxButton = new FBox(40, 40);
  boxButton.setPosition(width/4, 300);
  boxButton.setStatic(true);
  boxButton.setFillColor(buttonColor);
  boxButton.setNoStroke();
  world.add(boxButton);

  
  smooth();  
}

void draw()
{
  // update the cam
  context.update();
  background(0);
  
  findHands();
  
  world.step();
  world.draw();
     
}

void findHands() {
  // Dibujar manos si están disponibles
  int[] userList = context.getUsers();
  for(int i = 0; i < userList.length; i++) {
    if(context.isTrackingSkeleton(userList[i])) {
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
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
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,leftHand);
  convertedLeftHand = new PVector();
  context.convertRealWorldToProjective(leftHand, convertedLeftHand);
  convertedLeftHand.x = convertedLeftHand.x  * fact;
  convertedLeftHand.y = convertedLeftHand.y * fact;
  ellipse(convertedLeftHand.x, convertedLeftHand.y, 40, 40); // Se escala la coordenada.
  
  crearObjetos();
}

void crearObjetos() {
  
  FBody pressed = world.getBody(convertedRightHand.x, convertedRightHand.y);
  if (pressed == boxButton) {
    FBox myBox = new FBox(40, 40);
    myBox.setPosition(width/4, 200);
    myBox.setRotation(random(TWO_PI));
    myBox.setVelocity(0, 200);
    myBox.setFillColor(bodyColor);
    myBox.setNoStroke();
    world.add(myBox);
  }
}

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
  
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

