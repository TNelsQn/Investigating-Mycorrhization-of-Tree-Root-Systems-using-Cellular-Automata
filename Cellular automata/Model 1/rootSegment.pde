
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
  
  long roundToMultFour(long number, long Multiplier) {
    Long smallerMultiple = (number / Multiplier) * Multiplier;
    Long largerMultiple = smallerMultiple + Multiplier;
    
    return (number - smallerMultiple >= largerMultiple - number) ? largerMultiple : smallerMultiple;
  }
  
  // print the tree into the environment
  PVector printTree() { // Draws a line between the two points.
    
    PVector vect = new PVector((roundToMultFour(round(p1.x), 4)/4), (roundToMultFour(round(p2.y), 4)/4));
    
    return vect;
  }  
}
