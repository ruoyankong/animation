
class Particle  {
  
  PVector position;
  PVector velocity;
  float lifespan;
  int type;
  float gravity = 0.98;
  boolean highest = false;
  float r = 125;
  int id;
  
  int state = 0;
  
  PShape particleShape;
  
  int red = int(100 );
  int g = int(250 );
  int b = int(0);
  
  
  float d_color;
  
  //Four type of particles. 
  //1 wind attack
  //2 water defense
  //3 fire attack
  //4 wood defense
  // Each kind of particle has different behavior.
  
  
  Particle(PVector l, PVector v, int particleType ,int pid) {

    velocity = v;
    position = l;
    type = particleType;
    lifespan = 0;
    id = pid;
    

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
    particleShape = createShape();
    particleShape.beginShape(QUAD);
    particleShape.noStroke();
    particleShape.texture(sprite);
    particleShape.normal(0, 0, 1);
    particleShape.vertex(position.x-size/2, position.y -size/2,position.z,  0, 0);
    particleShape.vertex(position.x+size/2, position.y-size/2 ,position.z, sprite.width, 0);
    particleShape.vertex(position.x+size/2, position.y +size/2,position.z, sprite.width, sprite.height);
    particleShape.vertex(position.x-size/2, position.y+size/2,position.z, 0, sprite.height);
    particleShape.endShape();
    particleShape.setTint(color(red,g,b));


    
  }
  public float getPosX(){
    return position.x;
  }
  

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
      //For fire particles and wind particles, they have additional collision check.
        case 1:
          checkFireAttack();
          if(woodSys.barrier) checkWoodBarrier();
          else checkLeftWand();
          break;

        case 3:
          checkWindAttack();
          if(waterSys.barrier)checkWaterBarrier();
          else checkRightWand();
          break;

      }
    
    
  }
  
  void checkLeftWand(){
    if(position.x < startL.x - 20  && state == 0){

      state = 1;
      lifespan = 256;
      if(windSys.numParticles < 2){
        leftHit ++;
      }
    }
    
  }
  
  void checkRightWand(){
    
     if(position.x > startR.x + 15  && state == 0){
      state = 1;
      lifespan = 256;
      if(fireSys.numParticles < 2){
        rightHit ++;
      }
     }
     
  }
  
  void checkWoodBarrier(){
    //if wood barrier exists, it should take care of the potential collision.

      if(position.x < startL.x - 20 + r  && state == 0){
         if(!disappear.isPlaying()){
          disappear.play();
          woodSound2.stop();
          windSound.stop();
        }
        velocity.x = random(0,1);
        velocity.y = random(-10,0);
        velocity.z = random(-1,1);
        state = 1;
        windSys.meetbarrier = true;
      }
      

    if(windSys.meetbarrier){

      if(position.x < startL.x - 40 + r && state == 0){
        lifespan += 20;
        }
      
     }

    
    
  }
  
  void checkWaterBarrier(){
    //if water barrier exists, it should take care of the potential collision.

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
      
      if(position.x > startR.x - 75 && state ==0){
        particleShape.setTint(0);
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
    // if the fire particle meet the wind particle,
    // they will change direction and disappear after 5 frams
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
    
    // if the fire particle meet the wind particle,
    // they will change direction and disappear after 5 frams
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
    //do not move any particle if the key is pressed
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
    }
  }
  
  
  void updateWind(){

    float transX = 0;
    float transY = 0;
    float transZ = 0;
    
    //move in y direction in wave shape and move in x direction with constant speed
    if(state ==0 ){
      
      transX = velocity.x;
      transY = sin(position.x/(10))*(1-lifespan/255)*10 *velocity.y;;
      transZ = velocity.z ;
      
      red -=2;
      g += 30;
      b +=1;
      
    }
    
    // freely falling after collision
    else{
      velocity.y += 0.98;
      transX = velocity.x;
      transY = velocity.y;
      transZ = velocity.z  ;
    }
    
    position.x += transX;
    position.y += transY;
    position.z += transZ ;
    

    particleShape.setTint(color(red,g,b,255 - lifespan) );
    particleShape.translate(transX,transY,transZ );
  
}
  
  void updateWater(){
    
    float transX = 0;
    float transY = 0;
    float transZ = 0;
    
    //freely falling
    if(state == 0){
      velocity.y += 0.98/10;
      transY = velocity.y;

    }
   //form a new shape after reached the specific height
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
      

      // form a water drop shape
      transX =  radius * sqrt(1-x2*x2) * cos(theta) - 20;
      transZ =  radius * sqrt(1-x2*x2) * sin(theta) + 50;
      transY =  radius ;
      
      d_color = radius;
      g -= d_color/50;
      //part.rotate(1/2*PI);
        
    }  
    //stay the water drop shape
    else if (state == 1){
      g += d_color/50;
      transX = random(-2,2);
      transY = random(-2,2);
      transZ = random(-2,2);

    }
    
    particleShape.setTint(color(red,g,b,255-lifespan));
    particleShape.translate(transX,transY,transZ);
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
    particleShape.setTint(color(red,g,b,255 - lifespan) );

   //move in y direction as wave shape.
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
   // freely falling after collision
   else{
     velocity.y += 0.98;
     transX = velocity.x;
     transY = velocity.y;
     transZ = velocity.z;
   }
    
    position.y +=transY;
    position.x += transX;
    position.z += transZ;


    particleShape.translate(transX, transY,  transZ );
  
  }
  
  
  void updateWood(){
    
    
    float transX = 0;
    float transY = 0;
    float transZ = 0;
    
    //change shape from sphere to a disk
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
    
    //change shape from a disk to a circle
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
    
    //assign initial velocity to the particles at circle.
    else if(state == 2){
       velocity.y = random(5);
       transY = velocity.y;
       state = 3;
    }
    //drop due to gravity.
    if(state == 3){
      velocity.y = velocity.y + 0.98;
      transY = velocity.y;
    }
    
    particleShape.setTint(color(red,g,b,255-lifespan));
    particleShape.translate(transX,transY,transZ);
    position.x += transX;
    position.y +=transY;
    position.z +=transZ;
    
  }  
    
    

  boolean isDead() {
    if (lifespan > 255) {
      particleShape.setVisible(false);
      return true;
    } else {
      return false;
    }
  }

}
