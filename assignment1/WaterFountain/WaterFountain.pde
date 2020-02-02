import peasy.*; //<>// //<>// //<>//

float acceleration = 9.8;
float time_before;
PeasyCam cam;
PShape fountain;
PShape drop;
float floor = -75;
float initial_life_time = 40;
PVector sphere_pos = new PVector(-100, 0, 0);
float sphere_r = 30;
float generate_rate = 1500;

public void settings() {
  size(1000, 1000, P3D);
}

public void setup() {
  
  cam = new PeasyCam(this, 500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(2000);
  time_before = millis();
  fountain = loadShape("resource/3d-model.obj");
  
}

public class Particle{
  PVector pos, vel, col;
  float lifetime;
  float particle_size;
  float bounce_loss_ratio = 0.95;
  float bounce_v_loss_ratio = 0.5;
  float n_generate = 1;
  float tail_length = 3;
  public Particle(float h_vel, float v_vel, PVector col, PVector pos, float lifetime, float particle_size){
    float theta = random(2*PI);
    float initial_h_vel = h_vel;
    float initial_v_vel = v_vel;
    this.col = col;
    vel = new PVector(initial_h_vel*cos(theta), initial_v_vel, initial_h_vel*sin(theta));
    this.pos = pos;
    this.lifetime = lifetime;    
    this.particle_size = particle_size;
  }
  
  public void update(float dt, ArrayList<Particle> particle_list){   
    pos.add(PVector.mult(vel, dt)); 
    vel.y += dt * acceleration;
    PVector c_delta = col.copy();
    c_delta.sub(new PVector(255,255,255)).div(lifetime).mult(dt);
    col.sub(c_delta);
    particle_size -= particle_size/lifetime*dt;
    float h_vel = sqrt(vel.x*vel.x+vel.z*vel.z)*bounce_loss_ratio*random(1.0);
    float v_vel = -vel.y*bounce_loss_ratio*bounce_v_loss_ratio*random(1.0);
    PVector direction = PVector.sub(pos, sphere_pos);
    float distance = direction.mag();
    if (pos.y + particle_size > 50 || distance - particle_size <= sphere_r){
      for (int i = 0;i < n_generate; i++){
        particle_list.add(new Particle(h_vel, v_vel, col, pos, lifetime*bounce_loss_ratio, particle_size*bounce_loss_ratio*random(1.0)));
      }
      lifetime = 0;
    }
    
  }
  
  public void display(float dt) {
    
    beginShape(LINES);
    strokeWeight(particle_size);
    stroke(col.x, col.y, col.z, lifetime/initial_life_time*255);
    vertex(pos.x, pos.y, pos.z);
    strokeWeight(particle_size/10);
    vertex(pos.x, pos.y- particle_size/2, pos.z);
    endShape();
    
    beginShape(LINES);
    //strokeWeight(particle_size);
    stroke(col.x, col.y, col.z, lifetime/initial_life_time*255);
    vertex(pos.x, pos.y, pos.z);
    strokeWeight(particle_size/10);
    stroke(255,255,255, lifetime/initial_life_time*255);
    PVector s = PVector.sub(pos, PVector.mult(vel, dt*tail_length));
    vertex(s.x, s.y, s.z);
    endShape();
  }
}

public void showFountain(){
  
  background(255, 255, 255);
  pushMatrix();
  rotateX(PI);
  shapeMode(CENTER);
  shape(fountain,0,0);
  pushMatrix();  
  translate(-100, 0, 0);
  noStroke();
  fill(230);
  sphere(sphere_r);
  popMatrix();
  beginShape();
  fill(176*1.15, 196*1.15, 222*1.15);
  float n_point = 360;
  float angle = 360.0/n_point;
  float r = 160;
  for (int i = 0; i < n_point; i++) {
      float x = cos( radians( i * angle ) ) * r;
      float z = sin( radians( i * angle ) ) * r;
      vertex( x - 168, floor+25, z);
  }
  endShape(CLOSE);
  translate(0, floor, 0);
  fill(255,255,240);
  box(3000,10,3000);
  popMatrix();
  

}

public class ParticleSystem{
  float acceleration = 9.8;
  ArrayList<Particle> particle_list = new ArrayList<Particle>();
  
  public float updateTime(){
    float time_start = millis();
    float time_gap = time_start - time_before;
    time_before = time_start;
    return time_gap;
  }
  
  public void deleteParticle(float dt){
    int n_particle = particle_list.size();
    for (int i = n_particle-1; i >= 0; i--){
        particle_list.get(i).lifetime -= dt;
        if (particle_list.get(i).lifetime<=0 || particle_list.get(i).particle_size<=0.1)
        particle_list.remove(i);
    }
  }
  
  public void generateParticle(float dt){
    for (int i = 0; i < dt*generate_rate; i++) 
    particle_list.add(new Particle(10, -40, new PVector(176*0.8, 196*0.8, 222*0.8), new PVector(-180, -60, 0), initial_life_time, 5));
  }
  
  public void updateParticle(float dt){
    int n_particle = particle_list.size();
    for (int i = n_particle-1; i >= 0; i--) particle_list.get(i).update(dt, particle_list);
  }
  
  public void displayParticle(float dt){
    for (Particle particle: particle_list) particle.display(dt);
  }  
}

ParticleSystem ps = new ParticleSystem();
int flag = 0;
public void draw() {
  pushMatrix();
  lights();
  translate(180, 100, 0);
  
  //draw fountain
  showFountain();
  float dt = ps.updateTime()/1000.0;
  
  
  if (flag!=0){
    // generate particle each round
    ps.generateParticle(dt); //<>//
    
    // update particle position, color, velocity
    ps.updateParticle(dt); //<>//
    
    //calculate lifetime, delete dead particles
    ps.deleteParticle(dt);
    
    //display particles
    ps.displayParticle(dt);  //<>//
  }else{
    flag = 1;
  }
  println("# of Particles: " + ps.particle_list.size());  
  println("Frame Rate: " + frameRate);
  
  popMatrix();


}
