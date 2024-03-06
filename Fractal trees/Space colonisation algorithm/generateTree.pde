import peasy.*;

PeasyCam cam;

T tree;

void setup() {
  size(600, 900, P3D); //create a 3D processing environment.
  cam = new PeasyCam(this, 800); //create the peazy cam
  tree = new T(new PVector(0,-200,0));
}

void draw() {
  background(51);
  //tree.printWindow();
  tree.printTree();
  tree.grow();
}
