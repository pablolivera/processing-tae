/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/6147*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
//SYSTEM 1 by krqluld / 18th november 200
class Singularidad implements Escena {

  PImage loadedImg;
  ArrayList particles;


  void cerrarEscena() {
  }

  String getNombre() {
    return "Singularidad";
  }

  void setupEscena() {
    background(0);

    particles = new ArrayList();
    forces = new ArrayList();

    buffer = createImage(width, height, RGB);

    loadedImg = loadImage("_1.jpg");
    loadedImg.resize(width, 0);
    loadedImg.loadPixels();
    for (int y = 0; y < loadedImg.height; y+= 3) {
      for (int x = 0; x < loadedImg.width; x+= 3) {
        color c = loadedImg.pixels[y*loadedImg.width+x];
        Particle p = new Particle(x, y, c);
        particles.add(p);
      }
    }

    //initiating forces
    handIzqForce = new Force(new PVector(0, 0), 300, false, false);
    handDerForce = new Force(new PVector(0, 0), 300, false, false);
    mouseForce = new Force(new PVector(0, 0), 300, false, false);
    forces.add(handIzqForce);
    forces.add(handDerForce);
    forces.add(mouseForce);
  }

  void drawEscena() {
    background(0);

    if (!kinectConectado) {
      mouseForce.pos.set(cx, cy, 0);
      mouseForce.forceOn = true;
    } else {
      if (convertedRightHand!=null) {
        handDerForce.pos.set(convertedRightHand.x, convertedRightHand.y, 0);
        handDerForce.forceOn = true;
      }
      if (convertedLeftHand!=null) {
        handIzqForce.pos.set(convertedLeftHand.x, convertedLeftHand.y, 0);
        handIzqForce.forceOn = true;
      }
    }

    buffer.loadPixels();
    if (clear) {
      color black = color(0);
      for (int i = 0; i < buffer.pixels.length; i++) {
        buffer.pixels[i] = 0;
      }
    }
    for (int i = particles.size ()-1; i>=0; i--) {
      Particle p = (Particle) particles.get(i);
      p.run();
    }
    buffer.updatePixels();
    image(buffer, 0, 0);  

    if (renderForces) {
      for (int i = forces.size ()-1; i>=0; i--) {
        Force f = (Force) forces.get(i);
        f.render();
      }
    }
  }

  void addForce(PVector pos, float mass, boolean attract, boolean on) {
    forces.add(new Force(pos, mass, attract, on));
  }

  boolean circleIntercept(PVector pos, PVector circlePos, float radius) {
    float dis = dist(pos.x, pos.y, circlePos.x, circlePos.y);
    if (dis <= radius) {
      return true;
    } else {
      return false;
    }
  }
}

