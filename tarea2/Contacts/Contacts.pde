/**
 *  Contacts
 *
 *  by Ricard Marxer
 *
 *  This example shows how to use the contact events.
 */

import fisica.*;

FWorld world;
//FBox obstacle;
//FCircle obstacle;
//FLine obstacle;
FPoly obstacle;
FLine obstacle1;



void setup() {
  size(400, 400);
  smooth();

  Fisica.init(this);

  world = new FWorld();

  //obstacle = new FBox(150,150);
  // obstacle = new FCircle(150);
  //obstacle = new FLine(30,100, 120,120);
  
   obstacle = new FPoly();
   obstacle.vertex(0,0);
   obstacle.vertex(40,40);
   
   
   /*obstacle.vertex(40, 10);
   obstacle.vertex(43, 10);
   obstacle.vertex(47, 10);
   obstacle.vertex(50, 20);
   obstacle.vertex(60, 30);
   obstacle.vertex(60, 40);
   obstacle.vertex(50, 50);
   obstacle.vertex(40, 60);
   obstacle.vertex(30, 70);
   obstacle.vertex(20, 60);
   obstacle.vertex(10, 50);
   obstacle.vertex(10, 40);
   obstacle.vertex(20, 30);
   obstacle.vertex(30, 20);
   obstacle.vertex(40, 10);*/
 //world.add();
  
  
  obstacle1 = new FLine(0,50, 20,30);
  
  
  //obstacle.setRotation(PI/4);
  obstacle.setPosition(width/2, height/2);
  obstacle.setStatic(true);
  obstacle.setFill(0);
  obstacle.setRestitution(0);
  
  obstacle1.setPosition(width/2, height/2);
  obstacle1.setStatic(true);
  obstacle1.setFill(0);
  obstacle1.setRestitution(0);
  
  
  world.add(obstacle);
  world.add(obstacle1);
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
  for (int i=0; i<contacts.size(); i++) {
    FContact c = (FContact)contacts.get(i);
    line(c.getBody1().getX(), c.getBody1().getY(), c.getBody2().getX(), c.getBody2().getY());
  }
  
  ArrayList contacts1 = obstacle1.getContacts();
  for (int i=0; i<contacts1.size(); i++) {
    FContact c1 = (FContact)contacts1.get(i);
    line(c1.getBody1().getX(), c1.getBody1().getY(), c1.getBody2().getX(), c1.getBody2().getY());
  }
  
}

void contactStarted(FContact c) {
  FBody ball = null;
  if (c.getBody1() == obstacle) {
    ball = c.getBody2();
  } else if (c.getBody2() == obstacle) {
    ball = c.getBody1();
  }
  
  ball = null;
  if (c.getBody1() == obstacle1) {
    ball = c.getBody2();
  } else if (c.getBody2() == obstacle1) {
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
  
  if (c.getBody1() == obstacle1) {
    ball = c.getBody2();
  } else if (c.getBody2() == obstacle1) {
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
  
  if (c.getBody1() == obstacle1) {
    ball = c.getBody2();
  } else if (c.getBody2() == obstacle1) {
    ball = c.getBody1();
  }
  
  if (ball == null) {
    return;
  }
  
  ball.setFill(200, 30, 90);
}

/*void keyPressed() {
  try {
    saveFrame("screenshot.png");
  } 
  catch (Exception e) {
  }
}*/

