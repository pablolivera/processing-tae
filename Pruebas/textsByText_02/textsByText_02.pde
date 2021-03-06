  /* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/204199*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
color ELLIPSE_COLOR = color(0);
color LINE_COLOR = color(0, 125);
color PGRAPHICS_COLOR = color(0); 
int LINE_LENGTH = 25;
boolean reverseDrawing = false;

PGraphics pg;
PFont font;
ArrayList<OneChr> chrs = new ArrayList<OneChr>();

void setup() {
  size(1100, 400, JAVA2D);
  background(240);
  smooth();
  pg = createGraphics(width, height, JAVA2D);
  pg.beginDraw();
  pg.textSize(140);
  pg.textAlign(CENTER, CENTER);
  pg.fill(PGRAPHICS_COLOR);
  float a = random(4);
  float b = a > 2 ? random(a-2) : random(a+2);
  pg.text("hijo", pg.width/b, pg.height/b);
  pg.text("viento", pg.width/a, pg.height/a); 
  pg.endDraw();

}

void draw() {

  fill(255);
  stroke(0);
  textAlign(CENTER, CENTER);
 
  if(chrs.size() < 2000){
  for (int i=0; i<60; i++) {
    float x = random(mouseX);
    float y = random(mouseY);
    color c = pg.get( int(x), int(y) );
    if ( c == PGRAPHICS_COLOR ) {
      chrs.add( new OneChr(x,y,1) );      
    }
  }
  }
  for( OneChr oc: chrs){
    oc.updateMe();
  }
  
}

class OneChr {
  float x, y;
  float myRotate;
  float myBrightness, glowSpeed, glowOffs;
  int mySize;
  char myChr; 

  OneChr(float _x, float _y, float gS) {
    x = _x;
    y = _y;
    glowSpeed = gS;
    myBrightness = 0;
    glowOffs = random(40) * -1;

    int radi = floor(random(4));
    myRotate = ( HALF_PI * radi);
    float sizeFactor = random(1.5);
    mySize = ( int( max(10, (pow( sizeFactor , 5)))) );
    myChr = char( int(random(33, 126)));
  }

  void updateMe() {
    noStroke();
    fill(0, max( myBrightness + glowOffs , 0));
    pushMatrix();
    translate(x, y);
    int radi = floor(random(4));
    rotate( myRotate );
    textSize( mySize );
    text( myChr, 0, 0);
    popMatrix();
    myBrightness += glowSpeed;
    myBrightness = min(myBrightness, (255+ (-1 * glowOffs)) );
  }
}


