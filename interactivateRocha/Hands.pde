class Hands implements Scene
{   
  ArrayList parts;
  ArrayList<BAttraction> attractors;
  VPhysics physics;
  int oldAttractionRadius;

  public Hands(){};

  void closeScene(){
    pg.colorMode(RGB,255);
  };
  void initialScene(){
    pg.colorMode(HSB,255);
    physics = new VPhysics();
    physics.setfriction(.4f);

    parts = new ArrayList<PVector>();
    attractors = new ArrayList<BAttraction>();

    for(int i =0;i<2;i++){
      BAttraction ba = new BAttraction(new Vec(0, 0), 400, 0);
      attractors.add(ba);
      physics.addBehavior(ba);

    }
    oldAttractionRadius = attractionRadius;
    println("backColorHands",backColorHands,"pointsColorHands",pointsColorHands);

  };


  void drawScene(){
    pg.colorMode(HSB,255);
    if(oldAttractionRadius != attractionRadius) updateAttractionRadius();
    pg.beginDraw();
    pg.background(backColorHands,255,255);
    parts = getPartsPositions();
    physics.update();

    for (VParticle p : physics.particles) {
      pg.noStroke();
      pg.fill(pointsColorHands,255,255,pointTransparency);
      pg.ellipse(p.x, p.y, p.getRadius()*2, p.getRadius()*2);
    }

    if(parts.size() < 1){
      // si perdemos al usuario, seteamos la fuerza de los atractores en 0
      for (int i = 0; i < attractors.size(); i++) {
        BAttraction attr = (BAttraction) attractors.get(i);
        attr.setStrength(0);
      }
    }else{
      for (int i = 0; i < parts.size(); i++) {
        PVector now = (PVector) parts.get(i);
        BAttraction attr = (BAttraction) attractors.get(i);
        attr.setStrength(attractionStrength);
        attr.setAttractor(new Vec(now.x, now.y));

        if(showAttractionRadius){
          pg.stroke(pointsColorHands,255,255);
          pg.noFill();
          pg.ellipse(now.x, now.y, attractionRadius, attractionRadius);
        }
        // creamos nuevas particulas
        if ( generateNewPoints &&  (frameCount % ((11 - generationFrequency)*2) == 0) ) 
          physics.addParticle(new VParticle(new Vec(now.x, now.y),2, random(rMin,rMax)).addBehavior(new BCollision()));
      }
    }

    pg.endDraw();
    image(pg, 0, 0);
  };
  String getSceneName(){return "Hands";};

  void updateAttractionRadius(){
    //actualizamos los radios de atraccion
    for (int i = 0; i < parts.size(); i++) {
      PVector now = (PVector) parts.get(i);
      BAttraction attr = (BAttraction) attractors.get(i);
      attr.setRadius(attractionRadius);
    }

    oldAttractionRadius = attractionRadius;
  }

}