#'@noRd
.johnson_neyman_lm <- function(object,X,M,modrange=NULL,resolution=10000){
  B <- coef(object)
  sigm <- vcov(object)
  mr <- range(model.matrix(object)[,colnames(model.matrix(object))==M])
  if(!is.null(modrange))mr <- modrange
  df <- nrow(model.matrix(object)) - length(B)
  return(.johnson_neyman(B,sigm,X,M,mr,df,resolution))
}
