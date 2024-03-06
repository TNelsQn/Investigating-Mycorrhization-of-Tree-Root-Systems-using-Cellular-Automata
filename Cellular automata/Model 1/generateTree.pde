import peasy.*; // import peazy cam

PeasyCam cam;

Tree root;
Tree root2;

int dim = 4;
int fade = 2;
int ASW = 1500/dim; 
int ASH = 900/dim;
int [][] CA;
int [][] SavedCA;
int box = 10/dim;
int flag = 0;
int reachedL = 0;
int reachedR = 0;
int c = 200;

void setup() {
  size(1550, 950, P2D); //create a 2D processing environment.
  root = new Tree(new PVector(400,0));
  root2 = new Tree(new PVector(1100, 0));
  reset();
}

int[][] arrCopy(int[][] arr) {
  int[][] temp = new int[ASW][ASH];
  
    for (int i = 0; i < ASW; i++) {
      for (int j = 0; j < ASH; j++) {
          temp[i][j] = arr[i][j];
       }  
    }
  return temp;
}

int[][] arrCombine(int[][] arr1, int[][] arr2) {
  int[][] temp = new int[ASW][ASH];
    for (int i = 0; i < ASW; i++) {
      for (int j = 0; j < ASH; j++) {
          if (arr1[i][j] == 5 || arr2[i][j] == 5) {
            temp[i][j] = 5;
          } else if (arr1[i][j] == 1 || arr2[i][j] == 1) {
            temp[i][j] = 1;
          } else if (arr1[i][j] == -1 || arr2[i][j] == -1) {
            temp[i][j] = -1;
          } else if (arr1[i][j] == 10 || arr2[i][j] == 10) {
            temp[i][j] = 10;
          } else if (arr1[i][j] == 30 || arr2[i][j] == 30) {
            temp[i][j] = 30;
          } else if (arr1[i][j] == 31 || arr2[i][j] == 31) {
            temp[i][j] = 31;
          }
          
          for (int p = 50; p < 201; p++) {
            if (arr1[i][j] == p || arr2[i][j] == p) {
               temp[i][j] = p;
            }
          }
          
       }  
    }
    return temp;
}

void showSimulationBox() {
  translate(-1450, -850);
  scale(1500, 900);
  stroke(0);
  strokeWeight(0.9/1500);
  noFill();
  rect(1,1,1,1);
}

void addWaterandNutrients() { //method to add the water table and points in carbon and phosphouros.

  //ADD WATER
  for (int i = 0; i < ASW; i++) {
    for (int j = ASH-10; j < ASH; j++) {
      if (j == ASH-1) { //base of the water table always contains water.
        CA[i][j] = 10;
      } else if ((j < ASH-1 || j > ASH-5) && random(100) < 25) { // low levels of the water table have some water dotted around.
        CA[i][j] = 10;
      } else if ((j < ASH-5 || j > ASH-7) && random(100) < 15) { // this layer has much less water table has minimal water.
        CA[i][j] = 10;
      } else if ((j < ASH-7 || j > ASH-10) && random(100) < 5) { // top layer of the water table has almost no water.
        CA[i][j] = 10;
      }
    }
  }
  
  //ADD NUTRIENCE
  for (int i = 0; i < ASW-2; i += 2) {
    for (int j = 0; j < ASH-2; j += 2) {
      if (CA[i][j] != 5 && CA[i+1][j] != 5 && CA[i][j+1] != 5 && CA[i+1][j+1] != 5) {
        if (CA[i][j] != 10 && CA[i+1][j] != 10 && CA[i][j+1] != 10 && CA[i+1][j+1] != 10 && random(50) < 2) {
          CA[i][j] = 30; CA[i+1][j] = 30; CA[i][j+1] = 30; CA[i+1][j+1] = 30;
        }
      }
    }
  }
  
}

void showBox(int a, int b, color filler) {
  stroke(255);
  fill(filler);
  square(a*dim+50,b*dim+50,4);
}

void printCells() {
  for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      if (CA[i][j] == 5) {
        showBox(i,j, color(100));
      } else if (CA[i][j] == 1 || CA[i][j] > 49) {
        showBox(i,j, color(255, 204, 0));
        //showBox(i,j, color(100));
      } else if (CA[i][j] == 10) {
        showBox(i,j, color(55, 42, 209));
      } else if (CA[i][j] == 30) {
        showBox(i,j, color(139, 147, 37));
      } else if (CA[i][j] == 31) {
        showBox(i,j, color(160, 131, 24));
        //showBox(i,j, color(255, 204, 0));
      }
    }
  }
}

int getCount(int a, int b) {
  int count = 0;
  
  //BASE LAYER
  if (CA[(a-1+ASW)%ASW][b] == 1) {count++;} //left
  if (CA[(a-1+ASW)%ASW][(b+1)%ASH] == 1 && (b+1)%ASH - b == 1) {count++;} // left top
  if (CA[(a-1+ASW)%ASW][(b-1+ASH)%ASH] == 1) {count++;} // left bottom
  if (CA[a][(b+1)%ASH] == 1 && (b+1)%ASH - b == 1) {count++;} // top
  if (CA[a][(b-1+ASH)%ASH] == 1) {count++;} // bottom
  if (CA[(a+1)%ASW][b] == 1) {count++;} // right
  if (CA[(a+1)%ASW][(b+1)%ASH] == 1 && (b+1)%ASH - b == 1) {count++;} // right top
  if (CA[(a+1)%ASW][(b-1+ASH)%ASH] == 1) {count++;} // right bottom
  
  return count;
}

int getTreeCount(int a, int b) { // returns if the cell is next to a tree.
  int count = 0;
  
  //BASE LAYER
  if (CA[(a-1+ASW)%ASW][b] == 5) {count++;} //left
  if (CA[(a-1+ASW)%ASW][(b+1)%ASH] == 5) {count++;} // left top
  if (CA[(a-1+ASW)%ASW][(b-1+ASH)%ASH] == 5) {count++;} // left bottom
  if (CA[a][(b+1)%ASH] == 5) {count++;} // top
  if (CA[a][(b-1+ASH)%ASH] == 5) {count++;} // bottom
  if (CA[(a+1)%ASW][b] == 5) {count++;} // right
  if (CA[(a+1)%ASW][(b+1)%ASH] == 5) {count++;} // right top
  if (CA[(a+1)%ASW][(b-1+ASH)%ASH] == 5) {count++;} // right bottom
  
  return count;
}

int getWaterCount(int a, int b, int val) { // returns if the cell is next to a Water.
  int count = getTreeCount(a,b);
  
  if (count > 0) { //return highest level if next to a tree.
    return 200;
  }
  
  int currentMax = 20;
  if (CA[(a-1+ASW)%ASW][b] == val) {currentMax = CA[(a-1+ASW)%ASW][b];} //left
  if (CA[(a-1+ASW)%ASW][(b+1)%ASH] == val) {currentMax = CA[(a-1+ASW)%ASW][(b+1)%ASH];} // left top
  if (CA[(a-1+ASW)%ASW][(b-1+ASH)%ASH] == val) {currentMax = CA[(a-1+ASW)%ASW][(b-1+ASH)%ASH];} // left bottom
  if (CA[a][(b+1)%ASH] == val) {currentMax = CA[a][(b+1)%ASH];} // top
  if (CA[a][(b-1+ASH)%ASH] == val) {currentMax = CA[a][(b-1+ASH)%ASH];} // bottom
  if (CA[(a+1)%ASW][b] == val) {currentMax = CA[(a+1)%ASW][b];} // right
  if (CA[(a+1)%ASW][(b+1)%ASH] == val) {currentMax = CA[(a+1)%ASW][(b+1)%ASH];} // right top
  if (CA[(a+1)%ASW][(b-1+ASH)%ASH] == val) {currentMax = CA[(a+1)%ASW][(b-1+ASH)%ASH];} // right bottom
  
  if (currentMax == 20) {
    return 1;
  }
  
  return currentMax;
}

PVector finMaximal(int a, int b) { // returns if the cell is next to a Water.
  PVector ret = PVector.random2D();
  
  //BASE LAYER
  ret.x = (a-1+ASW)%ASW;
  ret.y = b;
  
  if (CA[(a-1+ASW)%ASW][(b+1)%ASH] > CA[int(ret.x)][int(ret.y)]) {  ret.x = (a-1+ASW)%ASW; ret.y = (b+1)%ASH;} // left top
  if (CA[(a-1+ASW)%ASW][(b-1+ASH)%ASH] > CA[int(ret.x)][int(ret.y)]) {ret.x = (a-1+ASW)%ASW; ret.y = (b-1+ASH)%ASH;} // left bottom
  if (CA[a][(b+1)%ASH] > CA[int(ret.x)][int(ret.y)]) {ret.x = a; ret.y = (b+1)%ASH;} // top
  if (CA[a][(b-1+ASH)%ASH] > CA[int(ret.x)][int(ret.y)]) {ret.x = a; ret.y = (b-1+ASH)%ASH;} // bottom
  if (CA[(a+1)%ASW][b] > CA[int(ret.x)][int(ret.y)]) {ret.x = (a+1)%ASW; ret.y = b;} // right
  if (CA[(a+1)%ASW][(b+1)%ASH] >= CA[int(ret.x)][int(ret.y)]) {ret.x = (a+1)%ASW; ret.y = (b+1)%ASH;} // right top
  if (CA[(a+1)%ASW][(b-1+ASH)%ASH] > CA[int(ret.x)][int(ret.y)]) {ret.x = (a+1)%ASW; ret.y = (b-1+ASH)%ASH;} // right bottom
  
  return ret;
}

void update() { //updates the world each tick
   int [][] temp = arrCopy(CA);
   for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      
        int count = getCount(i,j);
        int treeCount = getTreeCount(i,j);
        if (treeCount > 0 && count > 0) {
          if (i < ASW/2) {
            reachedL = 1;
          } else {
            reachedR = 1;
          }
        }
        
        if (CA[i][j] == 0 || CA[i][j] > 99) { // do nothing if cell is a tree root or a fungal cell or starved.
          if (count == 1 && random(100) < 50 || count == 2 && random(100) < 25 || count == 3 && random(100) < 12.5) {
            temp[i][j] = 1; // set cell to alive.
          }  else if (count > 0 && (random(100) < 50 && count == 1 || random(100) < 75 && count <= 2 || count >= 3)) {
             temp[i][j] = -1; //cell becomes starved.
          }
       }
    }
  }
  CA = arrCopy(temp);
}

void spread() { //updates the world each tick
   int [][] temp = arrCopy(CA);
   for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
        int count = getTreeCount(i,j);
        int fungicount = getCount(i,j);
        
        if (CA[i][j] == 0) { // do nothing if cell is a tree root or a fungal cell or starved.
          if (count > 0 && fungicount > 0) {
            temp[i][j] = 1; // set cell to alive.
          }
       }
    }
  }
  CA = arrCopy(temp);
}

void pathFinder() {

  for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      int count = getWaterCount(i,j,c);
      if (CA[i][j] == 1 && count > 50) {
        CA[i][j] = count - 1;
      }
    }

  }
  c = c - 1; //decrease c 
}

void trimCol() {
  for (int j = 0; j < ASH; j++){
    CA[0][j]= 0;
    CA[ASW-1][j] = 0;
  }
}

void Propagate() {
  for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      PVector Max = finMaximal(i,j);
      if (CA[i][j] ==  10 && CA[int(Max.x)][int(Max.y)] > 49 && int(Max.y) > 5 && CA[int(Max.x)][int(Max.y)] > SavedCA[i][j]) { //water mollecule

      
        CA[i][j] = SavedCA[i][j]; // CHANGE TO SAVEDCA
        CA[int(Max.x)][int(Max.y)] = 31;
      }
      
      if (CA[i][j] == 30 || CA[i][j] == 31 && CA[int(Max.x)][int(Max.y)] > 49 && int(Max.y) > 5 && CA[int(Max.x)][int(Max.y)] > SavedCA[i][j]) {
        
        CA[i][j] = SavedCA[i][j]; // CHANGE TO SAVEDCA  
        CA[int(Max.x)][int(Max.y)] = 31; //colour change
      }
    }
  }
  
}

/*
  Segments the root system into black cells to reprisent the root/fungi system and white cells to indicate the background.
  This can then be analysed to get a list of parameters for analysis.
*/
int[][] SegmentRootSystem() {
  int temp[][] = arrCopy(CA);
  for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      if (CA[i][j] != 1) {
        temp[i][j] = 0;
      }
    }
  }
  return temp;
}

void draw() {
  background(255);
  lights();
  //createSurface();
  int[][] CA1 = root.printTree();
  int[][] CA2 = root2.printTree();
  CA = arrCopy(arrCombine(arrCombine(CA1, CA), CA2));
  root.grow();
  root2.grow();
  
  printCells();
  showSimulationBox();
}

void createSurface() {
  strokeWeight(4);
  line(0, 100, 1500, 100);
}

void populate() { //populates the original fungi.
  for (int i = (ASW/2)-5; i < (ASW/2)+5; i++) {
    for (int j = (ASH/2)-5; j < (ASH/2)+5; j++) {
      if (random(100) < 10) {
        CA[i][j] = 1;
      }
    }
  }
}

void cull() {
  for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      if (CA[i][j] == 1) {
        CA[i][j] = 0;
      }
    }
  }
}

void showTrimmed() {
  for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      if (CA[i][j] == 31 || CA[i][j] == 5) {
        CA[i][j] = 1;
      }
      
      if (CA[i][j] > 49 ) {
        CA[i][j] = 0;
      } else if (CA[i][j] == 30) {
        CA[i][j] = 30;
      }
    }
  }
}

int t = 0;
void trimDown() {
  for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      if (CA[i][j] > 49 && random(50) < 1) {CA[i][j] = 0; t++;}
      if (t == 25 && CA[i][j] > 49) {CA[i][j] = 0;}
    }
  }
}

void cover() {
  for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      int c = getWaterCount(i,j,200);
      if (c == 200) {
        CA[i][j] = 1;
      }    
    }
  }
}


void keyPressed() {
  
  if (key == 'y') {
    for (int i = 0; i < 50; i++) {
      if (reachedL == 1 && reachedR == 1) {
        spread();
        spread();
        spread();
        update();
      } else {
        update();
      }
    }
  }
  
  if (key == 'k') {
    cover();
  }
  
  if (key == 'u') {   
    for (int i = 0; i < 50; i++) {
      Propagate();
    }
  }
  
  if (key == ' ') {
    if (reachedL == 1 && reachedR == 1) {
      spread();
      spread();
      spread();
      update();
    } else {
      update();
    }
  }
  
  if (key == 'r') {
    //trimCol();
    for(int i = 0; i < 140; i++) {
      pathFinder();
    //print("working");
    }
    SavedCA = arrCopy(CA);
  }
  
  if (key == 't') {
    Propagate();
  }
  
  if (key == 'f') {
    trimDown();
  } 
  
  if (key == 'p') {
    cull();
    print("reached");
  }
  
  if (key == 'l') {
    showTrimmed();
  }
  
  if (key == 'h') {
    int[][] temp = SegmentRootSystem();
    CA = temp;
  }
  
}

void reset() {
  CA = new int[ASW][ASH];
  populate();
  addWaterandNutrients();
}   
