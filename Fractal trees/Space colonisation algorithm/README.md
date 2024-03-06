# SPACE COLONISATION ALGORITHM

This program generates tree root systems using the space colonisation algorithm.

## USAGE

Follow the steps below to use the program:

1.  Run the file `generateTree` in Processing IDE.
2.  Observe the tree grow.

## EXPLANATION

The program has three files:

1. The file generateTree sets up the 3D envirnoment and creates the tree.
2. Files Tree and rootSegment are objects used to grow the tree.

The program creates fractal trees by first creating an object of the T class.  This ojbect populates a set of PVectors in an array called window, these PVectors are scaled to equal the size of the environment the tree will grow in.

The function grow() grows the tree, it iteratively goes through the window array and finds the closes rootsegments to each attraction poitn and stores this data in the array hashmap Sv.  Once all the attraction points have been processed the the rootSegments in the tree can grow according to the normalised vector stored in Sv.

This method iteratively adds new rootSegmetns and grows the tree.

The functions printTree() and printWindow() are used to visualise the rootSegemtns and the attraction points respectively.


## Tips

You can increase and decrease the number of attrations points by changing limit of the for loop on line (42).  This can parameter alters the number of branches the tree makes.

