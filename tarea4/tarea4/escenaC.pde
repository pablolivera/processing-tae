class EscenaC implements Escena {

  private String palabra;

  EscenaC(String palabra) {
    this.palabra = palabra;
  }

  void setupEscena() {
    //size(1100, 400, JAVA2D);
    background(fondo);
    smooth();
    //pg = createGraphics(width, height, JAVA2D);
    pg.beginDraw();
    pg.textSize(140);
    pg.textAlign(CENTER, CENTER);
    pg.fill(PGRAPHICS_COLOR);
    float a = random(4);
    float b = a > 2 ? random(a-2) : random(a+2);
    pg.text("hijo", pg.width/2, pg.height/2);
    //pg.text("viento", pg.width/a, pg.height/a); 
    pg.endDraw();
  }

  void cerrarEscena() {
  }

  String getNombre() {
    return "EscenaC";
  }

  void drawEscena() {
    background(fondo);
    fill(fondo);
    stroke(0);
    
    if (frameCount %50 == 0) {     
      pg.beginDraw();
      pg.textSize(140);
      pg.textAlign(CENTER, CENTER);
      pg.fill(PGRAPHICS_COLOR);
      float a = random(4);
      float b = a > 2 ? random(a-2) : random(a+2);
      pg.text(palabras[(int)random(2.99)], random(100, width-100), random(40,height-50));
      //pg.text("viento", pg.width/a, pg.height/a); 
      pg.endDraw();
    }

    textAlign(CENTER, CENTER);

    if (chrs.size() < 4000) {
      for (int i=0; i<60; i++) {
        //Aca va cx
        float x = random(width);
        //Aca va cy
        float y = random(height);

        color c = pg.get( int(x), int(y) );
        if ( c == PGRAPHICS_COLOR ) {
          chrs.add( new OneChr(x, y, 1) );
        }
      }
    }
    for ( OneChr oc : chrs) {
      oc.updateMe();
    }
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
    glowOffs = random(5) * -1;
    int radi = floor(random(4));
    myRotate = ( HALF_PI * radi);
    float sizeFactor = random(2);
    mySize = ( int( max(10, (pow( sizeFactor, 5)))) );
    myChr = 'A'; //char( int(random(33, 126)));
  }

  void updateMe() {
    noStroke();
    fill(255-fondo, max( myBrightness + glowOffs, 0));
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

