#'Generate Johnson-Neyman plot
#'
#'Generates a Johnson-Neyman plot for the effect of X on the dependent variable, moderated by M. Performs two-sided t-Test on coefficient.
#'
#'@param object model object, either "lm","lmer","nlme"
#'@param X name of independent variable
#'@param M name of moderator variable
#'@param modrange moderator range to consider. Defaults to observed range.
#'@param resolution plotting resolution, i.e. count of moderator values to consider
#'@param sig.thresh significance threshold alpha. Defaults to 0.05.
#'
#'@return Johnson-neyman plot as gpplot2 object.
#'
#'@examples
#'#Generate base plot for linear model
#'x <- rnorm(50)
#'m <- rnorm(50)
#'y <- rnorm(50,x*m,2)
#'model <- lm(y~x*m)
#'plot <- johnson_neyman(model,"x","m")
#'
#'# Add custom ggplot2 elements
#'plot + labs(x="Changed x label",y="Changed y label")
#'
#'#mixed models
#'x <- rnorm(50)
#'m <- rnorm(50)
#'y <- rnorm(50,x*m,2)
#'g <- sample(1:10,50,TRUE)
#'model <- lme4::lmer(y~m*x + (1|g))
#'johnson_neyman(model,"x","m")
#'
#'@export
#'
johnson_neyman <- function(object,X,M,modrange=NULL,resolution=10000,sig.thresh=0.05){
  if("lm" %in% class(object)){
    return(.johnson_neyman_lm(object,X,M,modrange,resolution,sig.thresh))
  }
  else if("lmerMod" %in% class(object)){
    return(.johnson_neyman_lme4(object,X,M,modrange,resolution,sig.thresh))
  }
  else if("nlme" %in% class(object)){
    return(.johnson_neyman_nlme(object,X,M,modrange,resolution,sig.thresh))
  }
  else{
    warning("Model is from neither of the allowed classes. Treating it as lm")
    return(.johnson_neyman_lm(object,X,M,modrange,resolution,sig.thresh))
  }
}
