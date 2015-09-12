import java.awt.Frame;
import controlP5.*;
public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  controlP5.Toggle verano1;
  controlP5.Toggle verano2;
  controlP5.Toggle otono1;
  controlP5.Toggle otono2;
  controlP5.Toggle invierno;
  controlP5.Toggle primavera;
  ControlTimer ct;
  Textlabel t;

  public void setup() {
    size(w, h);
    frameRate(30);
    cp5 = new ControlP5(this);
    ct = new ControlTimer();
    t = new Textlabel(cp5, "--", 100, 100);
    ct.setSpeedOfTime(1);

    int x = 20;
    int y = 30;

    primavera = cp5.addToggle("PRIMAVERA")
      .setPosition(x, y)
        .setSize(50, 20)
          .plugTo(parent, "esPrimavera")
            .setValue(false);

    verano1 = cp5.addToggle("VERANO_1")
      .setPosition(x+=80, y)
        .setSize(50, 20)
          .plugTo(parent, "esVerano1")
            .setValue(false)
              .lock();

    verano2 = cp5.addToggle("VERANO_2")
      .setPosition(x+=80, y)
        .setSize(50, 20)
          .plugTo(parent, "esVerano2")
            .setValue(false)
              .lock();

    otono1 = cp5.addToggle("OTONO_1")
      .setPosition(x+=80, y)
        .setSize(50, 20)
          .plugTo(parent, "esOtono1")
            .setValue(false)
              .lock();

    otono2 = cp5.addToggle("OTONO_2")
      .setPosition(x+=80, y)
        .setSize(50, 20)
          .plugTo(parent, "esOtono2")
            .setValue(false)
              .lock();

    invierno = cp5.addToggle("INVIERNO")
      .setPosition(x+=80, y)
        .setSize(50, 20)
          .plugTo(parent, "esInvierno")
            .setValue(false)
              .lock();


    y+= 50;
    x = 20;


    cp5.addToggle("Tirar hojas")
      .plugTo(parent, "tirarHojas")
        .setPosition(x, y)
          .setSize(50, 20)
            .setValue(false);

    y+= 50;
    x = 20;


    cp5.addSlider("Velocidad X")
      .plugTo(parent, "velocidadx")
        .setRange(0, 300)
          .setValue(20)
            .setSize(400, 20)
              .setPosition(x, y);

    cp5.addSlider("Velocidad Y")
      .plugTo(parent, "velocidady")
        .setRange(0, 300)
          .setValue(200)
            .setSize(400, 20)
              .setPosition(x, y+=30);

    cp5.addSlider("Color Arbol")
      .plugTo(parent, "colorArbol")
        .setRange(1000, 2550)
          .setValue(2000)
            .setSize(400, 20)
              .setPosition(x, y+=30);

    cp5.addSlider("Angulo Viento")
      .plugTo(parent, "windAngle")
        .setRange(0, 5)
          .setValue(0.001)
            .setSize(400, 20)
              .setPosition(x, y+=30);
              
    y+=40;
    x+=70;

    cp5.addTextlabel("label1")
      .setText("PRIMAVERA:    0.00 - 0.55")
        .setPosition(x, y+=30)
          .setColorValue(230)
            .setFont(createFont("Arial", 20))
              ;
    cp5.addTextlabel("label2")
      .setText("VERANO_1:     0.55 - 1.52")
        .setPosition(x, y+=30)
          .setColorValue(230)
            .setFont(createFont("Arial", 20))
              ;
    cp5.addTextlabel("label3")
      .setText("VERANO_2:     1.52 - 3.01")
        .setPosition(x, y+=30)
          .setColorValue(230)
            .setFont(createFont("Arial", 20))
              ;
    cp5.addTextlabel("label4")
      .setText("OTONO_1:       3.01 - 3.13")
        .setPosition(x, y+=30)
          .setColorValue(230)
            .setFont(createFont("Arial", 20))
              ;
    cp5.addTextlabel("label5")
      .setText("OTONO_2:       3.13 - 3.43")
        .setPosition(x, y+=30)
          .setColorValue(230)
            .setFont(createFont("Arial", 20))
              ;

    cp5.addTextlabel("label6")
      .setText("INVIERNO:      3.43 - FIN")
        .setPosition(x, y+=30)
          .setColorValue(230)
            .setFont(createFont("Arial", 20))
              ;
  }
  public void draw() {
    background(0);
    t.setValue(ct.toString());
    t.draw(this);
    t.setPosition(mouseX, mouseY);
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
  void PRIMAVERA(boolean theFlag) {
    integracion c = (integracion)parent;
    if (theFlag) {
      c.esOtono1 = false;
      otono1.setValue(false);
      otono1.update();
      c.esOtono2 = false;
      otono2.setValue(false);
      otono2.update();
      c.esVerano1 = false;
      verano1.setValue(false);
      verano1.unlock();
      verano1.update();
      c.esInvierno = false;
      invierno.setValue(false);
      invierno.update();
      c.esVerano2 = false;
      verano2.setValue(false);
      verano2.update();
      println("Primavera ON");
      ct.reset();
    }
  }
  void VERANO_1(boolean theFlag) {
    integracion c = (integracion)parent;
    if (theFlag) {
      c.esVerano1 = true;

      c.esOtono1 = false;
      otono1.setValue(false);
      otono1.update();
      c.esOtono2 = false;
      otono2.setValue(false);
      otono2.update();
      c.esPrimavera = false;
      primavera.setValue(false);
      primavera.lock();
      primavera.update();
      c.esInvierno = false;
      invierno.setValue(false);
      invierno.update();
      c.esVerano2 = false;
      verano2.setValue(false);
      verano2.unlock();
      verano2.update();
      println("Verano1 ON");
    }
  }
  void VERANO_2(boolean theFlag) {
    integracion c = (integracion)parent;
    if (theFlag) {
      c.esOtono1 = false;
      otono1.setValue(false);
      otono1.unlock();
      otono1.update();
      c.esOtono2 = false;
      otono2.setValue(false);
      otono2.update();
      c.esPrimavera = false;
      primavera.setValue(false);
      primavera.update();
      c.esInvierno = false;
      invierno.setValue(false);
      invierno.update();
      c.esVerano1 = false;
      verano1.setValue(false);
      verano1.lock();
      verano1.update();
      println("Verano2 ON");
    }
  }
  void OTONO_1(boolean theFlag) {
    integracion c = (integracion)parent;
    if (theFlag) {
      c.esOtono2 = false;
      otono2.setValue(false);
      otono2.unlock();
      otono2.update();
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
      verano2.lock();
      verano2.update();
    }
  }
  void OTONO_2(boolean theFlag) {
    integracion c = (integracion)parent;
    if (theFlag) {
      c.esOtono1 = false;
      otono1.setValue(false);
      otono1.lock();
      otono1.update();
      c.esVerano1 = false;
      verano1.setValue(false);
      verano1.update();
      c.esPrimavera = false;
      primavera.setValue(false);
      primavera.update();
      c.esInvierno = false;
      invierno.setValue(false);
      invierno.unlock();
      invierno.update();
      println("Otono ON");
      c.esVerano2 = false;
      verano2.setValue(false);
      verano2.update();
    }
  }
  void INVIERNO(boolean theFlag) {
    integracion c = (integracion)parent;
    if (theFlag) {
      c.esOtono1 = false;
      otono1.setValue(false);
      otono1.update();
      c.esOtono2 = false;
      otono2.setValue(false);
      otono2.lock();
      otono2.update();
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

