import peasy.*;
import java.util.*;
import processing.sound.*;

PeasyCam cam;
PShape wand;
PImage ground;
PVector startVel = new PVector(0,0,0);
//color wind = color(100,250,0);
//color water = color(0,0,155);
//color fire = color(155,0,0);
//color wood = color(255,200,0);
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
SoundFile emitSound;
SoundFile windSound;
SoundFile fireSound;
SoundFile waterSound;
SoundFile woodSound1;
SoundFile woodSound2;
SoundFile disappear;


public void setup() {
  size(800, 600, P3D);
  //fullScreen();
  cam = new PeasyCam(this,0,0,-100,1000);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(2000);
  ground = loadImage("./resource/ground2.png");
  wand = loadShape("./resource/magic_wand.obj");
  textSize(32);
  sprite = loadImage("./resource/sprite.png");
  emitSound = new SoundFile(this,"./resource/keyPress.mp3");
  windSound = new SoundFile(this,"./resource/wind.mp3");
  fireSound = new SoundFile(this,"./resource/fire.mp3");
  waterSound = new SoundFile(this,"./resource/water.mp3");
  //woodSound1 = new SoundFile(this,"./resource/wood1.mp3");
  woodSound2 = new SoundFile(this,"./resource/wood2.mp3");
  disappear = new SoundFile(this,"./resource/disappear.mp3");
  
}



public void draw() {
  iter ++;
  
  background(129,149,163);
  //background(0);


  drawWand();
  drawGround();
  

  windSys.run();
  fireSys.run();
  waterSys.run();
  woodSys.run();

  fill(0,0,0);
  int PC = windSys.numParticles + waterSys.numParticles + woodSys.numParticles + fireSys.numParticles;
  //text("Frame rate: " + int(frameRate), -100, -300);
  //text("# of Particles: " + PC, -100, -250);
  
  if(keyPressed && keyCode == 32 ) {
    noLoop();
  }

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
