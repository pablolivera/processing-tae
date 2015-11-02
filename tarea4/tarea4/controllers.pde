import java.awt.Frame;
import controlP5.*;
public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  
  controlP5.Toggle escenaAToggle;
  controlP5.Toggle escenaBToggle;
  controlP5.Toggle escenaCToggle;
  
  /*controlP5.Slider eratio;
  controlP5.Slider etwist;
  controlP5.Toggle warp;*/
  
  ControlTimer ct;
  Textlabel t;

  public void setup() {
    size(w, h);
    frameRate(30);
    cp5 = new ControlP5(this);
    
    // Timer para tener el tiempo en el cursor.
    ct = new ControlTimer();
    t = new Textlabel(cp5, "--", 100, 100);
    ct.setSpeedOfTime(1);

    // Posicion inicial de los controles  
    int x = 20;
    int y = 30;

    // Control para que aparezca la silueta de la persona
    cp5.addToggle("Debug Body")
      .plugTo(parent, "debugBody")
        .setPosition(x+=80, y)
          .setSize(50, 20)
            .setValue(false);
    
    // Posicion inicial de los controles  
    x = 20;
    y += 30;
    
    // Control para iniciar Escena A
    cp5.addToggle("EscenaA")
      .setPosition(x+=80,y)
        .setSize(50,20)
          .setValue(false);
         
    // Control para iniciar Escena B
    cp5.addToggle("EscenaB")
      .setPosition(x+=80,y)
        .setSize(50,20)
          .setValue(false);
          
    // Control para iniciar Escena C
    cp5.addToggle("EscenaC")
      .setPosition(x+=80,y)
        .setSize(50,20)
          .setValue(false);
 
    //salto de linea
    y+= 50;
    x = 20;         
}

  

  public void draw() {
    background(0);
    t.setValue(ct.toString());
    t.draw(this);
    t.setPosition(mouseX, mouseY);
    tarea4 t4 = (tarea4)parent;
    
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
  
  // En el inicio de la escena A se ajustan booleanos y desbloqueo la proxima escena
  void EscenaA(boolean theFlag) {
    tarea4 t4 = (tarea4)parent;
    if (theFlag) {
      t4.escenaA = true;
      
      t4.escenaB = false;
      //escenaB.setValue(false);
      //escenaB.update();
      
      t4.escenaC = false;
      //escenaC.setValue(false);
      //escenaC.update();
      
      t4.manejador.proxima();
      
      println("EscenaA ON");
      t4.toSwitch = true;
      ct.reset();
      
    }
  }
  
  // En el inicio de la escena B se ajustan booleanos y desbloqueo la proxima escena
  void EscenaB(boolean theFlag) {
    tarea4 t4 = (tarea4)parent;
    if (theFlag) {
      t4.escenaA = false;
      //escenaA.setValue(false);
      //escenaA.update();
      
      t4.escenaB = true;
      
      t4.escenaC = false;
      //escenaC.setValue(false);
      //escenaC.update();
      
      t4.manejador.proxima();
      
      println("EscenaB ON");
      t4.toSwitch = true;
      ct.reset();
      
    }
  }
  
  // En el inicio de la escena B se ajustan booleanos y desbloqueo la proxima escena
  void EscenaC(boolean theFlag) {
    tarea4 t4 = (tarea4)parent;
    if (theFlag) {
      t4.escenaA = false;
      //escenaA.setValue(false);
      //escenaA.update();
      
      t4.escenaB = false;
      //escenaC.setValue(false);
      //escenaC.update();
      
      t4.escenaC = true;
      
      t4.manejador.proxima();
      
      println("EscenaC ON");
      t4.toSwitch = true;
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

