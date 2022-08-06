# lmmadd - R package to add functions for linear (mixed) models

## Install from GitHub
```rb
#install.packages("devtools")
devtools::install_github("AlexHartmann00/lmmadd")
```

## Bootstrapped regression

Usage:

```rb
library(lmmadd)
x1 <- rnorm(100)
x2 <- rnorm(100)
y <- rnorm(100,0.4*x1-0.6*x2,2)
df <- data.frame(y,x1,x2)
model_lm <- lm(y~x1*x2,data=df)
#model_lme4 <- lme4::lmer(y~x1*x2 + (1|g))
brr_lm <- bootreg(data=df,model=model_lm,method=lm,n=1000)
#brr_lme4 <- bootreg(data=df,model=model_lme4,method=lme4::lmer,n=1000)
```
The code above runs 1000 bootstrap replications of the specified model. The outpu object is of class "brr" and can be summarized and plotted:

Summary:
```rb
summary(brr_lm)

            Estimate     SE       z      p    LLCI   ULCI
(Intercept)   0.2163 0.1982  1.0912 0.2752 -0.1722 0.6047
x1            0.2019 0.2063  0.9789 0.3276 -0.2024 0.6062
x2           -0.2530 0.2205 -1.1473 0.2513 -0.6851 0.1792
x1:x2         0.0291 0.2035  0.1428 0.8864 -0.3697 0.4279
Iterations: 1000 (planned) / 1000 (successful)
```

Plots:

```br
plot(brr_lm)
```

![bootregexample](https://user-images.githubusercontent.com/87905364/182581323-e3952792-1d37-4929-9469-05b272fd065e.png)


## Johnson-Neyman plots

Works for all of the following: "lm","glm","lme4","nlme", might work for more. ("brr" is WIP)

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

Simple regression equation with interaction term:

$$y = b_0 + b_1X + b_2M + b_3XM$$

Factorize X-terms:

$$b_1X + b_3XM = X\cdot(b_1+b_3M)$$

X's combined coefficient

$$w_1(M) = b_1 + b_3M$$

From elementary variance calculations,

$$Var(w_1(M)) = Var(b_1) + Var(b_3M) + 2Cov(B_1,B_3M)$$

Note that

$$Var(b_3M) = M^2 Var(b_3)$$

and

$$Cov(b_1,b_3M) = MCov(b_1,b_3)$$

So, we get

$$Var(w_1(M)) = Var(b_1) + M^2Var(b_3) + 2MCov(b_1,b_3)$$

and

$$se(w_1(M)) = \sqrt{(Var(b_1) + M^2Var(b_3) + 2MCov(b_1,b_3))}$$

The t-statistic is then calculated as

$$t = \frac{w_1(M)}{se(w_1(M))}$$

and tested for significance with $\alpha = .05$ and $df = n - k - 1$, where k is the feature count, n no. observations.

The plot above shows significant regions in blue and non-significant ones in red.



## HC standard errors

The package includes heteroscedasticity-consistent hypothesis testing for regression models. 

Example:

```rb
library(lmmadd)
x <- rnorm(50)
m <- rnorm(50)
y <- rnorm(50,x*m,2)
model <- lm(y~x*m)
robust_sig_test(model,type="HC3")
```

This produces a coefficient table of the form

```rb
                    coef        se           t          p
(Intercept) -0.034286686 0.2572227 -0.13329571 0.89454096
m            0.335772820 0.2656431  1.26399956 0.21259800
x           -0.003829244 0.2692055 -0.01422424 0.98871260
m:x          0.693468361 0.3693928  1.87731988 0.06682399
```

Available methods at the moment are "HC1" and "HC3".

Variance-Covariance matrix calculations:

HC1:

$$\mathbf{\sigma}_{HC1} = (\mathbf{X}^T \mathbf{X})^{-1} \times \mathbf{X}^T \Big(\frac{n(y - \hat{y})^2}{n-k} \mathbf{I}_n\Big) \mathbf{X} \times(\mathbf{X}^T\mathbf{X})^{-1}$$

HC3:

$$\mathbf{\sigma}_{HC3} = (\mathbf{X}^T \mathbf{X})^{-1} \times \mathbf{X}^T \Big(\frac{(y - \hat{y})^2}{(1 - \mathbf{H})^2} \mathbf{I}_n\Big) \mathbf{X} \times(\mathbf{X}^T\mathbf{X})^{-1}$$

where $\mathbf{H} $ is leverage, $\mathbf{X}$ the model matrix, $n$ the number of observations and $k$ the number of coefficients.

