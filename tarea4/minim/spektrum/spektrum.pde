// Source: http://www.creativecoding.org/lesson/topics/audio/sound-in-processing

import ddf.minim.*;
 
Minim minim;
AudioInput input;
 
float yStart = 100;
float yScale = 140;
 
void setup () {
  // Sketch einstellen
  size (800, 600);
  smooth();
  noStroke ();
  colorMode (HSB);
   
  // Audiotoolkit anlegen
  minim = new Minim (this);
  input = minim.getLineIn (Minim.STEREO, 96);
}
 
void draw () {
  background (0);
   
  // Auslesen und speichern des Spektrums
  float[] buffer = input.mix.toArray ();
  // Breite der Rechtecke berechnen
  float step = ceil ((float) width / buffer.length);
   
  // FÃ¼r jeden einzelnen Eintrag im Buffer wird ein 
  // Rechteck gezeichnet. Es entsteht durch das verbinden
  // zweier Buffer-EintrÃ¤ge. Die Schleife beginnt bei 1, 
  // jeder Eintrag wird mit seinem VorgÃ¤nger verbunden.
  for (int i=1; i < buffer.length; i++) {
     
    // Positionen fÃ¼r alle 4 Punkt bestimmen
    float x1 = (i-1) * step;
    float x2 = i * step;
    float y1 = yStart + buffer[i-1] * yScale;
    float y2 = yStart + buffer[i] * yScale;
     
    // FÃ¼llfarbe definieren
    float h = (buffer[i-1] + buffer[i]) / 2;
    fill (h * 255, 255, 255);
     
    // Rechteck zeichnen
    beginShape (QUADS);
    vertex (x1, y1);
    vertex (x2, y2);
    vertex (x2, height);
    vertex (x1, height);
    endShape ();
  }
}
