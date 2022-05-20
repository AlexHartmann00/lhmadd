# lhmadd - R package to provide model-agnostic additional linear modeling functions

## Johnson-Neyman plots

### Mathematical derivation of significance test

Simple regression equation with interaction term

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

and tested for significance with $\alpha = .05$.

![jnplt](https://user-images.githubusercontent.com/87905364/169590263-e1038194-d14a-4ea5-a83b-6f8bdd0e5c79.png)

## HC standard errors



