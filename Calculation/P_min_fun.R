### Used together with MainSolve.R
##### Calculates Pmin using the Analytic function ###########
Nt=length(traj_x)

P_min_fun=function(Nr_outp=2){ #Nr_outp=2 if Ndim=1.
  x=ifelse(is.na(x),0,x)
  
  if (x < 0){
    P_min=2
  } else if (sqrt((2 + 4*x + 3*x^2)/Nt) > sqrt((9. + 10.*x + 5.75*x^2)/Nt)+x){
    d=13*(22564 + 143244*x + 307017*x**2 + 242298*x**3 + 117*sqrt(as.complex(-18588 - 301664*x - 2183668*x**2 - 8613144*x**3 - 19346715*x**4 - 23538060*x**5 - 12247200*x**6)))**0.3333333333333333
    P_min=sqrt((2**(2/3)*7**(1/3)*d**2 + 52*d*(19 + 21*x) + 338*2**(1/3)*7**(2/3)*(301 + 1392*x + 2007*x**2))/d)/(13.*sqrt(6))
  } else {
    P_min=1
  }
  #cat("\n P_min = ",P_min)
  
  if (Nr_outp==2){
    x2=ifelse(is.na(x2),0,x2)
    if (x2<0){
      P_min2=2
    } else if (sqrt((2 + 4*x2 + 3*x2^2)/Nt) > sqrt((9. + 10.*x2 + 5.75*x2^2)/Nt)+x2) {
      d=13*(22564 + 143244*x2 + 307017*x2**2 + 242298*x2**3 + 117*sqrt(as.complex(-18588 - 301664*x2 - 2183668*x2**2 - 8613144*x2**3 - 19346715*x2**4 - 23538060*x2**5 - 12247200*x2**6)))**0.3333333333333333
      P_min2=sqrt((2**(2/3)*7**(1/3)*d**2 + 52*d*(19 + 21*x) + 338*2**(1/3)*7**(2/3)*(301 + 1392*x + 2007*x**2))/d)/(13.*sqrt(6))
    } else {
      P_min2=1
    }
    #cat("\n P_min_2 = ", P_min2)
    return(c(round(Re(P_min),0), round(Re(P_min2),0)))
  } else {
    return(P_min)
  }
}


# P_min_fun=function(Nr_outp=2){
#   N_T=length(traj_x)
#   
#   sig_x=sig/sqrt(2*D_coef*Delta_t)
#   P_min=2+2.31*sqrt(2)*sqrt(N_dim)*sig_x
#   if (is.nan(P_min)) {P_min=2}
#   #cat("\n P_min = ",P_min)
#   
#   if (Nr_outp==2){
#     sig_y=sig2/sqrt(2*D_coef2*Delta_t)
#     P_min2=2+2.31*sqrt(2)*sqrt(N_dim)*sig_y
#     if (is.nan(P_min2)) {P_min2=2}
#     #cat("\n P_min_2 = ", P_min2)
#     return(c(P_min, P_min2))
#   } else {
#     return(P_min)
#   }
# }


