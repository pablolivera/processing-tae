// Basado en el ejemplo Interactive - Ewelina Bakala
class Galaxia implements Escena { 

  public PImage bImg;
  PImage imagenDeFondo;
  String nombreImagen = "";
  PImage [] imagenes = new PImage[6];
  int cantImagenes = 6;
  int i = 0;

  public Galaxia() {}

  void setupEscena() {
      
      // Cargo las imagenes en un arra
      for (int imagen = 0; imagen < cantImagenes; imagen++) {
        nombreImagen = imagen + ".jpg";
        imagenes[imagen] = loadImage(nombreImagen);            
      }
      
  }

  void drawEscena() { 
    
    if (kinectConectado) { // Si no esta conectado no se ve nada 
    
    background(0);   
        imagenDeFondo = imagenes[i%cantImagenes];
    
        rect(0, 0, width, height);
        bImg = obtenerImagenPersona(imagenDeFondo);
        image(bImg, 0, 0);
        
        if (frameCount % 10 == 0) {
          i = i % cantImagenes;
          i++;
        }
          
        // Por las dudas que se vaya de tema el i
        if (i == 2147483647) {
            i = 0;
        }
    }
    
  }

  void cerrarEscena() {
  }

  String getNombre() {
    return "Galaxia";
  }


  // Funciones Auxiliares
  PImage obtenerImagenPersona(PImage imagenDeFondo) {

    // para imagen de la kinect
    //println("back w h ",imagenDeFondo.width,imagenDeFondo.height);
    PImage img = new PImage(context.depthWidth(), context.depthHeight(), ARGB); 
    img.loadPixels();
    // para imagen escalada
    PImage bigImg = new PImage(width, height, ARGB); 
    bigImg.loadPixels();

    context.update();
    int[]   userMap = context.userMap();
    int[]   depthMap = context.depthMap();


    // Obtengo la imagen del kinect y "prendo" los pixeles que "caen" dentro 
    int index;
    for (int x = 0; x < context.depthWidth(); x++)
    {
      for (int y = 0; y < context.depthHeight(); y++)
      {
        index = x + y * context.depthWidth();
        int d = depthMap[index];
        // si no hay usuarios
        // ponemos un pixel transparente
        img.pixels[index] = color(0, 0);
        if (d>0) {
          int userNr =userMap[index];
          if ( userNr > 0)
          { 
            img.pixels[index] = imagenDeFondo.pixels[index];
          }
        }
      }
    }
    img.updatePixels(); 
    // escalamos las imagenes
    bigImg.copy(img, 0, 0, 640, 480, 0, 0, width, height);
    return bigImg;
  }
  
}

