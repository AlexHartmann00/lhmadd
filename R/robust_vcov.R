#'Compute HC variance-covariance matrix
#'
#'Computes heteroskedasticity robust covariance matrix
#'
#'@param object Model object of type "lm", "glm" or "lmer"(lme4)
#'
#'@return Covariance matrix
#'
#'@export
robust_vcov <- function(object){
  mt <- .modelType(object)
  if(mt == "nlme"){
    return(.robust_vcov_nlme(object))
  }
  else{
    return(.robust_vcov_lm_lme4(object))
  }
}
