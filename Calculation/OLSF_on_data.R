#' Calculates the diffusion coefficient using the optimal least squares fit for
#' the motion of a bead, from the data files containing two rows:
#' x position and y position in pixels of the bead.
#' 
#' The input part below should define the name of the input data "data_name" and
#' directory "data_dir", the pixel size (in mum) and the save_rate (frames/sec).
#' In nAxes indicate if you want to look at the direction in each axis separately
#' (x and y axis) - Axes=1 or if you want to look at the 2D motion - nAxes=2.
#' The output is the calculated diffusion coefficient D, the reduced squared error x,
#' number of iterations of the algorithm until optimal number of fitting points pmin
#' predicted before the iteration was the same as after the iteration, and obtained pmin.
#' For the 1D case the result gives values for each axis.
#' aggregate function might take some 15 seconds to calculate MSD if Nt>1000 on
#' a normal laptop.

### Declare all paths relative to the .git folder
here::i_am("Calculation/OLSF_on_data.R") 
library(MotilityLab)
library(here)

# dr_here()

###Input Part
data_name = "Data_6.dat"
data_dir = 'Track/'
pix_size = 6.45/28 #*10^-6 #m
save_rate = 5.04  #1 /
nAxes = 1 # "1" if looked at each of two directions (x and y) separately,
        # "2" if looking at 2D motion in xy plane (recommended)

###Read the data
data<-read.csv(here(data_dir,data_name),head=FALSE)

###Extract xy positions from data
posx=data$V1
posx[posx==0]='NA' #Errors points in Data_4-3-1.dat
posy=data$V2
posy[posy==0]='NA'
n=length(posx)-1

time<-(0:n)/save_rate
Delta_t=1/save_rate

Nt=length(time)-1

#supressWarnings to ingore NA in data the trajectory in #mu m
suppressWarnings(traj_x<-(as.double(posx))*pix_size)
suppressWarnings(traj_y<-(as.double(posy))*pix_size) #-as.double(y_err)

#It is possible to draw a trajectory
#plot(traj_y)

#Calculate MSD, D, x using OLSF algorithm
in_for_MSD=data.frame(traj_x, traj_y, time)

source(here("Calculation","find_pmin.R"))
Pinit=round(c(Nt/10, Nt/10),0)
Result=find_pmin(input_traj=in_for_MSD, Pinit=Pinit, nAxes=nAxes )

print_result <- function(ax, result){
  cat(do.call(sprintf, c(ax, data.frame(t(c(result))),
                       fmt = "%s %13.4e  %12.4e  %12i  %12i \n")))
}

cat("Result:", "\n")
if (nAxes==1) {
  Result1 = Result[1:4]
  Result2 = Result[5:8]
  cat("\t D, m^2/s \t","x", "Number of iterations \t", "Pmin \n")
  print_result("x axis:", Result1)
  print_result("y axis:", Result2)
  
} else {
  cat("\t D, m^2/s \t","x \t", "Number of iterations   ", "Pmin \n")
  print_result("   ", Result)
}