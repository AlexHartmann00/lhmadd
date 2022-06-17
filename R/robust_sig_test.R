#'Perform heteroskedasticity robust significance tests
#'
#'Performs heteroskedasticity-robust t-tests for coefficients in a (generalized) linear (mixed) model.
#'
#'@param object Model object of type "lm", "glm", "lmer", "glmer", "nlme"
#'@param type Specifies which model to use for calculating HC standard errors. Can be any of {"HC1","HC3"}
#'
#'@export
robust_sig_test <- function(object,type="HC1"){
  mt <- .modelType(object)
  if(mt == "lm"){
    return(.robust_sig_test_lm(object,type))
  }
  else if(mt == "lme4"){
    return(.robust_sig_test_lme4(object,type))
  }
  else if(mt == "nlme"){
    stop(.robust_sig_test_nlme(object,type))
  }
  else{
    warning("Model is from none of the allowed classes. Treating it as lm")
    return(.johnson_neyman_lm(object,X,M,modrange,resolution,sig.thresh))
  }
}
