# MODEL 2: 3D Fungal Growth Simulation


This model simulates the 3D expansion of fungal growth and its interaction with tree root systems. It has been used to investigate the secondary and primary infections of tree root saplings. The model consists of two files: `HYPHAL SIMULATION` and `3D MYCORRHIZAL`.

## HYPHAL SIMULATION

This file contains the fungal simulation in a test environment without any tree roots. Follow the steps below to use the program:

1.  Run the file `generateTree` in Processing IDE.
2.  Press `[space]` to simulate one world tick.
3.  Observe the fungi grow.

## 3D MYCORRHIZAL

This file contains the code for the second model, including the procedurally generated tree roots. Follow the steps below to use the program:

1.  Run the file `generateTree` in Processing IDE.
2.  Let the tree root system grow and then press `[o]` to kill the tree's growth.
3.  Press `[p]` to begin the simulation.
4.  Press `[[]` to continue the experiment and allow further growth.
5.  To get diagnostic information, press `[d]`.


### EXPLANATION

The key concepts in this implementation are the set of TOKENS each describing a potential direction of the fungal growth in 3D.  The method setPos() is then used to update the position of these tokens each world tick.  The tockes have a deathprob and a branchprob which are values that the user can set.  Using these values the method the either grows the fungal tip one cell, branches the tip into two tips seperated by a 45% angle or kills the tip.  The method setInfect() is used to apply infection to the tree root segment cells.  This method uses two boolean values to mark the cell for either primary or secondary infection.

## Tips

Sometimes the Processing environment can load in looking the other way to where the fungi has been populated. The camera can be manipulated using the left cursor. The scroll wheel can also be used to drag the camera to the side.

## CONSIDERATIONS

Please note that the computational intensity of this model is high, and it can take several hours to run fully. Also note that the model uses a hidden render as described in the report, so the tree may not appear to be growing.
