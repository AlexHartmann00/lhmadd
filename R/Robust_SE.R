x <- rnorm(500)
z <- rnorm(500,2,4)
id <- sample(0:5,500,TRUE)
y <- rnorm(500,x^2-z^2)

model_multi <- lme4::lmer(y~x*z + (1|id))

#Robuste Varianz-Kovarianzschätzung
robust_vcov <- function(object){
  X <- model.matrix(object)
  k <- ncol(X)
  n <- nrow(X)
  hc1 <- (n/(n-k))*resid(object)^2
  #hc1 = beobachtungsspezifische Varianz
  sandwich <- solve(t(X) %*% X)
  meat <- (t(X) %*% (hc1*diag(n)) %*% X)
  vce <- solve(t(X) %*% X) %*%
    (t(X) %*% (hc1*diag(n)) %*% X) %*%
    solve(t(X) %*% X)
  return(sandwich %*% meat %*% sandwich)
}

#Regressionstabellenfunktion
robust_sig_test_multilevel <- function(object){
  rvcov <- robust_vcov(object)
  rvar <- diag(rvcov)
  coef <- lme4::fixef(object)
  se <- sqrt(rvar)
  t <- coef / se
  df <- nrow(model.matrix(object))-ncol(model.matrix(object))
  p <- pt(-abs(t),df) + 1 - pt(abs(t),df)
  return(cbind(coef,se,t,p))
}

robust_sig_test_multilevel(model_multi)
