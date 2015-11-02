class OneChr {
  float x, y;
  float myRotate;
  float myBrightness, glowSpeed, glowOffs;
  int mySize;
  char myChr; 

  OneChr(float _x, float _y, float gS) {
    x = _x;
    y = _y;
    glowSpeed = gS;
    myBrightness = 0;
    glowOffs = random(40) * -1;
    int radi = floor(random(4));
    myRotate = ( HALF_PI * radi);
    float sizeFactor = random(2);
    mySize = ( int( max(10, (pow( sizeFactor, 5)))) );
    myChr = char( int(random(33, 126)));
  }

  void updateMe() {
    noStroke();
    fill(0, max( myBrightness + glowOffs , 0));
    pushMatrix();
    translate(x, y);
    int radi = floor(random(4));
    rotate( myRotate );
    textSize( mySize );
    text( myChr, 0, 0);
    popMatrix();
    myBrightness += glowSpeed;
    myBrightness = min(myBrightness, (255+ (-1 * glowOffs)) );
  }
}

