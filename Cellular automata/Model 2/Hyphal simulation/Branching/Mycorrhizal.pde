import peasy.*;
PeasyCam cam;

int dim = 1;
int fade = 2;
int AS = 80/dim;
int [][][] CA;
int box = 5/dim;
public static int[] directions;
HashMap<String, ArrayList<String>> directionMap;

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

// VALID CELL FOR GROWTH
int VALID = 100;

void setup() {
  size(600, 600, P3D); // set up world
  cam = new PeasyCam(this, 100); // create PeasyCam
  cam.setMinimumDistance(50); // define PeasyCam settings
  cam.setMaximumDistance(500);
  cam.setSuppressRollRotationMode();
  directions = new int[] {N, NE, E, SE, S, SW, W, NW, BN, BNE, BE, BSE, BS, BSW, BW, BNW, AN, ANE, AE, ASE, ASS, ASW, AW, ANW, U, B};
  
  //directionMap = setRelations();
  reset();
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
    for (int j = (AS/2)-box; j < (AS/2)+box; j++) {
      for (int k = (AS/2)-box; k < (AS/2)+box; k++) {
        int rand = (int) random(10, 35);
        
        if (random(10) < 0.1) {
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

void searchPoints() {
  CA[0][0][0] = -1;
  CA[AS-1][AS-1][AS-1] = -1;
}

void reset() {
  CA = new int[AS][AS][AS];
  populate2();
  searchPoints();
}

void printCells() {
  for (int i = 0; i < AS; i++) {
    for (int j = 0; j < AS; j++) {
      for (int k = 0; k < AS; k++) {
        if (CA[i][j][k] == fade) {
          showBox(i,j,k, color(100));
        } else if (CA[i][j][k] == fade - 1) {
          showBox(i,j,k, color(255, 204, 0));
        } else if (CA[i][j][k] > 0) {
          showBox(i,j,k, color(255, 204, 0));
        }
      }
    }
  }
}

void draw() {
  background(255);
  lights();
  
  //showSimulationBox();
  printCells();
}

int getCount(int a, int b, int c, int[][][] TCA) {
  int count = 0;
  
  
  //BASE LAYER
  if (TCA[(a-1+AS)%AS][b][c] != DEAD && TCA[(a-1+AS)%AS][b][c] != 0) {count++;} //left
  if (TCA[(a-1+AS)%AS][(b+1)%AS][c] != DEAD && TCA[(a-1+AS)%AS][(b+1)%AS][c] != 0) {count++;} // left top
  if (TCA[(a-1+AS)%AS][(b-1+AS)%AS][c] != DEAD && TCA[(a-1+AS)%AS][(b-1+AS)%AS][c] != 0) {count++;} // left bottom
  if (TCA[a][(b+1)%AS][c] != DEAD && TCA[a][(b+1)%AS][c] != 0) {count++;} // top
  if (TCA[a][(b-1+AS)%AS][c] != DEAD && TCA[a][(b-1+AS)%AS][c] != 0) {count++;} // bottom
  if (TCA[(a+1)%AS][b][c] != DEAD && TCA[(a+1)%AS][b][c] != 0) {count++;} // right
  if (TCA[(a+1)%AS][(b+1)%AS][c] != DEAD && TCA[(a+1)%AS][(b+1)%AS][c] != 0) {count++;} // right top
  if (TCA[(a+1)%AS][(b-1+AS)%AS][c] != DEAD && TCA[(a+1)%AS][(b-1+AS)%AS][c] != 0) {count++;} // right bottom
  
  //BELLOW LAYER
  int bc = (c-1+AS)%AS;
  if (TCA[(a-1+AS)%AS][b][bc] != DEAD && TCA[(a-1+AS)%AS][b][bc] != 0) {count++;} //left
  if (TCA[(a-1+AS)%AS][(b+1)%AS][bc] != DEAD && TCA[(a-1+AS)%AS][(b+1)%AS][bc] != 0) {count++;} // left top
  if (TCA[(a-1+AS)%AS][(b-1+AS)%AS][bc] != DEAD && TCA[(a-1+AS)%AS][(b-1+AS)%AS][bc] != 0) {count++;} // left bottom
  if (TCA[a][(b+1)%AS][bc] != DEAD && TCA[a][(b+1)%AS][bc] != 0) {count++;} // top
  if (TCA[a][(b-1+AS)%AS][bc] != DEAD && TCA[a][(b-1+AS)%AS][bc] != 0) {count++;} // bottom
  if (TCA[a][b][bc] != DEAD && TCA[a][b][bc] != 0) {count++;} // middle
  if (TCA[(a+1)%AS][b][bc] != DEAD && TCA[(a+1)%AS][b][bc] != 0) {count++;} // right
  if (TCA[(a+1)%AS][(b+1)%AS][bc] != DEAD && TCA[(a+1)%AS][(b+1)%AS][bc] != 0) {count++;} // right top
  if (TCA[(a+1)%AS][(b-1+AS)%AS][bc] != DEAD && TCA[(a+1)%AS][(b-1+AS)%AS][bc] != 0) {count++;} // right bottom
  
  //ABOVE LAYER LAYER
   int ac = (c+1)%AS;
  if (TCA[(a-1+AS)%AS][b][ac] != DEAD && TCA[(a-1+AS)%AS][b][ac] != 0) {count++;} //left
  if (TCA[(a-1+AS)%AS][(b+1)%AS][ac] != DEAD && TCA[(a-1+AS)%AS][(b+1)%AS][ac] != 0) {count++;} // left top
  if (TCA[(a-1+AS)%AS][(b-1+AS)%AS][ac] != DEAD && TCA[(a-1+AS)%AS][(b-1+AS)%AS][ac] != 0) {count++;} // left bottom
  if (TCA[a][(b+1)%AS][ac] != DEAD && TCA[a][(b+1)%AS][ac] != 0) {count++;} // top
  if (TCA[a][(b-1+AS)%AS][ac] != DEAD && TCA[a][(b-1+AS)%AS][ac] != 0) {count++;} // bottom
  if (TCA[a][b][ac] != DEAD && TCA[a][b][ac] != 0) {count++;} // middle
  if (TCA[(a+1)%AS][b][ac] != DEAD && TCA[(a+1)%AS][b][ac] != 0) {count++;} // right
  if (TCA[(a+1)%AS][(b+1)%AS][ac] != DEAD && TCA[(a+1)%AS][(b+1)%AS][ac] != 0) {count++;} // right top
  if (TCA[(a+1)%AS][(b-1+AS)%AS][ac] != DEAD && TCA[(a+1)%AS][(b-1+AS)%AS][ac] != 0) {count++;} // right bottom
  
  return count;
}

int[][][] setLim(int a, int b, int c, int[][][] TCA) {
  
  //BASE LAYER
  if (TCA[(a-1+AS)%AS][b][c] == fade) {TCA[(a-1+AS)%AS][b][c] = fade - 1;} //left
  if (TCA[(a-1+AS)%AS][(b+1)%AS][c] == fade) {TCA[(a-1+AS)%AS][(b+1)%AS][c] = fade - 1;} // left top
  if (TCA[(a-1+AS)%AS][(b-1+AS)%AS][c] == fade) {TCA[(a-1+AS)%AS][(b-1+AS)%AS][c] = fade - 1;} // left bottom
  if (TCA[a][(b+1)%AS][c] == fade) {TCA[a][(b+1)%AS][c] = fade  - 1 ;} // top
  if (TCA[a][(b-1+AS)%AS][c] == fade) {TCA[a][(b-1+AS)%AS][c] = fade - 1;} // bottom
  if (TCA[(a+1)%AS][b][c] == fade) {TCA[(a+1)%AS][b][c] = fade - 1;} // right
  if (TCA[(a+1)%AS][(b+1)%AS][c] == fade) {TCA[(a+1)%AS][(b+1)%AS][c] = fade - 1;} // right top
  if (TCA[(a+1)%AS][(b-1+AS)%AS][c] == fade) {TCA[(a+1)%AS][(b-1+AS)%AS][c] = fade - 1;} // right bottom
  
  //BELLOW LAYER
  int bc = (c-1+AS)%AS;
  if (TCA[(a-1+AS)%AS][b][bc] == fade) {TCA[(a-1+AS)%AS][b][bc] = fade - 1;} //left
  if (TCA[(a-1+AS)%AS][(b+1)%AS][bc] == fade) {TCA[(a-1+AS)%AS][(b+1)%AS][bc] = fade - 1;} // left top
  if (TCA[(a-1+AS)%AS][(b-1+AS)%AS][bc] == fade) {TCA[(a-1+AS)%AS][(b-1+AS)%AS][bc] = fade - 1;} // left bottom
  if (TCA[a][(b+1)%AS][bc] == fade) {TCA[a][(b+1)%AS][bc] = fade - 1;} // top
  if (TCA[a][(b-1+AS)%AS][bc] == fade) {TCA[a][(b-1+AS)%AS][bc] = fade - 1;} // bottom
  if (TCA[a][b][bc] == fade) {TCA[a][b][bc] = fade - 1;} // middle
  if (TCA[(a+1)%AS][b][bc] == fade) {TCA[(a+1)%AS][b][bc] = fade - 1;} // right
  if (TCA[(a+1)%AS][(b+1)%AS][bc] == fade) {TCA[(a+1)%AS][(b+1)%AS][bc] = fade - 1;} // right top
  if (TCA[(a+1)%AS][(b-1+AS)%AS][bc] == fade) {TCA[(a+1)%AS][(b-1+AS)%AS][bc] = fade - 1;} // right bottom
  
  //ABOVE LAYER LAYER
   int ac = (c+1)%AS;
  if (TCA[(a-1+AS)%AS][b][ac] == fade) {TCA[(a-1+AS)%AS][b][ac] = fade - 1;} //left
  if (TCA[(a-1+AS)%AS][(b+1)%AS][ac] == fade) {TCA[(a-1+AS)%AS][(b+1)%AS][ac] = fade - 1;} // left top
  if (TCA[(a-1+AS)%AS][(b-1+AS)%AS][ac] == fade) {TCA[(a-1+AS)%AS][(b-1+AS)%AS][ac] = fade - 1;} // left bottom
  if (TCA[a][(b+1)%AS][ac] == fade) {TCA[a][(b+1)%AS][ac] = fade - 1;} // top
  if (TCA[a][(b-1+AS)%AS][ac] == fade) {TCA[a][(b-1+AS)%AS][ac] = fade - 1;} // bottom
  if (TCA[a][b][ac] == fade) {TCA[a][b][ac] = fade - 1;} // middle
  if (TCA[(a+1)%AS][b][ac] == fade) {TCA[(a+1)%AS][b][ac] = fade - 1;} // right
  if (TCA[(a+1)%AS][(b+1)%AS][ac] == fade) {TCA[(a+1)%AS][(b+1)%AS][ac] = fade - 1;} // right top
  if (TCA[(a+1)%AS][(b-1+AS)%AS][ac] == fade) {TCA[(a+1)%AS][(b-1+AS)%AS][ac] = fade - 1;} // right bottom
  
  return TCA;
}

int[][][] setPos(int a, int b, int c, int[][][] TCA, int dir) {

  int bc = (c-1+AS)%AS; 
  int ac = (c+1)%AS;
  float deathprob = random(100);
  float branchprob = random(100);
  
  if (deathprob < 1) { // HEAD DIES
   dir = DEAD;
  } else if (branchprob < 85) {
    /*
    NOMRAL HYPHALE GROWTH
    BRANCHING FACTOR = 0;
    GROTH DIR: STRAIGHT
    GROWTH LENGTH = 1 UNIT
    */
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
      print("1");
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

void update() { //updates the world each tick
   int [][][] temp = arrCopy(CA);
   int prob = 1;
   for (int i = 0; i < AS; i++) {
    for (int j = 0; j < AS; j++) {
      for (int k = 0; k < AS; k++) {
        int count = getCount(i,j,k, CA);
        int Bcount = getCount(i,j,k, CA);
        
        if (CA[i][j][k] == fade && Bcount > 2) {
          temp[i][j][k] = fade - 1;
        }
        
        if (CA[i][j][k] == 0 && count == 1 && Bcount < 2 && random(100) < prob*5) {
          CA = arrCopy(setLim(i,j,k,CA));
          temp = arrCopy(setLim(i,j,k,temp));
          temp[i][j][k] = fade;
        } else if (CA[i][j][k] == 0 && Bcount == 1 && random(1000) < 1) {
        }
      }
    }
  }
  CA = arrCopy(temp);
}

void up() {
 int [][][] temp = arrCopy(CA);
 
 for (int i = 0; i < AS; i++) {
  for (int j = 0; j < AS; j++) {
    for (int k = 0; k < AS; k++) {
      int count = getCount(i,j,k, CA);
      int Bcount = getCount(i,j,k, CA);
      
      if (CA[i][j][k] > 0) { // ACTIVE FUNGAL CELL
          temp = arrCopy(setPos(i,j,k,temp,CA[i][j][k]));
      }
      
      if (count > 2 || Bcount > 2) { // IF THE TIP REACHES ANOTHER TIP IT DIES.
        temp[i][j][k] = 0;
      }
    }
  }
}
CA = arrCopy(temp);
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

void keyPressed() {
  if (key == ' ') {
    up();
  }
  
  if (key == 'r') {
    slim();
  }
}

void showBox(int a, int b, int c, color filler) {
  pushMatrix();
  translate(a*dim+dim/2, b*dim+dim/2, c*dim+dim/2);
  scale(dim, dim, dim);
  fill(filler);
  strokeWeight(1.0/dim);
  box(1,1,1);
  popMatrix();
}

void showSimulationBox() {
  pushMatrix();
  translate(80/2, 80/2, 80/2);
  scale(80, 80, 80);
  stroke(0);
  strokeWeight(0.9/80);
  noFill();
  box(1,1,1);
  popMatrix();
}
