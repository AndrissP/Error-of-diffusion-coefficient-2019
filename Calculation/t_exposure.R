############# Check what value is the exposure and comare it with the localization error ###############
library(bbmle) #max likelihood
Data="4-2"
Dati<-read.csv(sprintf("~/Brauns/Eksperiments/4/Non-moving-%s.dat",Data),head=FALSE)

parv_y_meas=parv_y[3300:5500]
#########Max piedzisana
LL <- function(sigma, mu=0) {
  #parv_x1=time[20:length(parv_x)]*k+b
  R=parv_y_meas
  R = suppressWarnings(dnorm(R,mean = mu, sd = sigma, log = TRUE))
  -sum(R)
}
fit1 <- mle2(minuslogl = LL, start = list(mu = 6.0,sigma=0.01)) #, fixed=list(), method = "L-BFGS-B", method = "L-BFGS-B",lower = c(-Inf, -Inf), upper = c(Inf, Inf),fixed=list(D_koef = 0.5,N=9)

plot(time,parv_y)
lines(polynomial(fit1@coef[2:3]),lty=2,lwd=2,col=3)

tra<-tracks(data.frame(time, parv_y)) #,parv_kluday ,parv_y
da1<-aggregate(tra, squareDisplacement, FUN="mean.sd",na.rm=TRUE) #parkl
time2=tail(time,length(time)-1)
max_num=2000
plot(time2[1:max_num],da1$mean[1:max_num],xlab='time, s', ylab='MSD',xlim=c(0,time2[max_num]),ylim=c(0,da1$mean[max_num]))
fit1<-lm(da1$mean[1:10]~time2[1:10])
abline(fit1,col='red',lwd=2)
sigma=sqrt(fit1$coefficients[1]/(2*N_dim)) #mum

Rezult_sigma=c(0.006,0.0064,0.0086,NA) #mum with MSD
Rezult_sigma=c(0.0018, 0.0021, 0.0025,NA) #mum with maximum likelihood
t_E=0.05 #s
expos_err=2/3*D*t_E*10^12 #mum
