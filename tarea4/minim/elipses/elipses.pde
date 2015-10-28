/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/33001*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
//import processing.pdf.*;

//float a = 0.3

void setup () {
  size (1366, 768);
  //beginRecord(PDF, "PDF.pdf");
  strokeWeight (1);
  noFill ();
  smooth();
  //frameRate(5);
}
void draw () {



  background(0);

  translate(width/2, height/2); //CENTRAR
  //float b = a + 0.3;
  for (int i = 0; i < width/20; i++) {

    rotate (0.9);

    stroke(64, 161, 255, 40); //celeste
    ellipse(i/10, i/100, mouseX*2, mouseY*2);
    rectMode(CENTER);
    //rect(i/10,i/100,mouseX*2,mouseY*2);
    stroke(255, 64, 64, 40); //rojo
    ellipse(i/3, i/100, mouseX, mouseY);
  }
  //endRecord();
}

void mousePressed() {
  saveFrame("img ##.bmp");
}

