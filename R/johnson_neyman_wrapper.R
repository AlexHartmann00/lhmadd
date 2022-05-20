#'Generate Johnson-Neyman plot
#'
#'Generates a Johnson-Neyman plot for the effect of X on the dependent variable, moderated by M.
#'
#'@param object model object, either "lm","lmer","nlme"
#'@param X name of independent variable
#'@param M name of moderator variable
#'@param modrange moderator range to consider. Defaults to observed range.
#'@param resolution plotting resolution, i.e. count of moderator values to consider
#'
#'@return Johnson-neyman plot as gpplot2 object.
#'
#'@examples
#'x <- rnorm(50)
#'m <- rnorm(50)
#'y <- rnorm(50,x+m,2)
#'model <- lm(y~x*m)
#'plot <- johnson_neyman(model,"x","m")
#'plot + labs(x="Changed x label",y="Changed y label")
#'
#'@export
#'
johnson_neyman <- function(object,X,M,modrange=NULL,resolution=10000){
  if("lm" %in% class(object)){
    return(.johnson_neyman_lm(object,X,M,modrange,resolution))
  }
  else if("lme4" %in% class(object)){
    return(.johnson_neyman_lme4(object,X,M,modrange,resolution))
  }
  else if("nlme" %in% class(object)){
    return(.johnson_neyman_nlme(object,X,M,modrange,resolution))
  }
}
