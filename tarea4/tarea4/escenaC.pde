class EscenaC implements Escena {

  private String palabra;

  EscenaC(String palabra) {
    this.palabra = palabra;
  }

  void setupEscena() {
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

