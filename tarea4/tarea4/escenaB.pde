
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.signals.*;



class EscenaB implements Escena {

  EscenaB() {
  }

  void setupEscena() {
    
    frameRate(30);

    minim = new Minim(this);
    minim.debugOn();
    background(fondo);
    noStroke();
    
  }

  void cerrarEscena() {

  }

  String getNombre() {
    return "EscenaB";
  }

  void drawEscena() {


    noStroke();

    fft.window(FFT.HAMMING);
    for (int i = 0; i < fft.specSize (); i++)
    {
      
      line(i, height, i, height - fft.getBand(i)*4);
      if (fft.getBand(i) > loudestFreqAmp && fft.getBand(i) > 10)
      {
        loudestFreqAmp = fft.getBand(i);
        loudestFreq = i * 4;
        
        fill(255-fondo,255-fondo,255-fondo, random(50,255));
        if (loudestFreq < 5)
        {
          triangle(random(0, width), random(0, height), random(0, width), random(0, height), random(0, width)+loudestFreqAmp, random(0, height)+loudestFreqAmp);
          
        } 
        else if (loudestFreq < 23)
        {
          rect(random(0, width), random(0, height), loudestFreqAmp, loudestFreqAmp);
        } else
        {
          if(loudestFreq < 30){
            fill(255,0,0, random(50,255));
          }
          ellipse(random(0, width), random(0, height), loudestFreqAmp, loudestFreqAmp);
        }
        timerCounter = 0;
      }
    }
    loudestFreqAmp = 0;


    fft.forward(in.mix);
    timerCounter++;
    if (timerCounter >= 30)
    {

      fill(fondo, fondo, fondo, (timerCounter - 30) * 2);
      rect(0, 0, width, height);
    }
  }
}

