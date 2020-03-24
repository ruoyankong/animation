int n_obs = 5;
ArrayList<PVector> obstacles;
float obstacleR = 50;
int n_boid = 10;
Boids boids;
int n_node = 20;
int d_node = 100;
Node end;


void setup () {
  size(500, 500);
  boids = new Boids();
  end = new Node(new PVector(width - 20,20));
  
  
}

void drawObstacle(){
}
