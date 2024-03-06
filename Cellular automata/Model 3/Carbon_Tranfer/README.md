# MODEL 3: RESOURCE PROPAGATION


This model explores the resoruce propagation of CMNs.

## USAGE

Follow the steps below to use the program:

1.  Run the file `Carbon Transfer` in Processing IDE.
2.  Press `[6]` to simulate one world tick.
3.  Observe the cellular automata propagated the resources.
4. Press `[3]` to view the diagnostics.


## EXPLANATION

### SETUP

The world is setup with a random distribution of TREENODE cells.  This is done using the method createSimpleCity().  The printCells() method is used to display the CA array and shows cells with high abundance in red and cells in low abundance in green.

### PROPAGATION

The method helpTransfer() is used to udpate the CA array each tick.  This method uses a swtich statement to switch between the different stages of the propagation.  First, the method generateHeightmap() uses the Inverse Interpolation method to create a resourcemap of the world.  The input poitns into this method are the current values of the TREENODES in the simulation.

The helpTransfer() method then iteratively uses the propagateResourceStart() and propagateResource() methods to move the RESOURCE cells through the world as described in the report.


