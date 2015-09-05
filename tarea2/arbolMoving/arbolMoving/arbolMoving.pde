/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/90192*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* @pjs globalKeyEvents=true; */
import fisica.*;

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
int cantHojas = 0;
FWorld world;
FBox f;
//FBox obstacle;
//FCircle obstacle;
//FLine obstacle;
FPoly obstacle;
FLine obstacle1;


///////////////////////////////////////////////////////////
// Init ///////////////////////////////////////////////////
///////////////////////////////////////////////////////////
void setup() {
  size(800, 600, P2D); // Set screen size & renderer
  textFont(createFont("Verdana", 24, true), 24); // Create font
  PGraphics back = createGraphics(width, height, P2D);
  leaveImagePrimavera = createLeaveImage();
  leaveImageOtono = createLeaveImage2();
  createNewTree("OpenProcessing");
  //curContext = externals.context; // Get javascript drawing context

  //FISICA
  hayHoja = new Boolean[width/4][height/4];
  for (int i=0; i<width/4; i++) {
    for (int j=0; j<height/4; j++) {
      //println("x:"+i+" y:"+j);
      hayHoja[i][j]=new Boolean(false);
    }
  }
  Fisica.init(this);

  world = new FWorld();


  obstacle = new FPoly();
  obstacle.vertex(0, 0);
  obstacle.vertex(40, 40);
  obstacle1 = new FLine(0, 50, 20, 30);


  obstacle.setPosition(width/2, height/2);
  obstacle.setStatic(true);
  obstacle.setFill(0);
  obstacle.setRestitution(0);

  obstacle1.setPosition(width/2, height/2);
  obstacle1.setStatic(true);
  obstacle1.setFill(0);
  obstacle1.setRestitution(0);


  world.add(obstacle);
  world.add(obstacle1);
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
  PGraphics buffer = createGraphics(12, 18, P2D);
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
  PGraphics buffer = createGraphics(12, 18, P2D);
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
      scale = 730/xSize;
  } else {
    if (ySize > 500)
      scale = 730/ySize;
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

  background(0);
  //fill(200); 
  noStroke();
  //rect(120, 120, width-240, height-240);
  noFill();
  windAngle += 0.0001; //Con 0.01 parece que se MUEREEEE
  tree.windForce = sin(windAngle) * 0.005;
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
  world.draw();
  world.step();
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
        if (x < mouseX) {
          pushMatrix();
          translate(x, y);
          rotate(-angle);
          if ((random(10)>=5)&&(cantHojas<5500)&&(!hayHoja[(int)(x/4)][(int)(y/4)]) && (mouseY<(height/2))) {
            f = new FBox(5, 5);
            f.attachImage(leaveImageOtono);
            f.setPosition(x, y);
            float angle = random(TWO_PI);
            float magnitude = 200;
            f.setVelocity(magnitude*cos(angle), magnitude*sin(angle));
            f.setDamping(0);
            f.setRestitution(0.5);
            f.setRotatable(true);
            f.setRotation(random(PI/2));
            world.add(f);


            /*hoja = new FCircle(10);
             hoja.setPosition(x, y);
             hayHoja[(int)(x/4)][(int)(y/4)] = true;
             hoja.setVelocity(0, 200);
             hoja.setRestitution(0);
             hoja.setNoStroke();
             hoja.setFill(200, 30, 90);
             world.add(hoja);*/


            //image(leaveImagePrimavera, -leaveImagePrimavera.width/2, 0);
          } else if ((cantHojas<5500)||(hayHoja[(int)(x/4)][(int)(y/4)])) {
            image(leaveImageOtono, -leaveImageOtono.width/2, 0);
          }
          hayHoja[(int)(x/4)][(int)(y/4)] = true;
          cantHojas++;
          popMatrix();
        } else {
          hayHoja[(int)(x/4)][(int)(y/4)] = false;
          cantHojas--;
        }
      }
    }
  }
}

