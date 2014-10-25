
static final int NODE_COUNT = 100;

PVector[] startLocs = new PVector[17];
PVector[] endLocs = new PVector[17];

ArrayList<Node> nodes = new ArrayList<Node>();
HashMap<Integer,Integer[]> edges = new HashMap<Integer,Integer[]>();

float forceFactorCounter = (float)random(0,10000);
float currentForceFactor;



import SimpleOpenNI.*;

SimpleOpenNI kinect = new SimpleOpenNI(this);

//import processing.video.*;
//
//Capture cam;
//PImage prevFrame;
//PImage diffFrame;
//float threshold = 50;

void setup() {
  size(640,480);
//  frameRate(1);
  initializeAmpNodes();
  
  kinect.start();
  
  kinect.enableDepth();
  kinect.enableDepth(width,height,30);
  
  // enable skeleton generation for all joints
//  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.enableUser();
 
//  cam = new Capture(this, width, height, 30);
//  prevFrame = createImage(cam.width,cam.height,RGB);
//  diffFrame = createImage(cam.width,cam.height,RGB);
//  cam.start();
}

void draw() {
  drawKinectDetectionSections();
}

void drawNoise() {
  background(0);
  currentForceFactor = noise(forceFactorCounter);
  forceFactorCounter += 0.05;
  for(int i=0; i<nodes.size(); i++) {
    drawEdges(i);
  }
  for(int i=0; i<nodes.size(); i++) {
    nodes.get(i).setCurrentLoc(getCurrentNodeLocNoise(i));
//    drawNode(i);
  }
}

void drawKinectDetection() {
  background(0);
  
  kinect.update();
  
  int[] pixelMap = kinect.depthMap();
  float sum = 0;
  int count = 0;
  for(int i=0; i<pixelMap.length; i++) {
    count++;
    sum += pixelMap[i];
  }
  
  currentForceFactor = 1-(sum/count)/2500;
  System.out.println(currentForceFactor);
  for(int i=0; i<nodes.size(); i++) {
    nodes.get(i).setCurrentLoc(getCurrentNodeLocNoise(i));
  }
  for(int i=0; i<nodes.size(); i++) {
    drawEdges(i);
  }
}

void drawKinectDetectionSections() {
  background(0);
  
  kinect.update();
  
  int[] pixelMap = kinect.depthMap();
  PImage depthImage = kinect.depthImage();
  
  int numSections = 10;
  int sectionWidth = (int)(width/numSections);
  int[][] sections = new int[numSections][];
  float[] averages = new float[numSections];
  
  for(int i=0; i<numSections; i++) {
    sections[i] = new int[sectionWidth*height];
  }
  
  for(int x=0; x<depthImage.width; x++) {
    for(int y=0; y<depthImage.height; y++) {
      int loc = x + y*depthImage.width;
      int sectionIndex = (int)(x/(sectionWidth));
      int sectionX = x%(sectionWidth-1);
      sections[sectionIndex][sectionX+y*sectionWidth] = pixelMap[loc];
    }
  }
  
  
  for(int i=0; i<numSections; i++) {
    int count = 0;
    int sum = 0;
    for(int j=0; j<sections[i].length; j++) {
      count++;
      sum += sections[i][j];
    }
    averages[i] = sum/count;
  }
  
  for(int i=0; i<nodes.size(); i++) {
    Node n = nodes.get(i);
    float yDiff = n.getEndLoc().y - n.getStartLoc().y;
    float xDiff = n.getEndLoc().x - n.getStartLoc().x;
    
    //Get the section this node is in
    int sectionIndex = (int)(n.getStartLoc().x/(sectionWidth-1));
    yDiff *= 1-(averages[sectionIndex]/2500);
    xDiff *= 1-(averages[sectionIndex]/2500);
    
    n.setCurrentLoc(new PVector(n.getStartLoc().x+xDiff,n.getStartLoc().y+yDiff));
  }
  
  for(int i=0; i<nodes.size(); i++) {
    drawEdges(i);
  }
}

//void drawKinectDetectionSections() {
//  background(0);
//  
//  kinect.update();
//  
//  PImage depthImage = kinect.depthImage();
//  
//  int numSections = 10;
//  int sectionWidth = (int)(width/numSections);
//  PImage[] sections = new PImage[numSections];
//  float[] averages = new float[numSections];
//  
//  for(int i=0; i<numSections; i++) {
//    sections[i] = new PImage(sectionWidth,height);
//    sections[i].copy(depthImage,i*sectionWidth,0,sectionWidth,height,0,0,sectionWidth,height);
//    sections[i].loadPixels();
//    float sum = 0;
//    int count = 0;
//    for(int j=0; j<sections[i].pixels.length; j++) {
//      count++;
//      sum += sections[i].pixels[j];
//    }
//    averages[i] = sum/count;
//    System.out.println(sum/count);
//  }
//  
//  for(int i=0; i<nodes.size(); i++) {
//    Node n = nodes.get(i);
//    float yDiff = n.getEndLoc().y - n.getStartLoc().y;
//    float xDiff = n.getEndLoc().x - n.getStartLoc().x;
//    
//    //Get the section this node is in
//    int sectionIndex = (int)(n.getStartLoc().x/(sectionWidth-1));
//    yDiff *= 1-(averages[sectionIndex]/2500);
//    xDiff *= 1-(averages[sectionIndex]/2500);
//    
//    n.setCurrentLoc(new PVector(n.getStartLoc().x+xDiff,n.getStartLoc().y+yDiff));
//  }
//  
//  for(int i=0; i<nodes.size(); i++) {
//    drawEdges(i);
//  }
//  
//}

//void drawCamDiff() {
//  background(0);
//  if (cam.available() == true) {
//    prevFrame.copy(cam,0,0,cam.width,cam.height,0,0,cam.width,cam.height);
//    prevFrame.updatePixels();
//    cam.read();
//  }
//  cam.loadPixels();
//  prevFrame.loadPixels();
//  diffFrame.loadPixels();
//  
//  int[] diffCounts = new int[]{0,0,0,0,0,0,0,0,0,0};
//  // Begin loop to walk through every pixel
//  for (int x = 0; x < cam.width; x ++ ) {
//    for (int y = 0; y < cam.height; y ++ ) {
//      
//      int loc = x + y*cam.width;
//      color current = cam.pixels[loc];
//      color previous = prevFrame.pixels[loc];
//      
//      float r1 = red(current); float g1 = green(current); float b1 = blue(current);
//      float r2 = red(previous); float g2 = green(previous); float b2 = blue(previous);
//      float diff = dist(r1,g1,b1,r2,g2,b2);
//      
//      // If the color at that pixel has changed, then there is motion at that pixel.
//      if (diff > threshold) {
//        //Figure out which section to add to the diffCount
////        diffCounts[((int)(width/(x+1)))%diffCounts.length] += 1;
//        diffCounts[(int)(x/((width)/diffCounts.length))] += 1;
//        diffFrame.pixels[loc] = color(255);
//      } else {
//        diffFrame.pixels[loc] = color(0);
//      }
//    }
//  }
//  diffFrame.updatePixels();
////  for(int i : diffCounts) {
////    System.out.print(i + ",");
////  }
////  System.out.println();
////  image(diffFrame,0,0,width,height);
//  for(int i=0; i<nodes.size(); i++) {
//    PVector newLoc = new PVector();
//    Node n = nodes.get(i);
//    newLoc.x = n.getStartLoc().x;
//    newLoc.y = n.getStartLoc().y;
//    
//    //Find point on line currentForceFactor between node's start and end locs
//    float yDiff = n.getEndLoc().y - n.getStartLoc().y;
//    float xDiff = n.getEndLoc().x - n.getStartLoc().x;
//    
//    yDiff *= min(1,diffCounts[((int)(width/(newLoc.y+1)))%diffCounts.length]*2/(prevFrame.pixels.length/diffCounts.length));
//    xDiff *= min(1,diffCounts[((int)(width/(newLoc.y+1)))%diffCounts.length]*2/(prevFrame.pixels.length/diffCounts.length));
//    
//    newLoc.x += xDiff;
//    newLoc.y += yDiff;
//  
//    nodes.get(i).setCurrentLoc(newLoc);
//  }
//  for(int i=0; i<nodes.size(); i++) {
//    drawEdges(i);
//  }
//}

void drawNode(int nodeIndex) {
  Node n = nodes.get(nodeIndex);
  pushStyle();
  fill(color(255));
  ellipse(n.getCurrentLoc().x,n.getCurrentLoc().y,4,4);
  popStyle();
}

void drawEdges(int nodeIndex) {
  Node n = nodes.get(nodeIndex);
  for(Integer i : edges.get(nodeIndex)) {
    pushStyle();
    stroke(color(255));
    strokeWeight(1);
    line(n.getCurrentLoc().x,n.getCurrentLoc().y,nodes.get(i).getCurrentLoc().x,nodes.get(i).getCurrentLoc().y);
    popStyle();
  }
}

PVector getCurrentNodeLocNoise(int nodeIndex) {
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
