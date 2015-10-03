public class Estrellas implements Escena {


  float pi=4*atan(1);

  int stars=5000; // only ...
  int Rmax=50; // galaxy radius
  float speed=0.02;  // rotation speed

  // stars follow elliptic orbits around the center
  float eratio=.85; // ellipse ratio
  float etwist=8.0/Rmax; // twisting factor (orbit axes depend on radius)

  float []angle=new float[stars];
  float []radius=new float[stars];

  float cx; 
  float cy; 

  public Estrellas() {
  }

  void setupEscena() {
    //cosas galaxy
    speed=speed/frameRate;

    // begin in the center
    cx = width/2;
    cy = height/2;
    // itit stars
    for (int i=0; i< stars; i++) {
      angle[i]= random(0, 2*pi);
      radius[i]=((abs(randomGauss())))*Rmax*0.6+0.0;
    }
  }

  void drawEscena() {
    PVector centro = obtenerCentroMasa();
    dibujarGalaxia();
  }

  void cerrarEscena() {
  }

  String getNombre() { 
    return "Estrellas";
  }



  void dibujarGalaxia() {
    noSmooth();
    noStroke();
    float r, a, x, y, b, s, c, xx, yy, dd;
    for (int i=0; i< stars; i++) {
      r=radius[i];
      a=angle[i]+speed*(Rmax/r)*3.0; // increment angle
      angle[i]=a;
      x=r*sin(a);
      y=r*eratio*cos(a);
      b=r*etwist;
      s=sin(b);
      c=cos(b);
      xx=cx + s*x + c*y; // a bit of trigo
      yy=cy + c*x - s*y;
      dd=8000.0/r;
      fill(color(dd, dd, dd*0.9, 32));
      rect(xx-1.5, yy-1.5, 3.0, 3.0);
    }
  }

  float gauss(float x) { 
    return exp(-x*x/2.0) / sqrt(2*PI);
  }
  
  float gaussI(float z) { // integrated gauss [0..1]
    if (z<-8.0) return 0.0;
    if (z> 8.0) return 1.0;
    float sum=0.0, term=z;
    for (int i=3; sum+term!=sum; i+=2) {
      sum =sum+term;
      term=term*z*z/i;
    }
    return 0.5+sum*gauss(z);
  }
  
  float gaussE(float z) { 
    return gaussI(z)*2-1;
  }// gauss error func==> [-1..0..1]
  
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
  
  float randomGaussIn(float L, float H, float mul) { 
    return constrain( randomGauss()*(H-L)*mul + (L+H)/2.0, L, H);
  }
  
  float randomGaussAt(float L, float H, float mul) { 
    return            randomGauss()*(H-L)*mul + (L+H)/2.0;
  }
} 

