/**
 *  Contacts
 *
 *  by Ricard Marxer
 *
 *  This example shows how to use the contact events
 * 
 *  Modificado !
 *
 */
import fisica.*;

FWorld world;
FPoly obstacle;


void setup() {
  
  size(400, 400);
  smooth();

  background(255);

  Fisica.init(this);

  world = new FWorld();
  obstacle = new FPoly();
  obstacle.vertex(0,height-0);
  obstacle.vertex(40,height-40);
  obstacle.vertex(80,height-80);
  obstacle.vertex(120,height-120);
  obstacle.vertex(160,height-120);
  obstacle.vertex(200,height-80);
  obstacle.vertex(240,height-40);
  obstacle.vertex(240,height-40);
  obstacle.vertex(280,height-0);   
  obstacle.vertex(0,height-0);
  obstacle.setStatic(true);
  //obstacle.setFill(0);
  obstacle.setNoFill();
  obstacle.setNoStroke();
  obstacle.setRestitution(0);
  
  world.add(obstacle);
 
}

void draw() {
  background(255);

  if (frameCount % 5 == 0) {
    FCircle b = new FCircle(20);
    b.setPosition(width/2 + random(-50, 50), 50);
    b.setVelocity(0, 200);
    b.setRestitution(0);
    b.setNoStroke();
    b.setFill(200, 30, 90);
    world.add(b);
  }
  
  world.draw();
  world.step();
  
  strokeWeight(1);
  stroke(255);
  ArrayList contacts = obstacle.getContacts();
  System.out.println("Esto es el tamanio de contacts" + contacts.size());
  for (int i=0; i<contacts.size(); i++) {
    FContact c = (FContact)contacts.get(i);
    line(c.getBody1().getX(), c.getBody1().getY(), c.getBody2().getX(), c.getBody2().getY());
  } 
}

void contactStarted(FContact c) {
  FBody ball = null;
  if (c.getBody1() == obstacle) {
    ball = c.getBody2();
  } else if (c.getBody2() == obstacle) {
    ball = c.getBody1();
  }
  
  if (ball == null) {
    return;
  }
  
  ball.setFill(30, 190, 200);
}

void contactPersisted(FContact c) {
  FBody ball = null;
  if (c.getBody1() == obstacle) {
    ball = c.getBody2();
  } else if (c.getBody2() == obstacle) {
    ball = c.getBody1();
  }
  
  if (ball == null) {
    return;
  }
  
  ball.setFill(30, 120, 200);

  noStroke();
  fill(255, 220, 0);
  ellipse(c.getX(), c.getY(), 10, 10);
}

void contactEnded(FContact c) {
  FBody ball = null;
  if (c.getBody1() == obstacle) {
    ball = c.getBody2();
  } else if (c.getBody2() == obstacle) {
    ball = c.getBody1();
  }

  if (ball == null) {
    return;
  }
  
  ball.setFill(200, 30, 90);
  //
}

