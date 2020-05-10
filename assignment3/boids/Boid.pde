class Boid {
  PVector pos;
  ArrayList<Boid> close_neighbor;
  int currentGoal;
  PVector velocity;
  PVector acceleration;
  float maxAcc;    
  float maxspeed;    

  Boid (PVector p) {
    pos = p;
    close_neighbor = new ArrayList<Boid>();
    currentGoal = -1;
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-10, 10), random(-10, 10));
    maxspeed = 1;
    maxAcc = 0.5;
  }

  float distanceToPoint(PVector p) {
    return pos.dist(p);
  }

  void move_forward (float dt,int index) {
    pos.x = (pos.x + 800) % 800;
    pos.y = (pos.y + 576) % 576;
    check_group();
    group(index);
    update(dt);
    pos.add(velocity);
    if (currentGoal != -1 && currentGoal != 0 &&PVector.dist(primes.get(index).get(currentGoal).location, pos) < 7) {
      currentGoal--;
    }
    avoid_abstacles();
  }
  void check_group(){
    ArrayList<Boid> around = new ArrayList<Boid>();
    for (int i =0; i < boids.size(); i++) {
      Boid t = boids.get(i);
      if (t != this &&(distanceToPoint(t.pos) < 54)) {
        around.add(t);
      }
    }
    close_neighbor = around;
  }
  void avoid_abstacles(){
    for (obstacle obs: obstacles) {
        while(distanceToPoint(obs.pos) < 60) {
          pos.add(PVector.sub(pos, obs.pos).normalize());
        }
    }
  }    
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  void group (int index) {
    PVector allignment = new PVector(0, 0);
    PVector separation = new PVector(0, 0);
    PVector cohesion = new PVector(0, 0); 
    int ct = 0;
    for (Boid b : close_neighbor) {
      float d = PVector.dist(pos, b.pos);
      if (abs(d) < 82) { 
        PVector diff = PVector.sub(pos, b.pos).normalize().div(d); // pointing away from neighbor
        separation.add(diff);
        if (abs(d) < 54) { // speed group
          PVector v = b.velocity;
          v.normalize().div(d);  //weighted by distance
          allignment.add(v);
          cohesion.add(b.pos); // Add location
          ++ct;
        }      
      }
    }
    if (ct > 0) {
      cohesion.div(ct).sub(pos);   //average position   
    } 
    try{
    if (currentGoal == -1&&primes.get(index)!=null) {
      currentGoal = primes.get(index).size() - 1;
    }
    }
    catch(Exception e){
      print("too much boids");
    }
    PVector goalForce = new PVector(0,0);
    if(primes.get(index)!=null){
      goalForce=PVector.sub(primes.get(index).get(currentGoal).location, pos);
      goalForce.normalize();
    }
    float b=20;
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
    velocity.add(acceleration.mult(dt));
    velocity.limit(maxspeed);
    pos.add(velocity.mult(dt));
    acceleration.mult(0);
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
