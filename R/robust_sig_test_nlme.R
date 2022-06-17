#'Perform heteroskedasticity robust significance tests
#'
#'Performs heteroskedasticity-robust t-tests for coefficients in a (generalized) linear model.
#'
#'@param object Model object of type "nlme"
#'
#'
.robust_sig_test_nlme <- function(object,type="HC1"){
  rvcov <- robust_vcov(object,model.matrix(object$terms,nlme::getData(object)),type)
  rvar <- diag(rvcov)
  coef <- coefficients(object)
  se <- sqrt(rvar)
  t <- coef / se
  df <- nrow(model.matrix(object))-ncol(model.matrix(object))
  p <- pt(-abs(t),df) + 1 - pt(abs(t),df)
  return(cbind(coef,se,t,p))
}
