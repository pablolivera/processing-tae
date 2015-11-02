class ManejadorEscenas {

  Escena[] escenas;
  Escena actual;
  int actual_indx;

  ManejadorEscenas() {

    Escena [] todas = {
      new EscenaA(),
      new EscenaB(),
      };

      escenas = todas;
      actual_indx = 0;
      actual = escenas[actual_indx];
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
    if (actual != null) {
      actual.cerrarEscena();
    }
    actual_indx = indx;
    actual = escenas[indx];
    actual.setupEscena();
    println(indx, actual.getNombre());
    stopDraw = false;
  }

  void reset() {
    actual_indx = -1;
    actual = null;
  
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

