########Check changes during the random walk, divide trajectory into intervals#############
#Not complete


library(MotilityLab)
Data="4-3-2"
Dati<-read.csv(sprintf("~/Brauns/Eksperiments/4/Data_%s.dat",Data),head=FALSE)
Pinit=c(20,20) #initial nr of approximation points

N_dim=1 #1, ja apskata tikai x un y asi atseviðíi
size_of_split = 1000 #how long should the trajcetories be
Nr_tracks=length(parv_x)%/%size_of_split  #How many tracks can be divided
pix_size=6.45/28 #*10^-6 #m
save_rate=15.19 #
x=Dati$V1
x[x==0]='NA'

y=Dati$V2
y[y==0]='NA'

Delta_t=1/save_rate
suppressWarnings(parv_x<-(as.double(x))*pix_size) #jo in NA datos round( ,0) -as.double(x_err)
suppressWarnings(parv_y<-(as.double(y))*pix_size) #-as.double(y_err)

mat_x=matrix(parv_x[1:(Nr_tracks*size_of_split)],size_of_split)
mat_y=matrix(parv_y[1:(Nr_tracks*size_of_split)],size_of_split)
n=length(mat_x[,1])-1
time<-(0:n)/save_rate
time2=tail(time,length(time)-1)

my_mat<-array(c(mat_x,mat_y),dim=c(length(mat_x[,1]),length(mat_x[1,]),2))
#dim(my_mat)=c(3,6,2)
# 
# MSD_per_time<-function(my_mat){
#   Pfit=Pinit
#   parv_x=my_mat[,1]
#   parv_y=my_mat[,2]
#   tra<-tracks(data.frame(time, parv_x)) #,parv_kluday ,parv_y
#   da1<-aggregate(tra, squareDisplacement, FUN="mean.sd",na.rm=TRUE) #parkl
#   tra<-tracks(data.frame(time,parv_y)) #,parv_kluday
#   da2<-aggregate(tra, squareDisplacement, FUN="mean.sd",na.rm=TRUE) #parkl
#   fit1<-lm(da1$mean[1:Pfit[1]]~time2[1:Pfit[1]])
#   fit2<-lm(da2$mean[1:Pfit[2]]~time2[1:Pfit[2]])
#   sig<<-suppressWarnings(sqrt(fit1$coefficients[1]/(2*N_dim))*10^-6)
#   D_koef<<-fit1$coefficients[2]/(2*N_dim)*10^-12
#   sig2<<-suppressWarnings(sqrt(fit2$coefficients[1]/(2*N_dim))*10^-6)
#   D_koef2<<-fit2$coefficients[2]/(2*N_dim)*10^-12
#   source("~/Brauns/Eksperiments/Eksperiments/P_min_fun.R")  ###Where P_min_fun is
#   Pmin=round(P_min_fun(Nr_outp=2),0)
#   
#   #######Iterations to find the best fit#########
#   stopNr=1
#   while ((Pfit[1]!=Pmin[1])&(stopNr < 10)){
#     Pfit[1]=Pmin[1]
#     fit1<-lm(da1$mean[1:Pfit[1]]~time2[1:Pfit[1]])
#     sig<<-suppressWarnings(sqrt(fit1$coefficients[1]/(2*N_dim))*10^-6)
#     D_koef<<-fit1$coefficients[2]/(2*N_dim)*10^-12
#     source("~/Brauns/Eksperiments/Eksperiments/P_min_fun.R")  ###Where P_min_fun is
#     Pmin=round(P_min_fun(Nr_outp=2),0)
#     stopNr=stopNr+1
#   }
#   stopNr=1 
#   while ((Pfit[2]!=Pmin[2])&(stopNr < 10)){
#     Pfit[2]=Pmin[2]
#     fit2<-lm(da2$mean[1:Pfit[2]]~time2[1:Pfit[2]])
#     sig2<<-suppressWarnings(sqrt(fit2$coefficients[1]/(2*N_dim))*10^-6)
#     D_koef2<<-fit2$coefficients[2]/(2*N_dim)*10^-12
#     source("~/Brauns/Eksperiments/Eksperiments/P_min_fun.R")  ###Where P_min_fun is
#     Pmin=round(P_min_fun(Nr_outp=2),0)
#     stopNr=stopNr+1
#   }
#   
#   
#   return(c(D_koef,D_koef2,sig,sig2))
# }


source("~/Brauns/Eksperiments/Eksperiments/MSD_per_time.R")
D_coefs<-apply(my_mat,2,MSD_per_time)

Rez_D<-D_coefs[1:2,]
D_M=mean(Rez_D)
sig_x=D_coefs[3:4,]/sqrt(2*D_M*Delta_t)
sig_x[is.nan(sig_x)]=0.1
#i=seq(1:length(sig_x))
#if(is.nan(sig_x[i])){sig_x[i]=0.1}
N_T<-size_of_split
R_min = (2.59 + 1.34*sig_x)/sqrt(N_dim)*N_T^(-0.502-0.006*sig_x)
D_teor_D<-R_min*Rez_D

plot(D_coefs[1,])
points(D_coefs[2,], pch=3, col='green')
indx=1:Nr_tracks
arrows(indx,(Rez_D-D_teor_D)[1,],indx,(Rez_D+D_teor_D)[1,],code=3,length=0.02,angle=90)
arrows(indx,(Rez_D-D_teor_D)[2,],indx,(Rez_D+D_teor_D)[2,],code=3,length=0.02,angle=90,col='green')

