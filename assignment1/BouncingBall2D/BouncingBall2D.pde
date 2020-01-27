// Created for CSCI 5611

// Here is a simple processing program that demonstrates the central math used in the check-in
// to create a bouncing ball. The ball is integrated with basic Eulerian integration.
// The ball is subject to a simple PDE of constant downward acceleration  (by default, 
// down is the positive y direction).

// If you are new to processing, you can find an excellent tutorial that will quickly
// introduce the key features here: https://processing.org/tutorials/p3d/

String projectTitle = "Bouncing Ball";

//Animation Principle: Store object & world state in external variables that are used by both
//                     the drawing code and simulation code.
float x = 0;
float y = 200;
float y_velocity = 0;
float x_velocity = 5;
float radius = 40; 
float floor = 600;

//Creates a 600x600 window for 3D graphics 
void setup() {
 size(600, 600, P3D);
 noStroke(); //Question: What does this do?
}

//Animation Principle: Separate Physical Update 
void computePhysics(float dt){
  float acceleration = 9.8;
  
  //Eulerian Numerical Integration
  x = x + x_velocity * dt;
  y = y + y_velocity * dt;  //Question: Why update position before velocity? Does it matter?
  y_velocity = y_velocity + acceleration * dt;  
  
  
  //Collision Code (update velocity if we hit the floor)
  if (y + radius > floor){
    y = floor - radius; //Robust collision check
    y_velocity *= -.85; //Coefficient of restitution (don't bounce back all the way) 
  }
}

//Animation Principle: Separate Draw Code
void drawScene(){
  background(255,255,255);
  fill(0,200,10); 
  lights();
  translate(x, y); 
  sphere(radius);
}

//Main function which is called every timestep. Here we compute the new physics and draw the scene.
//Additionally, we also compute some timing performance numbers.
void draw() {
  float startFrame = millis(); //Time how long various components are taking
  
  //Compute the physics update
  computePhysics(0.15); //Question: Should this be a fixed number?
  float endPhysics = millis();
  
  //Draw the scene
  drawScene();
  float endFrame = millis();
  
  String runtimeReport = "Frame: "+str(endFrame-startFrame)+"ms,"+
        " Physics: "+ str(endPhysics-startFrame)+"ms,"+
        " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle(projectTitle+ "  -  " +runtimeReport);
  //print(runtimeReport);
}
