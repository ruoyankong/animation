import java.util.*;
import queasycam.*;

QueasyCam cam;

public class RigidBody{
  float Mass;
  PVector pos, vel;
  PVector acc, RotInertia, AngMomentum, Torque;
  PVector Force;
  PMatrix3D eye;
  float radius;
  
  public RigidBody(float Mass, PVector pos){
    this.Mass = Mass;
    this.pos = pos;
    this.radius = 20;
    this.vel = new PVector(0,0,0);
    this.acc = new PVector(0,0,0);
    this.Force = new PVector(0,0,0);
    this.Torque = new PVector(0,0,0);
    this.eye = new PMatrix3D(1,0,0,0,
                             0,1,0,0,
                             0,0,1,0,
                             0,0,0,1);               
                             
  }
  
  void Update(float time){
    Momentum.add(PVector.mult(Force, time));
    pos.add(PVector.mult(Momentum, time/Mass));
  }
  void AccumulateForce(PVector f){
    Force.add(f);
  }
}
public void settings() {
  size( 1000, 1000, P3D );
}

void setup() {
  cam = new QueasyCam(this);
  cam.position = new PVector(10, -20, -20);
  cam.sensitivity = 1;   
}
