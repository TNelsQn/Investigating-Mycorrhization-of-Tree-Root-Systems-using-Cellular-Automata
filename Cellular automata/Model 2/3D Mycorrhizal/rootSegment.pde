
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
  
  ArrayList<PVector> calcLine(int blockSize) {
   
   // define the line
   ArrayList<PVector> lines = new ArrayList<PVector>();
  
  //Calculate the direction vector from start_point to end_point
  long dx = roundToMultFour(round(p1.x), blockSize) - roundToMultFour(round(p2.x), blockSize);
  long dy = roundToMultFour(round(p1.y), blockSize) - roundToMultFour(round(p2.y), blockSize);
  long dz = roundToMultFour(round(p1.z), blockSize) - roundToMultFour(round(p2.z), blockSize);
  
  //Calculate the step size for each dimension
  int step_x = (dx > 0) ? blockSize : -blockSize;
  int step_y = (dy > 0) ? blockSize : -blockSize;
  int step_z = (dz > 0) ? blockSize : -blockSize;
  
  //Iterate until the two points are connected
  long x = roundToMultFour(round(p2.x), blockSize);
  long y = roundToMultFour(round(p2.y), blockSize);
  long z = roundToMultFour(round(p2.z), blockSize);
  
  long x_end = roundToMultFour(round(p1.x), blockSize);
  long y_end = roundToMultFour(round(p1.y), blockSize);
  long z_end = roundToMultFour(round(p1.z), blockSize);
  
  
  // Add the first position.  This ensures that the array is not empty for very small lines.
  lines.add(new PVector(x,y,z));
  
  // Continue till the end point has been reached
  while (x != x_end && y != y_end && z != z_end) {
    if (abs(dx) >= abs(dy) && abs(dx) >= abs(dz)) {
      x += step_x;
      dx -= step_x;
    } else if (abs(dy) >= abs(dx) && abs(dy) >= abs(dz)) {
      y += step_y;
      dy -= step_y;
    } else {
      z += step_z;
      dz -= step_z;
    }
    // add the new block
    lines.add(new PVector(x,y,z));
  }
  
  // Add the final position.
  lines.add(new PVector(x_end, y_end, z_end));
  
  return lines; 
  }
  
  // print the tree into the environment
  ArrayList<PVector> printTree() { // Draws a line between the two points.
    
    ArrayList<PVector> lines =  calcLine(2);
    
    return lines;
  }  
}
