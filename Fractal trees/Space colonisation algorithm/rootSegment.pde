
/*
  rootSegments are effectively a double of two position vectors
  encoding the staring and ending point of a line.
*/
class rootSegment {

  // The start and end position for each segment
  PVector p1;
  PVector p2;
  
  rootSegment(PVector pos1, PVector pos2) {
    p1 = pos1;
    p2 = pos2;
  }
  
  PVector getp1() {
    return p1;
  }
  
  PVector getp2() {
    return p2;
  }
  
  // print the tree into the environment
  void printTree() { // Draws a line between the two points.
    stroke(255);
    strokeWeight(4);
    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
  }  
}
