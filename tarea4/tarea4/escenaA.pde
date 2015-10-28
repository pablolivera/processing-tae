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




    minim = new Minim(this);
    minim.debugOn();
    background(0);
    strokeWeight (3);
    noFill ();
    smooth();
    // get a line in from Minim, default bit depth is 16
    in = minim.getLineIn(Minim.STEREO, 1024);
    fft = new FFT(in.bufferSize(), in.sampleRate());
  }

  void cerrarEscena() {
  }

  String getNombre() {
    return "EscenaA";
  }

  void drawEscena() {
    
    background(0);
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

    float rate = random(-1, 1);
    for (int j = 0; j < 4; j++) {
      rotate (0.9);

      stroke(64, 161, 255, 40); //celeste
      ellipse(rw1, rh1, loudestFreqAmp*16, rate*loudestFreqAmp*16);

      stroke(255, 64, 64, 40); //rojo
      //ellipse(rw2, rh2,loudestFreqAmp*8, rate*loudestFreqAmp*8);
      //}
    }      
    loudestFreqAmp = 0;
    fft.forward(in.mix);  

    timerCounter++;

    if (borro && timerCounter >= 25)
    {
      //println("Clr screen");
      noStroke();
      fill(0, 0, 0, (timerCounter - 25) * 10);
      rotate (pi-(0.9*4));
      translate(-width/2, -height/2);
      rect(0, 0, width*2, height*2);
      noFill ();
      strokeWeight (3);
    }
  }
}

