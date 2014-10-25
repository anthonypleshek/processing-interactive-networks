class Node {
  PVector startLoc;
  PVector endLoc;
  
  public Node(PVector startLoc, PVector endLoc) {
    this.startLoc = startLoc;
    this.endLoc = endLoc;
  }
  
  public void setStartLoc(PVector startLoc) {
    this.startLoc = startLoc;
  }
  
  public void setEndLoc(PVector endLoc) {
    this.endLoc = endLoc;
  }
  
  public PVector getStartLoc() {
    return this.startLoc;
  }
  
  public PVector getEndLoc() {
    return this.endLoc;
  }
}
