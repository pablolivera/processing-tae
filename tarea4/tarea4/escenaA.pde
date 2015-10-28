class EscenaA implements Escena {

  float h2;
  float w2;
  float d2;

  EscenaA() {
  }

  void setupEscena() {
    w2=width/2;
    h2= height/2;
    d2 = dist(0, 0, w2, h2);
    noStroke();
    
  }

  void cerrarEscena() {
  }

  String getNombre() {
    return "EscenaA";
  }

  void drawEscena() {
    background(155);
  }

}
