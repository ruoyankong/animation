// current newest 31 hao
import java.util.*;
import java.util.Map;
Camera cam;
PImage icon;
float[] visitedx=new float[2];
float[] visitedy=new float[2];
int numSides=25;
float ang;
ArrayList<Boid> boids;
ArrayList<Boid> boidss;
ArrayList<A_star> astar;
ArrayList<Node> node;
ArrayList<Node> node2;
ArrayList<obstacle> obstacles;
boolean allign = true;
boolean sep = true;
boolean cohese = true;
boolean to_goal = true;
boolean suc=false;
int num_node = 100;
Node goal = new Node(new PVector(0,0,0));
String draw_c = "boids";
ArrayList<Node> graph;
ArrayList<ArrayList<Node>> primes;

class obstacle {
   PVector pos;  
   obstacle (float x, float y,float z) {
     pos = new PVector(x,y,z);
   }
   void draw () {       
    fill(255,215,0);
  pushMatrix();
  translate(pos.x,pos.y,0);
  ang=360/numSides; //drawCyl(numSides);
  beginShape();
  for (int i=0; i<numSides; i++){
    float x=cos(radians(i*ang))*40;
    float y=sin(radians(i*ang))*40;
    vertex(x,y,-60);
  }
  endShape(CLOSE);
  beginShape();
  for (int i=0; i<numSides; i++){
    float x=cos(radians(i*ang))*40;
    float y=sin(radians(i*ang))*40;
    vertex(x,y,-1);
  }
  endShape(CLOSE);
  beginShape(TRIANGLE_STRIP);
  for (int i=0; i<numSides; i++){
    float x=cos(radians(i*ang))*40;
    float y=sin(radians(i*ang))*40;
    vertex(x,y,0);
    vertex(x,y,-60);
  }
  endShape(CLOSE);
  popMatrix();
  pushMatrix();
  translate(0,0,-60);
  for (int i=0; i<visitedx.length-1; i++){
    stroke(2);
    fill(255,0,0);
    line(visitedx[i],visitedy[i],visitedx[i+1],visitedy[i+1]);
  }
  popMatrix();
  }
}
class Node{
 PVector location;
 Node former = null;
 ArrayList<Node> nei = new ArrayList<Node>();
 Node(PVector loc){
   location = loc;
 }  
  void display() { 
    fill(10,10,200);
    ellipse(location.x, location.y, 15, 15);  
  }
  void check_neighbor(Node cur){
    int add=1;
    for (Node n: nei) {
      if (n == cur) {
        add=0;
        break;
      }
    }
    if(add==1) {
      nei.add(cur);
    }
  }    
  void path_highlight(){
      fill(190,10,20);
      ellipse(location.x, location.y, 15, 15);
  }
}

void borders(float x, float y) {
  x = (x + width) % width;
  y = (y + height) % height;
  
}
int calc_distance(Node start, Node end){
  float a = start.location.x - end.location.x;
  float b = start.location.y - end.location.y;
  float c = start.location.z - end.location.z;
  return (int)sqrt(a*a + b*b + c*c);
}



void setup () {
  size(800, 576,P3D); 
  cam = new Camera();
  cam.position = new PVector(400, 280, 700);
  boids = new ArrayList<Boid>();
  boidss = new ArrayList<Boid>();
  obstacles = new ArrayList<obstacle>();
  node = new ArrayList<Node>();
  node2 = new ArrayList<Node>();
  graph = new ArrayList<Node>();
  astar = new ArrayList<A_star>();
  goal.location.x=500;
  goal.location.y=220;
  icon = loadImage("icon.png");
  icon.resize(20, 20);
  primes = new ArrayList<ArrayList<Node>>(); 
  obstacles = new ArrayList<obstacle>();


  while(true){
      int count = 0;
  while(count <10){
    float x = random(790);
    float y = random(560);
    float z = 0;
    x = (x + 800) % 800;
    y = (y + 576) % 576;
    PVector temp = new PVector(x, y,z);
    boids.add(new Boid(new PVector(x, y,z)));
    node.add(new Node(temp));    
    graph.add(new Node(temp));
    ++count;    
  }
    println("run");
 //    int d=0;
 // while(d<num_obstacle){
 //  boolean dup = false;
 //  float x = random(125+ width);
 //  float y = random(height-100);
 //  x = (x + width) % width;
 //  y = (y + height) % height;
 //  for(obstacle ob:obstacles){
 //    if(PVector.dist(ob.pos,new PVector(x, y,0)) < 80){
 //      dup = true;
 //      break;
 //    }
 //  }
 //  if(!dup){       
 //    obstacles.add(new obstacle(x, y, 0)); 
 //    int t = obstacles.size()-1;
 //    obstacle a = obstacles.get(t);
 //    a.draw();   
 //    ++d;
 //  }   
 //}

   float xo1 = 400;
   float yo1 = 250;
   xo1 = (xo1 + width) % width;
   yo1 = (yo1 + height) % height;      
     obstacles.add(new obstacle(xo1, yo1, 0)); 
     int t1 = obstacles.size()-1;
     obstacle ob1 = obstacles.get(t1);
     ob1.draw();   
   float xo2 = 580;
   float yo2 = 300;
   xo1 = (xo2 + width) % width;
   yo1 = (yo2 + height) % height;      
     obstacles.add(new obstacle(xo2, yo2, 0)); 
     int t2 = obstacles.size()-1;
     obstacle ob2 = obstacles.get(t2);
     ob2.draw(); 
    float xo3 = 580;
   float yo3 = 100;
   xo1 = (xo3 + width) % width;
   yo1 = (yo3 + height) % height;      
     obstacles.add(new obstacle(xo3, yo3, 0)); 
     int t3 = obstacles.size()-1;
     obstacle ob3 = obstacles.get(t3);
     ob3.draw(); 
       int ct = 0;   //generate nodes according to prm
    while(ct < num_node){
      float x = random(width - 10);
      float y = random(height - 10);      
      for(obstacle obs : obstacles) {
        if(PVector.dist(obs.pos, new PVector(x, y, 0)) < 47) {
          float a = x - obs.pos.x;
          float b = y - obs.pos.y;
          float tmp = sqrt(a*a*47*47/(a*a+b*b));
          float sign = 1;
          if (a < 0) {
            sign = -1;
          }
          float new_x = sign*tmp + obs.pos.x;
          float new_y = (b/a)*sign*tmp + obs.pos.y;
          x=new_x;
          y=new_y;
        }
      } 
      ++ct;
    graph.add(new Node(new PVector(x, y,0)));
  }  
  graph.add(goal);
     num_node = graph.size(); 
    Node a,b;     
   for(int i = 0; i< num_node; i++){   
      a= graph.get(i);
      for(int j = i; j < num_node; j++){
        b = graph.get(j);//numofBoids - 1
        boolean notcold = true;
        for(obstacle ob : obstacles) {
          if(check_collsionss(a.location, b.location, ob.pos, 50)) notcold= false; 
        }
        float distance = dist(a.location.x, a.location.y, b.location.x, b.location.y);
         if (distance < 300 && i!=j&&notcold){ //connect all nodes within 300 cm
            a.check_neighbor(b);
           
        }          
     }
   }
   boolean can = true;
       for(int i =0; i< 10;i++){//each bird
      A_star ar = new A_star(graph);// put in aorresponding nodes
      astar.add(ar);      
      ArrayList<Node> path = ar.astar(graph.get(i), goal);
      
      if(path != null){//if this particular agent found an optimal path to the goal
          path.add(0, goal); // goal's index ==0 first one  
          primes.add(path);
         for(int j = 0; j<path.size();j++){
           path.get(j).display();     
          }
          //println("yyyyyy"); 
        }
        else {
         primes.add(null);
         can = false;
         println("nnnnnnn"); 
      }        
    }
  if(can) break;
  else{
  boids = new ArrayList<Boid>();
  obstacles = new ArrayList<obstacle>();
  node = new ArrayList<Node>();
  graph = new ArrayList<Node>();
  astar = new ArrayList<A_star>();
  primes = new ArrayList<ArrayList<Node>>(); 
  obstacles = new ArrayList<obstacle>();
  }
  } 

    beforet = millis();
 square(goal.location.x, goal.location.y, 20);
}


  boolean check_collsionss(PVector p1, PVector p2, PVector ob, float rad){
  float x1 = p1.x - ob.x;
  float y1 = p1.y - ob.y;
  float x2 = p2.x - ob.x;
  float y2 = p2.y - ob.y;
  float dir = sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
  float delta = rad*rad*dir*dir - (x1*y2-x2*y1)*(x1*y2-x2*y1);
  if(delta<=0){
    return false;
  }else{
    float y0 = (-(x1*y2-x2*y1)*(x2-x1)+(y2-y1)*sqrt(delta))/(dir*dir);
    if ((y0-y1)*(y0-y2)>0){
      return false;
    }else{
      return true;
    }
  }
}

  float nowt, beforet, dt;  
  void draw () {
    nowt = millis();
    dt = (nowt - beforet)/20;
    beforet = nowt;
    cam.Update(dt);
    
    background(255);
  square(goal.location.x, goal.location.y, 20);
  for(int i = 0; i<obstacles.size(); i++){ 
    obstacle o =obstacles.get(i);
    o.draw();
  }
  for(int i = 0; i< graph.size(); i++){
        graph.get(i).display();           
  }  
  
  for(int i = 0; i<primes.size(); i++){
    ArrayList<Node> sol = primes.get(i);
    if(sol==null||sol.size()<2) continue;
      for(int j = 0; j< sol.size()-1; j++){
        int k=j+1;
        Node a = sol.get(j);
        Node b = sol.get(k);       
        float x1 = a.location.x;
        float y1 = a.location.y;
        float x2 = b.location.x;
        float y2 = b.location.y;
        stroke(126);
        line(x1, y1, x2, y2);
        a.path_highlight();
        b.path_highlight();
    }  
  }

  for (int i = 0; i <boids.size(); i++) {
    //println(equals(node.get(i),graph.get(i)));
    Boid current = boids.get(i);
    current.move_forward(dt,i);
    current.draw();
  }
  for (int i = 0; i <boidss.size(); i++) {
    Boid current = boidss.get(i);
    current.move_forward(dt,i);  
    current.draw();
  }
  if (text_time > 0) {
    textSize(30);
    fill(0, 102, 153);
    text(text, 10, 40); 
    text_time -= 1; 
  }   
  }  

int text_time = 0;
String text = "";

void keyPressed () {
  cam.HandleKeyPressed();
  if (key == 'b') {
    draw_c = "boids";
    text = "Add boids";
    text_time = (int) frameRate * 3;
  } else if (key == '0') {
    draw_c = "obstacles";
    text = "Add obstacle";
    text_time = (int) frameRate * 3;
  } else if (key == '9') {
    draw_c = "goal_change";
    text = "Change goal position";
    text_time = (int) frameRate * 3;
  } else if (key == 'i') {
    draw_c = "move_ob1";
    text = "Move obstacle1";
    text_time = (int) frameRate * 3;
  } else if (key == 'o') {
    draw_c = "move_ob2";
    text = "Move obstacle2";
    text_time = (int) frameRate * 3;
  } else if (key == '1') {
     allign = allign ? false : true;
     text = "Turned allignment " + (allign ? "on" : "off");
     text_time = (int) frameRate * 3;
  } else if (key == '2') {
     sep = sep ? false : true;
     text = "Turned crowd separation " + (sep ? "on" : "off");
     text_time = (int) frameRate * 3;
  }else if (key == '3') {
     cohese = cohese ? false : true;
     text = "Turned cohesion " + (cohese ? "on" : "off");
     text_time = (int) frameRate * 3;
  } else if (key == '4') {
     to_goal = to_goal ? false : true;
     text = "goal " + (to_goal ? "on" : "off");
     text_time = (int) frameRate * 3;
  }
}

int cnt=0;
void mousePressed () {
  if(draw_c=="obstacles") {  
    obstacles.add(new obstacle(mouseX, mouseY,0));
  }
  else if(draw_c=="boids") {     
    boidss.add(new Boid(new PVector(mouseX, mouseY,0)));
    node2.add(new Node(new PVector(mouseX, mouseY,0)));
    A_star a = new A_star(graph);// put in aorresponding nodes
    astar.add(a);
    Node agent = node2.get(cnt); //always the first one       
    ArrayList<Node> solution = a.astar(agent, goal);
    if(solution != null){//if this particular agent found an optimal path to the goal
     solution.add(0, goal); // goal's index ==0 first one         
     for(int j = 0; j<solution.size();j++){
       Node b = solution.get(j);
       b.display();     
      }
    }
    primes.add(solution);
    ++cnt;
  }
}
void mouseDragged() 
{
  if(draw_c == "move_ob1"){
  obstacles.get(0).pos.x=mouseX;
  obstacles.get(0).pos.y=mouseY;
  }
  else if(draw_c == "move_ob2"){
    obstacles.get(1).pos.x=mouseX;
    obstacles.get(1).pos.y=mouseY;
  }
  else if(draw_c == "goal_change"){
    goal.location.x=mouseX;
    goal.location.y=mouseY;
  }
}
void keyReleased()
{
  cam.HandleKeyReleased();
}
class Camera
{
  Camera()
  {
    position      = new PVector( 0, 0, 0 ); // initial position
    theta         = 0; // rotation around Y axis. Starts with forward direction as ( 0, 0, -1 )
    phi           = 0; // rotation around X axis. Starts with up direction as ( 0, 1, 0 )
    moveSpeed     = 50;
    turnSpeed     = 1.57; // radians/sec
    
    // dont need to change these
    negativeMovement = new PVector( 0, 0, 0 );
    positiveMovement = new PVector( 0, 0, 0 );
    negativeTurn     = new PVector( 0, 0 ); // .x for theta, .y for phi
    positiveTurn     = new PVector( 0, 0 );
    fovy             = PI / 4;
    aspectRatio      = width / (float) height;
    nearPlane        = 0.1;
    farPlane         = 10000;
  }
  
  void Update( float dt )
  {
    theta += turnSpeed * (negativeTurn.x + positiveTurn.x) * dt;
    
    // cap the rotation about the X axis to be less than 90 degrees to avoid gimble lock
    float maxAngleInRadians = 85 * PI / 180;
    phi = min( maxAngleInRadians, max( -maxAngleInRadians, phi + turnSpeed * ( negativeTurn.y + positiveTurn.y ) * dt ) );
    
    // re-orienting the angles to match the wikipedia formulas: https://en.wikipedia.org/wiki/Spherical_coordinate_system
    // except that their theta and phi are named opposite
    float t = theta + PI / 2;
    float p = phi + PI / 2;
    PVector forwardDir = new PVector( sin( p ) * cos( t ),   cos( p ),   -sin( p ) * sin ( t ) );
    PVector upDir      = new PVector( sin( phi ) * cos( t ), cos( phi ), -sin( t ) * sin( phi ) );
    PVector rightDir   = new PVector( cos( theta ), 0, -sin( theta ) );
    PVector velocity   = new PVector( negativeMovement.x + positiveMovement.x, negativeMovement.y + positiveMovement.y, negativeMovement.z + positiveMovement.z );
    position.add( PVector.mult( forwardDir, moveSpeed * velocity.z * dt ) );
    position.add( PVector.mult( upDir,      moveSpeed * velocity.y * dt ) );
    position.add( PVector.mult( rightDir,   moveSpeed * velocity.x * dt ) );
    
    aspectRatio = width / (float) height;
    perspective( fovy, aspectRatio, nearPlane, farPlane );
    camera( position.x, position.y, position.z,
            position.x + forwardDir.x, position.y + forwardDir.y, position.z + forwardDir.z,
            upDir.x, upDir.y, upDir.z );
  }
  
  // only need to change if you want difrent keys for the controls
  void HandleKeyPressed()
  {
    if ( key == 'w' ) positiveMovement.z = 1;
    if ( key == 's' ) negativeMovement.z = -1;
    if ( key == 'a' ) negativeMovement.x = -1;
    if ( key == 'd' ) positiveMovement.x = 1;
    if ( key == 'q' ) positiveMovement.y = 1;
    if ( key == 'e' ) negativeMovement.y = -1;
    
    if ( keyCode == LEFT )  negativeTurn.x = 0.1;
    if ( keyCode == RIGHT ) positiveTurn.x = -0.1;
    if ( keyCode == UP )    positiveTurn.y = 0.1;
    if ( keyCode == DOWN )  negativeTurn.y = -0.1;
  }
  
  // only need to change if you want difrent keys for the controls
  void HandleKeyReleased()
  {
    if ( key == 'w' ) positiveMovement.z = 0;
    if ( key == 'q' ) positiveMovement.y = 0;
    if ( key == 'd' ) positiveMovement.x = 0;
    if ( key == 'a' ) negativeMovement.x = 0;
    if ( key == 's' ) negativeMovement.z = 0;
    if ( key == 'e' ) negativeMovement.y = 0;
    
    if ( keyCode == LEFT  ) negativeTurn.x = 0;
    if ( keyCode == RIGHT ) positiveTurn.x = 0;
    if ( keyCode == UP    ) positiveTurn.y = 0;
    if ( keyCode == DOWN  ) negativeTurn.y = 0;
  }
  
  // only necessary to change if you want different start position, orientation, or speeds
  PVector position;
  float theta;
  float phi;
  float moveSpeed;
  float turnSpeed;
  
  // probably don't need / want to change any of the below variables
  float fovy;
  float aspectRatio;
  float nearPlane;
  float farPlane;  
  PVector negativeMovement;
  PVector positiveMovement;
  PVector negativeTurn;
  PVector positiveTurn;
};
