class Boid {
  PVector pos;
  ArrayList<Boid> close_neighbor;
  int currentGoal;
  PVector velocity;
  PVector acceleration;
  float maxAcc;    
  float maxspeed;    
  int delay = 0;

  Boid (PVector p) {
    pos = p;
    close_neighbor = new ArrayList<Boid>();
    currentGoal = -1;
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-10, 10), random(-10, 10));
    maxspeed = 1;
    maxAcc = 0.5;
  }
  int calc_distance(Boid start, Boid end){
  float a = start.pos.x - end.pos.x;
  float b = start.pos.y - end.pos.y;
  float c = start.pos.z - end.pos.z;
  return (int)sqrt(a*a + b*b + c*c);
}

  void move_forward (float dt,int index) {
    delay = (delay + 1) % 5;
    pos.x = (pos.x + width) % width;
    pos.y = (pos.y + height) % height;
    if (delay ==0 ) {
    check_group();
    }
    group(index);
    update(dt);
    pos.add(velocity);
    if (currentGoal != -1 && currentGoal != 0 &&PVector.dist(primes.get(index)
    .get(currentGoal).location, pos) < 10) {
      currentGoal--;
    }
    avoid_abstacles();
  }
  void check_group(){
    ArrayList<Boid> around = new ArrayList<Boid>();
    for (int i =0; i < boids.size(); i++) {
      Boid t = boids.get(i);
      if (t != this &&(calc_distance(t,this) < allign_rad)) {
        around.add(t);
      }
    }
    close_neighbor = around;
  }
  void avoid_abstacles(){
    for (obstacle obs: obstacles) {
      float d = PVector.dist(obs.pos, pos);
      if ( d < 60) {
        while(PVector.dist(obs.pos, pos) < 60) {
          pos.add(PVector.sub(pos, obs.pos).normalize());
        }
      }
    }
  }
    
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  void group (int index) {
    PVector allignment = Alignment(); 
    PVector separation = Separation(); 
    PVector cohesion = Cohesion();

    if (currentGoal == -1&&primes.get(index)!=null) {
      currentGoal = primes.get(index).size() - 1;
    }
    PVector goalForce = new PVector(0,0);
    if(primes.get(index)!=null){
      goalForce=PVector.sub(primes.get(index).get(currentGoal).location, pos);
      goalForce.normalize();
    }
    float b=8;
    float c=0.05;
    float d=20;
    if (!allign) allignment.mult(0);    
    if (!sep) separation.mult(0);
    if (!cohese) cohesion.mult(0);
    if (!to_goal) {
      goalForce.mult(0);
    }    
    applyForce(allignment.mult(d));
    applyForce(separation.mult(b));     
    applyForce(cohesion.mult(c));
    applyForce(goalForce.mult(2));
    if (!to_goal) {
      applyForce(new PVector(2,0));
      maxspeed=1;
      maxAcc=0.5;
      b=20;
      c=0.1;
      d=5;
    } 
  }
  void update(float dt) {
    borders(pos.x,pos.y);
    velocity.add(acceleration.mult(dt));
    velocity.limit(maxspeed);
    pos.add(velocity.mult(dt));
    borders(pos.x,pos.y);
    acceleration.mult(0);
  }
  PVector Alignment () {//group velocity == alignment
    PVector group_speed = new PVector(0, 0);
    for (Boid b : close_neighbor) {
      float d = PVector.dist(pos, b.pos);
      if (abs(d) < allign_rad) { // speed group
        PVector v = b.velocity;
        v.normalize();
        v.div(d);  //weighted by distance
        group_speed.add(v);
      }
    }
    return group_speed;
  }
  PVector Separation() {
    PVector outward = new PVector(0, 0);
    for (Boid b : close_neighbor) {
      float d = PVector.dist(pos, b.pos);
      if (abs(d) < separate_rad) { 
        PVector diff = PVector.sub(pos, b.pos); // pointing away from neighbor
        diff.normalize();
        diff.div(d);        // Weight by distance
        outward.add(diff);
      }
    }
    return outward;
  }

  PVector Cohesion () { //position group will go, then i will go
    PVector group_pos = new PVector(0, 0);  
    int c = 0;
    for (Boid b : close_neighbor) {
      float d = PVector.dist(pos, b.pos);
      if (abs(d) < cohese_rad) { // group size
        group_pos.add(b.pos); // Add location
        ++c;
      }
    }
    if (c > 0) {
      group_pos.div(c);   //average position   
      PVector direction = PVector.sub(group_pos, pos);  
      group_pos= direction;
    } 
    return group_pos;
  }
  void draw () {
    noStroke();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(velocity.heading());
    image(icon,0,0);
    popMatrix();
  }
}
