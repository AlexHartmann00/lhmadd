#'Perform heteroskedasticity robust significance tests
#'
#'Performs heteroskedasticity-robust t-tests for coefficients in a linear mixed model.
#'
#'@param object Model object of type "lmer"(lme4)
#'
#'@export
robust_sig_test_lme4 <- function(object){
  rvcov <- robust_vcov(object)
  rvar <- diag(rvcov)
  coef <- lme4::fixef(object)
  se <- sqrt(rvar)
  t <- coef / se
  df <- nrow(model.matrix(object))-ncol(model.matrix(object))
  p <- pt(-abs(t),df) + 1 - pt(abs(t),df)
  return(cbind(coef,se,t,p))
}
