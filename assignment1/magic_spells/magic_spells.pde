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



class ParticleSystem{
  public int type;
  int numParticles;
  PVector center;
  ArrayList<Particle> particles = new ArrayList<Particle>();
  float genRate = 200;
  PVector v;
  boolean ready = false;
  boolean start = false;
  
  ParticleSystem(int systemType){
    type = systemType;
    numParticles = 0;
    if (type == 1 || type == 2){
      center = startR;
    }
    else{
      center = startL;
    }
    
  }
  
//1 wind attack
//2 water defense
//3 fire attack
//4 wood defense

  void drawAttack(){
    //1 wind attack
    //color c;
    //if(type == 1){
    //  c = wind;
    //}
    ////3 fire attack
    //else{
    //  c = fire;
    //}
    //v= new PVector(random(-1, 1), 0,0); 
    if (numParticles < 1){
    for (int i = 0; i < 10000; i++){
      float r = 30;
      float x1 = random(-1,1);
      float x2 = random(-1,1);
      float x, y, z;
      
//!: redefine region
      PVector pos = new PVector(center.x + r* sqrt(x1*x1),
                     center.y + r* sqrt(x1*x1),
                     center.z + r* sqrt(x1*x1));
                     
      //x = center.x+ x1;
      //y = center.y;
      //z =  center.z + x2;
      
      x =  center.x+ r*(x1*sqrt(1-(x1*x1)-(x2*x2)));
      y =  center.y + r*(x2*sqrt(1-(x1*x1)-(x2*x2)));
      z =  center.z + r*((1 - ((x1*x1)+(x2*x2))));
      
      //if(type == 1){
      //  x -=150;
      //}
      //else{
      //  x +=150;
      //}
      pos = new PVector(x,y,z);
      v= new PVector(random(-8, -5), 0,0); 
      
      if(type == 3){
        v.x = v.x * -1;
      }
      particles.add(new Particle(pos,v,type,numParticles));
      numParticles++;
    }
    }
    
  }
  
  void drawDefense(){
    if (numParticles < 1){
    for (int i = 0; i < 10000; i++){
      float r = 30;
      float x1 = random(0,1);
      float x2 = random(0,1);
      r = r * sqrt(x1);
      float theta = 2 * PI * x2;
      float phi = acos(1 -PI * random(0,1));
      float x = center.x + r * sin(phi)*cos(theta);
      float z = center.z + r * cos(phi);
      float y = center.y + r * sin(phi) * sin(theta);

      if(type == 2){
        v= new PVector(0, -5,0); 
        x +=60;
      }
      else{
      float a = random(-1,1);
      float b = random(-1,1)* 2* PI;

      float v_x = sin(b);
      float v_y = 0;
      float v_z = sqrt(1- v_x*v_x) ;
         if(a < 0){
            v_z = - v_z;
          }
      v= new PVector(v_x, v_y,v_z); 
      
      x -= 60;
  
      }
      
      PVector pos =new PVector(x,y,z);
    
      //v= new PVector(0, -5,0); 
      particles.add(new Particle(pos,v,type,numParticles));
      numParticles ++;
    }
    }
  }
  
  void drawWind(){
    if (numParticles < 10000){
    for (int i = 0; i < 1000; i++){
      float r = 50;
      float x1 = random(-1,1);
      float x2 = random(-1,1);
      float x, y, z;
      
//!: redefine region
      PVector pos = new PVector(center.x + r* sqrt(x1*x1),
                     center.y + r* sqrt(x1*x1),
                     center.z + r* sqrt(x1*x1));
                     
      //x = center.x+ x1;
      //y = center.y;
      //z =  center.z + x2;
      
      x =  center.x+ r*(x1*sqrt(1-(x1*x1)-(x2*x2))) - 100;
      y =  center.y + r*(x2*sqrt(1-(x1*x1)-(x2*x2)));
      z =  center.z + r*((1 - ((x1*x1)+(x2*x2))));
      
      pos = new PVector(x,y,z);
      v= new PVector(random(-2, 0), 0,0); 
      
      if(type == 3){
        v.x = v.x * -1;
      }
      particles.add(new Particle(pos,v,type,numParticles));
      numParticles++;
    }
    }
  }
  
  void drawWater(){
    if (numParticles < 10000){
    for (int i = 0; i < 1000; i++){
      float r = 30;
      float x1 = random(0,1);
      float x2 = random(0,1);
      r = r * sqrt(x1);
      float theta = 2 * PI * x2;
      float phi = acos(1 -PI * random(0,1));
      float x = center.x + r * sin(phi)*cos(theta) + 60;
      float z = center.z + r * cos(phi);
      float y = center.y + r * sin(phi) * sin(theta) - 50;

      PVector pos =new PVector(x,y,z);
    
      v= new PVector(0, -5,0); 
      particles.add(new Particle(pos,v,type,numParticles));
      numParticles ++;
    }
    }
  }
  
  void drawFire(){
    
  }
  
  void drawWood(){
    if (numParticles < 10000){
    for (int i = 0; i < 1000; i++){
      float r = 30;
      float x1 = random(0,1);
      float x2 = random(0,1);
      r = r * sqrt(x1);
      float theta = 2 * PI * x2;
      float phi = acos(1 -PI * random(0,1));
      float x = center.x + r * sin(phi)*cos(theta) - 60;
      float z = center.z + r * cos(phi);
      float y = center.y + r * sin(phi) * sin(theta) - 50;

      PVector pos =new PVector(x,y,z);
    
      v= new PVector(0, -5,0); 
      particles.add(new Particle(pos,v,type,numParticles));
      numParticles ++;
    }
    }
  }
  
  void run() {
 //if up / E is pressed 
   if (keyPressed) {
        
    if (keyCode == LEFT && type == 1) {
      //drawWind();
      drawAttack();
    }
    
    if (keyCode == UP && type == 2){
      //drawWater();
      drawDefense();
    }
    
    
    if (key == 'd' && type == 3){
      //drawFire();
      drawAttack();
    }
    
    if (key == 'w' && type == 4){
      //drawWood();
      drawDefense();
    }

    }

    strokeWeight(3);
    
    ready = true;
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      
      if (p.isDead()) {
        particles.remove(i);
        numParticles --;
      }
      
      if(p.state == 2){
        ready = false;
      }
      
      
    }
    
    if(type == 4 && ready == true && start == false){
      print("update" +" "+iter + "\n");
      
      numF = iter;
      start = true;
      print("update" +" "+ numF + "\n");
    }
    
    if(type == 4 && numParticles == 0){
      numF = 0;
      start = false;
    }
    
  }
  
  
}



class Particle {
  
  public PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color initColor;
  int type;
  color currColor;
  float gravity = 0.98;
  boolean highest = false;
  float r = 125;
  int id;
  
  int state = 0;
  
  
  Particle(PVector l, PVector v, int particleType ,int pid) {
    acceleration = new PVector(0.05, 0,0);
    velocity = v;
    position = l.copy();
    type = particleType;
    lifespan = 0;
    id = pid;
    switch(type){
      case 1:
        initColor = wind;
        break;
      case 2:
        initColor = water;
        break;
      case 3:
        initColor = fire;
        break;
      case 4:
        initColor = wood;
        break;
    }
    
  }

  void run() {
    update();
    collisionHandler();
    display();
  }
  void collisionHandler(){
    if(position.y + 2> floorY){
      position.y = floorY - 2; 
    }
  }
  // Method to update position
  void update() {
    
    if(keyPressed){
      position.x = position.x + random(-1,1);
      position.y = position.y + random(-1,1);
      position.z = position.z + random(-1,1);
    }
    
    else{
      switch(type){
        case 1:
          updateWind();
          break;
        case 2:
          updateWater();
          break;
        case 3:
          updateFire();
          break;
        case 4:
          updateWood();
          break;
      }
      
      lifespan += 1.0;
      currColor = color(initColor,(255-lifespan));
    }
  }
  
  
  void updateWind(){
    position.x = position.x + velocity.x;
    position.y = startL.y + sin(position.x/(5))*(1-lifespan/255)* random(0,1)*100 + random(-10,10);
    position.z = position.z + velocity.z ;
  }
  
  void updateWater(){
    
    if(state == 0){

      velocity.y = velocity.y + 0.98/10;
    }
   
    position.x = position.x + random(-1,1);
    position.y = position.y + velocity.y;
    position.z = position.z + random(-1,1);

      
    if(position.y <= -250 &&  state == 0){

      lifespan = 0;
      float a = random(-1,1);
      float b = random(-1,1)* 2* PI;

        
      r = sqrt(sqrt(a)*sin(b) + sqrt(a)*cos(b));
      state = 1;
        
      float x1 = random(0,1);
      float x2 = random(0,1);
    
      r = 300 * (3.8 + velocity.y)/3.8  ;
      float theta = 2 * PI * x1;
      position.x =  boomCenterR.x +  r * sqrt(1-x2*x2) * cos(theta);
      position.z = boomCenterR.z + r * sqrt(1-x2*x2) * sin(theta);
      position.y = boomCenterR.y + r  ;
        
      velocity.y = 0;
      velocity.x = 100*sqrt(a)*sin(b);
      velocity.z =  100*sqrt(a)*cos(b);
    }  
  }
  
  
  void updateFire(){
      position.x = position.x + velocity.x;
      //position.y = startL.y + sin(position.x)*(1-lifespan/255)*100 ;
      position.z = position.z + velocity.z ;
  }
  
  
  void updateWood(){
    
    if(state == 0){
     
      position.x = position.x;
      if(position.y > startL.y + 1){
        position.y = position.y - 0.98;
      }
      else if (position.y < startL.y - 1){
        position.y = position.y + 0.98;
      }

      else{
        state = 1;
        
      }
      position.z = position.z;
      
    }
    
    else if(state == 1){
      float dx = position.x  - startL.x + 50;
      float dz = position.z - startL.z;
      float d = sqrt(dx*dx + dz*dz);
      
      if(d < r){
        position.x += 3*velocity.x;
        position.z += 3*velocity.z;
      }
      else{
        state = 2;
        lifespan = 0;
      }
    }
    else if(state == 2){
      if(random(0,30) < 1){
        print(iter + " "+ numF + "\n");
        
        position.y = position.y  - 50 + (iter - numF);
        position.x = position.x + random(-1,1);
        position.z = position.z + random(-1,1);
        state = 3;
        lifespan = - 10;
      }
    }
     
    //if(woodSys.ready && state == 2){

    //  if(random(0,100) < 1){
    //    position.y = position.y + 0.5 * (iter - numF);
    //    state = 3;
    //    lifespan = - 200;
    //  }
           
    //}
    
    if(state == 3){
      position.x = position.x + random(-1,1);
      position.y = position.y + random(-1,1);
      position.z = position.z + random(-1,1);
    }
    
  }  
    
    


  // Method to display
  void display() {
    

    stroke(initColor);
    //stroke(initColor, (255-lifespan));
    point(position.x,position.y,position.z);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan > 255) {
      return true;
    } else {
      return false;
    }
  }
}

public void setup() {
  size(800, 600, P3D);
  cam = new PeasyCam(this,0,0,-100,1000);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(2000);
  ground = loadImage("./resource/ground2.png");
  wand = loadShape("./resource/magic_wand.obj");
  textSize(32);
  
}



public void draw() {
  iter ++;
  
  background(219,253,248);


  fill(255,0,0);
  drawWand();
  drawGround();
  
  color a = color(155,155,0);
  color b = a * 255;
  //pushMatrix();
  //translate(-280,-110,0);
  //rotate(1.2*PI);
  //fill(a,197);
  //box(50);
  //popMatrix();
  

  windSys.run();
  fireSys.run();
  waterSys.run();
  woodSys.run();
  
  //strokeWeight(3);
  //stroke(a);
  //for(int i = 0; i < 10; i++){
  //  point(iter*10+i,0,0);
  //}
  
  
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
