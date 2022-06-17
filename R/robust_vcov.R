#'Compute HC variance-covariance matrix
#'
#'Computes heteroskedasticity robust covariance matrix
#'
#'@param object Model object of type "lm", "glm" or "lmer"(lme4)
#'
#'@return Covariance matrix
#'
<<<<<<< HEAD
#' @export
robust_vcov <- function(object,modelmat,type="HC1"){
  X <- modelmat
  k <- ncol(X)
  n <- nrow(X)
  if(type == "HC1"){
    hc <- (n/(n-k))*resid(object)^2
  }
  else if(type == "HC3"){
    hc <- resid(m)^2/(1 - hatvalues(m))^2
  }
  else{
    stop("Type must be any of {HC1, HC3}")
  }
  sandwich <- solve(t(X) %*% X)
  meat <- (t(X) %*% (hc*diag(n)) %*% X)
  vce <- solve(t(X) %*% X) %*%
    (t(X) %*% (hc*diag(n)) %*% X) %*%
    solve(t(X) %*% X)
  return(sandwich %*% meat %*% sandwich)
=======
#'@export
robust_vcov <- function(object){
  mt <- .modelType(object)
  if(mt == "nlme"){
    return(.robust_vcov_nlme(object))
  }
  else{
    return(.robust_vcov_lm_lme4(object))
  }
>>>>>>> 8b4f4a6ba07dd8b30d654bd07e846fd592e547dc
}
