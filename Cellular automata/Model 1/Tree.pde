import java.util.ArrayList;
import java.util.Collections;
import processing.core.*;
import java.util.HashMap;


class Tree {
  
  ArrayList<PVector> window = new ArrayList<PVector>(); // stores the attraction points.
  ArrayList<rootSegment> nodes = new ArrayList<rootSegment>(); // stores the root nodes.
  HashMap<rootSegment, PVector> Sv; // S(v) hashmap stores the closest nodes.
  HashMap<rootSegment, Integer> Svcount;

  PVector p1;
  PVector p2;
  PVector PositionStart;
  
  // maximum area of infuence and kill disance
  int max = 250;
  int min = 5;
  
  // size of rootSegments
  float D = 3;
  
  
  Tree(PVector start) {
    p1 = start.copy();
    p2 = p1.copy();
    p2.y = p2.y-D;
    PositionStart = start.copy();
    PositionStart.y += 30;
    
    // Initialize the HashMap
    Sv = new HashMap<rootSegment, PVector>();
    Svcount = new HashMap<rootSegment, Integer>();
    
    //PVector p1 = new PVector(PositionSurface, PositionSurface);
    rootSegment r = new rootSegment(p1, p2);
    nodes.add(r); // add the starting root segemnt to the world
    
    // Iteratively add 200 attraction points to the window
    for (int i = 0 ; i < 200; i++) {
       PVector p = PVector.random2D(); // create random position between 0 and 1.
       p.mult(random(200)); // scale to size of the window
      
      // scale into an oval shape
      p.y += start.y + 200;
      p.y = p.y*1.2;
      p.x += start.x;
      
      // add the point
      window.add(p);
    }
  }

  void grow() {
  
    // for each point in the window find the closes rootSegment.
    for (int a = window.size()-1; a >= 0; a--) {
      
      rootSegment closestPoint = nodes.get(0);
      PVector dir = PVector.sub(window.get(a), nodes.get(0).getp2());
      
      for (int b = nodes.size()-1; b >= 0; b--) {
        // get the distance between the two nodes.
        PVector distance = PVector.sub(window.get(a), nodes.get(b).getp2());
        
        // if distance is less than the kill zone cull the attraction point.
        if (distance.mag() < min) {
          closestPoint = null;
          break;
        }
        
        // evaluate if root is closest to the point.
        if (distance.mag() < dir.mag()) {
          closestPoint = nodes.get(b);
          dir = PVector.sub(window.get(a), nodes.get(b).getp2());
        }
      }
      
      //Once the closest node has been found add it to Sv()
      dir.normalize();
      if (Sv.get(closestPoint) != null) {
        PVector curDir = Sv.get(closestPoint);
        curDir.add(dir);
        Sv.put(closestPoint, curDir);
        Svcount.put(closestPoint, Svcount.get(closestPoint)+1);
      } else {
        Sv.put(closestPoint, dir);
        Svcount.put(closestPoint, 1);
      }
    }
    
    for (int i = nodes.size()-1; i >= 0; i--) {
      
      if (Sv.get(nodes.get(i)) != null) {
        
        PVector st = nodes.get(i).getp2();
        PVector avg = PVector.div(Sv.get(nodes.get(i)), Svcount.get(nodes.get(i)));
        avg.add(PVector.random2D().setMag(0.3));
        avg.normalize();
        PVector ed = PVector.mult(avg, D);
        PVector nodePos = PVector.add(st, ed);
        rootSegment newRoot = new rootSegment(st, nodePos);
        nodes.add(newRoot);
      }
    }
    Sv.clear();
    Svcount.clear();
  }
  
  // Print display the points in the Processing window
  void printWindow() {
    for (int i = 0; i < window.size(); i++) {
    stroke(0);
    circle(window.get(i).x,window.get(i).y,2);
    }
    
  }
  
  int[][] printTree() {
    int[][] CA = new int[1500/4][900/4];
    
    for (int i = 0; i < nodes.size(); i++) {
      PVector vect = nodes.get(i).printTree();
      
      if (vect.x > 0 && vect.y > 0) {
        CA[int(vect.x)][int(vect.y)] = 5; //set cell to tree root segement.
      }    
    }
    
    for (int i = 0; i < 375; i++) {
      for (int j = 0; j < 225; j++) {
        if (CA[i][j] != 5) {
          CA[i][j] = 0;
        }
      }
    }
   return CA;
  }
}
