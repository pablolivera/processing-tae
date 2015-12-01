class MePicture implements Scene
{   
  PImage bImg; 
  boolean reset = false;
  public MePicture(){};

  void closeScene(){};
  void initialScene(){
    reset = true;

  }
  void drawScene(){
   // blendMode(BLEND);

    if(reset){
      fill(0,255);
      rect(0,0,width,height);
      reset =false;
    }

    fill(0,meTvTransparency);
    rect(0, 0, width, height);
    bImg = getMeImg();
    image(bImg,0,0);
  };
  String getSceneName(){return "MePicture";};
  void onPressedKey(String k){};
  void onImg(PImage img){};

  PImage getMeImg(){
    // para imagen de la kinect
    //println("back w h ",backPic.width,backPic.height);
    PImage img = new PImage(context.depthWidth(),context.depthHeight(),ARGB); 
    img.loadPixels();
    // para imagen escalada
    PImage bigImg = new PImage(width,height,ARGB); 
    bigImg.loadPixels();

    context.update();
    int[]   userMap = context.userMap();
    int[]   depthMap = context.depthMap();

    int index;
    for(int x=0;x <context.depthWidth();x+=1)
    {
      for(int y=0;y < context.depthHeight() ;y+=1)
      {
        index = x + y * context.depthWidth();
        int d = depthMap[index];
        // si no hay usuarios
        // ponemos un pixel transparente
        img.pixels[index] = color(0,0);
        if(d>0){
          int userNr =userMap[index];
          if( userNr > 0)
          { 
            // si esta un usuario cargamos img con el valor del pixel
            // de la backPic
            // int indexBack = int(map(x,0,img.width,0,backPic.width)  + map(y,0,img.height,0,backPic.height) * backPic.width);

            img.pixels[index] = backPic.pixels[index];
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