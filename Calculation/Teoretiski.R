

#eta <- viskozitâti var sarçíinât pçc http://www.met.reading.ac.uk/~sws04cdw/viscosity_calc.html


# eta=c(16.1)*10^-3 #Pa*s
# eta=c(14.28)*10^-3 #Pa*s 22.5oC
eta=c(13.6)*10^-3 #Pa*s 23.5oC
#eta=c(0.75)*10^-3 #Pa*s
Temp=295.5
r=1.87/2*10^-6 #m

kB=1.38*10^(-23)
D=kB*Temp/(6*pi*eta*r)

#D=1/2/10
# Delta_t=1/save_rate
# 
# D=D_koef
# N_T=length(parv_x)
# sig_x_prim=0.025*10^-6
# sig_x_prim=sigma2
# sig_x=sig_x_prim/sqrt(2*D*Delta_t)
# #N_dim=2
# 
# P_min=2+2.31*sqrt(2)*sqrt(N_dim)*sig_x
# print(P_min)

# DxSq=sqrt(2*N_dim*D*Delta_t) #Vienâ kadrâ
# #parbaudam vai N_T>P_min
# N_T>2+2.31*sqrt(N_dim)*sig_x
# R_min = (2.59 + 1.34*sig_x)/sqrt(N_dim)*N_T^(-0.502-0.006*sig_x)



#Delta_t=c(1/1.89,1/1.89,1/3.89,1/3.89,rep(1/1.89,6),1/3.89)

Rezultats<-read.table("Brauns/Eksperiments/test/Rezultats.dat")
Rez_D<-Rezultats$Rez_D
D=mean(Rez_D)
Delta_t<-c(rep(1/5.04,4),rep(1/15.19,8))
sig_x=Rezultats$Rez_sigma/sqrt(2*D*Delta_t)
#i=seq(1:length(sig_x))
#if(is.nan(sig_x[i])){sig_x[i]=0.1}
N_T<-Rezultats$NT
N_dim=c(rep(1,6),2,2,2)
N_dim=rep(1,12)
R_min = (2.59 + 1.34*sig_x)/sqrt(N_dim)*N_T^(-0.502-0.006*sig_x)
D_teor_D<-R_min*Rez_D

plot(Rez_D)
indx=1:12
arrows(indx,Rez_D-D_teor_D,indx,Rez_D+D_teor_D,code=3,length=0.02,angle=90)
#arrows(indx,Rez_D-Kludas_D,indx,Rez_D+Kludas_D,code=3,length=0.02,angle=90, col='red')
