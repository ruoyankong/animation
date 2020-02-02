import peasy.*;
import java.util.Random;
import java.util.ArrayList; 

PeasyCam cam;
PShape wand;
PImage ground;
PVector startVel = new PVector(0,0,0);
color wind = color(200,250,0);
color water = color(0,0,155);
color fire = color(155,0,0);
color wood = color(255,200,0);
PVector startL = new PVector(-350,-160,0);
PVector startR = new PVector(350,-160,0);
PVector boomCenterR  = new PVector(410,-250,0);
PVector boomCenterL  = new PVector(-410,-125,0);
ParticleSystem windSys = new ParticleSystem(1);
ParticleSystem waterSys = new ParticleSystem(2);
ParticleSystem fireSys = new ParticleSystem(3);
ParticleSystem woodSys = new ParticleSystem(4);
float floorY = 50;
int numF = 0;
int iter = 0;
PImage sprite; 


public void setup() {
  size(800, 600, P3D);
  cam = new PeasyCam(this,0,0,-100,1000);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(2000);
  ground = loadImage("./resource/ground2.png");
  wand = loadShape("./resource/magic_wand.obj");
  textSize(32);
  sprite = loadImage("sprite.png");
  
}



public void draw() {
  iter ++;
  
  //background(219,253,248);
    background(81,110,148);



  drawWand();
  drawGround();
  
  
  

  windSys.run();
  fireSys.run();
  waterSys.run();
  woodSys.run();

  fill(0);
  int PC = windSys.numParticles + waterSys.numParticles + woodSys.numParticles + fireSys.numParticles;
  text("Frame rate: " + int(frameRate), -100, -250);
  text("# of Particles: " + PC, -100, -200);

}


void drawWand(){
  pushMatrix();
  translate(-500,0,0);
  rotate(1.2*PI);
  scale(50,50,50);
  fill(155,0,155);
  shape(wand,0,0);
  popMatrix();
  
  pushMatrix();
  translate(500,0,0);
  rotate(0.8*PI);
  fill(155,155,0);
  scale(50,50,50);
  shape(wand,0,0);
  popMatrix(); 
  
}

void drawGround(){
  pushMatrix();
  translate(0,50,0);
  beginShape();
  noStroke();
  texture(ground);
  noFill();
  vertex(-800,0, -800,0,0);
  vertex(-800, 0,800,0,800);
  vertex(800, 0, 800,800,800);
  vertex(800, 0,-800,800,0);
  endShape();
  popMatrix();
}
