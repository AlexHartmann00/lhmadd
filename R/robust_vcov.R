#'Compute HC variance-covariance matrix
#'
#'Computes heteroskedasticity robust covariance matrix
#'
#'@param object Model object of type "lm", "glm" or "lmer"(lme4)
#'@param modelmat Model matrix, required only if model is of none of the allowed classes
#'@param type Any of "HC1", "HC3", indicating method for calculating HC variance-covariance matrix
#'
#'
#'@return Covariance matrix
#'
#' @export
robust_vcov <- function(object,modelmat=NULL,type="HC1"){
  if(is.null(modelmat)){
    modelmat <- model.matrix(object)
  }
  X <- modelmat
  k <- ncol(X)
  n <- nrow(X)
  if(type == "HC1"){
    hc <- (n/(n-k))*resid(object)^2
  }
  else if(type == "HC3"){
    hc <- resid(object)^2/(1 - hatvalues(object))^2
  }
  else{
    stop("Type must be any of {HC1, HC3}")
  }
  sandwich <- solve(t(X) %*% X)
  meat <- (t(X) %*% (hc*diag(n)) %*% X)
  return(sandwich %*% meat %*% sandwich)
}
