
ArrayList<int[][]> proximities = new ArrayList<int[][]>();
HashMap<int[], Integer> hashMap = new HashMap<int[], Integer>(); // stores the location of each pixel at the previous time tick
int dim = 4;
int fade = 2;
int boxSize = 400;
int ASW = boxSize/dim; 
int ASH = boxSize/dim;
int[][] grid = new int[ASW][ASH];
int[][] hm = new int[ASW][ASH];
int[][] knownCopy;
int [][] CA;
int [][] SavedCA;
int box = 10/dim;
int flag = 0;
int reachedL = 0;
int reachedR = 0;
int c = 400;
int avg = 600;
int factor = 20;

void setup() {
  size(1550, 950, P2D); //create a 3D processing environment.
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
          } else if (arr1[i][j] == 32 || arr2[i][j] == 32) {
            temp[i][j] = 32;
          }
          
          for (int p = 50; p < 1001; p++) {
            if (arr1[i][j] == p || arr2[i][j] == p) {
               temp[i][j] = p;
            }
          }
          
       }  
    }
    return temp;
}

int [][] arrCombineKeep(int[][] arr1, int[][] arr2) {
    int[][] temp = new int[ASW][ASH];
    
    for (int i = 0; i < ASW; i++) {
      for (int j = 0; j < ASH; j++) {
          if (arr1[i][j] == 30 || arr2[i][j] == 30) {
            temp[i][j] = 30;
          } else if (arr1[i][j] == 31 || arr2[i][j] == 31) {
            temp[i][j] = 31;
          } else if (arr1[i][j] == 32 || arr2[i][j] == 32) {
            temp[i][j] = 32;
          } else {
            temp[i][j] = arr1[i][j];
          }
        }    
     }
     return temp;
}

void showSimulationBox() {
  translate(-(boxSize-50), -(boxSize-50));
  scale(boxSize, boxSize);
  stroke(0);
  strokeWeight(0.9/boxSize);
  noFill();
  rect(1,1,1,1);
}

int num = 0;
void createCity() { //method to add the water table and points in carbon and phosphouros.
  
  //ADD NUTRIENCE
  for (int i = 0; i < ASW-2; i += 2) {
    for (int j = 0; j < ASH-2; j += 2) {
      if (CA[i][j] != 5 && CA[i+1][j] != 5 && CA[i][j+1] != 5 && CA[i+1][j+1] != 5) {
        if (CA[i][j] != 10 && CA[i+1][j] != 10 && CA[i][j+1] != 10 && CA[i+1][j+1] != 10 && random(100) < 1) {
          CA[i][j] = 30; CA[i+1][j] = 30; CA[i][j+1] = 30; CA[i+1][j+1] = 30;
          num = num + 4;
        }
      }
    }
  }
  
}

void createSimpleCity() {
   for (int i = 1; i < ASW-1; i++) {
    for (int j = 1; j < ASH-1; j++) {
      if (CA[i][j] != 5 && random(250) < 1) {
        CA[i][j] = 30;
        num++;
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
      } else if (CA[i][j] == 1 || CA[i][j] > 49 && CA[i][j] < 401) {
        showBox(i,j, color(255, 204, 0));
      } else if (CA[i][j] == 10) {
        showBox(i,j, color(55, 42, 209));
      } else if (CA[i][j] == 30 || (CA[i][j] > 401 && CA[i][j] < avg)) {
        showBox(i,j, color(139, 147, 37));
      }else if (CA[i][j] > avg) {
        showBox(i,j, color(252, 5, 5));
      } else if (CA[i][j] == 31 || CA[i][j] == 32) {
        showBox(i,j, color(160, 131, 24));
      } else if (CA[i][j] == 60) {
        showBox(i,j, color(55, 42, 209));
      } else if (CA[i][j] == 20) {
        showBox(i,j, color(100));
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

int getWaterCount(int a, int b, int val, int[][] arr) { // returns if the cell is next to a Water.
//MIGHT NEED TO AD SOMETHING HERE IF THE CELL IS NEXT TO A SITE OF INTEREST.
  int count = 0;
  
  //BASE LAYER
  if (arr[(a-1+ASW)%ASW][b] == 60) {count++;} //left
  if (arr[(a-1+ASW)%ASW][(b+1)%ASH] == 1 && (b+1)%ASH - b == 60) {count++;} // left top
  if (arr[(a-1+ASW)%ASW][(b-1+ASH)%ASH] == 60) {count++;} // left bottom
  if (arr[a][(b+1)%ASH] == 1 && (b+1)%ASH - b == 60) {count++;} // top
  if (arr[a][(b-1+ASH)%ASH] == 60) {count++;} // bottom
  if (arr[(a+1)%ASW][b] == 60) {count++;} // right
  if (arr[(a+1)%ASW][(b+1)%ASH] == 1 && (b+1)%ASH - b == 60) {count++;} // right top
  if (arr[(a+1)%ASW][(b-1+ASH)%ASH] == 60) {count++;} // right bottom
  
  if (count > 0 ) {
    return 200;
  }
  
  int currentMax = 20;
  if (arr[(a-1+ASW)%ASW][b] == val) {currentMax = arr[(a-1+ASW)%ASW][b];} //left
  if (arr[(a-1+ASW)%ASW][(b+1)%ASH] == val) {currentMax = arr[(a-1+ASW)%ASW][(b+1)%ASH];} // left top
  if (arr[(a-1+ASW)%ASW][(b-1+ASH)%ASH] == val) {currentMax = arr[(a-1+ASW)%ASW][(b-1+ASH)%ASH];} // left bottom
  if (arr[a][(b+1)%ASH] == val) {currentMax = arr[a][(b+1)%ASH];} // top
  if (arr[a][(b-1+ASH)%ASH] == val) {currentMax = arr[a][(b-1+ASH)%ASH];} // bottom
  if (arr[(a+1)%ASW][b] == val) {currentMax = arr[(a+1)%ASW][b];} // right
  if (arr[(a+1)%ASW][(b+1)%ASH] == val) {currentMax = arr[(a+1)%ASW][(b+1)%ASH];} // right top
  if (arr[(a+1)%ASW][(b-1+ASH)%ASH] == val) {currentMax = arr[(a+1)%ASW][(b-1+ASH)%ASH];} // right bottom
  
  if (currentMax == 20) {
    return 1;
  }
  
  return currentMax;
}

int getWaterCount(int a, int b, int val) { // returns if the cell is next to a Water.
//MIGHT NEED TO AD SOMETHING HERE IF THE CELL IS NEXT TO A SITE OF INTEREST.
  int count = 0;
  
  //BASE LAYER
  if (CA[(a-1+ASW)%ASW][b] == 60) {count++;} //left
  if (CA[(a-1+ASW)%ASW][(b+1)%ASH] == 1 && (b+1)%ASH - b == 60) {count++;} // left top
  if (CA[(a-1+ASW)%ASW][(b-1+ASH)%ASH] == 60) {count++;} // left bottom
  if (CA[a][(b+1)%ASH] == 1 && (b+1)%ASH - b == 60) {count++;} // top
  if (CA[a][(b-1+ASH)%ASH] == 60) {count++;} // bottom
  if (CA[(a+1)%ASW][b] == 60) {count++;} // right
  if (CA[(a+1)%ASW][(b+1)%ASH] == 1 && (b+1)%ASH - b == 60) {count++;} // right top
  if (CA[(a+1)%ASW][(b-1+ASH)%ASH] == 60) {count++;} // right bottom
  
  if (count > 0 ) {
    return 400;
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

PVector finMaximal(int a, int b) { // returns the maximal cell.
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

PVector findMaxGrad(int a, int b) { // returns the maximal cell.
  PVector ret = PVector.random2D(); // NEED TO IMPLEMENT RANDOM WALKS TO MAKE THIS WORK!!!
  
  int temp = hm[0][0];
  
  //BASE LAYER
  ret.x = 0;
  ret.y = 0;
  hm[0][0] = 1000000;
  //ret.x = (a-1+ASW)%ASW;
  //ret.y = b;
  
  //if (CA[(a-1+ASW)%ASW][b] != 1) {
  //  hm[a][b] = 100000;
  //}
  
  // Search the heighmap for maximual gradient
  if (hm[(a-1+ASW)%ASW][b] < hm[int(ret.x)][int(ret.y)] && CA[(a-1+ASW)%ASW][b] == 1) {  ret.x = (a-1+ASW)%ASW; ret.y = b;} // left
  if (hm[(a-1+ASW)%ASW][(b+1)%ASH] < hm[int(ret.x)][int(ret.y)] && CA[(a-1+ASW)%ASW][(b+1)%ASH] == 1) {  ret.x = (a-1+ASW)%ASW; ret.y = (b+1)%ASH;} // left top
  if (hm[(a-1+ASW)%ASW][(b-1+ASH)%ASH] < hm[int(ret.x)][int(ret.y)] && CA[(a-1+ASW)%ASW][(b-1+ASH)%ASH] == 1) {ret.x = (a-1+ASW)%ASW; ret.y = (b-1+ASH)%ASH;} // left bottom
  if (hm[a][(b+1)%ASH] < hm[int(ret.x)][int(ret.y)] && CA[a][(b+1)%ASH] == 1) {ret.x = a; ret.y = (b+1)%ASH;} // top
  if (hm[a][(b-1+ASH)%ASH] < hm[int(ret.x)][int(ret.y)] && CA[a][(b-1+ASH)%ASH] == 1) {ret.x = a; ret.y = (b-1+ASH)%ASH;} // bottom
  if (hm[(a+1)%ASW][b] < hm[int(ret.x)][int(ret.y)] && CA[(a+1)%ASW][b] == 1) {ret.x = (a+1)%ASW; ret.y = b;} // right
  if (hm[(a+1)%ASW][(b+1)%ASH] < hm[int(ret.x)][int(ret.y)] && CA[(a+1)%ASW][(b+1)%ASH] == 1) {ret.x = (a+1)%ASW; ret.y = (b+1)%ASH;} // right top
  if (hm[(a+1)%ASW][(b-1+ASH)%ASH] < hm[int(ret.x)][int(ret.y)] && CA[(a+1)%ASW][(b-1+ASH)%ASH] == 1) {ret.x = (a+1)%ASW; ret.y = (b-1+ASH)%ASH;} // right bottom
  
  // set the value of the heightmap back to what it should be.
  hm[0][0] = temp;
  
  return ret;
}

void update() { //updates the world each tick
   int [][] temp = arrCopy(CA);
   for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      
        int count = getCount(i,j);
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

int[][] pathFinder(int [][] arr) {

  for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      int count = getWaterCount(i,j,c, arr);
      if (arr[i][j] == 1 && count > 50) {
        arr[i][j] = count - 1;
      }
    }

  }
  c = c - 1; //decrease c
  
  return arr;
}

void pathFinderOrigin() {

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

int[][] finder(int a, int b) {
  int[][] arr = new int[ASW][ASH]; // create the new array.
  int[][] temp = arrCopy(CA);
  temp[a][b] = 60;
  temp[a+1][b] = 60;
  temp[a][b+1] = 60;
  temp[a+1][b+1] = 60;
  
  c = 200;
  for (int i = 0; i < 150; i++) {
    temp = pathFinder(temp);
  }
  
  return temp;
}

void createMatrix() { // creates the matrix of influence.

  for (int i = 0; i < ASW-2; i += 2) {
    for (int j = 0; j < ASH-2; j += 2) {
      if (CA[i][j] == 30 && CA[i+1][j] == 30 && CA[i][j+1] == 30 && CA[i+1][j+1] == 30) { // for each city in the network.
        int[][] arr = finder(i,j);
        arr[i][j] = 30;
        arr[i+1][j] = 30;
        arr[i][j+1] = 30;
        arr[i+1][j+1] = 30;
        proximities.add(arr);
      }
    }
  }

}

void createSimpleMatrix() {
  
  for (int i = 0; i < ASW-2; i++) {
    for (int j = 0; j < ASH-2; j++) {
      if (CA[i][j] == 30) { // for each city in the network.
        int[][] arr = finder(i,j);
        arr[i][j] = 30;
        proximities.add(arr);
      }
    }
  }  
}

int[][] stripCells(int a, int b, int maxA, int maxB, int[][] arr) {
  
  if (arr[(a-1+ASW)%ASW][b] > 150 && (((a-1+ASW)%ASW) != maxA || b != maxB)) {arr[(a-1+ASW)%ASW][b] = 1;} //left
  if (arr[(a-1+ASW)%ASW][(b+1)%ASH] > 150 && (((a-1+ASW)%ASW) != maxA || ((b+1)%ASH) != maxB)) {arr[(a-1+ASW)%ASW][(b+1)%ASH] = 1;} // left top
  if (arr[(a-1+ASW)%ASW][(b-1+ASH)%ASH] > 150 && (((a-1+ASW)%ASW) != maxA || ((b-1+ASH)%ASH) != maxB)) {arr[(a-1+ASW)%ASW][(b-1+ASH)%ASH] = 1;} // left bottom
  if (arr[a][(b+1)%ASH] > 150 && (a != maxA || ((b+1)%ASH) != maxB)) {arr[a][(b+1)%ASH] = 1;} // top
  if (arr[a][(b-1+ASH)%ASH] > 150 && (a != maxA || ((b-1+ASH)%ASH) != maxB)) {arr[a][(b-1+ASH)%ASH] = 1;} // bottom
  if (arr[(a+1)%ASW][b] > 150 && (((a+1)%ASW) != maxA || b != maxB)) {arr[(a+1)%ASW][b] = 1;} // right
  if (arr[(a+1)%ASW][(b+1)%ASH] > 150 && (((a+1)%ASW) != maxA || ((b+1)%ASH) != maxB)) {arr[(a+1)%ASW][(b+1)%ASH] = 1;} // right top
  if (arr[(a+1)%ASW][(b-1+ASH)%ASH] > 150 && (((a+1)%ASW) != maxA || ((b-1+ASH)%ASH) != maxB)) {arr[(a+1)%ASW][(b-1+ASH)%ASH] = 1;} // right bottom
  
  return arr;
}

boolean checkCells(int a, int b, int[][] arr) {
  
  if (arr[(a-1+ASW)%ASW][b] == 1) {return false;} //left
  if (arr[(a-1+ASW)%ASW][(b+1)%ASH] == 1) {return false;} // left top
  if (arr[(a-1+ASW)%ASW][(b-1+ASH)%ASH] == 1) {return false;} // left bottom
  if (arr[a][(b+1)%ASH] == 1) {return false;} // top
  if (arr[a][(b-1+ASH)%ASH] == 1) {return false;} // bottom
  if (arr[(a+1)%ASW][b] == 1) {return false;} // right
  if (arr[(a+1)%ASW][(b+1)%ASH] == 1) {return false;} // right top
  if (arr[(a+1)%ASW][(b-1+ASH)%ASH] == 1) {return false;} // right bottom
  
  
  return true;
}

void Propagate() {
  for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      PVector Max = finMaximal(i,j);
      if (CA[i][j] == 30 && CA[int(Max.x)][int(Max.y)] > 50 && CA[int(Max.x)][int(Max.y)] > SavedCA[i][j]) {
        
        CA[i][j] = SavedCA[i][j]; // CHANGE TO SAVEDCA  
        CA[int(Max.x)][int(Max.y)] = 31; //colour change
        
        //PVector NewMax = finMaximal(int(Max.x),int(Max.y)); //newMAX
        //CA = arrCopy(stripCells(int(Max.x), int(Max.y), int(NewMax.x), int(NewMax.y), CA));
        
        //checkCells(i,j,CA);
      } else if (CA[i][j] == 31 && CA[int(Max.x)][int(Max.y)] > 50 && CA[int(Max.x)][int(Max.y)] > SavedCA[i][j]) {
        CA[i][j] = 32; // CHANGE TO SAVEDCA  
        CA[int(Max.x)][int(Max.y)] = 31; //colour change
      }
    
  
    }
  }
  
}

void draw() {
  background(255);
  lights();
  
  printCells();
  showSimulationBox();
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
      
      if (CA[i][j] == 1) {
        CA[i][j] = 0;
      }
    }
  }
}

void trimCA() {
   for (int i = 0; i < ASW; i++) {
     CA[i][0] = 0;
     CA[i][ASH-1] = 0;
   }
   
   for (int j = 0; j < ASH; j++) {
     CA[0][j] = 0;
     CA[ASW-1][j] = 0;
   }
  
}

void fillAll() {
  for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      if (CA[i][j] != 31 && CA[i][j] != 5 && CA[i][j] != 30) {
        CA[i][j] = 1;
      }
    }
  }

}

void setMax() {
   for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      int x = 0;
      int xmax = proximities.size()-1;
      //for (int x = 0; x < 1; x++) {
      if (proximities.get(x)[i][j] > CA[i][j]) {
        CA[i][j] = proximities.get(x)[i][j]; 
      }
      
      if (proximities.get(xmax)[i][j] > CA[i][j]) {
        CA[i][j] = proximities.get(xmax)[i][j]; 
      }
      //}
    }
  }

}

void Central() {

  for (int x = ASW/2 - 20; x < ASW/2 + 10; x++) {
      for (int y = ASH/2 - 20; y < ASH/2 + 10; y++) {
        if (CA[x][y] == 30) {CA[x][y] = 60; return;}
      }
  }

}

int counter = 0;

int[][] knownPoints;
int[][] CopyPoints;
void addValue() {
  knownPoints = new int[num][3];
  CopyPoints = new int[num][3];
  knownCopy = new int[num][3];

  for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      if (CA[i][j] == 30 && i != 0 && j != 0) {
          int val = 0;  
          if (random(100) < 50) {
            val = (int) random(750, 1000);
          } else {
            val = (int) random(500, 600);
          }

          if (i != 0 && j != 0) {
            
            CA[i][j] = val;
            grid[i][j] = val;

            knownPoints[counter][0] = i;
            knownPoints[counter][1] = j;
            knownPoints[counter][2] = val;
            CopyPoints[counter][0] = i;
            CopyPoints[counter][1] = j;
            CopyPoints[counter][2] = val;
            knownCopy[counter][0] = i;
            knownCopy[counter][1] = j;
            knownCopy[counter][2] = val;
            counter++;
            
            avg = avg + val;
          }
      }
    }
  }
  avg = avg / num;
}

// Sets the perimeter of the world to be maximal value to prevent the resource from travelling towards the edges
void setEdge() {
   int index = num;
   
   for (int i = 0; i < ASW; i++) {
      knownPoints[index][0] = i;
      knownPoints[index][1] = 0;
      knownPoints[index][2] = 1000;
      
      index++;
      
      knownPoints[index][0] = i;
      knownPoints[index][1] = ASH-1;
      knownPoints[index][2] = 1000;
      
      index++;
   }
   
   for (int j = 0; j < ASH; j++) {
      knownPoints[index][0] = 0;
      knownPoints[index][1] = j;
      knownPoints[index][2] = 1000;
      
      index++;
      
      knownPoints[index][0] = ASW-1;
      knownPoints[index][1] = j;
      knownPoints[index][2] = 1000;
      
      index++;
   }
}

void setCorner() {
  knownPoints[num][0] = 0;
  knownPoints[num][1] = 0;
  knownPoints[num][2] = 200;
  
  knownPoints[num+1][0] = ASW-1;
  knownPoints[num+1][1] = 0;
  knownPoints[num+1][2] = 200;
  
    knownPoints[num+2][0] = 0;
  knownPoints[num+2][1] = ASH-1;
  knownPoints[num+2][2] = 200;
  
    knownPoints[num+3][0] = ASW-1;
  knownPoints[num+3][1] = ASH-1;
  knownPoints[num+3][2] = 200;
}

// sets the local minima
void setMinPoints() {
  
  for (int i = 0; i < knownPoints.length; i++) {
    if (knownPoints[i][2] < avg) {
       knownPoints[i][2] = -1000;
    }
  }
  
} 

int[][] finder(int i, int j, int val) {
  int [][] arr = CA;
  arr[i][j] = 80;
  arr[i+1][j] = 80;
  arr[i][j+1] = 80;
  arr[i+1][j+1] = 80;
  
  for (int x = 0; x < ASW; x ++) {
    for (int y = 0; y < ASH; y++) {
      
    }
  }
  
  return arr;
}

void createMatrixGradient() { // creates the matrix of influence.

  for (int i = 0; i < ASW-2; i += 2) {
    for (int j = 0; j < ASH-2; j += 2) {
      if (CA[i][j] > 499 && CA[i+1][j] > 499 && CA[i][j+1] > 499 && CA[i+1][j+1] > 499) { // for each city in the network.
        int[][] arr = finder(i,j, 1000 + 499);
        arr[i][j] = 30;
        proximities.add(arr);
      }
    }
  }

}

public int[][] generateHeightmap(int width, int height, int[][] knownPoints) {
    int[][] heightmap = new int[width][height];
    double[][] distances = new double[width][height];
    
    // calculate distances between each point and the known points
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            double sumDistances = 0.0;
            int numPoints = 0;
            for (int[] point : knownPoints) {
                if (point[0] == i && point[1] == j) {
                    // use known point directly
                    heightmap[i][j] = point[2];
                    numPoints = 1;
                    break;
                } else {
                    double distance = Math.sqrt((point[0]-i)*(point[0]-i) + (point[1]-j)*(point[1]-j));
                    sumDistances += distance;
                    numPoints++;
                }
            }
            if (numPoints > 0) {
                distances[i][j] = sumDistances / numPoints;
            }
        }
    }
    
    // generate the heightmap using inverse distance weighting
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            if (heightmap[i][j] != 0) {
                // use known point directly
                continue;
            } else {
                // interpolate using inverse distance weighting
                double sumWeights = 0.0;
                double sumValues = 0.0;
                for (int[] point : knownPoints) {
                    double distance = Math.sqrt((point[0]-i)*(point[0]-i) + (point[1]-j)*(point[1]-j));
                    double weight = 1.0 / (distance + 1.0); // add 1 to avoid division by zero
                    sumWeights += weight;
                    sumValues += weight * point[2];
                }
                heightmap[i][j] = (int) Math.round(sumValues / sumWeights);
            }
        }
    }
    
    return heightmap;
}

public static void smoothHeightmap(int[][] heightmap, int radius) {
    int size = heightmap.length;
    int[][] smoothed = new int[size][size];
    int diameter = 2 * radius + 1;
    float weight = 1.0f / (diameter * diameter);
    for (int y = 0; y < size; y++) {
        for (int x = 0; x < size; x++) {
            int sum = 0;
            for (int dy = -radius; dy <= radius; dy++) {
                int ny = y + dy;
                if (ny < 0 || ny >= size) continue;
                for (int dx = -radius; dx <= radius; dx++) {
                    int nx = x + dx;
                    if (nx < 0 || nx >= size) continue;
                    sum += heightmap[ny][nx];
                }
            }
            smoothed[y][x] = Math.round(sum * weight);
        }
    }
    // Copy the smoothed data back into the original heightmap
    for (int y = 0; y < size; y++) {
        for (int x = 0; x < size; x++) {
            heightmap[y][x] = smoothed[y][x];
        }
    }
}

void setMap(int[][] map) {
  for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      if (CA[i][j] == 31 || CA[i][j] == 32) {
        map[i][j] = map[i][j];
      } else {
        map[i][j] = 0;
      }
    }
  }
}

public static int[] findMaxCoord(int[][] arr) {
    // Initialize the maximum element and its coordinates
    int maxVal = arr[0][0];
    int maxI = 0;
    int maxJ = 0;
    
    // Loop through the array to find the maximum element and its coordinates
    for (int i = 0; i < arr.length; i++) {
        for (int j = 0; j < arr[i].length; j++) {
            if (arr[i][j] > maxVal) {
                maxVal = arr[i][j];
                maxI = i;
                maxJ = j;
            }
        }
    }
    
    // Return an array containing the coordinates of the maximum element
    return new int[] { maxI, maxJ };
}

public static int[] findCarbon(int[][] arr) {
    // Initialize the maximum element and its coordinates
    int carbon = arr[0][0];
    int CI = 0;
    int CJ = 0;
    
    // Loop through the array to find the maximum element and its coordinates
    for (int i = 0; i < arr.length; i++) {
        for (int j = 0; j < arr[i].length; j++) {
            if (arr[i][j] == 5) {
                carbon = arr[i][j];
                CI = i;
                CJ = j;
                return new int[] {CI, CJ};
            }
        }
    }
    
    // Return an array containing the coordinates of the maximum element
    return new int[] { CI, CJ };
}

void transferCarbonBegin() {
  // get the maximal co-oridnates of the heightmap.
  int[] max = findMaxCoord(CA);
  int x = max[0];
  int y = max[1];
  CA[x][y] = CA[x][y] - 5;
  PVector xy = findMaxGrad(x,y);
  CA[(int)xy.x][(int)xy.y] = 5;
}

void transferCarbon() {
  int[] c = findCarbon(CA);
  int x = c[0];
  int y = c[1];
  CA[x][y] = 32;
  PVector xy = findMaxGrad(x,y);
  CA[(int)xy.x][(int)xy.y] = 5;
}

// NEW SOLUTION

// Takes a single random step in any direction.  Taking no step is considered a valid operation.
void randomStep (int a, int b, int factor) {
  int[] x = {(a-1+ASW)%ASW, a, (a+1)%ASW};
  int[] y = {b, (b+1)%ASH, (b-1+ASH)%ASH};
  
  // Take the step
  CA[a][b] = 1;
  CA[x[int(random(x.length))]][y[int(random(y.length))]] = factor;
}

// get the average resource of a tree.
int avgResource() {
  int ret = 0;
  for (int i = 0; i < CopyPoints.length; i++) {
    ret = ret + CopyPoints[i][2];
  }
  ret = ret / CopyPoints.length;
  return ret;
}

int cCount = 0;
void propagateResourceStart() {
  // get the average resources of the world.
   //int avg = avgResource(); // RELATED TO HOW THIS AVG IS CALCULATED.
   // Rest cCount.
   cCount = 0;
   
   for (int t = 0; t < CopyPoints.length; t++) {
     if (CopyPoints[t][2] > (avg + factor)) {
        PVector xy = findMaxGrad(CopyPoints[t][0],CopyPoints[t][1]);
        CopyPoints[t][2] = CopyPoints[t][2] - factor;
        CA[(int) xy.x][(int) xy.y] = factor;
        CA[CopyPoints[t][0]][CopyPoints[t][1]] = CA[CopyPoints[t][0]][CopyPoints[t][1]] - factor;
     }
   }
  
  // Increment cCount/
  cCount++;
}

void propagateResource() {
   
   for (int i = 0; i < ASW; i++) {
    for (int j = 0; j < ASH; j++) {
      
      if (CA[i][j] == factor) { //NUTRIENCE POINT
        PVector xy = findMaxGrad(i,j);
        boolean flag = false;
        
        // if no maximal gradient was found resource is at a platau.
        // perfrom random walks until no longer at a platau
        if (xy.x == 0 && xy.y == 0) {
          // Perfrom 10 random walks
          for (int p = 0; p > 10; p++) {
            randomStep(i,j, factor);
          }  
          break;
        }
        
        // Find the maximal cell around co-oridanates i,j
        PVector max = finMaximal(i,j);
        
        // find out if the cell is next to a known point / known local minima / sink tree / any found tree
        int index = 0;
        for (int x = 0; x < CopyPoints.length; x++) {
          if (max.x == CopyPoints[x][0] && max.y == CopyPoints[x][1] && cCount  > 3) {flag = true; index = x; break;}
        }
        
        // if its not next to a local minima continue moving towards one
       if (!flag) {
        CA[i][j] = 1;
        CA[(int) xy.x][(int) xy.y] = factor;
       } else {
       // If it is next to one allow the sink to absorb it.
       CA[i][j] = 1;
       CopyPoints[index][2] = CopyPoints[index][2] + factor;
       CA[CopyPoints[index][0]][CopyPoints[index][1]] = CA[CopyPoints[index][0]][CopyPoints[index][1]] + factor;
       }
        
      }
     
    }
  }
  cCount++;
}

void setKnownPoints() {
  for (int i = 0; i < CopyPoints.length; i++) {
    knownPoints[i][2] = CopyPoints[i][2];
  }
}

// Helper functions
int toolbit = -1;
int bit = 0;
int bot = 0;
void helpTransfer() {

  switch(toolbit)
  {
    case -2:
    {
      setKnownPoints();
      avg = avgResource();
      setMinPoints();
      hm = generateHeightmap(ASW,ASH,knownPoints);
      toolbit = 0;
      bit = 0;
      bot = 0;
      break;
    }
    
    case -1:
    {
    fillAll();
    trimCA();
    addValue();
    setMinPoints();
    hm = generateHeightmap(ASW,ASH,knownPoints);
    toolbit = 0;
    break;
    }
    
    case 0:
    {
      propagateResourceStart();
      toolbit++;
      break;
    }
    
    case 1:
    {
    propagateResource();
    bit++;
    bot++;
    if (bit == 5) {toolbit = 5; bit = 0;}
    if (bot == 20) {toolbit = -2;}
    break;
    }
    
    case 5:
    {
    toolbit = 0;
    break;
    }
  }

}



int[][] temp = CA;
void keyPressed() {
  
  if (key == '6') {
    helpTransfer();
  }
  
  if (key == '3') {
    print("\nValues BEFORE: \n");
    
    for (int i = 0; i < CopyPoints.length; i++) {
      int tot = i+1;
      print("Tree " + tot + " before: " + knownCopy[i][2] + ", ");
    }
    
    print("\nValues AFTER: \n");
    
    for (int i = 0; i < CopyPoints.length; i++) {
      int tot = i+1;
      print("Tree " + tot + " after: " + CopyPoints[i][2] + ", ");
    }  
   
  }
  
  if (key == '2') {
    propagateResourceStart();
  }
  
  if (key == '4') {
    propagateResource();
  }
  
  if (key == 'y') {
    for (int i = 0; i < 50; i++) {
      update();
    }
    trimCA();
  }
  
  
  if (key == 'u') {
    
    for (int i = 0; i < 50; i++) {
      Propagate();
    }
  }
  
  if (key == ' ') {
    update();
  }
  
  if (key == 'g') {
    Central();
  }
  
  if (key == 'e') {
    addValue();
  }
  
  if (key == 'v') {
    setMinPoints();
    hm = generateHeightmap(50,50,knownPoints);
  }
  
  if (key == 'x') {
    transferCarbonBegin();
  }
  
  if (key == 'z') {
    transferCarbon();
  }
  
  if (key == 'm') {
    setMap(hm);
  }
  
  if (key == 'n') {
    CA = hm;
  }
  
  if (key == 'b') {
     smoothHeightmap(hm, 5);
  }
  
  if (key == 'r') {
    for(int i = 0; i < 250; i++) {  
    pathFinderOrigin();
    }
    SavedCA = arrCopy(CA);
  }
  
  if (key == 't') {
    Propagate();
  }
  
  if (key == 'p') {
    cull();
    print("reached");
  }
  
  if (key == 'l') {
    showTrimmed();
  }
  
  if (key == 'h') { //use this function for future use.
    createMatrix();
    SavedCA = arrCopy(CA);
    setMax();
    SavedCA = arrCopy(CA);
  }
  
  if (key == 'f') {
    fillAll();
    trimCA();
  }
  
  if (key == 'j') {
    
    for (int x = 0; x < proximities.size(); x++) { //cycle through the proximities.
      int [][] temp = arrCopy(CA);
      CA = arrCopy(proximities.get(x));
      SavedCA = arrCopy(CA);
      
      for (int j = 0; j < 15; j++) {
        Propagate();
      }
      CA = arrCombineKeep(CA, temp);
      print("reached" + x + " ");
    }
  }
  
  
  // DIFFERENT SOLUTIONS.
  
  int count = 0;
  if (key == ';') {
    count++;
    
    int [][] temp = arrCopy(CA);
    CA = arrCombineKeep(CA, proximities.get(count));
    SavedCA = arrCopy(CA);
  }
  
  if (key == '#') {
    Propagate(); 
  }
  
  if (key == '1') {
    print("[ ");
    for (int j = 0; j < ASH; j++) {
      for (int i = 0; i < ASW-1; i++) {
        print(CA[i][j] + ", ");
      }
      print(CA[ASW-1][j] + "; ");
    }
  }
  
}

void reset() {
  CA = new int[ASW][ASH];
  populate();
  createSimpleCity();
}   
