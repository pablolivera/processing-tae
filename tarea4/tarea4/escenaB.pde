/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/5488*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
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
    // get a line in from Minim, default bit depth is 16
    //in = minim.getLineIn(Minim.STEREO, 1024);
    //fft = new FFT(in.bufferSize(), in.sampleRate());
  }

  void cerrarEscena() {
    // always close M  inim audio classes when you are done with them
    //in.close();
    //minim.stop();
    //super.stop();
  }

  String getNombre() {
    return "EscenaB";
  }

  void drawEscena() {
    
    //background(255);

    noStroke();

    fft.window(FFT.HAMMING);
    for (int i = 0; i < fft.specSize (); i++)
    {
      // draw the line for frequency band i, scaling it by 4 so we can
      //see it a bit better
      //stroke(0);
      line(i, height, i, height - fft.getBand(i)*4);
      if (fft.getBand(i) > loudestFreqAmp && fft.getBand(i) > 10)
      {
        loudestFreqAmp = fft.getBand(i);
        loudestFreq = i * 4;
        //sine.setFreq(loudestFreq);
        fill(255,255,255, random(50,255));
        if (loudestFreq < 10)
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

    // draw the waveforms
    /*  for(int i = 0; i < in.bufferSize() - 1; i++)
     {
     line(i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50);
     line(i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50);
     }*/

    fft.forward(in.mix);
    timerCounter++;
    if (timerCounter >= 30)
    {
      //println("Clr screen");
      fill(fondo, fondo, fondo, (timerCounter - 30) * 2);
      rect(0, 0, width, height);
    }
  }
}

