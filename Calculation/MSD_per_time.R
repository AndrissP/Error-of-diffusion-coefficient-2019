###Use together with MainSolve1D.R or SplitterTracks.R
#From the data frame in input containing (x,y,time) calculates MSD of the trajectory, then it searches for the optimal number of points for the fit taking the starting values Pinit
#Returns D values for each axis, as well as x values un number of interations needed for obtaining convergance.

MSD_per_time<-function(input_traj,Pinit=c(10,10)){
  ###Calculate MSD and initial try with Pinit
  traj_x=input_traj[,1]
  traj_y=input_traj[,2]
  time=input_traj[,3]
  time2=tail(time,length(time)-1) #time for the plot
  
  tra<-tracks(data.frame(time, traj_x)) #traj_y
  da1<-aggregate(tra, squareDisplacement, FUN="mean.sd",na.rm=TRUE) #overlapping
  tra<-tracks(data.frame(time,traj_y)) 
  da2<-aggregate(tra, squareDisplacement, FUN="mean.sd",na.rm=TRUE) #overlapping
  fit1<-lm(da1$mean[1:Pinit[1]]~time2[1:Pinit[1]])
  fit2<-lm(da2$mean[1:Pinit[2]]~time2[1:Pinit[2]])
  
  
  D_coef<<-fit1$coefficients[2]/(2*N_dim)*10^-12
  #sig<<-suppressWarnings(sqrt(fit1$coefficients[1]/(2*N_dim))*10^-6)
  x<<-(fit1$coefficients[1]*10^-12)/(2*N_dim*D_coef)*save_rate
  D_coef2<<-fit2$coefficients[2]/(2*N_dim)*10^-12
  x2<<-(fit2$coefficients[1]*10^-12)/(2*N_dim*D_coef2)*save_rate
  #sig2<<-suppressWarnings(sqrt(fit2$coefficients[1]/(2*N_dim))*10^-6)
  source("~/Brauns/Experiment/Calculation/P_min_fun.R")  ###Where P_min_fun is
  Pmin=P_min_fun(Nr_outp=2)

  
  #######Iterations to find the optimal fit#########
  stopNr=1 #Stop number is to check if the iteration has a sequence, where it repeates and does not diverge, some kind of number of iterations
  while ((Pinit[1]!=Pmin[1])&(stopNr < 10)){
    Pinit[1]=Pmin[1]
    if (Pinit[1] == 1){
      D_coef<<-da1$mean[1]/(2*N_dim)*10^-12
      x = 0
    } else {
      fit1<-lm(da1$mean[1:Pinit[1]]~time2[1:Pinit[1]])
      #    sig<<-suppressWarnings(sqrt(fit1$coefficients[1]/(2*N_dim))*10^-6)
      D_coef<<-fit1$coefficients[2]/(2*N_dim)*10^-12
      x<<-(fit1$coefficients[1]*10^-12)/(2*N_dim*D_coef)*save_rate
    }
source("~/Brauns/Experiment/Calculation/P_min_fun.R")  ###Where P_min_fun is
    Pmin=P_min_fun(Nr_outp=2)
    stopNr=stopNr+1
  }
  stopNr2=1 
  while ((Pinit[2]!=Pmin[2])&(stopNr2 < 10)){
    Pinit[2]=Pmin[2]
    if (Pinit[2]==1) {
      D_coef2<<-da2$mean[1]/(2*N_dim)*10^-12
      x = 0   
    } else{
      fit2<-lm(da2$mean[1:Pinit[2]]~time2[1:Pinit[2]])
      #sig2<<-suppressWarnings(sqrt(fit2$coefficients[1]/(2*N_dim))*10^-6)
      D_coef2<<-fit2$coefficients[2]/(2*N_dim)*10^-12
      x2<<-(fit2$coefficients[1]*10^-12)/(2*N_dim*D_coef2)*save_rate
    }
    source("~/Brauns/Experiment/Calculation/P_min_fun.R")  ###Where P_min_fun is
    Pmin=round(P_min_fun(Nr_outp=2),0)
    stopNr2=stopNr2+1
  }
  
  return(c(D_coef,D_coef2,x,x2,stopNr,stopNr2))
}
