import java.awt.Frame;
public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;

  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);

    /*cp5.addSlider("Numero de brazos")
     .plugTo(parent,"num")
     .setRange(2, 6)
     .setPosition(10,10);
     cp5.addSlider("Color de fondo")
     .plugTo(parent,"backCol")
     .setRange(0, 255)
     .setPosition(10,30);
     cp5.addSlider("Tamano de los circulos")
     .plugTo(parent,"extraAdd")
     .setRange(0, 45)
     .setPosition(10,50);*/

    cp5.addToggle("Empezar escena")
      .plugTo(parent, "startEscena")
        .setPosition(10, 10)
          .setSize(50, 20)
            .setValue(false);

    cp5.addToggle("Arbol Crece")
      .plugTo(parent, "crece")
        .setPosition(90, 10)
          .setSize(50, 20)
            .setValue(true);

    cp5.addToggle("Cambio de colores")
      .plugTo(parent, "toSwitch")
        .setPosition(10, 50)
          .setSize(50, 20)
            .setValue(false);

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

