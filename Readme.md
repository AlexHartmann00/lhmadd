# lmmadd - R package to add functions for linear (mixed) models

## Install from GitHub
```rb
#install.packages("devtools")
devtools::install_github("AlexHartmann00/lmmadd")
```

## Johnson-Neyman plots

Works for all of the following: "lm","glm","lme4","nlme", might work for more.

Usage:

```rb
library(lmmadd)
x <- rnorm(50)
m <- rnorm(50)
y <- rnorm(50,x*m,2)
model <- lm(y~x*m)
johnson_neyman(model,"x","m")
```

![jnplt](https://user-images.githubusercontent.com/87905364/169644339-c4113ac3-98b6-4c75-9106-1192b0862a12.png)

### Mathematical derivation of significance test

Simple regression equation with interaction term!

$$y = b_0 + b_1X + b_2M + b_3XM$$

Factorize X-terms:

$$b_1X + b_3XM = X\cdot(b_1+b_3M)$$

X's combined coefficient

$$w_1(M) = b_1 + b_3M$$

From elementary variance calculations,

$$Var(w_1(M)) = Var(b_1) + Var(b_3M) + Cov(B_1,B_3M)$$

Note that

$$Var(b_3M) = M^2 Var(b_3)$$

and

$$Cov(b_1,b_3M) = MCov(b_1,b_3)$$

So, we get

$$Var(w_1(M)) = Var(b_1) + M^2Var(b_3) + MCov(b_1,b_3)$$

and

$$se(w_1(M)) = \sqrt{(Var(b_1) + M^2Var(b_3) + MCov(b_1,b_3))}$$

The t-statistic is then calculated as

$$t = \frac{w_1(M)}{se(w_1(M))}$$

and tested for significance with $\alpha = .05$ and $df = n - k - 1$, where k is the feature count, n no. observations.

The plot above shows significant regions in blue and non-significant ones in red.



## HC standard errors



