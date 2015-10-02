class ManejadorEscenas {

  Escena[] escenas;  
  Escena actual;
  int actual_indx;

  ManejadorEscenas() {

    Escena [] todas = {        
      new Movimiento()
      };

      escenas = todas;
    actual_indx = 0;
    escenas[0].setupEscena();
    actual = escenas[0];
  }

  void proxima() {
    int indx = (actual_indx+1)%(escenas.length);
    activar(indx);
  }

  void previa() {
    int indx;
    if (actual_indx-1 < 0) indx = escenas.length -1;
    else indx = (actual_indx-1)%(escenas.length);
    activar(indx);
  }

  void activar(int indx) {
    stopDraw = true;
    actual_indx = indx;
    actual.cerrarEscena();
    actual = escenas[indx];
    actual.setupEscena();
    println(indx, actual.getNombre());
    stopDraw = false;
  }
}


// Escena
interface Escena
{ 
  void setupEscena();
  void drawEscena();
  void cerrarEscena();
  String getNombre();
}

