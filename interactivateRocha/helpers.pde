
void defaultModes(){
  rectMode(CORNER);
  imageMode(CORNER);
  ellipseMode(CENTER);
}

void resetDancers(){
  dPos= new PVector();
  hasDancers = false;
}

PVector getCoMPosition(){
  PVector com = new PVector();                                   
  PVector com2d = new PVector(); 

  hasDancers = false;

  context.update();
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.getCoM(userList[i],com))
    {
      context.convertRealWorldToProjective(com,com2d);

      if(com2d.z != 0){
        // rescalamos la data que se ajustaba a 640x480 no a nuestro proyector 1024x768
        com2d.x = map(com2d.x,0,640,0,1024);
        com2d.y = map(com2d.y,0,480,0,768);
        hasDancers = true;
        return com2d;
      }
    }
  }
  return new PVector(0, 0);
}

ArrayList getPartsPositions(){
  ArrayList<PVector> allParts = new ArrayList<PVector>() ;
  // aca definimos con que vamos a trabajar
  //int[] namesOfParts = { SimpleOpenNI.SKEL_RIGHT_HAND, SimpleOpenNI.SKEL_LEFT_HAND, SimpleOpenNI.SKEL_HEAD };
  int[] namesOfParts = { SimpleOpenNI.SKEL_RIGHT_HAND, SimpleOpenNI.SKEL_LEFT_HAND};

  context.update();

  int[] userList = context.getUsers();
  // se toma en cuenta solo el ultimo usuario
  for(int i=0;i<userList.length;i++){
    if(context.isTrackingSkeleton(userList[i])){
      allParts = new ArrayList<PVector>(); 
      int userId = userList[i];

      for(int p=0;p<namesOfParts.length;p++){
        PVector somePart = new PVector();
        PVector somePartProjective = new PVector();
        // extraemos las posiciones
        context.getJointPositionSkeleton(userId,namesOfParts[p],somePart);
        // pasamos a dimensiones 640x480
        context.convertRealWorldToProjective(somePart,somePartProjective);
        // llevamos a la dimension1024x768
        somePartProjective.mult(1.6);
        allParts.add(somePartProjective);
      }
    } 
  }
  //println("all parts "+allParts);
  return allParts;

}

void loadBackPicture(){
  selectInput("Elegi archivo:", "fileSelected");
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Ventana fue cerrada o el usuario apreto cancelar.");
  } else {
    println("Usuario selecciono " + selection.getAbsolutePath());
    backPic = loadImage(selection.getAbsolutePath());
   // backPic.resize(640,480);

    PImage img1 = createImage(640, 480,ARGB);
    img1.copy(backPic,0,0,backPic.width,backPic.height,0,0,640,480);
    backPic = img1;


  }
}

void onNewUser(SimpleOpenNI curContext,int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  context.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext,int userId)
{
  println("onLostUser - userId: " + userId);
}