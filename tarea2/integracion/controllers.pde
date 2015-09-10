import java.awt.Frame;
import controlP5.*;
public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  controlP5.Toggle verano1;
  controlP5.Toggle verano2;
  controlP5.Toggle otono;
  controlP5.Toggle invierno;
  controlP5.Toggle primavera;

  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);



    primavera = cp5.addToggle("togglePrimavera")
      .setPosition(10, 50)
        .setSize(50, 20)
          .plugTo(parent, "esPrimavera")
            .setValue(false)
              .setMode(ControlP5.SWITCH)
                ;

    verano1 = cp5.addToggle("toggleVerano1")
      .setPosition(90, 50)
        .setSize(50, 20)
          .plugTo(parent, "esVerano1")
            .setValue(false)
              .setMode(ControlP5.SWITCH)
                ;

    verano2 = cp5.addToggle("toggleVerano2")
      .setPosition(170, 50)
        .setSize(50, 20)
          .plugTo(parent, "esVerano2")
            .setValue(false)
              .setMode(ControlP5.SWITCH)
                ;

    otono = cp5.addToggle("toggleOtono")
      .setPosition(250, 50)
        .setSize(50, 20)
          .plugTo(parent, "esOtono")
            .setValue(false)
              .setMode(ControlP5.SWITCH)
                ;

    invierno = cp5.addToggle("toggleInvierno")
      .setPosition(330, 50)
        .setSize(50, 20)
          .plugTo(parent, "esInvierno")
            .setValue(false)
              .setMode(ControlP5.SWITCH)
                ;

    cp5.addToggle("Lanzar hojas")
      .plugTo(parent, "lanzarHojas")
        .setPosition(10, 90)
          .setSize(50, 20)
            .setValue(false);

    cp5.addToggle("Tirar hojas")
      .plugTo(parent, "tirarHojas")
        .setPosition(90, 90)
          .setSize(50, 20)
            .setValue(false);

    cp5.addSlider("Velocidad X")
      .plugTo(parent, "velocidadx")
        .setRange(0, 300)
          .setValue(20)
            .setPosition(10, 130);

    cp5.addSlider("Velocidad Y")
      .plugTo(parent, "velocidady")
        .setRange(0, 300)
          .setValue(200)
            .setPosition(10, 160);

    cp5.addSlider("Color Arbol")
      .plugTo(parent, "colorArbol")
        .setRange(1000, 2550)
          .setValue(2000)
            .setPosition(10, 190);
  }
  public void draw() {
    background(0);
  }
  private ControlFrame() {
  }
  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }
  public ControlP5 control() {
    return cp5;
  }
  void toggleVerano1(boolean theFlag) {
    integracion c = (integracion)parent;
    if (theFlag) {
      c.esOtono = false;
      otono.setValue(false);
      otono.update();
      c.esPrimavera = false;
      primavera.setValue(false);
      primavera.update();
      c.esInvierno = false;
      invierno.setValue(false);
      invierno.update();
      c.esVerano2 = false;
      verano2.setValue(false);
      verano2.update();
      println("Verano1 ON");
    }
  }
  void toggleVerano2(boolean theFlag) {
    integracion c = (integracion)parent;
    if (theFlag) {
      c.esOtono = false;
      otono.setValue(false);
      otono.update();
      c.esPrimavera = false;
      primavera.setValue(false);
      primavera.update();
      c.esInvierno = false;
      invierno.setValue(false);
      invierno.update();
      c.esVerano1 = false;
      verano1.setValue(false);
      verano1.update();
      println("Verano2 ON");
    }
  }
  void toggleOtono(boolean theFlag) {
    integracion c = (integracion)parent;
    if (theFlag) {
      c.esVerano1 = false;
      verano1.setValue(false);
      verano1.update();
      c.esPrimavera = false;
      primavera.setValue(false);
      primavera.update();
      c.esInvierno = false;
      invierno.setValue(false);
      invierno.update();
      println("Otono ON");
      c.esVerano2 = false;
      verano2.setValue(false);
      verano2.update();
    }
  }
  void toggleInvierno(boolean theFlag) {
    integracion c = (integracion)parent;
    if (theFlag) {
      c.esOtono = false;
      otono.setValue(false);
      otono.update();
      c.esPrimavera = false;
      primavera.setValue(false);
      primavera.update();
      c.esVerano1 = false;
      verano1.setValue(false);
      verano1.update();
      c.esVerano2 = false;
      verano2.setValue(false);
      verano2.update();
      println("Invierno ON");
    }
  }
  void togglePrimavera(boolean theFlag) {
    integracion c = (integracion)parent;
    if (theFlag) {
      c.esOtono = false;
      otono.setValue(false);
      otono.update();
      c.esVerano1 = false;
      verano1.setValue(false);
      verano1.update();
      c.esInvierno = false;
      invierno.setValue(false);
      invierno.update();
      c.esVerano2 = false;
      verano2.setValue(false);
      verano2.update();
      println("Primavera ON");
    }
  }
}

ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}

