#'Find out what type the model is
#'
#'@param object model object
#'
#'@return string specifying package the model originates frmo
#'
#'
.modelType <- function(object){
  if("lm" %in% class(object)){
    return("lm")
  }
  else if("lmerMod" %in% class(object) || "glmerMod" %in% class(object) || attr(class(mod),"package") == "lmerTest"){
    return("lme4")
  }
  else if("nlme" %in% class(object) || "lme" %in% class(object)){
    return("nlme")
  }
  else{
    return("None")
  }
}
