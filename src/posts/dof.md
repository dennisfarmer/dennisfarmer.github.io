---
layout: layouts/base.njk
title: Degrees of Freedom
image: /images/dof.jpg
date: 2025-09-12
leftalign: true
---

# Degrees of Freedom

[![Preview](/images/dof.jpg)](https://www.instagram.com/drex.dsgn/)

Here's some Regression Analysis notes for the vibes: 

We are interested in estimating the variance of the population-level errors $\epsilon$, assuming the function that generated our data is a linear function of the form $y=X\beta + \epsilon$, with $\epsilon_i \stackrel{\mathrm{iid}}{\sim} \mathrm{N}\left(0, \sigma_\epsilon^2\right)$. This imposition of restriction on the distribution of the $\epsilon_{i}$'s is often called the "Stronger Linear Model", since it explains a greater proportion of the variation in the dependent variable than the "Weaker Linear Model" that doesn't assume anything about the distribution of $\epsilon_{i}$ (just that they satisfy $E[\epsilon_{i} | x_i] = 0$ and $\mathrm{Var}(\epsilon_{i}|x_i = \sigma^2_\epsilon), \mathrm{Cov}(\epsilon_{i}, \epsilon_{j} | x_j, x_j) = 0$ for all $i\neq j$).

The variance of the errors $\epsilon$ is of interest because we want to say something about the distribution of $\hat\beta \sim \mathrm{MVN}\left(\beta, \sigma^2_\epsilon(X^TX)^{-1}\right)$, ($\hat\beta$ is the vector containing the parameters of our linear model, and $\beta$ is the parameters of the underlying data generating linear model, assuming $E[y_i|x_i]$ is truely $\beta_0 + \beta_1x_{i1}+\cdots + \beta_{p}x_{ip}$ and not some nonlinear function of $x_i$ (linearity) and that the error terms $\epsilon_i$ all have the same variance $\mathrm{Var}(\epsilon_i | x_i) = \sigma_\epsilon^2$ (homoskedasticity)).

Could use more context here for explaining the significance of $\sigma_\epsilon$ $\dots$

## Estimating $\sigma_\epsilon$

We estimate $\sigma_\epsilon$ by way of the root mean squared error (RMSE), $\hat\sigma_\epsilon$

$\hat\sigma_\epsilon = \sqrt{\frac{\sum_{i=1}^ne_i^2}{n-p-1}} = \sqrt{\frac{\sum_{i=1}^n\left(y_i-\hat{y}_i\right)^2}{n-p-1}}$

$e_i = y_i = \hat{y}_i = y_i = x_i^T\hat{\beta}$

$e=(I-H)y = (I-H)X\beta + (I-H)\epsilon = 0 + (I-H)\epsilon$

$\Rightarrow e = (I-H)\epsilon$

$(I-H)X\beta = 0$ because $H$ projects vectors not of the form $X\beta$, and finds the closest vector of the form $X\beta$, so $HX\beta = X\beta$. Therefore we have $X\beta - X\beta = 0$.

The errors $\epsilon$ are closely related to the residuals $e$, which we do get to observe (no assumptions made for the result that $e = (I-H)\epsilon$, just linear algebra manipulation). We don't get to observe $\epsilon$, we can only estimate it.

## What is the variance of the errors $\epsilon$?

The residuals live in a lower dimensional space than the errors. $(I-H)$ is an orthogonal projection that projects into the orthogonal complement of the column space of $X$. $\mathrm{dim}(\mathrm{col}(X) = p+1$, since $X$ is a $n\times p+1$ matrix with full rank (invertable, all rows are linearly independent of each other).

$n - \mathrm{dim}(\mathrm{col}(X)) = n-(p+1) = n-p-1$

$\hat\sigma_\epsilon$ is computed by dividing the sum of squared residuals (RSS) by the degrees of freedom (not n-1 if have access to epsilon, we instead have access to a project on epsilon, so we use dim(col(X) = n-p-1, which is the degrees of freedom for the residual vector $e$.

Intuition:

- “How many elements of $e$ are freely determined?”
- We know that $e$ is constrained by the $p+1$ equations $e^TX = 0$
- Once I tell you $n-p-1$ elements of $e$, the remaining $p+1$ are fixed
- Residual vector is constrained to an $n-p-1$ dimensional subspace

RMSE is referred to as Residual standard error in R output when looking at summary of an lm object

SD($\hat\beta_j$) can be estimated using se($\hat\beta_j$), the standard error for the jth coefficient. This is interesting, isn’t $\hat\beta_j$ fixed since we have access to only one $\hat\beta_j$? How are we saying anything about how variable it will be? We can actually say things about how it might vary given different samples, using the standard error.

## A new t Statistic

Note: the context of the rest of these notes is for constructing a hypothesis test for $\hat\beta_j$. Currently learning this right now in lecture (career fair was worth it but gotta catch up on lecture recordings 😅), but basically $\mathrm{H}_0: \beta_j = 0$, and we want to construct a test to see if, holding all other variables equal, two individuals who differe in variable $x_j$ by 1 unit are expected to differ in $Y$ by $\beta_j$ units, where $\beta_j$ might be something that isn't totally boring, like $0$. It'd be more interesting to see the coefficients of the underlying linear model that generated the data be something non-zero (like $\mathrm{H}_1: \beta_j = 1$), and we want to tell if that's the case.

$t_\mathrm{stat} = \frac{\hat\beta_j - \gamma_0}{\mathrm{se}(\hat\beta_j)}$

This new test statistic replaces SD($\hat\beta_j$) with its sample analog se($\hat\beta_j$)

Under the null hypothesis and assuming the stronger linear model, $t_\mathrm{stat}$ follows a t distribution with $n-p-1$ degrees of freedom

We then use tail probabilities from the $t_{n-p-1}$ distribution to compute $p$-values. We can get these in R using the command $\texttt{pt(tstat, n-p-1)}$, which calculates the left tail probability.

Difference in numerator is normally distributed:

$\hat\beta_j - \gamma_0 \sim N(0, \mathrm{SD}^2(\hat\beta_j))$

Note that if we knew $\mathrm{SD}(\hat\beta_j)$, then we have:

$\frac{\hat\beta_j - \gamma_0}{\mathrm{SD}(\hat\beta_j)} \sim \mathrm{N}(0,1)$

The larger $n$ is, the closer that $t_{\mathrm{stat}}$ will be to a standard normal

The t distribution has heavier tails, with the most probability in the tails being when the degrees of freedom are the lowest. The intuition behind this is that when the degrees of freedom are low, there is something in the denominator that’s even more variable, causing large deviations from the center to be more common.



