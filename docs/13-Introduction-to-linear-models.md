# Introduction to Linear Models





In the last chapter we conducted a simple analysis of Darwin's maize data using R. We worked out confidence intervals 'by hand'. This simple method allowed us to learn more about analysis, estimates, standard error and confidence. But it is also slow, and it relied on the assumptions of a *z-distribution* to assess true differences between the groups. 

We will now work through a much more efficient way to carry out comparisons, we will use the functions in R that let us perform a **linear model** analysis.

### Packages


```r
library(tidyverse)
library(GGally)
library(emmeans)
library(performance)
```



## A linear model analysis for comparing groups

R has a general function `lm()` for fitting linear models, this is part of base R (does not require the tidyverse packages). We will run through a few different iterations of the linear model increasing in complexity. We will often want to fit several models to our data, so a common way to work is to fit a model and assign it to a named R object, so that we can extract data from when we need it. 

In the example below I have called the model `lsmodel0`, short for "least-squares model 0", this is because the linear-model uses a technique called **least-squares** we will explore what this means later. 


```r
lsmodel0 <- lm(formula = height ~ 1, data = darwin)
```

<div class="try">
<p>You can pipe into the lm() function, but when we use functions that
are “outside” of the tidyverse family we need to put a <code>.</code>
where the data should go (as it is usually not the first argument).</p>
<p>lsmodel0 &lt;- darwin %&gt;% lm(height ~ 1, data= .)</p>
</div>


The first argument of the `lm()` function is formula (we won't write this out in full in the future) - and this specifies we want to analyse a **response** variable (height) as a function of an **explanatory** variable using the *tilde* symbol (~).

The simplest possible model ignores any explanatory variables, instead the `1` indicates we just want to estimate an intercept. Without explanatory variables this means the formula will just estimate the overall mean height of **all** the plants in the dataset.


## Summaries for models

When you have made a linear model, we can investigate a summary of the model using the base R function `summary()`. There is also a tidyverse option provided by the package `broom`(@R-broom).

#### Broom

broom summarizes key information about models in tidy `tibble()s`. broom provides three verbs to make it convenient to interact with model objects:

* `broom::tidy()` summarizes information about model components

* `broom::glance()` reports information about the entire model

* `broom::augment()` adds informations about individual observations to a dataset and it can be used to model predictions onto a new dataset.

#### Model summary

<button id="displayTextunnamed-chunk-6" onclick="javascript:toggle('unnamed-chunk-6');">Show Solution</button>

<div id="toggleTextunnamed-chunk-6" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body"><div class="tab"><button class="tablinksunnamed-chunk-6 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-6', 'unnamed-chunk-6');">Base R</button><button class="tablinksunnamed-chunk-6" onclick="javascript:openCode(event, 'option2unnamed-chunk-6', 'unnamed-chunk-6');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-6" class="tabcontentunnamed-chunk-6">

```r
summary(lsmodel0)
```

```
## 
## Call:
## lm(formula = height ~ 1, data = darwin)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -6.8833 -1.3521 -0.0083  2.4917  4.6167 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  18.8833     0.5808   32.52   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3.181 on 29 degrees of freedom
```
</div><div id="option2unnamed-chunk-6" class="tabcontentunnamed-chunk-6">

```r
broom::tidy(lsmodel0)
```

<div class="kable-table">

|term        | estimate| std.error| statistic| p.value|
|:-----------|--------:|---------:|---------:|-------:|
|(Intercept) | 18.88333| 0.5807599|  32.51487|       0|

</div>
</div><script> javascript:hide('option2unnamed-chunk-6') </script></div></div></div>


The output above is called the *table of coefficients*. The 18.9 is the *estimate of the model coefficient* (in this case it is the overall mean), together with its standard error. The first row in any R model output is always labelled the 'Intercept' and the challenge is usually to workout what that represents. In this case we can prove that this is the same as the overall mean as follows:


```r
mean(darwin$height)
```

```
## [1] 18.88333
```


This simple model allows us to understand what the `lm()` function does. 

#### Compare means

What we really want is a linear model that analyses the *difference* in average plant height as a function of pollination type. We can use the `lm()` function to fit this as a linear model as follows:

<button id="displayTextunnamed-chunk-8" onclick="javascript:toggle('unnamed-chunk-8');">Show Solution</button>

<div id="toggleTextunnamed-chunk-8" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body"><div class="tab"><button class="tablinksunnamed-chunk-8 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-8', 'unnamed-chunk-8');">Base R</button><button class="tablinksunnamed-chunk-8" onclick="javascript:openCode(event, 'option2unnamed-chunk-8', 'unnamed-chunk-8');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-8" class="tabcontentunnamed-chunk-8">

```r
lsmodel1 <- lm(height ~ type, data=darwin)

# note that the following is identical

# lsmodel1 <- lm(height ~ 1 + type, data=darwin)

summary(lsmodel1)
```

```
## 
## Call:
## lm(formula = height ~ type, data = darwin)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -8.1917 -1.0729  0.8042  1.9021  3.3083 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  20.1917     0.7592  26.596   <2e-16 ***
## typeSelf     -2.6167     1.0737  -2.437   0.0214 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.94 on 28 degrees of freedom
## Multiple R-squared:  0.175,	Adjusted R-squared:  0.1455 
## F-statistic:  5.94 on 1 and 28 DF,  p-value: 0.02141
```
</div><div id="option2unnamed-chunk-8" class="tabcontentunnamed-chunk-8">

```r
lsmodel1 <- lm(height ~ type, data=darwin)

broom::tidy(lsmodel1)
```

<div class="kable-table">

|term        |  estimate| std.error| statistic|   p.value|
|:-----------|---------:|---------:|---------:|---------:|
|(Intercept) | 20.191667| 0.7592028| 26.595880| 0.0000000|
|typeSelf    | -2.616667| 1.0736749| -2.437113| 0.0214145|

</div>
</div><script> javascript:hide('option2unnamed-chunk-8') </script></div></div></div>


```r
lsmodel1 <- lm(height ~ type, data=darwin)

# note that the following is identical

# lsmodel1 <- lm(height ~ 1 + type, data=darwin)
```

Now the model formula contains the pollination type in addition to an intercept.

Some things to notice about the above:

1) The intercept value has changed! So what does it represent now?

2) The label of the second row is 'typeSelf'

But what does this mean? Think about it and see if you can figure it out for yourself before clicking the reveal

<button id="displayTextunnamed-chunk-10" onclick="javascript:toggle('unnamed-chunk-10');">Show Solution</button>

<div id="toggleTextunnamed-chunk-10" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

The label of the second row 'typeSelf' is produced by combining the variable type, with one of the factors (Self). As there are only two levels in type, it stands to reason that the intercept must represent typeCross. So the coefficient in the label intercept is the average height of the 15 maize plants in the crossed treatment.

So what about the second row? A common mistake is to think that this must refer to the height of the Self plants. However, this cannot be true as the value is *negative*. Instead what it actually refers to is the **difference in the mean height of the two groups**. This focuses then on the question which we are asking: is their a difference in the height of plants that result from cross pollination when compared to plants that have been self pollinated? 

This linear model indicates the average height of Crossed plants is 20.2 inches, and Selfed plants are an average of 2.6 inches *shorter*.

You can confirm this for yourself: 

  

```r
darwin %>% 
  group_by(type) %>% 
  summarise(mean=mean(height))
```

<div class="kable-table">

|type  |     mean|
|:-----|--------:|
|Cross | 20.19167|
|Self  | 17.57500|

</div>
</div></div></div>


Let's take a look at a fuller summary of our model, to see what else we can determine


```r
summary(lsmodel1)
```

```
## 
## Call:
## lm(formula = height ~ type, data = darwin)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -8.1917 -1.0729  0.8042  1.9021  3.3083 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  20.1917     0.7592  26.596   <2e-16 ***
## typeSelf     -2.6167     1.0737  -2.437   0.0214 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.94 on 28 degrees of freedom
## Multiple R-squared:  0.175,	Adjusted R-squared:  0.1455 
## F-statistic:  5.94 on 1 and 28 DF,  p-value: 0.02141
```

<div class="figure" style="text-align: center">
<img src="images/model summary.png" alt="Annotation of the summary function output" width="80%" />
<p class="caption">(\#fig:unnamed-chunk-12)Annotation of the summary function output</p>
</div>


#### Standard error of the difference

The output of the model also gives the standard errors of the values (estimates). In the first row the intercept calculates a mean and the standard error of the mean (SEM). As the second row gives the mean *difference* in this column it gives the *standard error of the difference* between the two means (SED). We have already seen how to calculate SEM, but what about SED?

$$
SED = {\sqrt \frac{s_1^2}{n_1}}+\frac{s_2^2}{n_2}
$$

> ** Note - The subscripts 1 and 2 indicate the two groups (self and cross). 

<div class="info">
<p>Our linear model analysis doesn’t actually calculate the individual
variances for the two groups. Instead it uses a ‘pooled’ variance
approach. This assumes the variance is roughly equal across all groups,
and allows us to take advantage of the larger sample size through
‘pooling’, to generate a more accurate SED. However, this does assume
that variance is <em>roughly equal</em> in the two groups. In fact last
week when we calculated standard deviation, we saw this was not the
case. So we must check this assumption in our model (more on this
later).</p>
</div>

## Confidence intervals

With a wrapper function around our model we can generate accurate 95% confidence intervals from the SE and calculated t-distribution:

<div class="tab"><button class="tablinksunnamed-chunk-14 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-14', 'unnamed-chunk-14');">Base R</button><button class="tablinksunnamed-chunk-14" onclick="javascript:openCode(event, 'option2unnamed-chunk-14', 'unnamed-chunk-14');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-14" class="tabcontentunnamed-chunk-14">

```r
confint(lsmodel1)
```

```
##                2.5 %     97.5 %
## (Intercept) 18.63651 21.7468231
## typeSelf    -4.81599 -0.4173433
```
</div><div id="option2unnamed-chunk-14" class="tabcontentunnamed-chunk-14">

```r
broom::tidy(lsmodel1, conf.int=T)
```

<div class="kable-table">

|term        |  estimate| std.error| statistic|   p.value| conf.low|  conf.high|
|:-----------|---------:|---------:|---------:|---------:|--------:|----------:|
|(Intercept) | 20.191667| 0.7592028| 26.595880| 0.0000000| 18.63651| 21.7468231|
|typeSelf    | -2.616667| 1.0736749| -2.437113| 0.0214145| -4.81599| -0.4173433|

</div>
</div><script> javascript:hide('option2unnamed-chunk-14') </script>

Because this follows the same layout as the table of coefficients, the output intercept row gives a 95% CI for the height of the crossed plants and the second row gives a 95% interval for the *difference in height between crossed and selfed plants*. The lower and upper bounds are the 2.5% and 97.5% of a *t*-distribution (more on this later). 

It is this difference in height in which we are specifically interested. Our summary models have generated *p*-values but we have conspicuously ignored these for now. Instead we are going to continue to focus on using confidence intervals to answer our question. 

## Answering the question

Darwin's original hypothesis was that self-pollination would reduce fitness (using height as a proxy for this). The null hypothesis is that there is no effect of pollination type, and therefore no difference in the average heights. 
We must ask ourselves if our experiment is consistent with this null hypothesis or can we reject it? If we choose to reject the null hypothesis, with what level of confidence can we do so?

To do this, we can simply whether or not the predicted value of our null hypothesis (a  difference of zero) lies inside the 95% CI for the difference of the mean. 

If our confidence intervals contain zero (or no difference), then we cannot establish a difference between our sample difference in height (-2.62 inches) from the null prediction of zero difference, given the level of variability (noise) in our data. 

In this case we can see that the upper and lower bounds of the confidence intervals do not cross zero. The difference in height is consistent with Darwin's alternate hypothesis of inbreeding depression. 

The `GGally` package has a handy `ggcoef_model()` function, that produces a graph of the estimated mean difference with an approx 95% CI. As we can see we are able to reject the null hypothesis at a 95% confidence level. 


```r
# Generate a coefficient plot for the linear regression model using ggcoef_model
GGally::ggcoef_model(lsmodel1,
                     show_p_values = FALSE,
                     conf.level = 0.95)
```

<img src="13-Introduction-to-linear-models_files/figure-html/unnamed-chunk-15-1.png" width="100%" style="display: block; margin: auto;" />

<div class="try">
<p>Set the confidence levels to 99%, do you think the difference between
treatments is still statistically significant at an of 0.01?</p>
</div>

If we increase the level of confidence (from 95% to 99%, roughly 2 SE to 3 SE), then we may find that we cannot reject the null hypothesis at a higher threshold of confidence. Try altering the conf.level argument above for yourself to see this in action. 

We can also include this argument in the `tidy()` function if we wish to:


```r
broom::tidy(lsmodel1, conf.int=T, conf.level=0.99)
```

<div class="kable-table">

|term        |  estimate| std.error| statistic|   p.value|  conf.low|  conf.high|
|:-----------|---------:|---------:|---------:|---------:|---------:|----------:|
|(Intercept) | 20.191667| 0.7592028| 26.595880| 0.0000000| 18.093790| 22.2895433|
|typeSelf    | -2.616667| 1.0736749| -2.437113| 0.0214145| -5.583512|  0.3501789|

</div>

#### Getting the other treatment mean and standard error

One limitation of the table of coefficients output is that it doesn't provide the mean and standard error of the *other* treatment level (only the difference between them). If we wish to calculate the "other" mean and SE then we can get R to do this.


```r
# Perform linear regression on darwin data with Self as the intercept
darwin %>% 
  # Convert 'type' column to a factor
  mutate(type = factor(type)) %>%
  # Relevel 'type' column to specify the order of factor levels
  mutate(type = fct_relevel(type, c("Self", "Cross"))) %>%
  # Fit linear regression model with 'height' as the response variable and 'type' as the predictor
  lm(height ~ type, data = .) %>%
  # Tidy the model summary
  broom::tidy()
```

<div class="kable-table">

|term        |  estimate| std.error| statistic|   p.value|
|:-----------|---------:|---------:|---------:|---------:|
|(Intercept) | 17.575000| 0.7592028| 23.149282| 0.0000000|
|typeCross   |  2.616667| 1.0736749|  2.437113| 0.0214145|

</div>

After relevelling, the self treatment is now taken as the intercept, and we get the estimate for it's mean and standard error

### Emmeans

We could also use the package [`emmeans`](https://aosmith.rbind.io/2019/03/25/getting-started-with-emmeans/) and its function `emmeans()` to do a similar thing


```r
# Calculate estimated marginal means (EMMs) using emmeans package
means <- emmeans::emmeans(lsmodel1, specs = ~ type)

means
```

```
##  type  emmean    SE df lower.CL upper.CL
##  Cross   20.2 0.759 28     18.6     21.7
##  Self    17.6 0.759 28     16.0     19.1
## 
## Confidence level used: 0.95
```

The advantage of emmeans is that it provides the mean, standard error and 95% confidence interval estimates of all levels from the model at once (e.g. it relevels the model multiple times behind the scenes). 


`emmeans` also gives us a handy summary to include in data visuals that combine raw data and statistical inferences. These are standard `ggplot()` outputs so can be [customised as much as you want](#intro-to-grammar).


```r
# Convert the 'means' object to a tibble
means %>%
  as_tibble() %>%
  # Create a plot using ggplot
  ggplot(aes(x = type, y = emmean)) +
  # Add point estimates with error bars
  geom_pointrange(aes(ymin = lower.CL, ymax = upper.CL))
```

<img src="13-Introduction-to-linear-models_files/figure-html/unnamed-chunk-20-1.png" width="100%" style="display: block; margin: auto;" />

Notice that no matter how we calculate the estimated SE (and therefore the 95% CI) of both treatments is the same. This is because as mentioned earlier the variance is a pooled estimate, e.g. variance is not being calculate separately for each group. The only difference you should see in SE across treatments will be if there is a difference in *sample size* between groups. 

<div class="info">
<p>Notice how the Confidence intervals of the estimated means strongly
overlap, there is a difference between the two SEMs and the SED we have
calculated. So overlapping error bars cannot be used to infer
significance.</p>
</div>

Because of this pooled variance, there is an assumption that variance is equal across the groups, this and other assumptions of the linear model should be checked. We cannot trust our results if the assumptions of the model are not adequately met. 

## Summary

However, we have not addressed an important part of our experimental design yet. The fact that the plants are paired, so in this example we have basically carried out a Student's t-test, not a paired t-test. Later we will add pair as another explanatory variable and see how this affects our model. 

So remember a linear model sets one factor level as the 'intercept' estimates its mean, then draws a line from the first treatment to the second treatment, the slope of the line is the difference in means between the two treatments. 

The difference in means is always accompanied by a standard error of the difference (SED), and this can be used to calculate a 95% confidence interval. If this confidence interval does not contain the intercept value, we can reject the null hypothesis that there is 'no effect'. 

Linear models make a variety of assumptions, including that the noise (residual differences) are approximately normally distributed, with roughly equal (homogenous) variance. 

## Write-up

<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 
Can you write an Analysis section? </div></div>


<button id="displayTextunnamed-chunk-23" onclick="javascript:toggle('unnamed-chunk-23');">Show Solution</button>

<div id="toggleTextunnamed-chunk-23" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">
The maize plants that have been cross pollinated had an average height of 20.19 inches [18.63 - 21.74] and were taller on average than the self-pollinated plants, with a mean difference in height of 2.62 [0.42, 4.82] inches (mean [95% CI]) (t(28) = -2.44, p = 0.02).
</div></div></div>

> This will be different to your previous manual calculations on two counts. One, we are using a t-distribution for our confidence intervals. Two this example is a two-sample t-test, our previous example was closer to a paired t-test we will see how to implement a linear model with a paired design in subsequent chapters.


```r
# Convert the 'means' object to a tibble
means %>%
  as_tibble() %>%
  # Create a plot using ggplot
  ggplot(aes(x = type, y = emmean, fill = type)) +
    # Add raw data
  geom_jitter(data = darwin,
              aes(x = type,
                  y = height),
              width = 0.1,
              pch = 21,
              alpha = 0.4) +
  # Add point estimates with error bars
  geom_pointrange(aes(ymin = lower.CL, 
                      ymax = upper.CL),
                  pch = 21) +
  theme_classic()
```

<img src="13-Introduction-to-linear-models_files/figure-html/unnamed-chunk-24-1.png" width="100%" style="display: block; margin: auto;" />


# Assumption checking

After conducting a linear model analysis, we often find ourselves with results and inferences. However, before we can fully trust our analysis, it’s essential to check whether the underlying assumptions of the model are adequately met. In this chapter, we will focus on two critical assumptions: the normality of residuals and the homogeneity of variance. We will also discuss the impact of outliers on our model and the formal tests available for these assumptions.

## Assumption 1: Normality of Residuals

### Understanding Residuals

Residuals are the differences between observed values and the fitted values produced by the model. In our case, this involves analyzing plant heights against treatment means. The normality of residuals is crucial because the linear model relies on this assumption to compute standard errors, which in turn affects confidence intervals and hypothesis testing.

### Graphical Checks for Normality

To visually assess the normality of residuals, we can utilize various plotting functions in R. Two effective methods are:

Quantile-Quantile (QQ) Plot: This plot compares the distribution of residuals to a theoretical normal distribution. If the residuals follow a normal distribution, they should approximately align along a diagonal line.

<div class="tab"><button class="tablinksunnamed-chunk-25 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-25', 'unnamed-chunk-25');">Base R</button><button class="tablinksunnamed-chunk-25" onclick="javascript:openCode(event, 'option2unnamed-chunk-25', 'unnamed-chunk-25');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-25" class="tabcontentunnamed-chunk-25">

```r
plot(lsmodel1, which=c(2,2))
```

<img src="13-Introduction-to-linear-models_files/figure-html/unnamed-chunk-37-1.png" width="100%" style="display: block; margin: auto;" />
</div><div id="option2unnamed-chunk-25" class="tabcontentunnamed-chunk-25">

```r
performance::check_model(lsmodel1, check=c("normality","qq"),
                         detrend = F)
```

<img src="13-Introduction-to-linear-models_files/figure-html/unnamed-chunk-38-1.png" width="100%" style="display: block; margin: auto;" />
</div><script> javascript:hide('option2unnamed-chunk-25') </script>
### Formal test of Normality

<div class="tab"><button class="tablinksunnamed-chunk-26 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-26', 'unnamed-chunk-26');">Base R</button><button class="tablinksunnamed-chunk-26" onclick="javascript:openCode(event, 'option2unnamed-chunk-26', 'unnamed-chunk-26');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-26" class="tabcontentunnamed-chunk-26">

```r
shapiro.test(residuals(lsmodel1))
```

```
## 
## 	Shapiro-Wilk normality test
## 
## data:  residuals(lsmodel1)
## W = 0.83089, p-value = 0.0002531
```
</div><div id="option2unnamed-chunk-26" class="tabcontentunnamed-chunk-26">

```r
performance::check_normality(lsmodel1)
```

```
## Warning: Non-normality of residuals detected (p < .001).
```
</div><script> javascript:hide('option2unnamed-chunk-26') </script>



## Assumption 2: Homogeneity of Variance

### Assessing Equal Variance

The assumption of homogeneity of variance (or homoscedasticity) states that the residual variance should be constant across all levels of the independent variable(s). This is important because linear models often pool variance across groups to make inferences.

### Graphical Checks for Homogeneity

To assess this assumption, we can plot the residuals against the fitted values:

<div class="tab"><button class="tablinksunnamed-chunk-27 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-27', 'unnamed-chunk-27');">Base R</button><button class="tablinksunnamed-chunk-27" onclick="javascript:openCode(event, 'option2unnamed-chunk-27', 'unnamed-chunk-27');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-27" class="tabcontentunnamed-chunk-27">

```r
plot(lsmodel1, which=c(1,3))
```

<img src="13-Introduction-to-linear-models_files/figure-html/unnamed-chunk-41-1.png" width="100%" style="display: block; margin: auto;" /><img src="13-Introduction-to-linear-models_files/figure-html/unnamed-chunk-41-2.png" width="100%" style="display: block; margin: auto;" />
</div><div id="option2unnamed-chunk-27" class="tabcontentunnamed-chunk-27">

```r
performance::check_model(lsmodel1, check=c("homogeneity"))
```

<img src="13-Introduction-to-linear-models_files/figure-html/unnamed-chunk-42-1.png" width="100%" style="display: block; margin: auto;" />
</div><script> javascript:hide('option2unnamed-chunk-27') </script>


### Formal Tests for Homogeneity of Variance

To formally test for homogeneity of variance, we can use:

Breusch-Pagan Test: This test evaluates whether the variance of residuals is constant.

<div class="tab"><button class="tablinksunnamed-chunk-28 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-28', 'unnamed-chunk-28');">Base R</button><button class="tablinksunnamed-chunk-28" onclick="javascript:openCode(event, 'option2unnamed-chunk-28', 'unnamed-chunk-28');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-28" class="tabcontentunnamed-chunk-28">

```r
library(lmtest)

bptest(lsmodel1, varformula = ~fitted.values(lsmodel1), studentize = F )
```

```
## 
## 	Breusch-Pagan test
## 
## data:  lsmodel1
## BP = 3.9496, df = 1, p-value = 0.04688
```
</div><div id="option2unnamed-chunk-28" class="tabcontentunnamed-chunk-28">

```r
performance::check_heteroscedasticity(lsmodel1)
```

```
## Warning: Heteroscedasticity (non-constant error variance) detected (p = 0.047).
```
</div><script> javascript:hide('option2unnamed-chunk-28') </script>

## Assumption 3: Linearity

Linear regression assumes a linear relationship between the predictor(s) and the response variable. If this assumption is violated, the model may produce biased or inaccurate predictions.

### Graphical checks for linearity

To assess this assumption, we can plot the residuals against the fitted values:

<div class="tab"><button class="tablinksunnamed-chunk-29 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-29', 'unnamed-chunk-29');">Base R</button><button class="tablinksunnamed-chunk-29" onclick="javascript:openCode(event, 'option2unnamed-chunk-29', 'unnamed-chunk-29');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-29" class="tabcontentunnamed-chunk-29">

```r
plot(lsmodel1, which=c(1,3))
```

<img src="13-Introduction-to-linear-models_files/figure-html/unnamed-chunk-45-1.png" width="100%" style="display: block; margin: auto;" /><img src="13-Introduction-to-linear-models_files/figure-html/unnamed-chunk-45-2.png" width="100%" style="display: block; margin: auto;" />
</div><div id="option2unnamed-chunk-29" class="tabcontentunnamed-chunk-29">

```r
performance::check_model(lsmodel1, check=c("linearity"))
```

<img src="13-Introduction-to-linear-models_files/figure-html/unnamed-chunk-46-1.png" width="100%" style="display: block; margin: auto;" />
</div><script> javascript:hide('option2unnamed-chunk-29') </script>

Checking for linearity can be difficult when we only have two groups in our model:

- **Limited Data Points**: With only two levels, you have a limited number of data points, which may not adequately capture the underlying relationship. This makes it hard to assess linearity visually or statistically.

- **No Intermediate Values**: A binary predictor means there are no intermediate values to examine. This limits the ability to see a continuous trend or relationship.

## Outliers and Their Impact

Outliers can significantly affect the estimates of a model, influencing both residuals and overall model fit. Therefore, it’s essential to assess the presence and impact of outliers on our analysis.

### Identifying Outliers

To identify outliers, we can employ Cook's Distance, which measures the influence of each data point on the model fit. Large values of Cook's Distance suggest that a point may be having an outsized effect.

<div class="tab"><button class="tablinksunnamed-chunk-30 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-30', 'unnamed-chunk-30');">Base R</button><button class="tablinksunnamed-chunk-30" onclick="javascript:openCode(event, 'option2unnamed-chunk-30', 'unnamed-chunk-30');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-30" class="tabcontentunnamed-chunk-30">

```r
plot(lsmodel1, which=c(4,4))
```

<img src="13-Introduction-to-linear-models_files/figure-html/unnamed-chunk-47-1.png" width="100%" style="display: block; margin: auto;" />
</div><div id="option2unnamed-chunk-30" class="tabcontentunnamed-chunk-30">

```r
performance::check_model(lsmodel1, check=c("outliers"))
```

<img src="13-Introduction-to-linear-models_files/figure-html/unnamed-chunk-48-1.png" width="100%" style="display: block; margin: auto;" />
</div><script> javascript:hide('option2unnamed-chunk-30') </script>

### Formal Tests for Outliers


```r
performance::check_outliers(lsmodel1)
```

```
## OK: No outliers detected.
## - Based on the following method and threshold: cook (0.5).
## - For variable: (Whole model)
```


## Multicollinearity

Check: Assess whether predictors are highly correlated with each other, which can affect the stability of coefficient estimates. In this model we only have a single predictor, so this test is not required - we will revisit this with more complex models later. 

<div class="tab"><button class="tablinksunnamed-chunk-32 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-32', 'unnamed-chunk-32');">Base R</button><button class="tablinksunnamed-chunk-32" onclick="javascript:openCode(event, 'option2unnamed-chunk-32', 'unnamed-chunk-32');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-32" class="tabcontentunnamed-chunk-32">

```r
library(car)
vif(lsmodel1)
```
</div><div id="option2unnamed-chunk-32" class="tabcontentunnamed-chunk-32">

```r
performance::check_model(lsmodel1, check=c("vif"))
```
</div><script> javascript:hide('option2unnamed-chunk-32') </script>


## Summary

So what can we determine from this analysis? Our model is not perfect, however it is reasonably good. Many of the statistical violations are likely because of the small sample size - and collecting more data might be a good idea.

Linear models are powerful tools for analyzing relationships between variables, but their validity hinges on several key assumptions. Checking these assumptions is crucial to ensure the reliability and interpretability of the model's results.

By systematically checking these assumptions, researchers can ensure that their linear models are robust, reliable, and capable of providing meaningful insights into the relationships between variables. Ignoring these checks can lead to flawed analyses and misguided conclusions, underscoring the necessity of thorough model evaluation.

In this chapter, we covered essential steps for checking linear model assumptions, including:

- Assessing the normality of residuals through QQ plots and formal tests (e.g., Shapiro-Wilk).

- Evaluating homogeneity of variance using residual plots and formal tests (e.g., Breusch-Pagan).

- Testing for model linearity

- Identifying outliers through Cook's Distance.

We can check all our model assumptions at once, as well as looking at individual plots as shown above. 

<div class="tab"><button class="tablinksunnamed-chunk-33 active" onclick="javascript:openCode(event, 'option1unnamed-chunk-33', 'unnamed-chunk-33');">Base R</button><button class="tablinksunnamed-chunk-33" onclick="javascript:openCode(event, 'option2unnamed-chunk-33', 'unnamed-chunk-33');"><tt>tidyverse</tt></button></div><div id="option1unnamed-chunk-33" class="tabcontentunnamed-chunk-33">

```r
plot(lsmodel1)
```
</div><div id="option2unnamed-chunk-33" class="tabcontentunnamed-chunk-33">

```r
performance::check_model(lsmodel1, detrend = F)
```
</div><script> javascript:hide('option2unnamed-chunk-33') </script>

While graphical checks provide a valuable first step, complementing them with formal tests strengthens our analysis. 

Conversely when sample sizes are very low or very large we can often see deviations from normality through formal tests which we might decide to tolerate based on on the graphical checks of model fit. 

By thoroughly checking these assumptions, we can ensure the reliability of our linear model analysis and make informed decisions based on the results obtained.


