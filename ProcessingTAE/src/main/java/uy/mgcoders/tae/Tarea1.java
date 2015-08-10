package uy.mgcoders.tae;

import processing.core.PApplet;
import SimpleOpenNI.*;

/**
 * Created by raul on 10/08/15.
 */
public class Tarea1 extends PApplet {

    SimpleOpenNI  context;

    // aca estan los colores de las barras
// definidos en el colorMode RGB -> https://processing.org/reference/colorMode_.html
// color( R, G, B)
    int [] color_bars={
            color(192,192,192),
            color(192,192,0),
            color(0,192,192),
            color(0,192,0),
            color(192,0,192),
            color(192,0,0),
            color(0,0,192)
    };

    // aca se guarda el nro total de los colores definidos
    int colorsNr = color_bars.length;

    // esta funcion se ejecuta una vez sola, al principio
    public void setup(){
        // size define el tamano de nuestro sketch
        size(1024,768);
        // por defecto esta cargada la opcion de dibujar un contorno de color negro en las figuras
        // la queremos deshabilitar
        noStroke();

        //initialize context variable
        context = new SimpleOpenNI(this);

        //asks OpenNI to initialize and start receiving depth sensor's data
        context.enableDepth();
    };

    // esta funcion se ejecuta todo el tiempo en un loop constante
    public void draw(){
        // la funcion que creamos para dibujar el fondo ruidoso
        //createNoisyBackground();
        // la funcion que dibuja las barras de colores
        // le pasamos la cantidad de barras que queremos dibujar
        //drawTv(colorsNr);

        //asks kinect to send new data
        context.update();

        //draws the depth map data as an image to the window
        //at position 0(left),0(top) corner
        image(context.depthImage(),0,0);

    };

    void createNoisyBackground(){
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
        int bar_width = width / bars_nr +1;
        // en funcion de la posicion x del mouse definimos cual de las barras de colores no se dibujara
        int whichBar = (int)(mouseX / bar_width);



        // dibujamos las barras
        for (int i = 0; i < bars_nr; i ++) {
            // dibujamos solo si el mouse no esta parado en esta barra
            if(whichBar != i) {
                // el color de la barra se corresponde a un color definido en el array color_bars[]
                fill(color_bars[i%colorsNr]);
                // dibujamos el rectangulo
                rect(i * bar_width, 0, bar_width, height);
            }
        }
    }

}
