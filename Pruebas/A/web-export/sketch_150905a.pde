int x;
int y;

void setup() 
{
    size (640,480);
    smooth();
    background( 255 );
    
}

void draw() 
{

  strokeWeight( 1 );
  point( 20, height/1.5 );
  line ( 70, 20, 70, height - 20 ); 

}

