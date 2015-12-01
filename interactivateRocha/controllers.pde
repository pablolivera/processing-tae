
public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;
  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);

/////////////// Escena 1 /////////////////////////////////
  int menuRef = 20;
    cp5.addSlider("cStroke")
      .plugTo(parent,"strokeCol")
      .setRange(0, 255)
      .setPosition(10,menuRef+10)
      .setSize(250,20)
      .setValue(0)
      .setLabel("Color de linea")
      ;
    strokeCol = 0;  
    
    cp5.addRadioButton("colBW")
      .setPosition(10,menuRef+40)
      .setSize(60,20)
      .setItemsPerRow(3)
      .setSpacingColumn(80)
      .addItem("Blanco y negro",1)
      .addItem("Color",2)
      ;

    cp5.addSlider("strokeWeight")
      .plugTo(parent,"sWeight")
      .setRange(1, 5)
      .setPosition(10,menuRef+70)
      .setSize(250,10)
      .setValue(1)
      .setLabel("Grosor de la linea")
      ;   
    sWeight = 1; 

    cp5.addSlider("displaceMagnitudeControl")
      .plugTo(parent,"displaceMagnitude")
      .setRange(1, 30)
      .setPosition(10,menuRef+90)
      .setSize(250,10)
      .setValue(10)
      .setLabel("Magnitud de cambio")
      ;   
    displaceMagnitude =10;

    cp5.addBang("bang1")
      .setPosition(360, menuRef+10)
      .setSize(80, 80)
      .setLabel("Activar  Escena  1")
      ;

/////////////// Escena 2 /////////////////////////////////
    menuRef = 160;
    cp5.addToggle("gravityControl")
      .plugTo(parent,"gravity")
      .setPosition(10,menuRef+10)
      .setSize(65,20)
      .setValue(true)
      .setLabel("Sin gravitacion")
      ;
    gravity = false;

    cp5.addToggle("linesControl")
      .plugTo(parent,"lines")
      .setPosition(95,menuRef+10)
      .setSize(65,20)
      .setValue(true)
      .setLabel("Puntos o lineas")
      ;
    lines = false;

    cp5.addToggle("rejectControl")
      .plugTo(parent,"reject")
      .setPosition(180,menuRef+10)
      .setSize(65,20)
      .setValue(false)
      .setLabel("Atraer o rechazar")
      ;
    reject = false;

    
    cp5.addSlider("influenceControl")
      .plugTo(parent,"influenceRadius")
      .setRange(1, 200)
      .setPosition(10,menuRef+50)
      .setSize(250,10)
      .setValue(70)
      .setLabel("Radio de influencia");
    influenceRadius =70;
    
    cp5.addSlider("strokeWeightFluid")
      .plugTo(parent,"sWeightFluid")
      .setRange(1, 20)
      .setPosition(10,menuRef+70)
      .setSize(250,10)
      .setValue(1)
      .setLabel("Grosor de la linea")
      ;
    sWeightFluid = 1;
    
    cp5.addSlider("lineTransparencyControl")
      .plugTo(parent,"lineTransparency")
      .setRange(1, 255)
      .setPosition(10,menuRef+110)
      .setSize(250,10)
      .setValue(200)
      .setLabel("Transparencia del trazo")
      ;
    lineTransparency = 200;


    cp5.addSlider("cFondoFluid")
      .plugTo(parent,"backColFluid")
      .setRange(0, 255)
      .setPosition(10,menuRef+90)
      .setSize(250,10)
      .setValue(0)
      .setLabel("Color del fondo")
      ;
    backColFluid = 0;  

    cp5.addBang("bang2")
      .setPosition(360, menuRef+5)
      .setSize(80, 80)
      .setLabel("Activar  Escena  2")
      ;  

    
////////////////// Escena 3//////////////////////////////
    menuRef = 330;

    cp5.addRadioButton("generar particulas")
      .setPosition(10,menuRef+10)
      .setSize(40,20)
      .setItemsPerRow(2)
      .setSpacingColumn(20)
      .addItem("si",1)
      .addItem("no",2)
      ;
    generateNewPoints = true;

    cp5.addToggle("borrar particulas")
      .setPosition(160,menuRef+10)
      .setSize(40,20)
      .setLabel("borrar")
      ;

    cp5.addToggle("mostrar radio de atraccion")
      .setPosition(220,menuRef+10)
      .setSize(40,20)
      .setLabel("mostrar radio")
      .setValue(true)
      ;
    showAttractionRadius = true;

    cp5.addSlider("radio de atraccion")
      .plugTo(parent,"attractionRadius")
      .setRange(0, 255)
      .setPosition(10,menuRef+60)
      .setSize(250,10)
      .setValue(200)
      ;
    attractionRadius = 200;

    cp5.addSlider("color fondo")
      .plugTo(parent,"backColorHands")
      .setRange(0, 255)
      .setPosition(10,menuRef+80)
      .setSize(250,10)
      .setValue(0)
      ;
    backColorHands = 0;

    cp5.addSlider("color puntos")
      .plugTo(parent,"pointsColorHands")
      .setRange(0, 255)
      .setPosition(10,menuRef+100)
      .setSize(250,10)
      .setValue(120)
      ;
    pointsColorHands = 120;

    rMin=10;
    rMax=20;
    cp5.addRange("radio de particulas")
      .setBroadcast(false) 
      .setRange(2, 50)
      .setPosition(10,menuRef+120)
      .setSize(250,10)
      .setHandleSize(20)
      .setValue(100)
      .setRangeValues(rMin,rMax)
      .setBroadcast(true)
      ;

    cp5.addSlider("transparencia")
      .plugTo(parent,"pointTransparency")
      .setRange(0, 255)
      .setPosition(10,menuRef+140)
      .setSize(250,10)
      .setValue(122)
      ;
    pointTransparency = 122;

    cp5.addSlider("velocidad de creacion")
      .plugTo(parent,"generationFrequency")
      .setRange(6, 10)
      .setPosition(10,menuRef+160)
      .setSize(250,10)
      .setValue(1)
      ;
    generationFrequency = 6;

    cp5.addSlider("fuerza de atraccion")
      .plugTo(parent,"attractionStrength")
      .setRange(-1, 1)
      .setPosition(10,menuRef+180)
      .setSize(250,10)
      .setValue(0.1)
      ;
    attractionStrength = 0.1;

    cp5.addBang("bang3")
      .setPosition(360, menuRef+10)
      .setSize(80, 80)
      .setLabel("Activar  Escena  3")
      ; 


/////////////////// Escena 4 /////////////////////////////
    menuRef = 560;
    cp5.addSlider("meTvTransparencyControl")
      .plugTo(parent,"meTvTransparency")
      .setRange(0, 255)
      .setPosition(10,menuRef+20)
      .setSize(250,10)
      .setValue(40)
      .setLabel("Transparencia")
      ;
    meTvTransparency = 40;

    cp5.addButton("select picture")
     .setPosition(10,menuRef+40)
     .setSize(60,30)
     .setLabel("Elegi imagen")
     ;

    cp5.addBang("bang4")
      .setPosition(360, menuRef+10)
      .setSize(80, 80)
      .setLabel("Activar  Escena  4")
      ; 

  }




  void controlEvent(ControlEvent theEvent) {
    String n = theEvent.getName();

    // Escena 1
    if( n == "colBW") {
      float v = theEvent.getValue();
      if ( v == 1 ) inColor = false;
      if ( v == 2 ) inColor = true;
    }
    else if( n == "bang1") {
      manager.activate(0);
    }
    // Escena 2
    else if( n == "gravityControl") {
      gravity = !gravity;
    }
    else if( n == "linesControl") {
      lines = !lines;
    }
    else if( n == "rejectControl") {
      reject = !reject;
    }
    else if( n == "bang2") {
      manager.activate(1);
    }
    // Escena 3
    else if( n == "generar particulas"){
      float v = theEvent.getValue();
      if ( v == 1 ) generateNewPoints = true;
      if ( v == 2 ) generateNewPoints = false;
    }

    else if( n == "borrar particulas"){
      if (manager.actualScene.getSceneName() == "Hands"){
        println("borramos particulas");
        manager.actualScene.initialScene();
      }
    } 
    else if( n == "mostrar radio de atraccion"){
      showAttractionRadius = !showAttractionRadius;
    }
    else if( n == "radio de particulas") {
      rMin = int(theEvent.getController().getArrayValue(0));
      rMax = int(theEvent.getController().getArrayValue(1));
    }
    else if( n == "bang3") {
      manager.activate(2);
    }
    // Escena 4
    else if( n == "select picture") {
      loadBackPicture();
    }
    else if( n == "bang4") {
      manager.activate(3);
    }
  }

  public void draw() {
    background(0);
    fill(255);
    text("Escena 1 - Espejo de lineas",10,20);
    stroke(255,0,0);

    line(5,135,445,135);
    text("Escena 2 - Sistema de particulas",10,160);

    line(5,305,445,305);
    text("Escena 3 - Generador de puntos",10,330);  

    line(5,535,445,535);
    text("Escena 4 - Yo en la imagen",10,560);  
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

