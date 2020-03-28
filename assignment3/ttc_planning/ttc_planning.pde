import java.util.*;

Camera cam = new Camera();
Random random = new Random();

PVector obsPos = new PVector(0,0,0);
float obsR = 2.0;
float agentR = 1;
float confR = obsR + agentR;
//ArrayList<PVector> path;
int n_agent = 20;
//float agentV = 0.01;

ArrayList<DPQ> dpqs;
ArrayList<PVector> startPs = new ArrayList<PVector>();
ArrayList<PVector> obstacles = new ArrayList<PVector>();
int n_obs = 4;

void setup(){
  size(1000, 1000, P3D);
  cam.position = new PVector(0, 0, 40);
  dpqs = new ArrayList<DPQ>();
  gen_obstacle(n_obs);
  for (int i=0;i<n_agent;i++) dpqs.add(new DPQ());
  for (int i=0;i<dpqs.size();i++){
    //while(true){
      while (true){
        dpqs.get(i).genRandomPoints();
        if (dpqs.get(i).buildGraph()) break;
      }
      dpqs.get(i).dijkstra();
      
    //  if(dpqs.get(i).dijkstra()) break;
    //}
     
  }
  beforet = millis();
}

void gen_obstacle(int n){
  PVector obspos;
  for (int i=0;i<n;i++){
    obspos = new PVector(-9.5+obsR + random.nextFloat() * (19-2*obsR), -9.5+obsR + random.nextFloat() * (19-2*obsR), 0);
    while (!check_obs_collision(obspos)) obspos = new PVector(-9.5+obsR + random.nextFloat() * (19-2*obsR), -9.5+obsR + random.nextFloat() * (19-2*obsR), 0);
    obstacles.add(obspos);
  }
}
 PVector end = new PVector(10-2*agentR, 10-2*agentR, 0);
boolean check_obs_collision(PVector obspos){
  for (int i=0;i<obstacles.size();i++){
    if (PVector.dist(obspos, obstacles.get(i))<obsR*2+0.01) return false;
  }
  for (int i=0;i<dpqs.size();i++){
    if (PVector.dist(obspos, dpqs.get(i).agentPos)<obsR+agentR+0.01) return false;
  }
  if (PVector.dist(obspos, end)<obsR+sqrt(2)*agentR+0.01) return false;
 
  
  return true;
}

boolean check_agent_obs_collision(PVector agentpos){
    for (int i=0;i<obstacles.size();i++){
    if (PVector.dist(agentpos, obstacles.get(i))<obsR+agentR+0.01) return false;
  }
  return true;
}

boolean checkStartPCollision(PVector start){
  for (int i=0; i<startPs.size();i++){
    if (PVector.dist(start, startPs.get(i))<2*agentR+0.01) return false;
  }
  return true;
}

public class DPQ { 
    ArrayList<PVector> randomPoints;
    int nRandomPoint = 200;
    private float dist[]; 
    private Set<Integer> settled; 
    private PriorityQueue<Node> pq; 
    private int V; // Number of vertices 
    //List<List<Node> > adj; 
    LinkedList<Node> adj[];
    PVector start;
    ArrayList<PVector> path;
    PVector v;
    PVector gv;
    PVector f;
    float speed;
    PVector col;
    PVector agentPos;
    int current_node_i = 0;
  
    public DPQ() 
    { 
         
        //pq = new PriorityQueue<Node>(V, new Node()); 
        this.start = new PVector(-9.5+agentR + random.nextFloat() * (19-2*agentR), -9.5+agentR + random.nextFloat() * (19-2*agentR), 0);
        while ((!check_agent_obs_collision(this.start))||!checkStartPCollision(this.start)){
          this.start = new PVector(-9.5+agentR + random.nextFloat() * (19-2*agentR), -9.5+agentR + random.nextFloat() * (19-2*agentR), 0);
        }
        startPs.add(this.start);
        //this.end = new PVector(-9.5+agentR + random.nextFloat() * (19-2*agentR), -9.5+agentR + random.nextFloat() * (19-2*agentR), 0);
        //while (PVector.dist(this.end, obsPos) <= 2*agentR +obsR+0.01){
        //  this.end = new PVector(-9.5+agentR + random.nextFloat() * (19-2*agentR), -9.5+agentR + random.nextFloat() * (19-2*agentR), 0);
        //}
        //this.v = new PVector(-0.01 + random.nextFloat() * 0.02, -0.01 + random.nextFloat() * 0.02, 0);
        this.speed = 5+random.nextFloat() * 5;
        float theta = random.nextFloat();
        this.v = new PVector(cos(theta)*this.speed, sin(theta)*this.speed);
        this.gv = this.v.copy();
        this.col = new PVector(random.nextFloat()*255, random.nextFloat()*255, random.nextFloat()*255);
        randomPoints = new ArrayList<PVector>(this.nRandomPoint);
        for (int i = 0; i < this.nRandomPoint; i++) {
          this.randomPoints.add(new PVector(0,0,0));
        }
        this.path = new ArrayList<PVector>();
        this.agentPos = this.start.copy();
    } 
    
    public DPQ(PVector start) 
    { 
         
        //pq = new PriorityQueue<Node>(V, new Node()); 
        this.start = start;
        startPs.add(this.start);
        //this.end = new PVector(-9.5+agentR + random.nextFloat() * (19-2*agentR), -9.5+agentR + random.nextFloat() * (19-2*agentR), 0);
        //while (PVector.dist(this.end, obsPos) <= 2*agentR +obsR+0.01){
        //  this.end = new PVector(-9.5+agentR + random.nextFloat() * (19-2*agentR), -9.5+agentR + random.nextFloat() * (19-2*agentR), 0);
        //}
        //this.end = end;//new PVector(10-2*agentR, 10-2*agentR, 0);
        //this.v = new PVector(-0.01 + random.nextFloat() * 0.02, -0.01 + random.nextFloat() * 0.02, 0);
        this.speed = 5+random.nextFloat() * 5;
        float theta = random.nextFloat();
        this.v = new PVector(cos(theta)*this.speed, sin(theta)*this.speed);
        this.gv = this.v.copy();
        this.col = new PVector(random.nextFloat()*255, random.nextFloat()*255, random.nextFloat()*255);
        randomPoints = new ArrayList<PVector>(this.nRandomPoint);
        for (int i = 0; i < this.nRandomPoint; i++) {
          this.randomPoints.add(new PVector(0,0,0));
        }
        this.path = new ArrayList<PVector>();
        this.agentPos = this.start.copy();
    }
    
    boolean buildGraph(){
      settled = new HashSet<Integer>();
      this.randomPoints.add(agentPos);
      this.randomPoints.add(PVector.add(end, new PVector(agentR, agentR, 0)));
      this.V = this.randomPoints.size(); 
      dist = new float[V];
      pq = new PriorityQueue<Node>(V, new Node()); 
      this.adj = new LinkedList[this.nRandomPoint+2]; 
      for(int i = 0; i < this.nRandomPoint+2 ; i++){ 
          adj[i] = new LinkedList<Node>(); 
      } 
      PVector p1, p2;
      boolean can_reach_end = false;
      int flag;
      for (int i = 0; i < this.nRandomPoint+1; i++) {
        p1 = this.randomPoints.get(i);
        for (int j = i+1; j < this.nRandomPoint+2; j++) {
          p2 = this.randomPoints.get(j);
          flag = 1;
          for (int k = 0; k<obstacles.size();k++){
            if (!this.checkCollison(p2.y-p1.y, p1.x-p2.x, p2.x*p1.y-p2.y*p1.x, obstacles.get(k).x, obstacles.get(k).y, obsR+agentR)){
                flag = 0;break;
            }
          }
          if (flag == 1){
            adj[i].add(new Node(j, 0));
            adj[j].add(new Node(i, 0));
            if (j==this.nRandomPoint+1) can_reach_end = true;
          }
        }
      }    
      return can_reach_end;
    } //<>//
    
    void genRandomPoints(){
      int n = 0;
      float x, y;
      PVector tmp;
      while (n<this.nRandomPoint){
        x = -10+agentR + random.nextFloat() * (20-2*agentR);
        y = -10+agentR + random.nextFloat() * (20-2*agentR);
        tmp = new PVector(x, y, 0);
        int flag = 1;
        for (int i=0; i<obstacles.size();i++){
          if (PVector.dist(tmp, obstacles.get(i)) <= confR){
            flag = 0;
          }
        }
        if (flag==1){
            this.randomPoints.set(n, tmp);
            n++;
        }
      }
    }
    
    boolean checkCollison(float a, float b, float c, float x, float y, float radius){
      // Finding the distance of line from center. 
      double dist = (Math.abs(a * x + b * y + c)) /  
                      Math.sqrt(a * a + b * b); 
    
      // Checking if the distance is less than,  
      // greater than or equal to radius. 
      if (radius < dist) return true;
      else return false;
    }     
  
    // Function for Dijkstra's Algorithm 
    public boolean dijkstra() 
    { 
        int src = this.nRandomPoint;
        for (int i = 0; i < V; i++) 
            dist[i] = Float.MAX_VALUE; 
  
        // Add source node to the priority queue 
        pq.add(new Node(src, 0)); 
  
        // Distance to the source is 0 
        dist[src] = 0; 
        //while (settled.size() != V) { 
  
        //    // remove the minimum distance node  
        //    // from the priority queue  
        //    int u = pq.remove().node; 
   
        //    // adding the node whose distance is 
        //    // finalized 
        //    settled.add(u); 
  
        //    e_Neighbours(u); 
        //} 
        Node currentnode = new Node(src, 0);
        int u;
        while (settled.size() != V) { 
  
            // remove the minimum distance node  
            // from the priority queue  
            if (pq.isEmpty()) return false;
            currentnode = pq.remove(); 
            u = currentnode.node;
            if (settled.contains(u)) continue;
            if (u==this.nRandomPoint+1) break;
   
            // adding the node whose distance is 
            // finalized 
            settled.add(u); 
            e_Neighbours(u, currentnode); 
        } 
        
        while(currentnode != null){
          this.path.add(this.randomPoints.get(currentnode.node));
          currentnode = currentnode.prenode;          
        }
        Collections.reverse(this.path);
        return true;
       
    } 
  
    // Function to process all the neighbours  
    // of the passed node 
    private void e_Neighbours(int u, Node node) 
    { 
        float edgeDistance = -1; 
        float newDistance = -1; 
        Node tmp;
  
        // All the neighbors of v 
        for (int i = 0; i < adj[u].size(); i++) { 
            Node v = adj[u].get(i); 
  
            // If current node hasn't already been processed 
            if (!settled.contains(v.node)) { 
                edgeDistance = this.randomPoints.get(u).dist(this.randomPoints.get(v.node));//v.cost; 
                newDistance = dist[u] + edgeDistance; 
  
                // If new distance is cheaper in cost 
                if (newDistance < dist[v.node]) 
                    dist[v.node] = newDistance; 
  
                // Add the current node to the queue 
                tmp = new Node(v.node, dist[v.node]);
                tmp.prenode = node;
                pq.add(tmp); 
            } 
        } 
    } 
    
    public void draw_end(){
      //fill(this.col.x, this.col.y, this.col.z);
      fill(100, 100, 100);
      square(end.x, end.y, 2*agentR);
    }
    
    public void draw_agent(){
      fill(this.col.x, this.col.y, this.col.z);

      circle(agentPos.x,agentPos.y, 2*agentR);
    }
}

class Node implements Comparator<Node> { 
    public int node; 
    public float cost; 
    public Node prenode;
  
    public Node() 
    { 
    } 
  
    public Node(int node, float cost) 
    { 
        this.node = node; 
        this.cost = cost; 
        this.prenode = null;
    } 
  
    @Override
    public int compare(Node node1, Node node2) 
    { 
        if (node1.cost < node2.cost) 
            return -1; 
        if (node1.cost > node2.cost) 
            return 1; 
        return 0; 
    } 
} 


void drawEnv(){
  background(119, 136, 153);
  
  fill(255, 255, 255);
  square(-10, -10, 20);
  
  fill(119, 136, 153);
  //circle(obsPos.x,obsPos.y, 2*obsR);  
  for (int i=0;i<obstacles.size();i++) circle(obstacles.get(i).x,obstacles.get(i).y, 2*obsR); 
  
  for (int i=0; i<dpqs.size();i++) dpqs.get(i).draw_end();
  
  
  
  

}


PVector direction;
int flag;
Iterator<DPQ> i, j;
DPQ dpq;



float ttc(DPQ dpq1, DPQ dpq2){
  float r = 2 * agentR;
  PVector n = PVector.sub(dpq2.agentPos, dpq1.agentPos);
  float c = PVector.dot(n, n)-r*r;
  if (c<0) return 0;
  PVector v = PVector.sub(dpq1.v, dpq2.v);
  float a = PVector.dot(v, v);
  float b = PVector.dot(v, n);
  float dist = b*b - a*c;
  if (dist <= 0) return Float.POSITIVE_INFINITY;
  float t = (b - sqrt(dist))/a;
  if (t <0) return Float.POSITIVE_INFINITY;
  return t;
}



 //<>//

void avoidCollision(float dt, DPQ dpq1){
  DPQ dpq2;
  float t;
  float size;
  float dist;
  PVector n;
    j = dpqs.iterator();
    dpq1.f = PVector.mult(PVector.sub(dpq1.gv, dpq1.v),2);
    while(j.hasNext()){
      
      dpq2 = j.next();
      if (dpq1.equals(dpq2)) continue;
      t = ttc(dpq1, dpq2);
      if (t<Float.POSITIVE_INFINITY && t>=0){
        PVector fa = PVector.add(PVector.sub(dpq1.agentPos, dpq2.agentPos), 
        PVector.mult(PVector.sub(dpq1.v, dpq2.v), t));
        //fa.x = fa.x/t/t;
        //fa.y = fa.y/t/t;
        if (fa.x*fa.y!=0) fa.normalize();
        size = 0;
        if (t>=0 && t<20) size = (20-t)/(t+0.001);
        fa.mult(size);
        dpq1.f.add(fa);      
      }
    } 
     dpq1.v.add(PVector.mult(dpq1.f,dt));
     dpq1.agentPos.add(PVector.mult(dpq1.v,dt));
     for (int i = 0; i<obstacles.size();i++){
       dist = PVector.dist(dpq1.agentPos, obstacles.get(i));
       if (dist<agentR+obsR+0.01){
         n = PVector.sub(dpq1.agentPos, obstacles.get(i));
         n.normalize();
         dpq1.agentPos = PVector.add(PVector.mult(n,(obsR+agentR)*1.001), obstacles.get(i));
       }
     }
      // if (dpq1.agentPos.x<-9.5 || dpq1.agentPos.x > 9.5||dpq1.agentPos.y<-9.5 || dpq1.agentPos.y > 9.5)
      //System.out.println(dpq1.agentPos);
     dpq1.agentPos.x = max(dpq1.agentPos.x,-10+agentR);
     dpq1.agentPos.x = min(dpq1.agentPos.x, 10-agentR);
     dpq1.agentPos.y = max(dpq1.agentPos.y,-10+agentR);
     dpq1.agentPos.y = min(dpq1.agentPos.y, 10-agentR);
}

void update(float dt){
  i = dpqs.iterator();
  float dist, agent_dist;
  DPQ dpq;
  while(i.hasNext()){
    dpq = i.next();
    if (dpq.current_node_i >= dpq.path.size() - 1){
      i.remove();
      continue;
    }
    PVector d = PVector.sub(dpq.path.get(dpq.current_node_i+1), dpq.path.get(dpq.current_node_i));
    dist = d.mag();
    PVector ad = PVector.sub(dpq.agentPos, dpq.path.get(dpq.current_node_i));
    agent_dist = ad.mag();
    d.normalize();
    dpq.v = PVector.mult(d, dpq.v.mag());
    dpq.gv = PVector.mult(d, 10);
    avoidCollision(dt, dpq);
    dpq.agentPos = PVector.add(dpq.agentPos, PVector.mult(dpq.v, dt));
    if (dist<agent_dist) dpq.current_node_i++;
    if (dpq.current_node_i >= dpq.path.size() - 1) 
    i.remove(); //<>//
    
    
  }
}


void drawAgent(){
  for (int i=0; i<dpqs.size();i++) dpqs.get(i).draw_agent();
  
}

float nowt, beforet, dt;

void draw(){
  
  nowt = millis();
  dt = nowt - beforet;
  beforet = nowt;
  
  cam.Update(0.002);
  drawEnv();
  update(0.002);
  drawAgent();
  
  System.out.println("frame rate: "+frameRate); 
  
}

void keyPressed() {
  // If the return key is pressed, save the String and clear it
  DPQ dpq;
 if ( keyCode == UP ){
   n_agent ++;
   dpq = new DPQ();
   dpqs.add(dpq);
    while (true){
      dpq.genRandomPoints();
      if (dpq.buildGraph()) break;
    }
    dpq.dijkstra();    
 }
 if (keyCode == DOWN){
   dpqs.remove(dpqs.size()-1);
 }
 if (keyCode == RIGHT) obsR += 0.1;
 if (keyCode == LEFT) obsR -= 0.1;
 if (key == 'w'){
   for (int i=0; i<obstacles.size();i++) obstacles.get(i).y -= 0.1;
 }
 if (key == 's'){
   for (int i=0; i<obstacles.size();i++) obstacles.get(i).y += 0.1;
 }
 if (key == 'd'){
   for (int i=0; i<obstacles.size();i++) obstacles.get(i).x += 0.1;
 }
 if (key == 'a'){
   for (int i=0; i<obstacles.size();i++) obstacles.get(i).x -= 0.1;
 }
 //if (key == 'e'){
 //  n_obs ++;
 //  gen_obstacle(1);
 //}
 
}

void mousePressed() {
   if (mouseButton == LEFT) {
      PVector start = new PVector(((mouseX-200.0)/600-0.5)*20, ((mouseY-200.0)/600-0.5)*20, 0);
      
      if (start.x<-10+agentR || start.x>10-agentR || start.y<-10+agentR || start.y>10-agentR){
        System.out.println("The agent you want to add is out of boundary.");
        return;
      }
      if (check_agent_obs_collision(start)&&checkStartPCollision(start)){
       n_agent ++;
       dpq = new DPQ(start);
       dpqs.add(dpq);
        while (true){
          dpq.genRandomPoints();
          if (dpq.buildGraph()) break;
        }
        dpq.dijkstra(); 
      }else{
        System.out.println("The agent you want to add is too close to other agents or obstacles."+start);
      }
   }
  
}
