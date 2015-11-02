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

    background(255);
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
    fft.window(FFT.HAMMING);

    for (int i = 1; i < fft.specSize (); i=i*4)
    {

      if (fft.getBand(i) > loudestFreqAmp && fft.getBand(i) > 10)
      {
        borro = false;      
        loudestFreqAmp = fft.getBand(i);
        loudestFreq = i * 4;


        timerCounter = 0;
      } else {
        borro = true;
      }
    }
    translate(width/2, height/2); //CENTRAR
    //float b = a + 0.3;
    /*for (int j = 0; j < 4; j++) {
     
     
     */

    /*float wi = ((width /2)-15);
     float ws = ((width /2)+15);
     float hi = ((height/2)-15);
     float hs = ((height/2)+15);
     */

    float wi = -5;
    float ws = +5;
    float hi = -5;
    float hs = +5;

    float rw1 = random(wi, ws);
    float rw2 = random(wi-30, ws+30);
    float rh1 = random(hi, hs);
    float rh2 = random(hi-30, hs+30);
    //println("wi: "+rwi+" ws: "+rws+" hi: "+rhi+"hs: "+rhs);

    println("rw1: "+rw1+" rw2: "+rw2+" rh1: "+rh1+" rh2: "+rh2);

    //float rate = random(-1, 1);
    for (int j = 0; j < 7; j++) {
      //rotate (0.9);

      rotate (0.9);

      if (frameCount%6==0) {
        stroke(230,1,128, 255); //RojoVioleta
        ellipse(0, 0, loudestFreqAmp*2, cx*2);

        stroke(58,212,0, 255); //AmarilloVerde
        ellipse(0, 0, loudestFreqAmp, cx);
      }
      if (frameCount%6==1) {
        stroke(254,254,0, 255); //Amarillo
        ellipse(0, 0, loudestFreqAmp*2, cx*2);

        stroke(151,0,132, 255); //Violeta
        ellipse(0, 0, loudestFreqAmp, cx);
      }
      if (frameCount%6==2) {
        stroke(255,193,0, 255); //AmarilloNaranja
        ellipse(0, 0, loudestFreqAmp*2, cx*2);

        stroke(95,44,145, 255); //AzulVioleta
        ellipse(0, 0, loudestFreqAmp, cx);
      }
      if (frameCount%6==3) {
        stroke(255,128,1, 255); //Naranja
        ellipse(0, 0, loudestFreqAmp*2, cx*2);

        stroke(1,69,255, 255); //Azul
        ellipse(0, 0, loudestFreqAmp, cx);
      }
      if (frameCount%6==4) {
        stroke(255,93,2, 255); //RojoNaranja
        ellipse(0, 0, loudestFreqAmp*2, cx*2);

        stroke(0,133,102, 255); //AzulVerde
        ellipse(0, 0, loudestFreqAmp, cx);
      }
      if (frameCount%6==5) {
        stroke(255,34,0, 255); //celeste
        ellipse(0, 0, loudestFreqAmp*2, cx*2);

        stroke(0,171,33, 255); //rojo
        ellipse(0, 0, loudestFreqAmp, cx);
      }

      
      
      
    }      
    loudestFreqAmp = 0;
    fft.forward(in.mix);  

    timerCounter++;

    if (borro && timerCounter >= 25)
    {
      //println("Clr screen");
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

