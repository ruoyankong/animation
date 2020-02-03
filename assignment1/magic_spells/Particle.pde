
class Particle  {
  
  PVector position;
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
    position = l;
    type = particleType;
    lifespan = 0;
    id = pid;
    
     stroke(initColor);

    switch(type){
      case 1:
          red = int(100 );
          g = int(250 );
          b = int(0);
        break;
      case 2:
        red = 29;
        g = 0;
        b = 253;
        break;
      case 3:
        red = 255;
        g = 50;
        b = 30;
        break;
      case 4:
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
  public float getPosX(){
    return position.x;
  }
  
 // @Override
 // public int compare(Particle b){ 
 ////if this particle is on the right of b, it will be the larger one.
 
 //    return this.position.x.compareTo(b.position.x);
 // }


  void run() {

    update();
    collisionHandler();

  }
  
  
  void collisionHandler(){
    
    //check floor
    if(position.y + 2> floorY){
      position.y = floorY - 2; 
      velocity.y = - velocity.y;
      if(type == 4){
        velocity.y -= 1;
      }
    }
    
    switch(type){
        case 1:
          checkWoodBarrier();
          checkFireAttack();
          break;
        //case 2:
        //  updateWater();
        //  break;
        case 3:
          checkWaterBarrier();
          checkWindAttack();
          break;
        //case 4:
        //  updateWood();
        //  break;
      }
    
    
  }
  
  void checkWoodBarrier(){
    if(woodSys.barrier){
      if(position.x < startL.x - 25 + r  && state == 0){
         if(!disappear.isPlaying()){
          disappear.play();
          woodSound2.stop();
          windSound.stop();
        }
        velocity.x = 0;
        velocity.y = random(-10,0);
        velocity.z = random(-1,1);
        state = 1;
        windSys.meetbarrier = true;
      }
      
    }
    else if(windSys.meetbarrier){

      if(position.x < startL.x - 40 + r && state == 0){
        lifespan += 20;
      }
      
     }

    
    
  }
  
  void checkWaterBarrier(){
    
    if(waterSys.barrier){
      if(position.x > startR.x - 80 && position.x < startR.x - 75 && state ==0){
       if(!disappear.isPlaying()){
        disappear.play();
        waterSound.stop();
        fireSound.stop();
        }
        velocity.x = -5;
        velocity.y = -10;
        velocity.z = random(-5,5);
        state = 1;
        fireSys.meetbarrier = true;
      }
      else if(position.x > startR.x - 75 && state ==0){
        part.setTint(0);
        lifespan = 256;
      }
    }
     else if(fireSys.meetbarrier){
      if(position.x > startR.x - 80){
        lifespan = 256;
      }
     }
  }
  
  void checkFireAttack(){
    Particle fireP = fireSys.getHead();
    
    if (fireP == null) return;
    
    if ( fireP.position.x > this.position.x && state == 0) {
      
      if(!disappear.isPlaying()){
        disappear.play();
      }
      
      velocity.x = random(0,5);
      velocity.y = random(-1,1);
      velocity.z = random(-1,1);
      state = 1;
      lifespan = 250;
    }
  }
  void checkWindAttack(){
    Particle windP = windSys.getHead();
    
    if (windP == null) return;
    
    if ( windP.position.x < this.position.x && state == 0) {
      velocity.x = random(-5,0);
      velocity.y = random(-5,5);
      velocity.z = random(-1,1);
      state = 1;
      lifespan = 250;
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

    float transX = 0;
    float transY = 0;
    float transZ = 0;
    
    
    if(state ==0 ){
      
      transX = velocity.x;
      transY = sin(position.x/(10))*(1-lifespan/255)*10 *velocity.y;;
      transZ = velocity.z ;
      
      red -=2;
      g += 30;
      b +=1;
      
    }
    else{
      velocity.y += 0.98;
      transX = velocity.x;
      transY = velocity.y;
      transZ = velocity.z  ;
    }
    
    position.x += transX;
    position.y += transY;
    position.z += transZ ;
    

    part.setTint(color(red,g,b,255 - lifespan) );
    part.translate(transX,transY,transZ );
  
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
      waterSys.barrier = true;
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
      
      transX =  radius * sqrt(1-x2*x2) * cos(theta) - 20;
      transZ =  radius * sqrt(1-x2*x2) * sin(theta) + 50;
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
          
    float transX = 0;
    float transY = 0;
    float transZ = 0;
    
    
    
    g += 1;
    b +=lifespan/50;
    part.setTint(color(red,g,b,255 - lifespan) );

   if(state == 0){
      transX = velocity.x;
      transY = sin(position.x/(5))*(1-lifespan/255) * 3 *velocity.y;
      transZ = velocity.z;
    
      if(velocity.y > 0 && position.y > startL.y){
        transY = -transY;
      }
      if(velocity.y < 0 && position.y < startL.y){
        transY = -transY;
      }
   }
   else{
     velocity.y += 0.98;
     transX = velocity.x;
     transY = velocity.y;
     transZ = velocity.z;
   }
    
    position.y +=transY;
    position.x += transX;
    position.z += transZ;


    part.translate(transX, transY,  transZ );
  
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
      woodSys.barrier = true;
      
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
      part.setVisible(false);
      return true;
    } else {
      return false;
    }
  }

}
