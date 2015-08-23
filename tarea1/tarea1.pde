
import SimpleOpenNI.*;
import controlP5.ControlP5;
import java.awt.*;

// dimensiones de la pantalla del sketch
int sizeW = 1024;
int sizeH = 768;

double scale = (double)sizeW / (double)640;
double barraAnterior = 0;

// dimensiones de la pantalla del sketch de los controles
int sizeCW = 250;
int sizeCH = 400;

SimpleOpenNI  context;
PVector com = new PVector();
PVector com2d = new PVector();
ControlP5 cp5;
Tarea1Control tarea1Control;
PImage img;

int[] userClr = { color(255,0,0),
        color(0,255,0),
        color(0,0,255),
        color(255,255,0),
        color(255,0,255),
        color(0,255,255)
};

// aca estan los colores de las barras
// definidos en el colorMode RGB -> https://processing.org/reference/colorMode_.html
// color( R, G, B)
int[] color_bars = {
        color(192,192,192),
        color(192,192,0),
        color(0,192,192),
        color(0,192,0),
        color(192,0,192),
        color(192,0,0),
        color(0,0,192)
};

int[] color_bars_in = {
        color(255 - 192,255 - 192,255 - 192),
        color(255 - 192,255 - 192,255 - 0),
        color(255 - 0,255 - 192,255 - 192),
        color(255 - 0,255 - 192,255 - 0),
        color(255 - 192,255 - 0,255 - 192),
        color(255 - 192,255 - 0,255 - 0),
        color(255 - 0,255 - 0,255 - 192)
};

// aca se guarda el nro total de los colores definidos
int colorsNr = color_bars.length;

boolean toSwitch = false;
int contTiempoConvulsiones = 0;
boolean cambiarFondo = false;

// esta funcion se ejecuta una vez sola, al principio
void setup(){
    size(sizeW, sizeH);

    String nombreImagen = "fondo" + sizeW + "x" + sizeH + ".jpg";
    img = loadImage(nombreImagen);

    cp5 = new ControlP5(this);
    tarea1Control = addControlFrame("Controladores", sizeCW, sizeCH, colorsNr);

    context = new SimpleOpenNI(this);
    if(context.isInit() == false)
    {
        println("Can't init SimpleOpenNI, maybe the camera is not connected!");
        exit();
        return;
    }

    // enable depthMap generation
    context.enableDepth();

    // enable skeleton generation for all joints
    context.enableUser();

    background(255);

    noStroke();
    smooth();
}

void draw() {
    //background(255);
    // update the cam
    context.update();

    // draw the skeleton if it's available
    int[] userList = context.getUsers();
    for(int i = 0; i < userList.length; i++) {
        if(context.getCoM(userList[i], com)) {
            context.convertRealWorldToProjective(com, com2d);
            //drawCenterOfMass(userList, i);
            //ajuste
            //drawLineasAjuste(userList,i);
        }
    }

    //Convulsiones
    if (tarea1Control.velocidad != 0 && contTiempoConvulsiones % tarea1Control.velocidad == 0) {
            int[] aux = color_bars;
            color_bars = color_bars_in;
            color_bars_in = aux;
            contTiempoConvulsiones = 0;
    }
    else if(contTiempoConvulsiones > 50000000) {
        contTiempoConvulsiones = 0;
    }
    contTiempoConvulsiones++;

    if(cambiarFondo) {
        image(img, 0, 0);
    }
    else {
        // la funcion que creamos para dibujar el fondo ruidoso
        createNoisyBackground();
    }
    // la funcion que dibuja las barras de colores
    // le pasamos la cantidad de barras que queremos dibujar
    drawTv(colorsNr);

}

void createNoisyBackground() {
    // una función ya dada que carga los datos de los píxeles de la pantalla de visualización en el pixels [] array
    // siempre debe ser llamada antes de leer o escribir en pixels [].
    loadPixels();

    // recorremos todos los pixeles
    for (int i = 0; i < pixels.length; i++) {
        // y si el numero que fue "sorteado" en la funcion random(x) es mayor de 50 el pixel va a ser blanco
        if(random(100)>50) pixels[i] = color(255);
            // en el caso contrario, sera negro
        else pixels[i] = color(40);
    }
    // una función ya dada que actualiza la ventana de la pantalla con los datos de los pixels [] array
    updatePixels();
}

void drawTv( int bars_nr) {
    // definimos el ancho de las barras
    // por el tema del redondeo hacemos +1 para cubrir toda la pantalla
    int bar_width = width / bars_nr + 1;

    double posX = com2d.x;
    if(Double.isNaN(posX) || posX < 0 || posX > 640) {
        posX = barraAnterior;
    }
    else {
        barraAnterior = posX;
    }

    int whichBar = (int)((posX * scale) / bar_width);

    // dibujamos las barras
    for (int i = 0; i < bars_nr; i ++) {
        if((!toSwitch && whichBar != i) || (toSwitch && whichBar == i)) {
            fill(color_bars[i % colorsNr]);
            rect(i * bar_width, 0, bar_width, height);
        }
    }
}

Tarea1Control addControlFrame(String name, int width, int height, int colorsLength) {
    Frame frame = new Frame(name);
    Tarea1Control control = new Tarea1Control(this, width, height, colorsLength);
    frame.add(control);
    control.init();
    frame.setTitle(name);
    frame.setSize(control.sizeW, control.sizeH);
    frame.setLocation(100, 100);
    frame.setResizable(false);
    frame.setVisible(true);
    return control;
}



