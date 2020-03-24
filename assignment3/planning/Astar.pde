import java.util.Map;
class Node{
 PVector position;
 Node former = null;
 ArrayList<Node> nei = new ArrayList<Node>();
 Node(PVector pos){
   position = pos;
 }  
  void neighbors(Node cur){
    int add=1;
    for (Node n: nei) {
      if (n == cur) {
        add=0;
      }
    }
    if(add==1) nei.add(cur);
  }  
}

class Astar{
ArrayList<Node> graph;
ArrayList<Node> open;
ArrayList<Node> close;
HashMap<Node,Integer> gs;
HashMap<Node,Integer> fs;
Astar(ArrayList<Node> node){
  graph = node;
}

int calc_distance(Node start, Node end){
  float a = start.position.x - end.position.x;
  float b = start.position.y - end.position.y;
  return (int)sqrt(a*a + b*b);
}

ArrayList<Node> path(ArrayList<Node>pres, Node cur) {
  ArrayList<Node> p = new ArrayList<Node>();
  while (cur.former != null) {
    int index = pres.indexOf(cur);
    if (index != -1) { 
      p.add(pres.get(index));
      cur = pres.get(index).former;
    }
    else
      return null;
  }
  return p;
}

ArrayList<Node> astar(Node start, Node end){
  close = new ArrayList<Node> ();
  open = new ArrayList<Node> ();
  ArrayList<Node>  pres = new ArrayList<Node> ();
  gs = new HashMap<Node,Integer>();
  fs = new HashMap<Node,Integer>();
  open.add(start);
  for(int i = 0; i< graph.size(); i++){
    Node n = graph.get(i);
    gs.put(n, Integer.MAX_VALUE);
  } 
  gs.put(start, 0);
  for(int i = 0; i< graph.size(); i++){
    Node n = graph.get(i);
    fs.put(n, Integer.MAX_VALUE); 
  } 
  fs.put(start, calc_distance(start,end));
  while (!open.isEmpty()){    
    int min_f = fs.get(open.get(0));
    int min_index = 0;
    for(int i = 1; i<open.size(); i++){
      int f = fs.get(open.get(i));
      if(f < min_f){
        min_f = f;
        min_index = i;
      }  
    }
    Node cur = open.get(min_index);
    if(cur==end){
      return path(pres, end);
    }   
    open.remove(min_index);
    close.add(cur);   
    ArrayList<Node> neighbors= cur.nei;
    for(int i = 0; i< neighbors.size(); i++){
      Node neighbor = neighbors.get(i);
      if(close.contains(neighbor)){       
        continue;
      }
      if(!(open.contains(neighbor))){
        open.add(neighbor);
      }
      else if (gs.get(cur) + calc_distance(cur,neighbor) >= gs.get(neighbor)){
        continue;   
      }
      pres.add(neighbor);
      neighbor.former = cur;    
      gs.put(neighbor, gs.get(cur) + calc_distance(cur,neighbor));
      fs.put(neighbor, gs.get(neighbor) +calc_distance(neighbor, end));
    }  
  }
  return null;
}
}
