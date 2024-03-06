import peasy.*;
PeasyCam cam;

int dim = 2;
int fade = 200;
int AS = 500/dim;
int ASH = 500/dim;
int [][][] CA;
int box = 30/dim;
public static int[] directions;
HashMap<String, ArrayList<String>> directionMap;
boolean printc = true;

Tree root;

// STATISTICS:
// VALUES BASED ON STUDY PERFORMED BY THE ROYAL SOCIETY
// ARTICLE TITLE : L-System model for the growth of arbuscular mycorrhizal fungi, both within and outside of their host roots
// FULL REFERENCE AVAILABLE IN THE REPORT BIBLIOGRAPHY

// PRIMARY INFECTION:

// probability of infection of 1 cm root within 1 day
public static final float P = 0.15;

// dx:length of 1 block and dt:time of one tick
public static final float dx = 0.05;
public static final float dt = 1;

// primary infection rate
public static final float primary = 1 - pow((1-P), dt-dx);


// SECONDARY INFECTION:

// secondary infection co-efficient
public static final float Vi = 0.13;

// secondary infection (done inline)
//public static float secondary = Vi * (number of infected blocks in Moore's neighbourhood)


// WORLD STATS:

// number of fungal matter, tree matter and number of infected root segments
int fungiC;
int treeC;
int infectedP;
int infectedS;

// TOKENS:

// MAIN RING
public static final int N = 10;
public static final int NE = 11;
public static final int E = 12;
public static final int SE = 13;
public static final int S = 14;
public static final int SW = 15;
public static final int W = 16;
public static final int NW = 17;

// ABOVE RING
public static final int AN = 18;
public static final int ANE = 19;
public static final int AE = 20;
public static final int ASE = 21;
public static final int ASS = 22;
public static final int ASW = 23;
public static final int AW = 24;
public static final int ANW = 25;

// BLOWING RING
public static final int BN = 26;
public static final int BNE = 27;
public static final int BE = 28;
public static final int BSE = 29;
public static final int BS = 30;
public static final int BSW = 31;
public static final int BW = 32;
public static final int BNW = 33;

// ABOVE/BELLOW CELLS
public static final int U = 34;
public static final int B = 35;

// DEAD CELLS
public static final int DEAD = 36;

// INFECTED CELLS
public static final int PRIMARY = 37;
public static final int SECONDARY = 38;

// VALID CELL FOR GROWTH
int VALID = 100;
boolean flag = true;
int lim = 200;

void setup() {
  size(600, 600, P3D); // set up world
  cam = new PeasyCam(this, 100); // create PeasyCam
  cam.setMinimumDistance(50); // define PeasyCam settings
  cam.setMaximumDistance(500);
  cam.setSuppressRollRotationMode();
  directions = new int[] {N, NE, E, SE, S, SW, W, NW, BN, BNE, BE, BSE, BS, BSW, BW, BNW, AN, ANE, AE, ASE, ASS, ASW, AW, ANW, U, B};
  
  root = new Tree(new PVector(AS/2,0,AS/2));
  
  fungiC = 0;
  treeC = 0;
  infectedP = 0;
  infectedS = 0;
  
  reset();
}

int[][][] arrCombine(int[][][] arr1, int[][][] arr2) {
  int[][][] temp = new int[AS][AS][AS];
    for (int i = 0; i < AS; i++) {
      for (int j = 0; j < AS; j++) {
        for (int k = 0; k < AS; k++) {
          if (arr1[i][j][k] == 5 || arr2[i][j][k] == 5) {
            temp[i][j][k] = 5;
          } else if (arr1[i][j][k] == 1 || arr2[i][j][k] == 1) {
            temp[i][j][k] = 1;
          } else if (arr1[i][j][k] == -1 || arr2[i][j][k] == -1) {
            temp[i][j][k] = -1;
          } else if (arr1[i][j][k] == 10 || arr2[i][j][k] == 10) {
            temp[i][j][k] = 10;
          } else if (arr1[i][j][k] == 30 || arr2[i][j][k] == 30) {
            temp[i][j][k] = 30;
          } else if (arr1[i][j][k] == 31 || arr2[i][j][k] == 31) {
            temp[i][j][k] = 31;
          }
          
          for (int p = 50; p < 201; p++) {
            if (arr1[i][j][k] == p || arr2[i][j][k] == p) {
               temp[i][j][k] = p;
            }
          }
        }
       }  
    }
    return temp;
}

void populate() {
   for (int i = 0; i < AS; i++) {
    for (int j = 20; j < AS; j++) {
      for (int k = 0; k < AS; k++) {
        // Create a random direction within the 25 valid hyphal tip directions.
        int rand = (int) random(10, 35);
        
        // Randomly assign a direction to the spore.
        if (CA[i][j][k] > 195 && random(1000) < 2) {
          CA[i][j][k] = rand;
        }
        
      }
    }
  }
}

void populate1() {
   for (int i = 0; i < AS; i++) {
    for (int j = 0; j < AS; j++) {
      if (random(1) < 0.5) {
        CA[i][j][0] = fade;
      } else {
        CA[i][j][0] = 0;
      }
    }
  }
}

void populate2() {
  for (int i = (AS/2)-box; i < (AS/2)+box; i++) {
    for (int j = 20; j < 20+box; j++) {
      for (int k = (AS/2)-box; k < (AS/2)+box; k++) {
        // Create a random direction within the 25 valid hyphal tip directions.
        int rand = (int) random(10, 35);
        
        // Randomly assign this direction according to a set probabilty
        if (random(100) < 0.1) {
          CA[i][j][k] = rand;
        } else {
          CA[i][j][k] = 0;
        }
      }
    }
  }
}

void populate3() {
  CA[AS/2][AS/2][AS/2] = U;
}

void populate4() {
  for (int i = (AS/2)-box; i < (AS/2)+box; i++) {
    for (int j = 20; j < 20+box; j++) {
      for (int k = (AS/2)-box; k < (AS/2)+box; k++) {
        // Create a random direction within the 25 valid hyphal tip directions.
        int rand = (int) random(10, 35);
        
        // Randomly assign this direction according to a set probabilty
        if (random(30) < 0.1) {
          CA[i][j][k] = rand;
        } else {
          CA[i][j][k] = 0;
        }
      }
    }
  }
}

void searchPoints() {
  CA[0][0][0] = -1;
  CA[AS-1][AS-1][AS-1] = -1;
}

void fill() {
  CA[0][0][0] = 1;
  CA[AS-1][AS-1][AS-1] = -1;
}

void reset() {
  CA = new int[AS][AS][AS];
  searchPoints();
}

void printCells() {
  for (int i = 0; i < AS; i++) {
    for (int j = 0; j < AS; j++) {
      for (int k = 0; k < AS; k++) {
        if (CA[i][j][k] == fade) {
          showBox(i,j,k, color(100));
        } else if (CA[i][j][k] >= 10 && CA[i][j][k] <= 36) {
          showBox(i,j,k, color(0, 255, 70));
        } else if (CA[i][j][k] == 5 || CA[i][j][k] == 2) {
          showTree(i,j,k, color(0, 0, 0));
        } else if (CA[i][j][k] == PRIMARY) {
          showTree(i,j,k, color(255, 0, 0));
        } else if (CA[i][j][k] == SECONDARY) {
          showTree(i,j,k, color(255, 234, 0));
        }
      }
    }
  }
}
boolean tag = false;
void draw() {
  background(255);
  lights();
  pointLight(255, 255, 255, mouseX, mouseY, 500); // Create a point light
  ambientLight(100,100,100); // Create an ambient light


  
  if (flag) {
     CA = root.printTree();
     root.grow();
     thickenTree();   
  }
  
   if (tag) {
     up();
     print("complete \n");
   }
    
  if (printc) {
    printCells();
  }
}

int getCount(int a, int b, int c, int[][][] TCA) {
  int count = 0;
  
  // If the cell is not a active fungal cell return zero
  if (TCA[a][b][c]  < 10 || TCA[a][b][c] > 36) {return 0;}
  
  
  //BASE LAYER
  if (TCA[(a-1+AS)%AS][b][c] != DEAD && TCA[(a-1+AS)%AS][b][c] >=10 && TCA[(a-1+AS)%AS][b][c] <= 36) {count++;} //left
  if (TCA[(a-1+AS)%AS][(b+1)%AS][c] != DEAD && TCA[(a-1+AS)%AS][(b+1)%AS][c] >= 10 && TCA[(a-1+AS)%AS][(b+1)%AS][c] <= 36) {count++;} // left top
  if (TCA[(a-1+AS)%AS][(b-1+AS)%AS][c] != DEAD && TCA[(a-1+AS)%AS][(b-1+AS)%AS][c] >= 10 && TCA[(a-1+AS)%AS][(b-1+AS)%AS][c] <= 36) {count++;} // left bottom
  if (TCA[a][(b+1)%AS][c] != DEAD && TCA[a][(b+1)%AS][c] >= 10 && TCA[a][(b+1)%AS][c] <= 36) {count++;} // top
  if (TCA[a][(b-1+AS)%AS][c] != DEAD && TCA[a][(b-1+AS)%AS][c] >= 10 && TCA[a][(b-1+AS)%AS][c] <= 36) {count++;} // bottom
  if (TCA[(a+1)%AS][b][c] != DEAD && TCA[(a+1)%AS][b][c] >= 10 && TCA[(a+1)%AS][b][c] <= 36) {count++;} // right
  if (TCA[(a+1)%AS][(b+1)%AS][c] != DEAD && TCA[(a+1)%AS][(b+1)%AS][c] >= 10 && TCA[(a+1)%AS][(b+1)%AS][c] <= 36) {count++;} // right top
  if (TCA[(a+1)%AS][(b-1+AS)%AS][c] != DEAD && TCA[(a+1)%AS][(b-1+AS)%AS][c] >= 10 && TCA[(a+1)%AS][(b-1+AS)%AS][c] <= 36) {count++;} // right bottom
  
  //BELLOW LAYER
  int bc = (c-1+AS)%AS;
  if (TCA[(a-1+AS)%AS][b][bc] != DEAD && TCA[(a-1+AS)%AS][b][bc] >= 10 && TCA[(a-1+AS)%AS][b][bc] <= 36) {count++;} //left
  if (TCA[(a-1+AS)%AS][(b+1)%AS][bc] != DEAD && TCA[(a-1+AS)%AS][(b+1)%AS][bc] >= 10 && TCA[(a-1+AS)%AS][(b+1)%AS][bc] <= 36) {count++;} // left top
  if (TCA[(a-1+AS)%AS][(b-1+AS)%AS][bc] != DEAD && TCA[(a-1+AS)%AS][(b-1+AS)%AS][bc] >= 10 && TCA[(a-1+AS)%AS][(b-1+AS)%AS][bc] <= 35) {count++;} // left bottom
  if (TCA[a][(b+1)%AS][bc] != DEAD && TCA[a][(b+1)%AS][bc] >= 10 && TCA[a][(b+1)%AS][bc]  <= 36) {count++;} // top
  if (TCA[a][(b-1+AS)%AS][bc] != DEAD && TCA[a][(b-1+AS)%AS][bc] >= 10 && TCA[a][(b-1+AS)%AS][bc] <= 36) {count++;} // bottom
  if (TCA[a][b][bc] != DEAD && TCA[a][b][bc] >= 10 && TCA[a][b][bc] <= 36) {count++;} // middle
  if (TCA[(a+1)%AS][b][bc] != DEAD && TCA[(a+1)%AS][b][bc] >= 10 && TCA[(a+1)%AS][b][bc] <= 36) {count++;} // right
  if (TCA[(a+1)%AS][(b+1)%AS][bc] != DEAD && TCA[(a+1)%AS][(b+1)%AS][bc] >= 10 && TCA[(a+1)%AS][(b+1)%AS][bc] <= 36) {count++;} // right top
  if (TCA[(a+1)%AS][(b-1+AS)%AS][bc] != DEAD && TCA[(a+1)%AS][(b-1+AS)%AS][bc] >= 10 && TCA[(a+1)%AS][(b-1+AS)%AS][bc] <= 36) {count++;} // right bottom
  
  //ABOVE LAYER LAYER
   int ac = (c+1)%AS;
  if (TCA[(a-1+AS)%AS][b][ac] != DEAD && TCA[(a-1+AS)%AS][b][ac] >= 10 && TCA[(a-1+AS)%AS][b][ac] <= 36) {count++;} //left
  if (TCA[(a-1+AS)%AS][(b+1)%AS][ac] != DEAD && TCA[(a-1+AS)%AS][(b+1)%AS][ac] >= 10 && TCA[(a-1+AS)%AS][(b+1)%AS][ac] <= 36) {count++;} // left top
  if (TCA[(a-1+AS)%AS][(b-1+AS)%AS][ac] != DEAD && TCA[(a-1+AS)%AS][(b-1+AS)%AS][ac] >= 10 && TCA[(a-1+AS)%AS][(b-1+AS)%AS][ac] <= 36) {count++;} // left bottom
  if (TCA[a][(b+1)%AS][ac] != DEAD && TCA[a][(b+1)%AS][ac] >= 10 && TCA[a][(b+1)%AS][ac] <= 46) {count++;} // top
  if (TCA[a][(b-1+AS)%AS][ac] != DEAD && TCA[a][(b-1+AS)%AS][ac] >= 10 && TCA[a][(b-1+AS)%AS][ac] <= 36) {count++;} // bottom
  if (TCA[a][b][ac] != DEAD && TCA[a][b][ac]  >= 10 && TCA[a][b][ac] <= 36) {count++;} // middle
  if (TCA[(a+1)%AS][b][ac] != DEAD && TCA[(a+1)%AS][b][ac] >= 10 && TCA[(a+1)%AS][b][ac] <= 36) {count++;} // right
  if (TCA[(a+1)%AS][(b+1)%AS][ac] != DEAD && TCA[(a+1)%AS][(b+1)%AS][ac] >= 10 && TCA[(a+1)%AS][(b+1)%AS][ac] <= 36) {count++;} // right top
  if (TCA[(a+1)%AS][(b-1+AS)%AS][ac] != DEAD && TCA[(a+1)%AS][(b-1+AS)%AS][ac] >= 10 && TCA[(a+1)%AS][(b-1+AS)%AS][ac] <= 36) {count++;} // right bottom
  
  return count;
}

boolean proximityCheck(int a, int b, int c, int val, int[][][] TCA) {
  //BASE LAYER
  if (TCA[(a-1+AS)%AS][b][c] == val && abs(a - (a-1+AS)%AS) <= 10 && abs(b - b) <= 10 && abs(c - c) <= 10) {return true;} //left
  if (TCA[(a-1+AS)%AS][(b+1)%AS][c] == val && abs(a - (a-1+AS)%AS) <= 10 && abs(b - (b+1)%AS) <= 10 && abs(c - c) <= 10) {return true;} // left top
  if (TCA[(a-1+AS)%AS][(b-1+AS)%AS][c] == val && abs(a - (a-1+AS)%AS) <= 10 && abs(b - (b-1+AS)%AS) <= 10 && abs(c - c) <= 10) {return true;} // left bottom
  if (TCA[a][(b+1)%AS][c] == val && abs(a - a) <= 10 && abs(b - (b+1)%AS) <= 10 && abs(c - c) <= 10) {return true;} // top
  if (TCA[a][(b-1+AS)%AS][c] == val && abs(a - a) <= 10 && abs(b - (b-1+AS)%AS) <= 10 && abs(c - c) <= 10) {return true;} // bottom
  if (TCA[(a+1)%AS][b][c] == val && abs(a - (a+1)%AS) <= 10 && abs(b - b) <= 10 && abs(c - c) <= 10) {return true;} // right
  if (TCA[(a+1)%AS][(b+1)%AS][c] == val && abs(a - (a+1)%AS) <= 10 && abs(b - (b+1)%AS) <= 10 && abs(c - c) <= 10) {return true;} // right top
  if (TCA[(a+1)%AS][(b-1+AS)%AS][c] == val && abs(a - (a+1)%AS) <= 10 && abs(b - (b-1+AS)%AS) <= 10 && abs(c - c) <= 10) {return true;} // right bottom
  
  //BELLOW LAYER
  int bc = (c-1+AS)%AS;
  if (TCA[(a-1+AS)%AS][b][bc] == val && abs(a - (a-1+AS)%AS) <= 10 && abs(b - b) <= 10 && abs(c - bc) <= 10) {return true;} //left
  if (TCA[(a-1+AS)%AS][(b+1)%AS][bc] == val && abs(a - (a-1+AS)%AS) <= 10 && abs(b - (b+1)%AS) <= 10 && abs(c - bc) <= 10) {return true;} // left top
  if (TCA[(a-1+AS)%AS][(b-1+AS)%AS][bc] == val && abs(a - (a-1+AS)%AS) <= 10 && abs(b - (b-1+AS)%AS) <= 10 && abs(c - bc) <= 10) {return true;} // left bottom
  if (TCA[a][(b+1)%AS][bc] == val && abs(a - a) <= 10 && abs(b - (b+1)%AS) <= 10 && abs(c - bc) <= 10) {return true;} // top
  if (TCA[a][(b-1+AS)%AS][bc] == val && abs(a - a) <= 10 && abs(b - (b-1+AS)%AS) <= 10 && abs(c - bc) <= 10) {return true;} // bottom
  if (TCA[a][b][bc] == val && abs(a - a) <= 10 && abs(b - b) <= 10 && abs(c - bc) <= 10) {return true;} // middle
  if (TCA[(a+1)%AS][b][bc] == val && abs(a - (a+1)%AS) <= 10 && abs(b - b) <= 10 && abs(c - bc) <= 10) {return true;} // right
  if (TCA[(a+1)%AS][(b+1)%AS][bc] == val && abs(a - (a+1)%AS) <= 10 && abs(b - (b+1)%AS) <= 10 && abs(c - bc) <= 10) {return true;} // right top
  if (TCA[(a+1)%AS][(b-1+AS)%AS][bc] == val && abs(a - (a+1)%AS) <= 10 && abs(b - (b-1+AS)%AS) <= 10 && abs(c - bc) <= 10) {return true;} // right bottom
  
  //ABOVE LAYER LAYER
  int ac = (c+1)%AS;
  if (TCA[(a-1+AS)%AS][b][ac] == val && abs(a - (a-1+AS)%AS) <= 10 && abs(b - b) <= 10 && abs(c - ac) <= 10) {return true;} //left
  if (TCA[(a-1+AS)%AS][(b+1)%AS][ac] == val && abs(a - (a-1+AS)%AS) <= 10 && abs(b - (b+1)%AS) <= 10 && abs(c - ac) <= 10) {return true;} // left top
  if (TCA[(a-1+AS)%AS][(b-1+AS)%AS][ac] == val && abs(a - (a-1+AS)%AS) <= 10 && abs(b - (b-1+AS)%AS) <= 10 && abs(c - ac) <= 10) {return true;} // left bottom
  if (TCA[a][(b+1)%AS][ac] == val && abs(a - a) <= 10 && abs(b - (b+1)%AS) <= 10 && abs(c - ac) <= 10) {return true;} // top
  if (TCA[a][(b-1+AS)%AS][ac] == val && abs(a - a) <= 10 && abs(b - (b-1+AS)%AS) <= 10 && abs(c - ac) <= 10) {return true;} // bottom
  if (TCA[a][b][ac] == val && abs(a - a) <= 10 && abs(b - b) <= 10 && abs(c - ac) <= 10) {return true;} // middle
  if (TCA[(a+1)%AS][b][ac] == val && abs(a - (a+1)%AS) <= 10 && abs(b - b) <= 10 && abs(c - ac) <= 10) {return true;} // right
  if (TCA[(a+1)%AS][(b+1)%AS][ac] == val && abs(a - (a+1)%AS) <= 10 && abs(b - (b+1)%AS) <= 10 && abs(c - ac) <= 10) {return true;} // right top
  if (TCA[(a+1)%AS][(b-1+AS)%AS][ac] == val && abs(a - (a+1)%AS) <= 10 && abs(b - (b-1+AS)%AS) <= 10 && abs(c - ac) <= 10) {return true;} // right bottom
  
  return false;
}

int setLim(int a, int b, int c, int val, int[][][] TCA) {

  if (proximityCheck(a,b,c,2,TCA)) {
    return 200;
  } else if (proximityCheck(a,b,c,val,TCA)) {
    return val;
  }
  
  // Default case
  return 1;
}

int[][][] fillTree(int a, int b, int c, int[][][] TCA) {
  
  //BASE LAYER
  TCA[(a-1+AS)%AS][b][c] = 2; //left
  TCA[(a-1+AS)%AS][(b+1)%AS][c] = 2; // left top
  TCA[(a-1+AS)%AS][(b-1+AS)%AS][c] = 2; // left bottom
  TCA[a][(b+1)%AS][c] = 2 ; // top
  TCA[a][(b-1+AS)%AS][c] = 2; // bottom
  TCA[(a+1)%AS][b][c] = 2; // right
  TCA[(a+1)%AS][(b+1)%AS][c] = 2; // right top
  TCA[(a+1)%AS][(b-1+AS)%AS][c] = 2; // right bottom
  
  //BELLOW LAYER
  int bc = (c-1+AS)%AS;
  TCA[(a-1+AS)%AS][b][bc] = 2; //left
  TCA[(a-1+AS)%AS][(b+1)%AS][bc] = 2; // left top
  TCA[(a-1+AS)%AS][(b-1+AS)%AS][bc] = 2; // left bottom
  TCA[a][(b+1)%AS][bc] = 2; // top
  TCA[a][(b-1+AS)%AS][bc] = 2; // bottom
  TCA[a][b][bc] = 2; // middle
  TCA[(a+1)%AS][b][bc] = 2; // right
  TCA[(a+1)%AS][(b+1)%AS][bc] = 2; // right top
  TCA[(a+1)%AS][(b-1+AS)%AS][bc] = 2; // right bottom
  
  //ABOVE LAYER LAYER
   int ac = (c+1)%AS;
  TCA[(a-1+AS)%AS][b][ac] = 2; //left
  TCA[(a-1+AS)%AS][(b+1)%AS][ac] = 2; // left top
  TCA[(a-1+AS)%AS][(b-1+AS)%AS][ac] = 2; // left bottom
  TCA[a][(b+1)%AS][ac] = 2; // top
  TCA[a][(b-1+AS)%AS][ac] = 2; // bottom
  TCA[a][b][ac] = 2; // middle
  TCA[(a+1)%AS][b][ac] = 2; // right
  TCA[(a+1)%AS][(b+1)%AS][ac] = 2; // right top
  TCA[(a+1)%AS][(b-1+AS)%AS][ac] = 2; // right bottom
  
  return TCA;
}

int[][][] setPos(int a, int b, int c, int[][][] TCA, int dir) {

  int bc = (c-1+AS)%AS; 
  int ac = (c+1)%AS;
  float deathprob = random(100);
  float branchprob = random(100);
  
  if (deathprob < 1 || proximityCheck(a,b,c,190,TCA)) { // HEAD DIES
   dir = DEAD;
  } else if (branchprob < 80) {
    /*
    NOMRAL HYPHALE GROWTH
    BRANCHING FACTOR = 0;
    GROTH DIR: STRAIGHT
    GROWTH LENGTH = 1 UNIT
    */
    
    fungiC++;
    
    switch(dir)
    {
    case N:
    TCA[a][(b+1)%AS][c] = N;
    break;
    
    case NE:
    TCA[(a+1)%AS][(b+1)%AS][c] = NE;
    break;
    
    case E:
    TCA[(a+1)%AS][b][c] = E;
    break;
    
    case SE:
    TCA[(a+1)%AS][(b-1+AS)%AS][c] = SE;
    break;
    
    case S:
    TCA[a][(b-1+AS)%AS][c] = S;
    break;
    
    case SW:
    TCA[(a-1+AS)%AS][(b-1+AS)%AS][c] = SW;
    break;
    
    case W:
    TCA[(a-1+AS)%AS][b][c] = W;
    break;
    
    case NW:
    TCA[(a-1+AS)%AS][(b+1)%AS][c] = NW;
    break;
    
    case BN:
    bc = (c-1+AS)%AS;
    TCA[a][(b+1)%AS][bc] = BN;
    break;
    
    case BNE:
    bc = (c-1+AS)%AS;
    TCA[(a+1)%AS][(b+1)%AS][bc] = BNE;
    break;
    
    case BE:
    bc = (c-1+AS)%AS;
    TCA[(a+1)%AS][b][bc] = BE;
    break;
    
    case BSE:
    bc = (c-1+AS)%AS;
    TCA[(a+1)%AS][(b-1+AS)%AS][bc] = BSE;
    break;
    
    case BS:
    bc = (c-1+AS)%AS;
    TCA[a][(b-1+AS)%AS][bc] = S;
    break;
    
    case BSW:
    bc = (c-1+AS)%AS;
    TCA[(a-1+AS)%AS][(b-1+AS)%AS][bc] = BSW;
    break;
    
    case BW:
    bc = (c-1+AS)%AS;
    TCA[(a-1+AS)%AS][b][bc] = BW;
    break;
    
    case BNW:
    bc = (c-1+AS)%AS;
    TCA[(a-1+AS)%AS][(b+1)%AS][bc] = BNW;
    break;
    
    case AN:
    ac = (c+1)%AS;
    TCA[a][(b+1)%AS][ac] = AN;
    break;
    
    case ANE:
    ac = (c+1)%AS;
    TCA[(a+1)%AS][(b+1)%AS][ac] = ANE;
    break;
    
    case AE:
    ac = (c+1)%AS;
    TCA[(a+1)%AS][b][ac] = AE;
    break;
    
    case ASE:
    ac = (c+1)%AS;
    TCA[(a+1)%AS][(b-1+AS)%AS][ac] = ASE;
    break;
    
    case ASS:
    ac = (c+1)%AS;
    TCA[a][(b-1+AS)%AS][ac] = ASS;
    break;
    
    case ASW:
    ac = (c+1)%AS;
    TCA[(a-1+AS)%AS][(b-1+AS)%AS][ac] = ASW;
    break;
    
    case AW:
    ac = (c+1)%AS;
    TCA[(a-1+AS)%AS][b][ac] = AW;
    break;
    
    case ANW:
    ac = (c+1)%AS;
    TCA[(a-1+AS)%AS][(b+1)%AS][ac] = ANW;
    break;
    
    case U:
    ac = (c+1)%AS;
    TCA[a][b][ac] = U;
    break;
    
    case B:
    bc = (c-1+AS)%AS;
    TCA[a][b][bc] = B;
    break;
    
    case DEAD:
    TCA[a][b][c] = DEAD;
    break;
    }
  } else {
    /*
    BRANCHING HYPHALE GROWTH
    BRANCHING FACTOR = 2;
    GROTH DIR: 45 DEG
    GROWTH LENGTH = 1 UNIT
    */
    
    fungiC +=2;
    
    // random factor
    float prob = random(10);
    
    switch(dir)
    {
    case N:
    if (prob < 5) 
    {
    TCA[(a-1+AS)%AS][(b+1)%AS][c] = NW;
    TCA[(a+1)%AS][(b+1)%AS][c] = NE;
    } else 
    {
     TCA[a][(b+1)%AS][bc] = BN;
     TCA[a][(b+1)%AS][ac] = AN;
    }
    // cell itself dies.
    TCA[a][b][c] = DEAD;
    break;
    
    case NE:
    if (prob < 5) 
    {
    TCA[a][(b+1)%AS][c] = N;
    TCA[(a+1)%AS][b][c] = E;
    } else 
    {
    TCA[a][(b+1)%AS][bc] = BNE;
    TCA[a][(b+1)%AS][ac] = ANE;
    }
    // cell itself dies.
    TCA[a][b][c] = DEAD;
    break;
    
    case E:
    if (prob < 5) 
    {
    TCA[(a+1)%AS][(b+1)%AS][c] = NE;
    TCA[(a+1)%AS][(b-1+AS)%AS][c] = SE;
    } else
    {
    TCA[(a+1)%AS][b][bc] = BE;
    TCA[(a+1)%AS][b][ac] = AE;
    }
    break;
    
    case SE:
    if (prob < 5)
    {
    TCA[a][(b-1+AS)%AS][bc] = S;
    TCA[(a+1)%AS][b][c] = E;
    } else 
    {
    TCA[a][(b+1)%AS][bc] = BSE;
    TCA[a][(b+1)%AS][ac] = ASE;
    }
    break;
    
    case S:
    if (prob < 5) 
    {
    TCA[(a+1)%AS][(b-1+AS)%AS][c] = SE;
    TCA[(a-1+AS)%AS][(b-1+AS)%AS][c] = SW;
    } else
    {
    TCA[a][(b-1+AS)%AS][bc] = BS;
    TCA[a][(b-1+AS)%AS][ac] = ASS;
    }
    break;
    
    case SW:
    if (prob < 5)
    {
    TCA[(a-1+AS)%AS][b][c] = W;
    TCA[a][(b-1+AS)%AS][c] = S;
    } else 
    {
    TCA[(a-1+AS)%AS][(b-1+AS)%AS][bc] = BSW;
    TCA[(a-1+AS)%AS][(b-1+AS)%AS][ac] = ASW;
    }
    break;
    
    case W:
    if (prob < 5)
    {
    TCA[(a-1+AS)%AS][(b+1)%AS][c] = NW;
    TCA[(a-1+AS)%AS][(b-1+AS)%AS][c] = SW;
    } else 
    {
    TCA[(a-1+AS)%AS][b][bc] = BW;
    TCA[(a-1+AS)%AS][b][ac] = AW;
    }
    break;
    
    case NW:
    if (prob < 5)
    {
    TCA[(a-1+AS)%AS][(b+1)%AS][c] = N;
    TCA[(a+1)%AS][(b+1)%AS][c] = W;
    } else 
    {
    TCA[(a-1+AS)%AS][(b+1)%AS][bc] = BNW;
    TCA[(a-1+AS)%AS][(b+1)%AS][ac] = ANW;
    }
    break;
    
    
    // BREAK
    
    case BN:
    if (prob < 5) 
    {
    TCA[(a-1+AS)%AS][(b+1)%AS][bc] = BNW;
    TCA[(a+1)%AS][(b+1)%AS][bc] = BNE;
    } else 
    {
     TCA[(a-1+AS)%AS][(b-1+AS)%AS][bc] = BSW;
     TCA[(a+1)%AS][(b-1+AS)%AS][bc] = BSE;
    }
    break;
    
    case BNE:
    if (prob < 5) 
    {
    TCA[a][(b+1)%AS][bc] = BN;
    TCA[(a-1+AS)%AS][(b+1)%AS][c] = BE;
    } else 
    {
    TCA[a][(b+1)%AS][bc] = BN;
    TCA[(a+1)%AS][(b+1)%AS][c] = ANE;
    }
    break;
    
    case BE:
    if (prob < 5) 
    {
    TCA[(a+1)%AS][(b+1)%AS][bc] = BNE;
    TCA[(a+1)%AS][(b-1+AS)%AS][bc] = BSE;
    } else
    {
    TCA[(a+1)%AS][(b+1)%AS][c] = E;
    TCA[a][(b+1)%AS][bc] = B;
    }
    break;
    
    case BSE:
    if (prob < 5)
    {
    TCA[a][(b-1+AS)%AS][bc] = S;
    TCA[(a+1)%AS][(b-1+AS)%AS][c] = BE;
    } else 
    {
    TCA[(a+1)%AS][(b+1)%AS][c] = E;
    TCA[a][(b+1)%AS][bc] = B;
    }
    break;
    
    case BS:
    if (prob < 5) 
    { 
    TCA[(a+1)%AS][(b-1+AS)%AS][c] = SE;
    TCA[(a-1+AS)%AS][(b-1+AS)%AS][c] = SW;
    } else
    {
    TCA[a][(b-1+AS)%AS][bc] = BS;
    TCA[a][(b-1+AS)%AS][ac] = ASS;
    }
    break;
    
    case BSW:
    if (prob < 5)
    {
    TCA[(a-1+AS)%AS][b][bc] = W;
    TCA[a][(b-1+AS)%AS][bc] = S;
    } else 
    {
    TCA[(a-1+AS)%AS][(b-1+AS)%AS][bc] = ASW;
    TCA[(a+1)%AS][(b-1+AS)%AS][bc] = BSE;
    }
    break;
    
    case BW:
    if (prob < 5)
    {
    TCA[(a-1+AS)%AS][b][bc] = W;
    TCA[a][(b-1+AS)%AS][bc] = S;
    } else 
    {
    TCA[(a-1+AS)%AS][(b-1+AS)%AS][bc] = ASW;
    TCA[(a+1)%AS][(b-1+AS)%AS][bc] = BSE;
    }
    break;
    
    case BNW:
    if (prob < 5)
    {
    TCA[(a-1+AS)%AS][(b+1)%AS][c] = N;
    TCA[(a+1)%AS][(b+1)%AS][c] = W;
    } else 
    {
    TCA[(a-1+AS)%AS][(b+1)%AS][bc] = BNW;
    TCA[(a-1+AS)%AS][(b+1)%AS][ac] = ANW;
    }
    break;
    
    
    // BREAK
    
    case AN:
    if (prob < 5)
    {
    TCA[(a-1+AS)%AS][(b-1+AS)%AS][ac] = ASW;
    TCA[(a+1)%AS][(b-1+AS)%AS][ac] = ASE;
    } else 
    {
     TCA[(a-1+AS)%AS][(b+1)%AS][ac] = ANW;
     TCA[(a+1)%AS][(b+1)%AS][ac] = ANE;
    }
    break;
    
    case ANE:
    if (prob < 0) 
    {
    TCA[a][(b+1)%AS][ac] = AN;
    TCA[(a+1)%AS][(b+1)%AS][ac] = AE;
    } else 
    {
    TCA[(a-1+AS)%AS][(b+1)%AS][ac] = U;
    TCA[(a+1)%AS][(b+1)%AS][ac] = E;
    }
    break;
    
    case AE:
    if (prob < 5) 
    {
    TCA[(a+1)%AS][(b+1)%AS][ac] = ANE;
    TCA[(a+1)%AS][(b-1+AS)%AS][ac] = ASE;
    } else
    {
    TCA[(a+1)%AS][(b+1)%AS][ac] = AE;
    TCA[a][(b+1)%AS][ac] = U;
    }
    break;
    
    case ASE:
    if (prob < 5)
    {
    TCA[a][(b-1+AS)%AS][ac] = N;
    TCA[(a+1)%AS][(b-1+AS)%AS][c] = AE;
    } else 
    {
    TCA[(a+1)%AS][(b+1)%AS][c] = E;
    TCA[a][(b+1)%AS][ac] = U;
    }
    break;
    
    case ASS:
    if (prob < 0) 
    { 
    TCA[(a+1)%AS][(b-1+AS)%AS][ac] = NE;
    TCA[(a-1+AS)%AS][(b-1+AS)%AS][ac] = NW;
    } else
    {
    TCA[a][(b-1+AS)%AS][ac] = ASW;
    TCA[a][(b-1+AS)%AS][c] = ASE;
    }
    break;
    
    case ASW:
    if (prob < 10)
    {
    TCA[(a-1+AS)%AS][b][ac] = U;
    TCA[a][(b-1+AS)%AS][ac] = ANE;
    } else 
    {
    TCA[(a-1+AS)%AS][(b-1+AS)%AS][c] = ASW;
    TCA[(a+1)%AS][(b-1+AS)%AS][ac] = ASE;
    }
    break;
    
    case AW:
    if (prob < 5)
    {
    TCA[(a-1+AS)%AS][b][ac] = E;
    TCA[a][(b-1+AS)%AS][ac] = S;
    } else 
    {
    TCA[(a-1+AS)%AS][(b-1+AS)%AS][ac] = ASW;
    TCA[(a+1)%AS][(b-1+AS)%AS][ac] = ASE;
    }
    break;
    
    case ANW:
    if (prob < 5)
    {
    TCA[(a-1+AS)%AS][(b+1)%AS][ac] = N;
    TCA[(a+1)%AS][(b+1)%AS][ac] = W;
    } else 
    {
    TCA[(a-1+AS)%AS][(b+1)%AS][ac] = ANE;
    TCA[(a-1+AS)%AS][(b+1)%AS][ac] = ASE;
    }
    break;
    
    case U:
    if (prob < 5)
    {
    TCA[(a-1+AS)%AS][(b+1)%AS][ac] = ANE;
    TCA[(a-1+AS)%AS][(b-1+AS)%AS][ac] = ASE;
    } else 
    {
    TCA[(a+1)%AS][(b+1)%AS][ac] = ANW;
    TCA[(a+1)%AS][(b-1+AS)%AS][ac] = ASW;
    }
    break;
    
    case B:
    if (prob < 5)
    {
    TCA[(a-1+AS)%AS][(b+1)%AS][bc] = BNE;
    TCA[(a-1+AS)%AS][(b-1+AS)%AS][bc] = BSE;
    } else 
    {
    TCA[(a+1)%AS][(b+1)%AS][bc] = BNW;
    TCA[(a+1)%AS][(b-1+AS)%AS][bc] = BSW;
    }
    break;
    
    case DEAD:
    TCA[a][b][c] = DEAD;
    break; 
    }
  }
  
  // kill the cell to prevent future branches.
  TCA[a][b][c] = DEAD;

  
  return TCA;
}

int[][][] setInfect(int a, int b, int c, int[][][] TCA) {
  // flags mark cell for primary or secondary infection.
  boolean primaryF = false;
  boolean secondaryF = false;
  
  // check for primary infection candidacy
  for (int i = 10; i < 36; i++) {
    if (proximityCheck(a,b,c,i,TCA)) {
      primaryF = true;
    }
  }
  
  // check for secondary infection candidacy
  if (proximityCheck(a,b,c,PRIMARY,TCA) || proximityCheck(a,b,c,SECONDARY,TCA)) {
    secondaryF = true;
  }
  
  if (primaryF && random(100) < (100 * primary)) {
    TCA[a][b][c] = PRIMARY;
    infectedP++;
    return TCA;
  }
  
  if (secondaryF && random(100) < (100 * Vi)) {
    TCA[a][b][c] = SECONDARY;
    infectedS++;
    return TCA;
  }
  
  // no dothing if not enough detail for primary or secondary infection to occur.
  return TCA;
}



int[][][] arrCopy(int[][][] arr) {
  int[][][] temp = new int[AS][AS][AS];
  
  for (int i = 0; i < AS; i++) {
    for (int j = 0; j < AS; j++) {
      for (int k = 0; k < AS; k++) {
          temp[i][j][k] = arr[i][j][k];
       }  
    }
  }
  return temp;
}

void up() {
 int [][][] temp = arrCopy(CA);

 for (int i = 0; i < AS; i++) {
  for (int j = 0; j < AS; j++) {
    for (int k = 0; k < AS; k++) {
      int count = getCount(i,j,k, CA);
      int Bcount = getCount(i,j,k, CA);
      //int Ccount = getCount(i,j,k,CA);
      
      if (CA[i][j][k] >= 10 && CA[i][j][k] <= 35) { // ACTIVE FUNGAL CELL
          temp = arrCopy(setPos(i,j,k,temp,CA[i][j][k]));
      }
      
      if (count > 2 || Bcount > 2) { // IF THE TIP REACHES ANOTHER TIP IT DIES.
        temp[i][j][k] = 0;
      }
      
      // if the cell is a TREE cell
      if (CA[i][j][k] == 2 || CA[i][j][k] == 5) {
        temp = arrCopy(setInfect(i,j,k,temp));
      }
    }
  }
}
CA = arrCopy(temp);
//CA = temp;
}

void thickenTree() {
 for (int i = 0; i < AS; i++) {
  for (int j = 0; j < AS; j++) {
    for (int k = 0; k < AS; k++) {
      // If the cell is a tree
      if (CA[i][j][k] == 5) {
        CA = fillTree(i,j,k, CA);
      } 
    }
  }
 }
 
}

void slim() {
  int [][][] temp = arrCopy(CA);
   for (int i = 0; i < AS; i++) {
    for (int j = 0; j < AS; j++) {
      for (int k = 0; k < AS; k++) {
        int count = getCount(i,j,k, temp);
        
       if (CA[i][j][k] > 0) { // cell is alive
         if (count == 26 && random(1) < 0.2) {
           temp[i][j][k] = 0;
         }
       }
      }
    }
   }
   CA = temp;
}

void pathFinder() {

  for (int i = 0; i < AS; i++) {
    for (int j = 0; j < AS; j++) {
      for (int k = 0; k < AS; k++) {
        
       int count = setLim(i,j,k,lim,CA);
        if (CA[i][j][k] == 0 && count > 50) {
          CA[i][j][k] = count - 1;
        } 
      }
    }

  }
  lim = lim - 1; //decrease lim
}

void keyPressed() {
  if (key == ' ') {
    up();
    print("complete \n");
  }
  
  if (key == 'z') {
    for (int i = 0; i < 30; i++) {
      up();
      print("complete \n");
    }
  }
  
  if (key == 'r') {
    fill();
  }
  
  if (key == 'o') {
    flag = false;
  }
  
  if (key == 'p') {
    for (int i = 0; i < 20; i++) {
      pathFinder();
      int tot = i+1;
      print("Loop: " + tot + "/20\n");
    }
    
    populate();
    
    for (int i = 0; i < 8; i++) {
      up();
      int tot = i+1;
      print("complete: " + tot + "/8 \n");
    }
    print("Simulation terminated");
  }
  
  if (key == '[') {
     for (int i = 0; i < 2; i++) {
      up();
      print("complete \n");
    }
    print("Simulation terminated");
  }
  
  if (key == '1' ) {
    tag = false;
  }
  
  if (key == '2') {
    thickenTree();
  }
  
  if (key == '3') {
    if (printc) {printc = false;} else {printc = true;}
  }
  
  if (key == 'd') {
    print("DIAGONSITCS: \n");
    print("fungal matter: " + fungiC + "\n");
    print("primary infection: " + infectedP + "\n");
    print("secondary infection: " + infectedS + "\n");
  }
}

void showBox(int a, int b, int c, color filler) {
  pushMatrix();
  translate(a*dim+dim/2, b*dim+dim/2, c*dim+dim/2);
  //scale(dim, dim, dim);
  fill(filler);
  // set the ambient and specular properties of the box
  ambient(200);
  specular(255);
  box(2);
  popMatrix();
}

void showTree(int a, int b, int c, color filler) {
  pushMatrix();
  translate(a*dim+dim/2, b*dim+dim/2, c*dim+dim/2);
  //scale(dim, dim, dim);
  fill(filler);
  // set the ambient and specular properties of the box
  ambient(200);
  specular(255);
  box(2);
  popMatrix();
}

void showSimulationBox() {
  pushMatrix();
  translate(AS/2, AS/2, AS/2);
  scale(AS, AS, AS);
  stroke(0);
  strokeWeight(0.9/AS);
  noFill();
  box(1,1,1);
  popMatrix();
}
