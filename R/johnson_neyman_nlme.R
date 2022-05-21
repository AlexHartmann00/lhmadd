#'@noRd
.johnson_neyman_nlme <- function(object,X,M,modrange=NULL,resolution=10000,sig.thresh){
  B <- object$coefficients$fixed
  sigm <- vcov(object)
  mr <- modrange
  df <- object$dims$N - length(B)
  return(.johnson_neyman(B,sigm,X,M,mr,df,resolution,sig.thresh))
}
