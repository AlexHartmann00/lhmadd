#'@export
johnson_neyman_lme4 <- function(object,X,M,modrange=NULL,resolution=10000){
  B <- lme4::fixef(object)
  sigm <- vcov(object)
  mr <- range(model.matrix(object)[,colnames(model.matrix(object))==M])
  if(!is.null(modrange))mr <- modrange
  df <- nrow(model.matrix(object)) - length(B)
  return(lhmadd::.johnson_neyman(B,sigm,X,M,mr,df,resolution))
}
