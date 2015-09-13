//basado en el sketch: http://www.openprocessing.org/sketch/90192
//autor: http://www.openprocessing.org/user/25079
//clase para crear las ramas y hojas.
class Branch {


  //definicion de variables
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


  //Contructor, posicion de la rama (x,y), inclinacion offset: angleOffset, profundidad de la recursion: length
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
        //rama derecha
        branchA = new Branch(this, xB, yB, -0.05-random(0.2) + ((angle % TWO_PI) > PI ? -1/length : +1/length), length*(0.95));
      }
      if (length+random(length) > 29) {
        //rama izquierda
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


  //tamano del arbol
  void setScale(float scale) {
    length *= scale;
    if (branchA != null) {
      branchA.setScale(scale);
      if (branchB != null)
        branchB.setScale(scale);
    }
  }


  //actualizacion del arbol en cada iteracion de draw.
  void update() {
    //mientras crece, en "primavera".
    if (esPrimavera) {
      if (parent != null) {
        x = parent.x + sin(parent.angle) * parent.length * parent.growth;
        y = parent.y + cos(parent.angle) * parent.length * parent.growth;
        windForce = parent.windForce * (1.0+5.0/length) + blastForce;
        blastForce = (blastForce + sin(x/2+windAngle)*0.005/length) * 0.98;
        angle = parent.angle + angleOffset + windForce + blastForce;
        growth = min(growth + 0.01*parent.growth, 1);
      } else
        growth = min(growth + 0.001, 1);
      if (branchA != null) {
        branchA.update();
        if (branchB != null)
          branchB.update();
      }
    } 
    //cuando se achica en "invierno"
    else if (esInvierno) {
      if (parent != null) {
        x = parent.x + sin(parent.angle) * parent.length * parent.growth;
        y = parent.y + cos(parent.angle) * parent.length * parent.growth;
        windForce = parent.windForce * (1.0+5.0/length) + blastForce;
        blastForce = (blastForce + sin(x/2+windAngle)*0.005/length) * 0.98;
        angle = parent.angle + angleOffset + windForce + blastForce;
        growth = min(growth - 0.0008*parent.growth, 1);
      } else
        growth = min(growth - 0.001, 1);
      if (branchA != null) {
        branchA.update();
        if (branchB != null)
          branchB.update();
      }
    }
  }


  //dibujo del arbol en cada iteracion del draw.
  void render(int maxLen) {
    if (length > maxLen) {
      //mientras son ramas
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
        stroke(floor(2000/length));
        strokeWeight(length/5);
        beginShape();
        vertex(x, y);
        bezierVertex(xB, yB, xB, yB, branchB.x, branchB.y);
        endShape();
        branchB.render(maxLen);
        if (branchA != null)
          branchA.render(maxLen);
      } 
      //al final se agregan las hojas.
      else {
        pushMatrix();
        translate(x, y);
        rotate(-angle);
        //en "verano" se van agregando hojas con cierta probabilidad mientras no supere el maximo de hojas establecido.
        if ((esVerano1)&&(random(1000)>999)&&(cantHojas<maxHojas)) {
          FBody f = circulo(x, y);
          f.setStatic(true);
          world.add(f);
          cantHojas++;
        }
        popMatrix();
      }
    }
  }
}

