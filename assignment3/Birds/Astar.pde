import java.util.Map;
class Node{
 PVector position;
 Node former = null;
 ArrayList<Node> nei = new ArrayList<Node>();
 Node(PVector pos){
   position = pos;
 }  
  void addNeighbor(Node e){
    for (Node temp: nei) {
      if (temp == e) {
        return;
      }
    }
    nei.add(e);
  }  
}

class Astar{
ArrayList<Node> graph;
ArrayList<Node> open;
ArrayList<Node> close;
HashMap<Node,Integer> gscore;
HashMap<Node,Integer> fscore;
Astar(ArrayList<Node> node){
  graph = node;
}

float heuristic_cost(Node start, Node end){
  float a = start.position.x - end.position.x;
  float b = start.position.y - end.position.y;
  return sqrt(a*a + b*b);
}

ArrayList<Node> constructPath(ArrayList<Node>  from, Node cur) {
  ArrayList<Node> path = new ArrayList<Node>();
  while (cur.former != null) {
    if (from.indexOf(cur) != -1) {
      cur = from.get(from.indexOf(cur)).former;
      path.add(cur);
    }
    else
      return null;
  }
  return path;
}

ArrayList<Node> astar(Node start, Node end){
  close = new ArrayList<Node> ();
  open = new ArrayList<Node> ();
  open.add(start);
  ArrayList<Node>  pres = new ArrayList<Node> ();
  gscore = new HashMap<Node,Integer>();
  fscore = new HashMap<Node,Integer>();
  for(int i = 0; i< graph.size(); i++){
    Node v = graph.get(i);
    gscore.put(v, Integer.MAX_VALUE);
  }
  gscore.put(start, 0);
  
  for(int i = 0; i< graph.size(); i++){
    Node v = graph.get(i);
    fscore.put(v, Integer.MAX_VALUE);  
  }
  fscore.put(start, (int)heuristic_cost(start,end));
  while (open.size()>0){    
    int minfs = fscore.get(open.get(0));
    int minIndex = 0;
    for(int i = 0; i<open.size(); i++){
      Node temp = open.get(i);
      int fs = fscore.get(temp);
      if(fs < minfs){
        minfs = fs;
        minIndex = i;
      }  
    }
    Node current = open.get(minIndex);
    if(graph.indexOf(current)==graph.indexOf(end)){
      return constructPath(pres, end);
    }   
    open.remove(minIndex);
    close.add(current);    
    for(int i = 0; i< current.nei.size(); i++){
      Node neighbor = current.nei.get(i);
      if(close.contains(neighbor)){       
        continue;
      }
      float a = current.position.x - neighbor.position.x;
      float b = current.position.y - neighbor.position.y;
      float distance = sqrt(a*a + b*b);
      int tenetive_g = gscore.get(current) + (int)distance;
      if(!(open.contains(neighbor))){
        open.add(neighbor);
      }else if (tenetive_g >= gscore.get(neighbor)){
        continue;   
      }
       neighbor.former = current;
       pres.add(neighbor);
      gscore.put(neighbor, tenetive_g);
      int estimatedFScore = gscore.get(neighbor) +(int) heuristic_cost(neighbor, end);
      fscore.put(neighbor, estimatedFScore);
    }  
  }
  return null;
}









}
