import peasy.*;
import java.util.*;
import processing.sound.*;

PeasyCam cam;
PShape wand;
PShape wand_moon;
PShape wand_heart;
PImage ground;
PImage wandimg;
PVector startVel = new PVector(0,0,0);
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

int leftHit = 0;
int rightHit = 0;


public void setup() {
  size(800, 600, P3D);
  //fullScreen();
  cam = new PeasyCam(this,0,0,-100,1000);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(2000);
  ground = loadImage("./resource/ground2.png");
  wandimg = loadImage("./resource/1.jpg");
  wand = loadShape("./resource/magic_wand.obj");

  //wand_moon = loadShape("./resource/moon.obj");
  //wand_moon.setTexture(wandimg);
  //wand_heart = loadShape("./resource/heart.obj");
  //wand_heart.setTexture(wandimg);
  textSize(32);
  sprite = loadImage("./resource/sprite.png");
  emitSound = new SoundFile(this,"./resource/keyPress.mp3");
  windSound = new SoundFile(this,"./resource/wind.mp3");
  fireSound = new SoundFile(this,"./resource/fire.mp3");
  waterSound = new SoundFile(this,"./resource/water2.mp3");
  woodSound2 = new SoundFile(this,"./resource/wood2.mp3");
  disappear = new SoundFile(this,"./resource/disappear2.mp3");
  

}



public void draw() {
  iter ++;
  

  background(0);
  
  fill(0,0,0);
  int PC = windSys.numParticles + waterSys.numParticles + woodSys.numParticles + fireSys.numParticles;
  //text("Frame rate: " + int(frameRate), -100, -300);
  //text("# of Particles: " + PC, -100, -250);

 if(leftHit < 3){
    drawLeftWand();
    //text("Hit by Wind: " + leftHit, -500, -350);
  }
  if(rightHit < 3){
    drawRightWand();
    //text("Hit by Fire: " + rightHit, 350, -350);
  }
  drawGround();
  
  woodSys.run();
  waterSys.run();
  fireSys.run();
  windSys.run();

  
  //fill(0,0,0);
  //int PC = windSys.numParticles + waterSys.numParticles + woodSys.numParticles + fireSys.numParticles;
  //text("Frame rate: " + int(frameRate), -100, -300);
  //text("# of Particles: " + PC, -100, -250);
  
  //reset when space key is pressed
  //if(keyPressed && keyCode == RETURN ) {
  //  leftHit = 0;
  //  rightHit = 0;
  //}

}


void drawLeftWand(){
  noStroke();
  fill(204,190,188);
  pushMatrix();
  translate(-450,-80,0); 
  rotate(1.2*PI);
  rotateX( PI/2 );
  drawCylinder( 30, 10, 150 );
  popMatrix();
  
  fill(251,212,208);
  pushMatrix();
  translate(-400, -150,0); 
  sphere(20);
  popMatrix();
}
  

void drawRightWand(){
  fill(198,198,176);
  pushMatrix();
  translate(450, -80,0);
  rotate(0.8*PI);
  rotateX(0.5*PI);
  drawCylinder( 30, 10, 150 );
  popMatrix();
  
  fill(250,248,133);
  pushMatrix();
  translate(400,-150,0);
  sphere(20);
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


void drawCylinder( int sides, float r, float h)
{
    float angle = 360 / sides;
    float halfHeight = h / 2;

    // draw top of the tube
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, -halfHeight);
    }
    endShape(CLOSE);

    // draw bottom of the tube
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, halfHeight);
    }
    endShape(CLOSE);
    
    // draw sides
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < sides + 1; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, halfHeight);
        vertex( x, y, -halfHeight);    
    }
    endShape(CLOSE);
}
