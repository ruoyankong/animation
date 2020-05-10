// refer to Wiki A_star algorithm
class A_star {
  ArrayList<Node> graph;
  ArrayList<Node> openlist;
  ArrayList<Node> closelist;
  HashMap<Node, Integer> gs;
  HashMap<Node, Integer> fs;
  ArrayList<Node> pres;
  A_star(ArrayList<Node> no) {
    graph = no;
    for(int i=0;i<graph.size();++i){
      graph.get(i).former=null;
    }
  }

  int dis_calc(Node a, Node b) {
    float d1 = a.location.x - b.location.x;
    float d2 = a.location.y - b.location.y;
    return (int)sqrt(d1*d1 + d2*d2);
  }
  ArrayList<Node> record_path(ArrayList<Node>  pres, Node cur) {  
    ArrayList<Node> path = new ArrayList<Node>();  
    while (cur.former != null) {  
      if (pres.indexOf(cur) != -1) {  
        cur = pres.get(pres.indexOf(cur)).former;  
        path.add(cur);  
      }  
      else  
        return null;  
    }  
    return path;  
  }

  ArrayList<Node> astar(Node start, Node goal) {
    closelist = new ArrayList<Node> ();
    openlist = new ArrayList<Node> ();
    pres= new ArrayList<Node> ();
    openlist.add(start);   
    gs = new HashMap<Node, Integer>();
    fs = new HashMap<Node, Integer>();
    for (int i = 0; i< graph.size(); i++) {
      Node v = graph.get(i);
      gs.put(v, Integer.MAX_VALUE);
      fs.put(v, Integer.MAX_VALUE);
    }
    gs.put(start, 0);
    fs.put(start, dis_calc(start, goal));
    while (!openlist.isEmpty()) {
       int min_f = fs.get(openlist.get(0));
       int min_ind = 0;
        for (int i = 1; i<openlist.size(); i++) {
          if (fs.get(openlist.get(i)) < min_f) {
            min_f = fs.get(openlist.get(i));
            min_ind = i;
          }
        }
if (graph.indexOf(openlist.get(min_ind))==graph.indexOf(goal)) { 
        return record_path(pres, goal);
      }     
      Node c= openlist.get(min_ind);
      closelist.add(c);
      openlist.remove(min_ind);
      for (int i = 0; i< c.nei.size(); i++) {
        Node near = c.nei.get(i);
        if (!(closelist.contains(near))) {
          openlist.add(near);
          if (!(openlist.contains(near))) {
              openlist.add(near);
          }
          if (gs.get(c) + dis_calc(c, near) < gs.get(near)) {
            near.former = c;
            pres.add(near);
            gs.put(near, gs.get(c) + dis_calc(c, near));
            fs.put(near, gs.get(near) + dis_calc(near, goal));

          }
        }
      }
    }
    return null;
  }
}
