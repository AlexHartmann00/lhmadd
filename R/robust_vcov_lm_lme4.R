#'Compute HC variance-covariance matrix
#'
#'Computes heteroskedasticity robust covariance matrix
#'
#'@param object Model object of type "lm", "glm" or "lmer"(lme4)
#'
#'@return Covariance matrix
#'
#'
.robust_vcov_lm_lme4 <- function(object){
  X <- model.matrix(object)
  k <- ncol(X)
  n <- nrow(X)
  hc1 <- (n/(n-k))*resid(object)^2
  sandwich <- solve(t(X) %*% X)
  meat <- (t(X) %*% (hc1*diag(n)) %*% X)
  vce <- solve(t(X) %*% X) %*%
    (t(X) %*% (hc1*diag(n)) %*% X) %*%
    solve(t(X) %*% X)
  return(sandwich %*% meat %*% sandwich)
}
