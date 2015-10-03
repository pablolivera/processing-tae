import java.awt.Frame;
import controlP5.*;
public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  controlP5.Toggle estrellas;
  controlP5.Toggle movimiento;
  controlP5.Toggle bigbang;
  controlP5.Toggle galaxia;
  controlP5.Toggle end;
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

    //Control para iniciar escena primavera.
    estrellas = cp5.addToggle("ESTRELLAS")
      .setPosition(x, y)
        .setSize(50, 20)
          .setValue(false);

    //Control para iniciar escena verano 1.
    movimiento = cp5.addToggle("MOVIMIENTO")
      .setPosition(x+=80, y)
        .setSize(50, 20)
          .setValue(false)
            .lock();

    //Control para iniciar escena verano 2.
    bigbang = cp5.addToggle("BIGBANG")
      .setPosition(x+=80, y)
        .setSize(50, 20)
          .setValue(false)
            .lock();

    //Control para iniciar escena otono 1.
    galaxia = cp5.addToggle("GALAXIA")
      .setPosition(x+=80, y)
        .setSize(50, 20)
          .setValue(false)
            .lock();

    //Control para iniciar escena otono 2.
    end = cp5.addToggle("END")
      .setPosition(x+=80, y)
        .setSize(50, 20)
          .setValue(false)
            .lock();




    //salto de linea
    y+= 50;
    x = 20;

    //tamaño galaxia
    cp5.addSlider("eratio")
      .plugTo(parent, "eratio")
        .setRange(1, 20)
          .setValue(1)
            .setSize(200, 20)
              .setPosition(x, y+=30);

    cp5.addSlider("etwist")
      .plugTo(parent, "etwist")
        .setRange(-0.5, 0.5)
          .setValue(0)
            .setSize(200, 20)
              .setPosition(x, y+=30);

    //Control para tirar las hojas que queden
    //cp5.addToggle("Kinect Conectado")
    //.plugTo(parent, "kinectConectado")
    //.setPosition(x, y)
    //.setSize(50, 20)
    //.setValue(false);

    //Control para tirar las hojas que queden
    //cp5.addToggle("Contorno Silueta Activado")
    //.plugTo(parent, "contornoSiluetaActivado")
    //.setPosition(x+70, y)
    //.setSize(50, 20)
    //.setValue(false);



    //salto de linea
    y+= 50;
    x = 20;

    //velocidad de las hojas al caer en x.
    //cp5.addSlider("Velocidad de Hojas X")
    //.plugTo(parent, "velocidadx")
    //.setRange(0, 300)
    //.setValue(185)
    //.setSize(400, 20)
    //.setPosition(x, y);

    //velocidad de las hojas al caer en y.
    //cp5.addSlider("Velocidad de Hojas Y")
    //.plugTo(parent, "velocidady")
    //.setRange(0, 300)
    //.setValue(250)
    //.setSize(400, 20)
    //.setPosition(x, y+=30);

    //escala de grises del arbol.
    //cp5.addSlider("Color Arbol")
    //.plugTo(parent, "colorArbol")
    //.setRange(1000, 2550)
    //.setValue(2000)
    //.setSize(400, 20)
    //.setPosition(x, y+=30);

    //angulo del viento para las ramas del arbol.
    //cp5.addSlider("Angulo Viento")
    //.plugTo(parent, "windAngle")
    //.setRange(0, 5)
    //.setValue(0.001)
    //.setSize(400, 20)
    //.setPosition(x, y+=30);

    //salto de linea
    y+=40;
    x+=70;


    //textos de referencia para el cambio manual de escenas.
    cp5.addTextlabel("label1")
      .setText("ESTRELLAS:    0.00 - 0.08")
        .setPosition(x, y+=30)
          .setColorValue(230)
            .setFont(createFont("Arial", 20))
              ;
    cp5.addTextlabel("label2")
      .setText("MOVIMIENTO:     0.09 - 1.02")
        .setPosition(x, y+=30)
          .setColorValue(230)
            .setFont(createFont("Arial", 20))
              ;
    cp5.addTextlabel("label3")
      .setText("BIG BANG:     1.03 - 1.10")
        .setPosition(x, y+=30)
          .setColorValue(230)
            .setFont(createFont("Arial", 20))
              ;
    cp5.addTextlabel("label4")
      .setText("GALAXIA:       1.11 - 2.36")
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

  //en el inicio de primavera ajusto booleanos de estaciones y desbloqueo la proxima escena.
  void ESTRELLAS(boolean theFlag) {
    tarea3 c = (tarea3)parent;
    if (theFlag) {
      c.estrellas = true;

      c.movimiento = false;
      movimiento.setValue(false);
      movimiento.unlock();
      movimiento.update();

      c.bigbang = false;
      bigbang.setValue(false);
      bigbang.update();

      c.galaxia = false;
      galaxia.setValue(false);
      galaxia.update();

      c.end = false;
      end.setValue(false);
      end.update();

      c.manejador.proxima();

      println("Estrellas ON");
      c.toSwitch = true;
      ct.reset();
    }
  }

  //en el inicio de verano1 ajusto booleanos de estaciones y desbloqueo la proxima escena.
  void MOVIMIENTO(boolean theFlag) {
    tarea3 c = (tarea3)parent;
    if (theFlag) {
      c.movimiento = true;

      c.estrellas = false;
      estrellas.setValue(false);
      estrellas.update();

      c.bigbang = false;
      bigbang.setValue(false);
      bigbang.unlock();
      bigbang.update();

      c.galaxia = false;
      galaxia.setValue(false);
      galaxia.update();

      c.end = false;
      end.setValue(false);
      end.update();

      c.manejador.proxima();

      println("Movimiento ON");
      c.toSwitch = true;
      ct.reset();
    }
  }

  //en el inicio de verano2 ajusto booleanos de estaciones y desbloqueo la proxima escena.
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

      c.galaxia = false;
      galaxia.setValue(false);
      galaxia.unlock();
      galaxia.update();

      c.end = false;
      end.setValue(false);
      end.update();

      c.manejador.proxima();

      println("BigBang ON");
      c.toSwitch = true;
      ct.reset();
    }
  }

  //en el inicio de otono1 ajusto booleanos de estaciones y desbloqueo la proxima escena.
  void GALAXIA(boolean theFlag) {
    tarea3 c = (tarea3)parent;
    if (theFlag) {
      c.galaxia = true;

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
      end.unlock();
      end.update();

      c.manejador.proxima();
            
      println("Galaxia ON");
      c.toSwitch = true;
      ct.reset();
    }
  }

  ///en el inicio de otono2 ajusto booleanos de estaciones y desbloqueo la proxima escena.
  void END(boolean theFlag) {
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

      c.galaxia = false;
      galaxia.setValue(false);
      galaxia.update();

      c.manejador.reset();

      println("End ON");
      c.toSwitch = true;
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

