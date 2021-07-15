## Overview
The project consists of two folders. *Calculation* folder contains a script in R language which calculates the diffusion coefficient using the OLSF from a given trajectory.
The calculation can be perfomed of an examples of experimental results provided in folder *Track*. 

## Prerequsites
### For performing OLSF on a data file with coordinates
* R version>2.0
* Packages MotilityLab, pbapply and icesTAF installed. Possible to install either through *"Tools"* in .. or by typing in console *"install.packages(XLConnect, MotilityLab,icesTAF)"*
### For extracting coordinates from an optical microscope movie
* Matlab

*Calculation* folder contains a script in R language calculating the diffusion coefficient using the OLSF from a given trajectory. *MainSolve1D.R* is the master script runing *MSD_per_time.R* and *P_min_fun.R* as shell functions. To run the function, open the *MainSolve1D.R* in R and read the first lines with the explanation.

## Content
*Track* directory contains an example data file *Data_6.dat* containing the result of a tracking experiment of bead in a liquid. It contains (x, y, R) values for each measurement, where (x,y) are the x and y coordinates of the bead in pixels, and R is the detected radius of the bead. 

*Track* folder also contains the original movie of the experiment obtained by the optical microscope, *6.tif*, providing the data mentioned above. In addition, it contains a matlab function *Find_coord.m* used to extract the trajectories of a bead from the film. *Find_coord.m* repeatedly runs *Find_coordinate.m* function that finds the position of the centre of one bead in only one frame. The output of *Find_coord.m* gives as output (x, y, R) as explained above.

To run the matlab function, run *Find_coord.m* in Matlab, reading beforehand the explanation and instructions below the definition of the function.



### Parameters for the given example experiment
The radius of a bead is 1.87 mum, the speed of camera (save rate) 5.04 frames/s, camera magnification 40*0.7 times, pixel size 6.45/28 mum, Temperature 21.5 deg C, viscosity of the fluid (a mixture of water and glicerol) 16.1 *10^(-3) Pa s
