
class ParticleSystem{
  public int type;
  int numParticles;
  PVector center;
  ArrayList<Particle> particles = new ArrayList<Particle>();
  float genRate = 200;
  PVector v;
  boolean ready = false;
  boolean start = false;
  
  PShape groupShape;
  
  ParticleSystem(int systemType){

    //PShape groupShape = createShape(PShape.GROUP);
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
    
    
    if (numParticles < 1){
    groupShape = createShape(PShape.GROUP);
    for (int i = 0; i < 10000; i++){
//      float r = 30;
//      float x1 = random(-1,1);
//      float x2 = random(-1,1);
//      float x, y, z;
      
////!: redefine region
//      PVector pos = new PVector(center.x + r* sqrt(x1*x1),
//                     center.y + r* sqrt(x1*x1),
//                     center.z + r* sqrt(x1*x1));
                     
      
//      x =  center.x+ r*(x1*sqrt(1-(x1*x1)-(x2*x2)));
//      y =  center.y + r*(x2*sqrt(1-(x1*x1)-(x2*x2)));
//      z =  center.z + r*((1 - ((x1*x1)+(x2*x2))));
      float r = 30;
      float x1 = random(0,1);
      float x2 = random(0,1);
      r = r * sqrt(x1);
      float theta = 2 * PI * x2;
      float phi = acos(1 -PI * random(0,1));
      float x = center.x + r * sin(phi)*cos(theta);
      float z = center.z + r * cos(phi);
      float y = center.y + r * sin(phi) * sin(theta);
      
      PVector pos = new PVector(x,y,z);
      
      if(y < center.y){
         
        v= new PVector(random(-5, -3), 1, 0); 
        //v= new PVector(0, 0, 0); 
      }
      else{
        v= new PVector(random(-5, -3), -1, 0); 
      }

      
      
      
      if(type == 3){
        // v.x = random(4,5);

         v.x = (pos.x - center.x)/10 ;
       

         if(pos.x < center.x){
          v.x = ((center.x - pos.x))/5 ;
          
        }
        
        //if(y < center.y && z < center.z){
          
        //  v.z = 1;
        //}
        //else if(y < center.y && z > center.z){
        //  v= new PVector(random(-5, -3), -1, 0); 
        //}
        
        
        //  v.x = (pos.x - center.x)/3;
        //}
        //v.x = random(4,5);
        //v.x = abs((pos.x - center.x)/10);
      }
      Particle p = new Particle(pos,v,type,numParticles);
      particles.add(p);
      numParticles++;
      groupShape.addChild(p.part);
      }
    }
    
  }
  
  void drawDefense(){
    if (numParticles < 1){
    groupShape = createShape(PShape.GROUP);
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
        y -=50;

      }
      
      
      
      PVector pos =new PVector(x,y,z);
      Particle p = new Particle(pos,v,type,numParticles);
      particles.add(p);
      numParticles ++;
      groupShape.addChild(p.part);
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

      //p.part.translate(10,0,0);
      
      if(i == 0){

      }
      if (p.isDead()) {
        particles.remove(i);
        numParticles --;
      }
      
      if(p.state == 2){
        ready = false;
      }
      
      
    }
    
    if(type == 4 && ready == true && start == false){

      
      numF = iter;
      start = true;
    
    }
    
    if(type == 4 && numParticles == 0){
      numF = 0;
      start = false;
    }
    
    if(numParticles > 0 ){
  
      shape(groupShape);
    }
  }
  
}
