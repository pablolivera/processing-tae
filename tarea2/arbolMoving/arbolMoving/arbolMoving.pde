/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/90192*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* @pjs globalKeyEvents=true; */


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
PImage leaveImage;
int cont = 0;
//var curContext; // Javascript drawing context (for faster rendering)


///////////////////////////////////////////////////////////
// Init ///////////////////////////////////////////////////
///////////////////////////////////////////////////////////
void setup() {
  size(800, 600, P2D); // Set screen size & renderer
  textFont(createFont("Verdana", 24, true), 24); // Create font
  PGraphics back = createGraphics(width, height, P2D);
  leaveImage = createLeaveImage();
  createNewTree("OpenProcessing");
  //curContext = externals.context; // Get javascript drawing context
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
      scale = 500/xSize;
  } else {
    if (ySize > 500)
      scale = 500/ySize;
  }
  tree.setScale(scale);
  tree.x = width/2 - xSize/2*scale + (tree.x-minX)*scale;
  tree.y = height/2 + ySize/2*scale + (tree.y-maxY)*scale;
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
  windAngle += 0.001; //Con 0.01 parece que se MUEREEEE
  tree.windForce = sin(windAngle) * 0.08;
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
}


///////////////////////////////////////////////////////////
// Compute text input /////////////////////////////////////
///////////////////////////////////////////////////////////
void keyReleased() {
  blinkUpdate = millis();
  if (key != CODED) { // Compute ASCII key input
    switch(key) {
    case BACKSPACE: 
    case DELETE:
      typedText = typedText.substring(0, max(0, typedText.length()-1));
      break;
    case TAB:
      typedText += "   ";
      break;
    case ENTER: 
    case RETURN:
      createNewTree(typedText);
      break;
    default:
      //typedText += (int)key > 31 ? String.fromCharCode(key) : "";
    }
  }
  switch(keyCode) { // Compute Non-ASCII key input
  case 127: // Workaround: If BACKSPACE/DELETE do not work on your browser
    typedText = typedText.substring(0, max(0, typedText.length()-2));
    break;
  case 17: // Workaround: If RETURN/ENTER do not work on your browser
    createNewTree(typedText);
    break;
  case 18: // Save tree
    if (typedText.length() == 0) {
      saveFrame("YourTree.png");
      blinkUpdate = -1;
    }
  }
}


///////////////////////////////////////////////////////////
// Create new random tree /////////////////////////////////
///////////////////////////////////////////////////////////
void mouseClicked() {
  createNewTree(getRandomSeed());
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
    if (length > 10) {
      if (length+random(length*10) > 30)
        branchA = new Branch(this, xB, yB, -0.1-random(0.4) + ((angle % TWO_PI) > PI ? -1/length : +1/length), length*(0.6+random(0.3)));
      if (length+random(length*10) > 30)
        branchB = new Branch(this, xB, yB, 0.1+random(0.4) + ((angle % TWO_PI) > PI ? -1/length : +1/length), length*(0.6+random(0.3)));
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
      if (branchA != null) {
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
        bezierVertex(xB, yB, xB, yB, branchA.x, branchA.y);
        endShape();

        /*curContext.beginPath();
         curContext.moveTo(x, y);
         curContext.bezierCurveTo(xB, yB, xB, yB, branchA.x, branchA.y);
         int branchColor = floor(1100/length);
         curContext.strokeStyle = "rgb("+branchColor+","+branchColor+","+branchColor+")";
         curContext.lineWidth = length/5;
         curContext.stroke();*/
        branchA.render(maxLen);
        if (branchB != null)
          branchB.render(maxLen);
      } else {
        pushMatrix();
        translate(x, y);
        rotate(-angle);
        image(leaveImage, -leaveImage.width/2, 0);
        popMatrix();
      }
    }
  }
}

