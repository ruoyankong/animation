
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
  
  PShape part;
  
  
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
    //point(position.x,position.y,position.z);
    
    
    float size = random(1,10);
    part = createShape();
    part.beginShape(QUAD);
    part.noStroke();
    part.texture(sprite);
    part.normal(0, 0, 1);
    part.vertex(position.x-size/2, 0,position.z-size/2,  0, 0);
    part.vertex(position.x+size/2, 0,position.z-size/2, sprite.width, 0);
    part.vertex(position.x+size/2, 0,position.z+size/2, sprite.width, sprite.height);
    part.vertex(position.x-size/2, 0,position.z+size/2, 0, sprite.height);
    part.endShape();
    part.setTint(color(255,0,0));
    shape(part);
    
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
