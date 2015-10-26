// Source: http://creativec0d3r.blogspot.com.uy/2013/01/how-to-get-frequency-values-from-mic.html

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
FFT fft;

int sampleRate= 44100;//sapleRate of 44100

float frequency;//the frequency in hertz
float frequencyPrint = 10000;
float highestAmp;

void setup()
{
  size(400, 200);

  minim = new Minim(this);
  //minim.debugOn();
  in = minim.getLineIn(Minim.MONO, 4096, sampleRate);
  fft = new FFT(in.left.size(), sampleRate);
}

void draw()
{

  background(0);//black BG

  findFrequency(); // obtener la frecuencia
  
  if (frequency > frequencyPrint) {
    textSize(20); //size of the text

    text (frequency + " hz", 50, 80);//display the frequency in hertz

    pushStyle();
    fill(240);

    text ("Cambia escena ", 50, 150);//display the note name
    popStyle();
  }
}

void findFrequency() {
  highestAmp = 0;
  fft.forward(in.left);
  for (int f = 0; f < sampleRate/2; f++) { //analyses the amplitude of each frequency analysed, between 0 and 22050 hertz
    float amplitude = fft.getFreq(float(f)); //each index is correspondent to a frequency and contains the amplitude value
    if(amplitude > highestAmp) {
      highestAmp = amplitude;
      frequency = f;
    }
  }
}

void stop() {
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();

  super.stop();
}

