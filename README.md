# 

### There are two folders. *Track* folder contains an example of one original movie of one bead taken by the optical microscope as well as the matlab and two functions *Find_coordinate.m* and *Find_coord.m* used to extract the trajectories of a bead from the film. *Find_coordinate.m* finds the position of the centre of one bead in one frame. It is run by *Find_coord.m* function for each frame and gives as output the trajectory (x,y coordinate) in pixels of the bead. The third output is the detected radius of the bead. The parameters of the experiment are given below. *Track* directory also contains *Data_6.dat* containing a an output of the *Find_coordinate.m* ready to be inputed in the scripts given in the *Calcualtion* folder, which will calculate the diffusion coefficient using the optimal least-squeres fit.





## Parameters for the given example experiment
###The radius of a bead is 1.87 mum, the speed of camera (save rate) 5.04 frames/s, camera magnification 40*0.7 times, pixel size 6.45/28 mum, Temperature 21.5 deg C, viscosity of the fluid (a mixture of water and glicerol) 16.1 *10^(-3) Pa s
