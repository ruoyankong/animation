
class ParticleSystem{
  public int type;
  int numParticles;
  PVector center;
  ArrayList<Particle> particles = new ArrayList<Particle>();
  float genRate = 200;
  PVector v;
  
  boolean barrier = false;
  boolean meetbarrier = false;


  
  PShape groupShape;
  
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
    
    
    if (numParticles < 1){
      groupShape = createShape(PShape.GROUP);
      if(type == 1 && !windSound.isPlaying() ){
        windSound.play();
      }
      if (type == 3 && !fireSound.isPlaying() ){
       fireSound.play();
      }
      barrier = false;
    
      for (int i = 0; i < 10000; i++){

        float r = 30;
        float x1 = random(0,1);
        float x2 = random(0,1);
        r = r * sqrt(x1);
        float theta = 2 * PI * x2;
     
        float phi = acos(2 * random(0,1)-1);
        float x = center.x + r * sin(phi)*cos(theta);
        float z = center.z + r * cos(phi);
        float y = center.y + r * sin(phi) * sin(theta);
      
        PVector pos = new PVector(x,y,z);

        
        //particles on upper and lower hemisphere has wave shape in different direction.
        if(y < center.y){
          v= new PVector(random(-5, -3), 1, 0); 
        }
        else{
          v= new PVector(random(-5, -3), -1, 0); 
        }

      
      
      //fire particles on left-half hemisphere has larger speed.
      if(type == 3){
         v.x = (pos.x - center.x)/10 ;
         if(pos.x < center.x){
          v.x = ((center.x - pos.x))/5 ; 
        }
      }
     
      Particle p = new Particle(pos,v,type,numParticles);
      particles.add(p);
      numParticles++;
      groupShape.addChild(p.particleShape);
      }
    }
    
  }
  
  void drawDefense(){
    if (numParticles < 1){
    groupShape = createShape(PShape.GROUP);
    if(!windSound.isPlaying()&&  type == 2){
      waterSound.play();
    }
    if ( !woodSound2.isPlaying() &&  type == 4){
       woodSound2.play();
    }
    meetbarrier = false;
    for (int i = 0; i < 10000; i++){
      float r = 30;
      float x1 = random(0,1);
      float x2 = random(0,1);
      r = r * sqrt(x1);
      float theta = 2 * PI * x2;
      float phi = acos(2* random(0,1) - 1);
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
      groupShape.addChild(p.particleShape);
      }
    }
  }

  void run() {

   if (keyPressed) {
        
    if (keyCode == LEFT && type == 1) {
      drawAttack();
      
    }
    
    if (keyCode == UP && type == 2){

      drawDefense();
    }
    
    
    if (keyCode == RIGHT && type == 3){

      drawAttack();
    }
    
    if (keyCode == DOWN && type == 4){

      drawDefense();
    }

    }
    
    //sort the list
    if(type == 1 && numParticles> 0){
      Collections.sort(particles,new MyCompare());
    }
    if(type == 3&& numParticles> 0){
      Collections.sort(particles,new MyCompare());
      Collections.reverse(particles);
    }
   
    
   
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
   
      if (p.isDead()) {
        particles.remove(i);
        numParticles --;
      }
            
    }
    
    
    
    if(numParticles > 0 ){

      shape(groupShape);
    }
    else{
      switch(type){
        case 1:
        windSound.stop();
        break;
        case 2:
        waterSound.stop();
        break;
        case 3:
        fireSound.stop();
        break;
        case 4:
        woodSound2.stop();
        break;
        
      }

      barrier = false;
      meetbarrier = false;
    }
    
  }
  
// return the leftmost/rightmost particle in the list.
  Particle getHead(){
    if(numParticles > 0){
      return particles.get(0);     
    }
    else return null;
  }
  
  Particle getLast(){
    if(numParticles > 0){
      return particles.get(numParticles-1);     
    }
    else return null;
  }
  
}
