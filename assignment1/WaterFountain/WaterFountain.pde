import processing.opengl.*;
import java.util.concurrent.CopyOnWriteArrayList; 
import java.util.*;

float radius = 100;
float ang = 0, ang2 = 0;
int pts = 120;
float depth = 20;
float x_velocity = 4;
float y_velocity = -10;
float z_velocity = 0;
float acceleration = 9.8;
float floor = -depth;
static CopyOnWriteArrayList<Ball> ball_list = new CopyOnWriteArrayList<Ball>(); 
void setup(){
 size(400, 400, OPENGL);
 //size(400, 400, P3D);

 background(255,255,255,1);
 
 smooth();  // comment out with P3D renderer
 noStroke();
 
 
  //camera(width/2.0, -100, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, -50, 0, 0, 1, 0);
 directionalLight(166, 166, 196, -60, -60, -60);
 ambientLight(105, 105, 130);
 //translate(width/2, height/2, -200);
 

 drawCylinder();
   int pts = 6;
   float ang = 0;
   float r_ball = 3;
   for (int i=0; i<pts; i++){
     float vx = x_velocity * cos(radians(ang)) - z_velocity * sin(radians(ang));
     float vy = y_velocity;
     float vz = x_velocity * sin(radians(ang)) + z_velocity * cos(radians(ang));
     ang+=360.0/(pts+1);
     ball_list.add(new Ball(0, -depth, 0, r_ball, vx, vy, vz));
   }   

}

void drawCylinder(){
   //body
 camera(0, -100, (height/2.0) / tan(PI*30.0 / 180.0), 0, -50, 0, 0, 1, 0);
 fill(150);
 beginShape(QUAD_STRIP);
 float ang = 0;
 for (int i=0; i<=pts; i++){
   float  px = cos(radians(ang))*radius;
   float  pz = sin(radians(ang))*radius;
   vertex(px, depth, pz);
   vertex(px, -depth, pz);
   ang+=360/pts;
 }
 endShape();
 
 //cap 1
 beginShape(POLYGON);
 for (int i=0; i<=pts; i++){
   float  px = cos(radians(ang))*radius;
   float  pz = sin(radians(ang))*radius;
   vertex(px, depth, pz);
   
   ang+=360/pts;
 }
 endShape();

 //cap2
 fill(0,255,255); 
 beginShape(POLYGON);
 for (int i=0; i<=pts; i++){
   float  px = cos(radians(ang))*radius;
   float  pz = sin(radians(ang))*radius;
   vertex(px, -depth, pz);
   ang+=360/pts;
   
 }
 endShape();
}


class Ball{
  float x_pos, y_pos, z_pos;
  float v_x, v_y, v_z;
  float r_ball;
  
  Ball(float x, float y, float z, float r, float vx, float vy, float vz){
    this.x_pos = x;
    this.y_pos = y;
    this.z_pos = z;
    this.v_x = vx;
    this.v_y = vy;
    this.v_z = vz;
    this.r_ball = r;
  }
  
  void update(float dt){
      this.x_pos = this.x_pos + this.v_x * dt;
      this.y_pos = this.y_pos + this.v_y * dt;  //Question: Why update position before velocity? Does it matter?
      this.v_y = this.v_y + acceleration * dt; 
      this.z_pos = this.z_pos + this.v_z * dt;
      //if (this.v_x<0){
      //System.out.println(this.x_pos);
      //System.out.println(this.z_pos);
      //}
      if (this.y_pos< floor){
        translate(this.x_pos, this.y_pos, this.z_pos);
        sphere(this.r_ball);
      }else{
        this.r_ball = this.r_ball * 0.1;
        //if (r_ball>0.1){ //<>//
        //   float ang = 0; //<>//
        //   int pts = 10;
        //   for (int i=0; i<pts; i++){
        //     float  px = x_pos;
        //     float  pz = z_pos;
        //     float py = y_pos;
        //     float vx = v_x * 0.8 * cos(radians(ang));
        //     float vz = v_z * 0.8 * sin(radians(ang));
        //     float vy = -v_y*0.8;
        //     ang+=360/pts;
        //     ball_list.add(new Ball(px, py, pz, r_ball, vx, vy, vz));
        //   }                   
        //}
        this.r_ball = 0.1;
      }
  }
}

void draw(){
  drawCylinder();
  fill(0,220,220);
   for (Ball ball: ball_list){
     
     if (ball.r_ball > 0.1){
       ball.update(0.01); //<>//
     }
   }

}
