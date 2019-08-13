# Calculates the diffusion coefficient using the optimal least squares fit for the motion 1D motion (looking at each direction separatelly), from the data files containing containing two rows: x position and y postition in pixels of the bead.
#The input part you should define name of the input data and directory, the pixel size and the save_rate.
#aggregate function might take some 15 seconds to calulate MSD if Nt>1000



library(MotilityLab)
library(polynom)

###Input Part
DataName="Data_6.dat"
Folder='~/Brauns/Experiment/Track/'
pix_size=6.45/28 #*10^-6 #m
save_rate=15.19  #1 /s

Data<-read.csv(sprintf("%s%s",Folder,DataName),head=FALSE)
N_dim=1 #"1" if looked at each of two directions (x and y) separatelly, "2" if looking at 2D motion in xy plane 


###Extract xy postitions from data
posx=Data$V1
posx[posx==0]='NA' #Errors points in Data_4-3-1.dat
posy=Data$V2
posy[posy==0]='NA'
n=length(posx)-1
#plot(y)

time<-(0:n)/save_rate
Delta_t=1/save_rate
suppressWarnings(traj_x<-(as.double(posx))*pix_size) #supressWarnings to ingore NA in data
#traj_x=traj_x-x[1]
suppressWarnings(traj_y<-(as.double(posy))*pix_size) #-as.double(y_err)
plot(traj_y)


#Calculate MSD, D, x using OLSF algorithm
InputForMSD=data.frame(traj_x,traj_y,time)
source("~/Brauns/Experiment/Calculation/MSD_per_time.R")
Result=MSD_per_time(input_traj = InputForMSD, Pinit = c(10,10) )
names(Result)=c("D,x axis, m^2/s","D,y axis, m^2/s","x, x axis", "x, y axis", "Number of iter x", "Number of iter y")
