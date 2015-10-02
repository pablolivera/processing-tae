class SceneManager{

  Escena[] escenas;  
  Escena actual;
  int actual_indx;
  
}


// Escena
interface Escena
{ 
    void setupEscena();
    void drawScene();
    void cerrarEscena();
    String getNombre();
}
