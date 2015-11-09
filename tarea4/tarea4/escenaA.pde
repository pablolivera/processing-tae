import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.signals.*;

class EscenaA implements Escena {

  EscenaA() {
  }

  void setupEscena() {

    w2=width/2;
    h2= height/2;
    d2 = dist(0, 0, w2, h2);
    noStroke();

    background(fondo);
    strokeWeight (3);
    noFill ();
    smooth();
  }

  void cerrarEscena() {
  }

  String getNombre() {
    return "EscenaA";
  }

  void drawEscena() {

    
    background(fondo);

    translate(width/2, height/2); //CENTRAR
    

    float wi = -5;
    float ws = +5;
    float hi = -5;
    float hs = +5;

    float rw1 = random(wi, ws);
    float rw2 = random(wi-30, ws+30);
    float rh1 = random(hi, hs);
    float rh2 = random(hi-30, hs+30);
     

    float radioW = cx > width ? width : cx;
    radioW = radioW < 0 ? 0 : radioW;
    float radioH = frequency > height ? height : frequency;

   
    //float rate = random(-1, 1);
    for (int j = 0; j < 5; j++) {
      //rotate (0.9);

      rotate (0.6);

      noFill();
      if (radioH>10 && radioW>10) {
        int valor = (int)random(230);
        strokeWeight(3);
        stroke(200, 200, 200, valor); //Circulo blanco de afuera
        ellipse(0, 0, radioH, radioW);

        strokeWeight(6);
        stroke(random(100), random(100), random(100), 255-valor); //Circulos de colores internos
        ellipse(0, 0, radioH/2, radioW/2);
      }
      
    }      

    timerCounter++;

    if (borro && timerCounter >= 25)
    {
     
      noStroke();
      fill(fondo, fondo, fondo, (timerCounter - 25) * 10);
      rotate (pi-(0.9*4));
      translate(-width, -height);
      rect(0, 0, width*16, height*16);
      noFill ();
      strokeWeight (3);
    }
  }
}

