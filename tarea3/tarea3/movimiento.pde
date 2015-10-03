class Movimiento implements Escena {

  ArrayList<PVector> stars = new ArrayList<PVector>();
  float h2;//=height/2
  float w2;//=width/2
  float d2;//=diagonal/2

    Movimiento() {
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
    return "movimiento";
  }

  void drawEscena() {
    //el color sera un gris dependiendo de la distancia del centro de masa a a mitad de la pantalla.
    //cy, cy globales, centro de masa.
    fill(0, map(dist(cx, cy, w2, h2), 0, d2, 255, 5));
    rect(0, 0, width, height);
    fill(255);

    for (int i = 0; i<20; i++) {   // star init
      stars.add(new PVector(random(width), random(height), random(1, 3)));
    }

    for (int i = 0; i<stars.size (); i++) {
      float x =stars.get(i).x;//local vars
      float y =stars.get(i).y;
      float d =stars.get(i).z;

      //el movimiento de las estrellas
      //si no hay kinect dependen del mouse.
      float enX = mouseX;
      float enY = mouseY;
      //si hay y no esta el warp activado con las manos
      if (!movimientoWarp) {
        if (convertedRightHand!=null) enX = min(convertedRightHand.x, convertedLeftHand.x);
        if (convertedLeftHand!=null) enY =  min(convertedRightHand.y, convertedLeftHand.y);
      } 
      //sino warp
      else {
        enX = 0;
        enY = 0;
      }

      stars.set(i, new PVector(x-map(enX, 0, width, -0.05, 0.05)*(w2-x), y-map(enY, 0, height, -0.05, 0.05)*(h2-y), d+0.2-0.6*noise(x, y, frameCount)));


      if (d > 3 ||d < -3) { 
        stars.set(i, new PVector(x, y, 3));
      }
      if (x < 0 || x > width || y < 0 || y > height) stars.remove(i);
      if (stars.size()>9999) stars.remove(1);
      ellipse(x, y, d, d);//draw stars
    }
  }
}










