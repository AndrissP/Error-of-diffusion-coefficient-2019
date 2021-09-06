###Use together with OLSF_on_data.R or SplitterTracks.R
#' From the data frame in input containing (x,y,time) calculates MSD of the
#' trajectory, then it searches for the optimal number of points for the fit
#' taking the starting values Pinit
#' Returns D values for each axis, as well as x values, number of interactions
#' needed for obtaining convergence and pmin.


### Used by find_pmin below
iterate_pmin<-function(tra, Pinit, time2, nAxes=2){
  da<-aggregate(tra, squareDisplacement, FUN="mean.sd", na.rm=TRUE) #overlapping
  fit<-lm(da$mean[1:Pinit[1]]~time2[1:Pinit[1]])
  
  D_coef<<-fit$coefficients[2]/(2*nAxes)*10^-12
  #sig<<-suppressWarnings(sqrt(fit$coefficients[1]/(2*nAxes))*10^-6)
  x<<-(fit$coefficients[1]*10^-12)/(2*nAxes*D_coef)*save_rate
  
  source(here("Calculation", "p_min_fun.R"))  ###Where p_min_fun is
  Nt=length(time2)
  Pmin=p_min_fun(x, Nt)
  
  
  #######Iterations to find the optimal fit#########
  unname(D_coef) #R adds annoying names to fit output variables when printing out
  unname(x)
  cat(c("iteration \t",  "D  \t\t", "x  \t" ,  "Pmin \n"))
  cat(sprintf("%2i  %16.3e  %12.3e  %8i \n", 0, D_coef, x, Pmin))
  
  ii=1
  while ((Pinit!=Pmin)&(ii < 10)){
    Pinit=Pmin
    if (Pinit[1] == 1){
      D_coef<<-da$mean[1]/(2*nAxes)*10^-12
      x = 0
    } else {
      fit<-lm(da$mean[1:Pinit]~time2[1:Pinit])
      
      #    sig<<-suppressWarnings(sqrt(fit$coefficients[1]/(2*nAxes))*10^-6)
      D_coef<<-fit$coefficients[2]/(2*nAxes)*10^-12
      x<<-(fit$coefficients[1]*10^-12)/(2*nAxes*D_coef)*save_rate
    }
    Pmin=p_min_fun(x, Nt)
    ii=ii+1
    cat(sprintf("%2i  %16.3e  %12.3e  %8i \n",ii-1, D_coef, x, Pmin))
  }
  Res = c(D_coef, x, ii, Pmin )
  return(Res)
}


find_pmin<-function(input_traj, Pinit=c(10,10), nAxes=2){
  ###Calculate MSD and initial try with Pinit
  traj_x=input_traj[,1]
  traj_y=input_traj[,2]
  time=input_traj[,3]
  time2=tail(time,length(time)-1) #time for the plot
  line_break_print = c(paste(rep("=",80), collapse = ""), "\n")
  
  
  if (nAxes==1){
    tra<-tracks(data.frame(time, traj_x))
    cat(line_break_print,"x axis.", " Initial P = ", Pinit[1], "\n",line_break_print)
    fitRes1<-iterate_pmin(tra, Pinit[1], time2, nAxes)
    tra<-tracks(data.frame(time, traj_y))
    cat(line_break_print, "Axis 2.", " Initial P = ", Pinit[2], "\n",line_break_print)
    fitRes2<-iterate_pmin(tra, Pinit[2], time2, nAxes)
    cat(c(line_break_print))
    return(c(fitRes1, fitRes2))
  } else {
    cat(line_break_print," Initial P = ", Pinit[1], "\n",line_break_print)
    tra<-tracks(data.frame(time, traj_x, traj_y))
    fitRes = iterate_pmin(tra, Pinit[1], time2, nAxes)
    cat(c(line_break_print))
    return(fitRes)
  }

}