class EscenaC implements Escena {

  private String [] palabras = {
    "hijo", "rebelde", "esclavo", "viento", "fuerte", "vivo"
  };
  private int [] coords = {
    1, 3, 5, 7, 9, 10
  };

  EscenaC() {
  }

  void setupEscena() {
    background(240);
    smooth();
    for (int i=0; i<palabras.length; i++) {
      pg.beginDraw();
      pg.textAlign(CENTER, CENTER);
      pg.fill(PGRAPHICS_COLOR);
      float a = coords[(i*3)%(coords.length-1)]*(height/10);
      ;
      float b = coords[i]*(height/10);
      String w = palabras[i];
      pg.textSize(100 + (int)random(10));
      pg.text(w, a, b);
      //pg.text("viento", pg.width/a, pg.height/a); 
      pg.endDraw();
    }
  }

  void cerrarEscena() {
  }

  String getNombre() {
    return "EscenaC";
  }

  void drawEscena() {
    fill(255);
    stroke(0);
    textAlign(CENTER, CENTER);



    if (chrs.size() < 2000) {
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
    glowOffs = random(40) * -1;
    int radi = floor(random(4));
    myRotate = ( HALF_PI * radi);
    float sizeFactor = random(2);
    mySize = ( int( max(9, (pow( sizeFactor, 3)))) );
    myChr = Character.toChars(int(random(95, 122)))[0];//'A'; //char( int(random(33, 126)));
  }

  void updateMe() {
    noStroke();
    //colores con mano derecha y frecuencia
    int r = (int) map(convertedRightHand.x, 0, width, 0, 255);
    int g = (int) map(convertedRightHand.y, 0, height, 0, 255);
    int b = (int) map(frequency, 0, 22050, 0, 255);
    fill(r,g,b, max( myBrightness + glowOffs, 0));
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

