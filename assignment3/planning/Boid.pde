class Boid{
  Node node;
  ArrayList<Node> nodes;
  PVector velocity, position;
  ArrayList<Boid> nei = new ArrayList<Boid>();
  ArrayList<Node> path;
  Boid(PVector position){
    //init position
    //add node to nodes
    //update node neighbor in nodes
    // use Astar to find a path to goal
  }
  
  void update(){
    //wrap
    //update_nei
    //rule1, rule2, rule3 -> update pos based on rules
    //update pos based on obstacle
    //update currentgoal
  }
  void update_nei(){
  }
  void rule1(){}
  void rule2(){}
  void rule3(){}
  
  void draw(){
  }
  
}
