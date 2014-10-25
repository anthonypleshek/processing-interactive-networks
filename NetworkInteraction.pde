
static final int NODE_COUNT = 100;
ArrayList<Node> nodes = new ArrayList<Node>();
HashMap<Integer,Integer[]> edges = new HashMap<Integer,Integer[]>();

void setup() {
  size(400,400);
  
  background(0);
  initializeNodes();
}

void draw() {
  for(int i=0; i<nodes.size(); i++) {
    drawEdges(i);
  }
  for(int i=0; i<nodes.size(); i++) {
    drawNode(i);
  }
}

void initializeNodes() {
  for(int i=0; i<100; i++) {
    nodes.add(new Node(new PVector(random(0,width),random(0,height)),new PVector(random(0,width),random(0,height))));
    Integer[] tmpEdges = new Integer[3];
    for(int j=0; j<3; j++) {
      tmpEdges[j] = (int)random(0,99);
    }
    edges.put(i,tmpEdges);
  }
}

void drawNode(int nodeIndex) {
  Node n = nodes.get(nodeIndex);
  pushStyle();
  fill(color(0,255,0));
  ellipse(n.getStartLoc().x,n.getStartLoc().y,4,4);
  popStyle();
}

void drawEdges(int nodeIndex) {
  Node n = nodes.get(nodeIndex);
  for(Integer i : edges.get(nodeIndex)) {
    pushStyle();
    stroke(color(0,0,255));
    strokeWeight(1);
    line(n.getStartLoc().x,n.getStartLoc().y,nodes.get(i).getStartLoc().x,nodes.get(i).getStartLoc().y);
    popStyle();
  }
}

void getCurrentNodeLoc(int nodeIndex) {
  
}

