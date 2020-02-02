
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
  
  int red = int(100 );
  int g = int(250 );
  int b = int(0);
  
  
  float d_color;
  
  
  Particle(PVector l, PVector v, int particleType ,int pid) {
    acceleration = new PVector(0.05, 0,0);
    velocity = v;
    position = l.copy();
    type = particleType;
    lifespan = 0;
    id = pid;
    
        stroke(initColor);
    //stroke(initColor, (255-lifespan));
    //point(position.x,position.y,position.z);
    switch(type){
      case 1:
        initColor = wind;
        //red = 
        break;
      case 2:
        initColor = water;
        red = 29;
        g = 0;
        b = 253;
        break;
      case 3:
        initColor = fire;
        red = 255;
        g = 50;
        b = 30;
        break;
      case 4:
        initColor = wood;
        red = 255;
        g = 200;
        b = 0;
        break;
    }
    
    float size = random(5,10) ;
    part = createShape();
    part.beginShape(QUAD);
    part.noStroke();
    part.texture(sprite);
    part.normal(0, 0, 1);
    part.vertex(position.x-size/2, position.y -size/2,position.z,  0, 0);
    part.vertex(position.x+size/2, position.y-size/2 ,position.z, sprite.width, 0);
    part.vertex(position.x+size/2, position.y +size/2,position.z, sprite.width, sprite.height);
    part.vertex(position.x-size/2, position.y+size/2,position.z, 0, sprite.height);
    part.endShape();
    part.setTint(color(red,g,b));

    
    
  }


  void run() {
    //part.setTint(color(255,0,0));
    //part.translate(-10,0,0);
    update();
    collisionHandler();
    //display();
  }
  
  
  void collisionHandler(){
    if(position.y + 2> floorY){
      position.y = floorY - 2; 
      velocity.y = - velocity.y;
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
    position.y = sin(position.x/(10))*(1-lifespan/255)*10 *velocity.y;
    position.z = position.z + velocity.z ;
    
    red -=2;
    g += 30;
    b +=1;

    part.setTint(color(red,g,b,255 - lifespan) );
    
    position.z = position.z + velocity.z;
    
    part.translate(velocity.x, sin(position.x/(10))*(1-lifespan/255)*10 *velocity.y, velocity.z );
  
}
  
  void updateWater(){
    
    float transX = 0;
    float transY = 0;
    float transZ = 0;
    
    if(state == 0){
      velocity.y += 0.98/10;
      transY = velocity.y;

    }
   
    if(position.y < -250 &&  state == 0){

      lifespan = 0;   
      float a = random(-1,1);
      float b = random(TWO_PI);

        
      float radius = sqrt(sqrt(a)*sin(b) + sqrt(a)*cos(b));
      state = 1;
        
      float x1 = random(0,1);
      float x2 = random(0,1);
    
      radius = 400 * (3.8 + velocity.y)/3.8  ;
      float theta = 2 * PI * x1;
      
      velocity.y = 0;
      velocity.x = 100*sqrt(a)*sin(b);
      velocity.z =  100*sqrt(a)*cos(b);
      
      //g -= radius;
      
      transX =  radius * sqrt(1-x2*x2) * cos(theta);
      transZ =  radius * sqrt(1-x2*x2) * sin(theta);
      transY =  radius ;
      
      d_color = radius;
      g -= d_color/50;
      //part.rotate(1/2*PI);
        
    }  
    else if (state == 1){
      
      g += d_color/50;
      transX = random(-2,2);
      transY = random(-2,2);
      transZ = random(-2,2);

    }
    
    part.setTint(color(red,g,b,255-lifespan));
    part.translate(transX,transY,transZ);
    position.x += transX;
    position.y +=transY;
    position.z +=transZ;
  }
  
  
  void updateFire(){
          
    position.x = position.x + velocity.x;
    position.z = position.z + velocity.z ;




    g += 1;
    b +=lifespan/50;
    part.setTint(color(red,g,b,255 - lifespan) );

    
    position.z = position.z + velocity.z;
    
    float transY = sin(position.x/(5))*(1-lifespan/255) * 3 *velocity.y;
    
    if(velocity.y > 0 && position.y > startL.y){
      transY = -transY;
    }
    if(velocity.y < 0 && position.y < startL.y){
      transY = -transY;
    }
    position.y +=transY;

    part.translate(velocity.x, transY,  velocity.z );
  
  }
  
  
  void updateWood(){
    
    float transX = 0;
    float transY = 0;
    float transZ = 0;
    
    
    if(state == 0){
      
      if(position.y > startL.y + 51){
        transY = - 0.98;
        
      }
      else if (position.y < startL.y - 51){
        transY = 0.98;
      }
      else{
        state = 1;
        transY = 0;
      }
      
    }
    
    else if(state == 1){
      float dx = position.x  - startL.x + 50;
      float dz = position.z - startL.z;
      float d = sqrt(dx*dx + dz*dz);
      
      if(d < r){
        transX = 3*velocity.x;
        transZ = 3*velocity.z;

      }
      else{
        state = 2;
        lifespan = 0;
      }
    }
    else if(state == 2){
       velocity.y = random(5);
       transY = velocity.y;
       state = 3;
    }
     
    if(state == 3){

      velocity.y = velocity.y + 0.98;
      transY = velocity.y;
    }
    
    part.setTint(color(red,g,b,255-lifespan));
    part.translate(transX,transY,transZ);
    position.x += transX;
    position.y +=transY;
    position.z +=transZ;
    
  }  
    
    

  boolean isDead() {
    if (lifespan > 255) {
      return true;
    } else {
      return false;
    }
  }

}
