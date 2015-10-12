// Basado en:
// Spiral Galaxy Simulation
// author : Philippe Guglielmetti (Dr. Goulu www.goulu.net)

public class Estrellas implements Escena {

  float pi=4*atan(1);

  int stars=8000;

  float speed=0.1;  // velocidad de rotacion

  float []angle=new float[stars];
  float []radius=new float[stars];
  final boolean crece;

  public Estrellas(boolean crece) {
    this.crece = crece;
  }

  void setupEscena() {
    speed=speed/frameRate;
    // iniciar estrellas
    for (int i=0; i< stars; i++) {
      angle[i]= random(0, 2*pi);
      radius[i]=((abs(randomGauss())))*Rmax*0.6+0.0;
    }
    //musica
    sonido1.trigger();
  }

  void drawEscena() {
    //crecimiento / decrecimiento automatico
    if (frameCount%5==0) {
      if (crece) {
        if (eratio<=20)
          eratio+=0.01;
        if (etwist <=0.5)
          etwist+=0.0001;
      } else {
        if (eratio>=1)
          eratio-=0.01;
        if (etwist >=-0.5)
          etwist-=0.0001;
      }
    }
    dibujarGalaxia();
  }

  void cerrarEscena() {
  }

  String getNombre() { 
    if (crece)
      return "Estrellas Crecen";
    else return "Estrellas Mueren";
  }


  void dibujarGalaxia() {    
    noStroke();
    float r, a, x, y, b, s, c, xx, yy, dd;
    for (int i=0; i< stars; i++) {
      r=radius[i];
      a=angle[i]+speed*(Rmax/r)*3.0; // incrementar angulo
      angle[i]=a;
      x=r*sin(a);
      y=r*eratio*cos(a);
      b=r*etwist;
      s=sin(b);
      c=cos(b);
      xx=cx + s*x + c*y; 
      yy=cy + c*x - s*y + 100;
      yy -= offset;
      dd=8000.0/r;
      fill(color(dd, dd, dd*0.9, 32));
      rect(xx-1.5, yy-1.5, 3.0, 3.0);
    }
  }

  float randomGauss() {
    float x=0, y=0, r, c;
    do { 
      x=random(-1.0, 1.0);
      y=random(-1.0, 1.0);
      r=x*x+y*y;
    }
    while (r==0 || r>1);
    c=sqrt(-2.0*log(r)/r);
    return x*c; //return [x*c, y*c];
  }
}

