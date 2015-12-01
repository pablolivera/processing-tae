import java.awt.Frame;
import controlP5.*;
public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  controlP5.Toggle estrellas;
  controlP5.Toggle movimiento;
  controlP5.Toggle bigbang;
  controlP5.Toggle imagenes;
  controlP5.Toggle end;
  controlP5.Toggle reset;

  controlP5.Slider eratio;
  controlP5.Slider etwist;
  controlP5.Toggle warp;
  ControlTimer ct;
  Textlabel t;

  public void setup() {
    size(w, h);
    frameRate(30);
    cp5 = new ControlP5(this);
    //Timer para tener el tiempo en el cursor.
    ct = new ControlTimer();
    t = new Textlabel(cp5, "--", 100, 100);
    ct.setSpeedOfTime(1);

    //Posicion inicial de los controles  
    int x = 20;
    int y = 30;

    //Control para iniciar escena estrellas.
    estrellas = cp5.addToggle("ESTRELLAS")
      .setPosition(x, y)
        .setSize(50, 20)
          .setValue(false);

    //Control para iniciar escena imagenes.
    imagenes = cp5.addToggle("IMAGENES")
      .setPosition(x+=80, y)
        .setSize(50, 20)
          .setValue(false);

    //Control para iniciar escena movimiento.
    movimiento = cp5.addToggle("MOVIMIENTO")
      .setPosition(x+=80, y)
        .setSize(50, 20)
          .setValue(false);

    //Control para iniciar escena singularidad - saturno.
    end = cp5.addToggle("SING")
      .setPosition(x+=80, y)
        .setSize(50, 20)
          .setValue(false);

    //Control para iniciar escena bigbang.
    bigbang = cp5.addToggle("BIGBANG")
      .setPosition(x+=80, y)
        .setSize(50, 20)
          .setValue(false);

    //Control para iniciar escena reset.
    reset = cp5.addToggle("RESET")
      .setPosition(x+=80, y)
        .setSize(50, 20)
          .setValue(false);

    //salto de linea
    y+= 50;
    x = 20;

    //tamaño imagenes
    eratio = cp5.addSlider("eratio")
      .plugTo(parent, "eratio")
        .setRange(1, 20)
          .setValue(1)
            .setSize(200, 20)
              .setPosition(x, y+=30);

    // grado de giro de la galaxia - escena estrellas
    etwist = cp5.addSlider("etwist")
      .plugTo(parent, "etwist")
        .setRange(-0.5, 0.5)
          .setValue(0)
            .setSize(200, 20)
              .setPosition(x, y+=30);

    // distancia desde el centro de masa al centro de la galaxia - escena estrellas
    cp5.addSlider("offset")
      .plugTo(parent, "offset")
        .setRange(0, 500)
          .setValue(322)
            .setSize(200, 20)
              .setPosition(x, y+=30);

    //salto de linea
    y+= 50;
    x = 20;

    // control alternativo para ignorar el movimiento de las manos
    warp = cp5.addToggle("Warp (Movimiento)")
      .plugTo(parent, "movimientoWarp")
        .setPosition(x, y)
          .setSize(50, 20)
            .lock()
              .setValue(false);

    cp5.addToggle("Debug Body")
      .plugTo(parent, "debugBody")
        .setPosition(x+80, y)
          .setSize(50, 20)
            .setValue(false);

    cp5.addToggle("Play Video")
      .plugTo(parent, "playVideo")
        .setPosition(x+160, y)
          .setSize(50, 20)
            .setValue(false);

    //salto de linea
    y+=40;
    x+=70;

    //textos de referencia para el cambio manual de escenas.
    cp5.addTextlabel("label1")
      .setText("ESTRELLAS:    0.00 - 0.34")
        .setPosition(x, y+=30)
          .setColorValue(230)
            .setFont(createFont("Arial", 20))
              ;
    cp5.addTextlabel("label2")
      .setText("IMAGENES:     0.35 - 1.05")
        .setPosition(x, y+=30)
          .setColorValue(230)
            .setFont(createFont("Arial", 20))
              ;
    cp5.addTextlabel("label3")
      .setText("MOVIMIENTO:     1.06 - 1.36")
        .setPosition(x, y+=30)
          .setColorValue(230)
            .setFont(createFont("Arial", 20))
              ;
    cp5.addTextlabel("label4")
      .setText("SINGULARIDAD:       1.37 - 2.36")
        .setPosition(x, y+=30)
          .setColorValue(230)
            .setFont(createFont("Arial", 20))
              ;
    cp5.addTextlabel("label5")
      .setText("END:       2.37 - 3.04")
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
    tarea3 c = (tarea3)parent;
    eratio.setValue(c.eratio);
    eratio.update();
    etwist.setValue(c.etwist);
    etwist.update();
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

  //en el inicio de la escena estrellas se ajustan booleanos y desbloqueo la proxima escena.
  void ESTRELLAS(boolean theFlag) {
    tarea3 c = (tarea3)parent;
    if (theFlag) {
      c.estrellas = true;

      c.movimiento = false;
      movimiento.setValue(false);
      movimiento.update();

      c.bigbang = false;
      bigbang.setValue(false);
      bigbang.update();

      c.imagenes = false;
      imagenes.setValue(false);
      imagenes.update();

      c.end = false;
      end.setValue(false);
      end.update();

      reset.setValue(false);
      reset.update();

      c.manejador.proxima();

      println("Estrellas ON");
      c.toSwitch = true;
      ct.reset();
    }
  }

  //en el inicio de la escena movimiento se ajustan booleanos y desbloqueo la proxima escena.
  void MOVIMIENTO(boolean theFlag) {
    tarea3 c = (tarea3)parent;
    if (theFlag) {
      c.movimiento = true;

      c.estrellas = false;
      estrellas.setValue(false);
      estrellas.update();

      c.bigbang = false;
      bigbang.setValue(false);
      bigbang.update();

      warp.unlock();
      warp.setValue(false);
      warp.update();

      c.imagenes = false;
      imagenes.setValue(false);
      imagenes.update();

      c.end = false;
      end.setValue(false);
      end.update();

      c.manejador.proxima();

      println("Movimiento ON");
      c.toSwitch = true;
    }
  }

  //en el inicio de la escena big bang se ajustan booleanos y desbloqueo la proxima escena.
  void BIGBANG(boolean theFlag) {
    tarea3 c = (tarea3)parent;
    if (theFlag) {
      c.bigbang = true;

      c.estrellas = false;
      estrellas.setValue(false);
      estrellas.update();

      c.movimiento = false;
      movimiento.setValue(false);
      movimiento.update();

      c.imagenes = false;
      imagenes.setValue(false);
      imagenes.update();

      c.end = false;
      end.setValue(false);
      end.update();

      c.manejador.proxima();

      println("BigBang ON");
      c.toSwitch = true;
    }
  }

  //en el inicio de la escena imagenes se ajustan booleanos y desbloqueo la proxima escena.
  void IMAGENES(boolean theFlag) {
    tarea3 c = (tarea3)parent;
    if (theFlag) {
      c.imagenes = true;

      c.estrellas = false;
      estrellas.setValue(false);
      estrellas.update();

      c.movimiento = false;
      movimiento.setValue(false);
      movimiento.update();

      c.bigbang = false;
      bigbang.setValue(false);
      bigbang.update();

      c.end = false;
      end.setValue(false);      
      end.update();

      c.manejador.proxima();

      println("Imagenes ON");
      c.toSwitch = true;
    }
  }

  //en el inicio de la escena singularidad se ajustan booleanos y desbloqueo la proxima escena.
  void SING(boolean theFlag) {
    tarea3 c = (tarea3)parent;
    if (theFlag) {
      c.end = true;

      c.estrellas = false;
      estrellas.setValue(false);
      estrellas.update();

      c.movimiento = false;
      movimiento.setValue(false);
      movimiento.update();

      c.bigbang = false;
      bigbang.setValue(false);
      bigbang.update();

      c.imagenes = false;
      imagenes.setValue(false);
      imagenes.update();

      c.manejador.proxima();

      println("End ON");
      c.toSwitch = true;
    }
  }

  void RESET(boolean theFlag) {
    tarea3 c = (tarea3)parent;
    if (theFlag) {

      c.manejador.reset();

      println("RESET");
      ct.reset();
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

