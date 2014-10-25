
static final int NODE_COUNT = 100;

PVector[] startLocs = new PVector[17];
PVector[] endLocs = new PVector[17];

ArrayList<Node> nodes = new ArrayList<Node>();
HashMap<Integer,Integer[]> edges = new HashMap<Integer,Integer[]>();

float forceFactorCounter = (float)random(0,10000);
float currentForceFactor;

void setup() {
  size(400,400);
  
  background(0);
  initializeAmpNodes();
}

void draw() {
  background(0);
  currentForceFactor = noise(forceFactorCounter);
  forceFactorCounter += 0.05;
  for(int i=0; i<nodes.size(); i++) {
    drawEdges(i);
  }
  for(int i=0; i<nodes.size(); i++) {
    drawNode(i);
  }
}

void initializeAmpNodes() {
  startLocs[0] = new PVector(width*.1,height*.9);
  startLocs[1] = new PVector(width*.1,height*.9);
  startLocs[2] = new PVector(width*.1,height*.5);
  startLocs[3] = new PVector(width*.3,height*.5);
  startLocs[4] = new PVector(width*.3,height*.9);
  startLocs[5] = new PVector(width*.3,height*.95);
  
  endLocs[0] = new PVector(width*.1,height*.9);
  endLocs[1] = new PVector(width*.15,height*.6);
  endLocs[2] = new PVector(width*.15,height*.6);
  endLocs[3] = new PVector(width*.2,height*.3);
  endLocs[4] = new PVector(width*.25,height*.6);
  endLocs[5] = new PVector(width*.3,height*.9);
  
  startLocs[6] = new PVector(width*.35,height*.9);
  startLocs[7] = new PVector(width*.35,height*.5);
  startLocs[8] = new PVector(width*.5,height*.5);
  startLocs[9] = new PVector(width*.5,height*.9);
  startLocs[10] = new PVector(width*.65,height*.5);
  startLocs[11] = new PVector(width*.65,height*.9);
  
  endLocs[6] = new PVector(width*.35,height*.9);
  endLocs[7] = new PVector(width*.425,height*.3);
  endLocs[8] = new PVector(width*.5,height*.6);
  endLocs[9] = new PVector(width*.5,height*.6);
  endLocs[10] = new PVector(width*.575,height*.3);
  endLocs[11] = new PVector(width*.65,height*.9);
  
  startLocs[12] = new PVector(width*.7,height*.95);
  startLocs[13] = new PVector(width*.7,height*.9);
  startLocs[14] = new PVector(width*.7,height*.5);
  startLocs[15] = new PVector(width*.9,height*.5);
  startLocs[16] = new PVector(width*.9,height*.9);
  
  endLocs[12] = new PVector(width*.7,height*.9);
  endLocs[13] = new PVector(width*.7,height*.65);
  endLocs[14] = new PVector(width*.7,height*.3);
  endLocs[15] = new PVector(width*.9,height*.3);
  endLocs[16] = new PVector(width*.9,height*.65);
  
  for(int i=0; i<17; i++) {
    nodes.add(new Node(startLocs[i],endLocs[i]));
  }
  
  edges.put(0,new Integer[]{1});
  edges.put(1,new Integer[]{0,2,4});
  edges.put(2,new Integer[]{1,3});
  edges.put(3,new Integer[]{2,4});
  edges.put(4,new Integer[]{1,3,5});
  edges.put(5,new Integer[]{4});
  
  edges.put(6,new Integer[]{7});
  edges.put(7,new Integer[]{6,8});
  edges.put(8,new Integer[]{7,9,10});
  edges.put(9,new Integer[]{8});
  edges.put(10,new Integer[]{8,11});
  edges.put(11,new Integer[]{10});
  
  edges.put(12,new Integer[]{13});
  edges.put(13,new Integer[]{12,14,16});
  edges.put(14,new Integer[]{13,15});
  edges.put(15,new Integer[]{14,16});
  edges.put(16,new Integer[]{13,15});
}

void initializeRandomNodes() {
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
  n.setCurrentLoc(getCurrentNodeLoc(nodeIndex));
  ellipse(n.getCurrentLoc().x,n.getCurrentLoc().y,4,4);
  popStyle();
}

void drawEdges(int nodeIndex) {
  Node n = nodes.get(nodeIndex);
  for(Integer i : edges.get(nodeIndex)) {
    pushStyle();
    stroke(color(0,0,255));
    strokeWeight(1);
//    line(n.getStartLoc().x,n.getStartLoc().y,nodes.get(i).getStartLoc().x,nodes.get(i).getStartLoc().y);
    line(n.getCurrentLoc().x,n.getCurrentLoc().y,nodes.get(i).getCurrentLoc().x,nodes.get(i).getCurrentLoc().y);
    popStyle();
  }
}

PVector getCurrentNodeLoc(int nodeIndex) {
  PVector retLoc = new PVector();
  
  Node n = nodes.get(nodeIndex);
  //Find point on line currentForceFactor between node's start and end locs
  float yDiff = n.getEndLoc().y - n.getStartLoc().y;
  float xDiff = n.getEndLoc().x - n.getStartLoc().x;
  xDiff *= currentForceFactor;
  yDiff *= currentForceFactor;
  
  retLoc.x = n.getStartLoc().x + xDiff;
  retLoc.y = n.getStartLoc().y + yDiff;
  
  return retLoc;
}

