#'Run Bootstrapped regression
#'
#'runs repeated regressions on bootstrap samples, testing coefficients via z-distribution using bootstrapped standard errors.
#'
#'@param data a data frame
#'@param model a fitted lme or lm - model
#'@param method a function to use for refitting
#'@param n number of bootstrap samples
#'
#'@return Bootstrap regression results object (brr)
#'
#'@examples
#'R base models
#'x <- rnorm(100)
#'m <- rnorm(100)
#'y <- rnorm(100,0.4*x-0.6*m,2)
#'model <- lm(y~m*x)
#'brr <- bootreg(data.frame(x,m,y),model,lm)
#'
#'
#'#mixed models
#'x <- rnorm(50)
#'m <- rnorm(50)
#'y <- rnorm(50,x*m,2)
#'g <- sample(1:10,50,TRUE)
#'model <- lme4::lmer(y~m*x + (1|g))
#'brr <- bootreg(data.frame(x,m,y,g),model,lme4::lmer)
#'
#'@export
#'
bootreg <- function(data,model,method=lm,n=1000){
  modelcoefs <- .extractCoefficients(model)
  ret <- list()
  attr(ret,"class") <- "brr"
  coeflist <- list()
  st <- system.time(bootrep(data,model,method))[1]
  for(i in 1:n){
    coefs <- bootrep(data,model,method)
    if(all(coefs != "error")){
      coeflist[[i]] <- coefs
    }
    if(i %% 100 == 0){
      print(paste("Estimated time remaining:",ceiling(st*(n-i)),"seconds."))
    }
  }
  ret$coefficients <- do.call(rbind.data.frame,coeflist)
  colnames(ret$coefficients) <- names(modelcoefs)
  ret$parcount <- length(modelcoefs)
  ret$replications <- n
  ret$sreplications <- nrow(ret$coefficients)
  ret$formula <- formula(model)
  return(ret)
}

bootrep <- function(data,model,method){
  indices <- sample(nrow(data),replace=TRUE)
  bootdata <- data[indices,]
  res <- tryCatch(
    {model <- method(formula(model),data=bootdata)
    .extractCoefficients(model)
    },
    error=function(cond){
      print(cond)
      return("error")
    }
  )
  return(res)
}


#'@export
summary.brr <- function(object){
  stopifnot(inherits(object,"brr"))
  estimates <- colMeans(object$coefficients)
  sds <- apply(object$coefficients,2,sd)
  zs <- estimates/sds
  ps <- pnorm(-abs(zs)) + 1 - pnorm(abs(zs))
  los <- estimates - 1.96*sds
  his <- estimates + 1.96*sds
  coeftable <- round(data.frame(Estimate=estimates,SE=sds,z=zs,p=ps,LLCI=los,ULCI=his),4)
  print(coeftable)
  cat(paste("Iterations:",object$replications,"(planned) /",object$sreplications,"(successful)"))
}

#'@export
plot.brr <- function(object){
  if(object$parcount <  4){
    par(mfrow=c(1,object$parcount))
  }
  else if(round(sqrt(object$parcount)) == sqrt(object$parcount)){
    par(mfrow=c(sqrt(object$parcount),sqrt(object$parcount)))
  }
  else{
    par(mfrow=c(ceiling(object$parcount / 3),3))
  }
  for(i in 1:object$parcount){
    hist(object$coefficients[,i],xlab="",ylab="",main=colnames(object$coefficients)[i],breaks=20)
    abline(v=0,lty=2,col="red")
  }
}

.extractCoefficients <- function(object){
  mt <- .modelType(object)
  if(mt == "lm"){
    return(coefficients(object))
  }
  else if(mt == "lme4"){
    return(lme4::fixef(object))
  }
  else if(mt == "nlme"){
    return(nlme::fixef(object))
  }
  else{
    warning("Model is from none of the allowed classes. Treating it as lm")
    return(coefficients(object))
  }
}
