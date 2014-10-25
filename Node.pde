class Node {
  PVector startLoc;
  PVector endLoc;
  PVector currentLoc;
  
  public Node(PVector startLoc, PVector endLoc) {
    this.startLoc = startLoc;
    this.currentLoc = startLoc;
    this.endLoc = endLoc;
  }
  
  public void setStartLoc(PVector startLoc) {
    this.startLoc = startLoc;
  }
  
  public void setEndLoc(PVector endLoc) {
    this.endLoc = endLoc;
  }
  
  public void setCurrentLoc(PVector currentLoc) {
    this.currentLoc = currentLoc;
  }
  
  public PVector getStartLoc() {
    return this.startLoc;
  }
  
  public PVector getEndLoc() {
    return this.endLoc;
  }
  
  public PVector getCurrentLoc() {
    return this.currentLoc;
  }
}
