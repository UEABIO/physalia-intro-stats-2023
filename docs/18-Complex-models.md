# Complex models









## Designing a Model

We are introduced to the fruitfly dataset Partridge and Farquhar (1981)^[https://nature.com/articles/294580a0]. From our understanding of sexual selection and reproductive biology in fruit flies, we know there is a well established 'cost' to reproduction in terms of reduced longevity for female fruitflies. The data from this experiment is designed to test whether increased sexual activity affects the lifespan of male fruitflies.

The flies used were an outbred stock, sexual activity was manipulated by supplying males with either new virgin females each day, previously mated females ( Inseminated, so remating rates are lower), or provide no females at all (Control). All groups were otherwise treated identically.





```{=html}
<a href="https://raw.githubusercontent.com/Philip-Leftwich/physalia-stats-intro/main/book/files/fruitfly.csv">
<button class="btn btn-success"><i class="fa fa-save"></i> Download Fruitfly data as csv</button>
</a>
```


* **type**: type of female companion (virgin, inseminated, control(partners = 0))

* **longevity**: lifespan in days

* **thorax**: length of thorax in micrometres (a proxy for body size)

* **sleep**: percentage of the day spent sleeping

## Hypothesis

Before you start any formal analysis you should think clearly about the sensible parameters to test. In this example, we are *most* interested in the effect of sexual activity on longevity. But it is possible that other factors may also affect longevity and we should include these in our model as well, and we should think **hard** about what terms might reasonably be expected to *interact* with sexual activity to affect longevity. 

<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 
Which terms and interactions do you think we should include in our model? </div></div>

<button id="displayTextunnamed-chunk-6" onclick="javascript:toggle('unnamed-chunk-6');">Show Solution</button>

<div id="toggleTextunnamed-chunk-6" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">
In this exercise I have just asked you to try and think logically about suitable predictors. For a more formal investigation you should support this with evidence where possible

* type - should definitely be included. 

* thorax - the size of the flies could determine longevity. Carreira et al (2009)^[https://www.nature.com/articles/hdy2008117]

* sleep - sleep could easily help determine longevity. Thompson et al (2020)^[https://journals.biologists.com/bio/article/9/9/bio054361/225803/Sleep-length-differences-are-associated-with]

* type:sleep - the amount that sleep (rest) helps promote longevity could change depending on how much activity the fly engages in when awake. Chen et al (2017)^[https://www.nature.com/articles/s41467-017-00087-5#:~:text=In%20this%20study%2C%20we%20show,but%20aroused%20females%20sleep%20more]

Other interactions *could* be included but you should have a strong reason for them. </div></div></div>

## Checking the data

You should now import, clean and tidy your data. Making sure it is in tidy format, all variables have useful names, and there are no mistakes, missing data or typos.

Based on the variables you have decided to test you should start with some simple visualisations, to understand the distribution of your data, and investigate visually the relationships you wish to test.

This is a full two-by-two plot of the entire dataset, but you should try and follow this up with some specific plots. 


```r
GGally::ggpairs(fruitfly)
```

<img src="18-Complex-models_files/figure-html/unnamed-chunk-7-1.png" width="100%" style="display: block; margin: auto;" />

## Activity 1: Think about your data

Think carefully about the plots you should make to investigate the potential differences and relationships you wish to investigate - try and answer the questions first before checking the examples hidden behind dropdowns.

<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 
Make density distributions for longevity of males across the three treatments. </div></div>


<button id="displayTextunnamed-chunk-9" onclick="javascript:toggle('unnamed-chunk-9');">Show Solution</button>

<div id="toggleTextunnamed-chunk-9" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">
In this first figure - we can investigate whether there is an obvious difference in the longevities of males across the three treatments

```r
colours <- c("cyan", "darkorange", "purple")

fruitfly %>% 
  ggplot(aes(x = longevity, y = type, fill = type))+
  geom_density_ridges(alpha = 0.5)+
  scale_fill_manual(values = colours)+
  theme_minimal()+
  theme(legend.position = "none")
```

<div class="figure" style="text-align: center">
<img src="18-Complex-models_files/figure-html/unnamed-chunk-41-1.png" alt="A density distribution of longevity across the three sexual activity treatments" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-41)A density distribution of longevity across the three sexual activity treatments</p>
</div>
</div></div></div>

**Q** Does it like treatment affects longevity? <select class='webex-select'><option value='blank'></option><option value='answer'>Yes</option><option value=''>No</option></select>

<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 
Make a scatterplot of size against longevity. </div></div>


<button id="displayTextunnamed-chunk-11" onclick="javascript:toggle('unnamed-chunk-11');">Show Solution</button>

<div id="toggleTextunnamed-chunk-11" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">
In this first figure - we can investigate whether there is an obvious difference in the longevities of males across the three treatments

```r
fruitfly %>% 
  ggplot(aes(x = thorax, y = longevity))+
  geom_point()+
  theme_minimal()+
  theme(legend.position = "none")
```

<div class="figure" style="text-align: center">
<img src="18-Complex-models_files/figure-html/unnamed-chunk-42-1.png" alt="A scatterplot of longevity against body size (thorax (mm)). No trend line added - often it is a good idea to look at data points without being lead to a conclusion by a line" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-42)A scatterplot of longevity against body size (thorax (mm)). No trend line added - often it is a good idea to look at data points without being lead to a conclusion by a line</p>
</div>
</div></div></div>


**Q** Does it look like size affects longevity? <select class='webex-select'><option value='blank'></option><option value='answer'>Yes</option><option value=''>No</option></select>


<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 
Make an interaction plot to see if size interacts with treatment to affect longevity. (Use colour and groups to make differentiate points and lines) </div></div>

<button id="displayTextunnamed-chunk-13" onclick="javascript:toggle('unnamed-chunk-13');">Show Solution</button>

<div id="toggleTextunnamed-chunk-13" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
colours <- c("cyan", "darkorange", "purple")

fruitfly %>% 
  ggplot(aes(x=thorax, y = longevity, group = type, colour = type))+
  geom_point( alpha = 0.6)+
  geom_smooth(method = "lm",
            se = FALSE)+
  scale_colour_manual(values = colours)+
  theme_minimal()
```

<div class="figure" style="text-align: center">
<img src="18-Complex-models_files/figure-html/unnamed-chunk-43-1.png" alt="A scatterplot of thorax against longevity - colours indicate treatment types. This time I have included a line, as it will help determine if I think the slopes are different by group" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-43)A scatterplot of thorax against longevity - colours indicate treatment types. This time I have included a line, as it will help determine if I think the slopes are different by group</p>
</div>
</div></div></div>

**Q** Does it look like size affects longevity differently between treatment groups? <select class='webex-select'><option value='blank'></option><option value=''>Yes</option><option value='answer'>No</option></select>


<div class='webex-solution'><button>Explain this</button>


Here it does look as though larger flies have a longer lifespan than smaller flies. But there appears to be little difference in the angle of the slopes between groups. This does not mean we can't test this in our model, but we may decide it is not worth including.


</div>




We are also interested in the potential effect of sleep on activity, we can construct a scatter plot of sleep against longevity, while including treatment as a covariate.

<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 
Make an interaction plot to see if sleep interacts with treatment to affect longevity. </div></div>

<button id="displayTextunnamed-chunk-15" onclick="javascript:toggle('unnamed-chunk-15');">Show Solution</button>

<div id="toggleTextunnamed-chunk-15" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
fruitfly %>% 
  ggplot(aes(x=sleep, y = longevity, group = type, colour = type))+
  geom_point( alpha = 0.6)+
  geom_smooth(method = "lm",
            se = FALSE)+
  scale_colour_manual(values = colours)+
  theme_minimal()
```

<div class="figure" style="text-align: center">
<img src="18-Complex-models_files/figure-html/unnamed-chunk-44-1.png" alt="A scatter plot of proportion of time spent sleeping against longevity with a linear model trendline. Points represent individual flies, colours represent treatments." width="100%" />
<p class="caption">(\#fig:unnamed-chunk-44)A scatter plot of proportion of time spent sleeping against longevity with a linear model trendline. Points represent individual flies, colours represent treatments.</p>
</div>
</div></div></div>


In these plots - Are the trendlines moving in the same direction?  <select class='webex-select'><option value='blank'></option><option value=''>Yes</option><option value='answer'>No</option></select>


<div class='webex-solution'><button>Explain this</button>


Here it does look as though sleep interacts with treatment to affect lifespan. As the slopes of the lines are very different in each group. But in order to know the strength of this association, and if it is significantly different from what we might observe under the null hypothesis, we will have to build a model.


</div>




## Designing a model

<div class="info">
<p>When you include an interaction term, the numbers produced from this
are how much <strong>more</strong> or <strong>less</strong> the mean
estimate is than if you just combined the main effects.</p>
</div>


<div class="tab"><button class="tablinks= T active" onclick="javascript:openCode(event, 'option1= T', '= T');">Base R</button><button class="tablinks= T" onclick="javascript:openCode(event, 'option2= T', '= T');"><tt>tidyverse</tt></button></div><div id="option1= T" class="tabcontent= T">

```r
flyls1 <- lm(longevity ~ type + thorax + sleep + type:sleep, data = fruitfly)
summary(flyls1)
```

```
## 
## Call:
## lm(formula = longevity ~ type + thorax + sleep + type:sleep, 
##     data = fruitfly)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -28.808  -6.961  -2.024   7.463  28.741 
## 
## Coefficients:
##                        Estimate Std. Error t value Pr(>|t|)    
## (Intercept)           -57.52754   11.35546  -5.066 1.52e-06 ***
## typeInseminated         7.98838    5.34120   1.496   0.1374    
## typeVirgin            -10.90754    5.47458  -1.992   0.0486 *  
## thorax                142.50900   13.41154  10.626  < 2e-16 ***
## sleep                   0.09045    0.18859   0.480   0.6324    
## typeInseminated:sleep  -0.19651    0.20823  -0.944   0.3473    
## typeVirgin:sleep       -0.11243    0.21665  -0.519   0.6048    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 11.27 on 118 degrees of freedom
## Multiple R-squared:  0.608,	Adjusted R-squared:  0.5881 
## F-statistic: 30.51 on 6 and 118 DF,  p-value: < 2.2e-16
```
</div><div id="option2= T" class="tabcontent= T">

```r
# a full model
flyls1 <- lm(longevity ~ type + thorax + sleep + type:sleep, data = fruitfly)

flyls1 %>% 
  broom::tidy()
```

<div class="kable-table">

|term                  |    estimate|  std.error|  statistic|   p.value|
|:---------------------|-----------:|----------:|----------:|---------:|
|(Intercept)           | -57.5275383| 11.3554560| -5.0660703| 0.0000015|
|typeInseminated       |   7.9883828|  5.3412012|  1.4956154| 0.1374236|
|typeVirgin            | -10.9075381|  5.4745755| -1.9923989| 0.0486358|
|thorax                | 142.5090010| 13.4115350| 10.6258531| 0.0000000|
|sleep                 |   0.0904459|  0.1885893|  0.4795919| 0.6324053|
|typeInseminated:sleep |  -0.1965054|  0.2082301| -0.9436937| 0.3472544|
|typeVirgin:sleep      |  -0.1124276|  0.2166543| -0.5189260| 0.6047842|

</div>

</div><script> javascript:hide('option2= T') </script>


<div class="info">
<p>Because we have included an interaction effect the number of terms is
quite long and takes more consideration to understand. We can see for
the individual estimates that it does not appear that the interaction is
having a strong effect (estimate) and this does not appear to be
different from a null hypothesis of no interaction effect. But we we
should use an <em>F</em> test to look at the overall effect to be
sure.</p>
</div>

<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 
From the model summary table could you say what the mean longevity of a male with a 0.79mm thorax, that sleeps for 22% of the day and is paired with virgin females would be? </div></div>


<button id="displayTextunnamed-chunk-19" onclick="javascript:toggle('unnamed-chunk-19');">Show Solution</button>

<div id="toggleTextunnamed-chunk-19" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
# intercept
coef(flyls1)[1] + 
  
# 1*coefficient for virgin treatment  
coef(flyls1)[3] + 
  
# 0.79 * coefficient for thorax size  
(coef(flyls1)[4]*0.79) + 
  
# 22 * coefficient for sleep  
(coef(flyls1)[5]*22) + 
```

```r
# 22 * 1 * coefficient for interaction
(coef(flyls1)[7]*22*1)
```

```
## typeVirgin:sleep 
##        -2.473406
```
</div></div></div>


## Model checking & collinearity

Before we start playing with the terms in our model, we should check to see if this is even a good way of fitting and measuring our data. We should check the assumptions of our model are being met.


```r
performance::check_model(flyls1, detrend = F)
```

<img src="18-Complex-models_files/figure-html/unnamed-chunk-20-1.png" width="100%" style="display: block; margin: auto;" />

## Activity 2: Model checking

**Question - IS the assumption of homogeneity of variance met?** <select class='webex-select'><option value='blank'></option><option value='answer'>Yes</option><option value=''>No</option></select>

<button id="displayTextunnamed-chunk-21" onclick="javascript:toggle('unnamed-chunk-21');">Show Solution</button>

<div id="toggleTextunnamed-chunk-21" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

* Mostly - the reference line is fairly flat (there is a slight curve).

* It looks as though there might be some increasing heterogeneity with larger values, though very minor.

VERDICT, pretty much ok, should be fine for making inferences. 

With a slight curvature this could indicate that you *might* get a better fit with a transformation, or perhaps that there is a missing variable that if included in the model would improve the residuals. In this instance I wouldn not be overly concerned. See here for a great explainer on intepreting residuals^[https://www.qualtrics.com/support/stats-iq/analyses/regression-guides/interpreting-residual-plots-improve-regression/].

```r
performance::check_heteroscedasticity(flyls1)
```

```
## OK: Error variance appears to be homoscedastic (p = 0.114).
```
</div></div></div>

**Question - ARE the residuals normally distributed?** <select class='webex-select'><option value='blank'></option><option value='answer'>Yes</option><option value=''>No</option></select>

<button id="displayTextunnamed-chunk-22" onclick="javascript:toggle('unnamed-chunk-22');">Show Solution</button>

<div id="toggleTextunnamed-chunk-22" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">
Yes - the QQplot looks pretty good, a very minor indication of a right skew, but nothing to worry about. 

[Interpreting QQ plots][What is a Quantile-Quantile (QQ) plot?]

```r
performance::check_normality(flyls1)
```

```
## OK: residuals appear as normally distributed (p = 0.097).
```
</div></div></div>


**Question - IS their an issue with Collinearity?** <select class='webex-select'><option value='blank'></option><option value=''>Yes</option><option value='answer'>No</option></select>

<button id="displayTextunnamed-chunk-23" onclick="javascript:toggle('unnamed-chunk-23');">Show Solution</button>

<div id="toggleTextunnamed-chunk-23" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

This graph clearly shows there **is** collinearity. But this is not unusual when we include an *interaction term*, if we see evidence of collinearity in terms that are not part of an interaction **then** we should take another look^[https://easystats.github.io/performance/reference/check_collinearity.html].

What can you do about collinearity in main effects? 1) Nothing 2) Mean-center 3) Drop one of the terms. 

The `check_performance()` function produces a visual summary of a Variance Inflation Factor produced from the `vif()` function. This is a measure of the standard error of each estimated coefficient. If this is very larger (greater than 5 or 10), this indicates the model has problems estimating the coefficient. This does not affect model predictions, but makes it more difficult to determine the estimate change from a predictor. 

```r
performance::check_collinearity(flyls1)
```

<div class="kable-table">

|Term       |       VIF| VIF_CI_low| VIF_CI_high| SE_factor| Tolerance| Tolerance_CI_low| Tolerance_CI_high|
|:----------|---------:|----------:|-----------:|---------:|---------:|----------------:|-----------------:|
|type       | 12.478906|   9.183114|   17.102095|  3.532550| 0.0801352|        0.0584724|         0.1088955|
|thorax     |  1.052967|   1.001793|    2.564661|  1.026142| 0.9496972|        0.3899150|         0.9982102|
|sleep      |  8.750764|   6.487969|   11.946552|  2.958169| 0.1142757|        0.0837062|         0.1541314|
|type:sleep | 38.749001|  28.176470|   53.434592|  6.224870| 0.0258071|        0.0187145|         0.0354906|

</div>
</div></div></div>


## Mean-centering

We often find issues of apparent collinearity are reduced or removed when we mean-center continuous variables, this has the added bonus of centering our intercept, so let's try that now! 


```r
fruitfly <- fruitfly %>% 
  mutate(thorax_centered = thorax - mean(thorax),
         sleep_centered = sleep - mean(sleep))

flyls1 <- lm(longevity ~ type + thorax_centered + sleep_centered + type:sleep_centered, data = fruitfly)
```

## Data transformations

The most common issues when trying to fit simple linear regression models is that our response variable is not normal which violates our modelling assumption. There are two things we can do in this case:

* Variable transformation e.g `lm(sqrt(x) ~ y, data = data)`
    
    - Can sometimes fix linearity
    
    - Can sometimes fix non-normality and heteroscedasticity (i.e non-constant variance) 
    
* Generalized Linear Models (GLMs) to change the error structure (i.e the assumption that residuals need to be normal - see next week.)

### BoxCox

<div class="info">
<p>The BoxCox gets its name from its two inventors, George Box and David
Cox. Implemented by the MASS package, when applied to a linear model it
sytematically applies transformations by raising the y variable to a
power (lambda).</p>
<p>The R output for the <code>MASS::boxcox()</code> function plots a
maximum likelihood curve (with a 95% confidence interval - drops down as
dotted lines) for the best transformation for fitting the data to the
model.</p>
</div>

In this case we already know that our model is very likely "good enough" as it does not deviate from expectations of our linear model assumptions - however it is possible that we can still find a better fit. 


<table class="table" style="font-size: 16px; width: auto !important; margin-left: auto; margin-right: auto;">
<caption style="font-size: initial !important;">(\#tab:unnamed-chunk-26)Common Box-Cox Transformations</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> lambda value </th>
   <th style="text-align:left;"> transformation </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:left;"> log(Y) </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.5 </td>
   <td style="text-align:left;"> sqrt(Y) </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:left;"> Y </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.0 </td>
   <td style="text-align:left;"> Y^1 </td>
  </tr>
</tbody>
</table>


```r
# run this, pick a transformation and retest the model fit
MASS::boxcox(flyls1)
```

<div class="figure" style="text-align: center">
<img src="18-Complex-models_files/figure-html/unnamed-chunk-27-1.png" alt="standard curve fitted by maximum likelihood, dashed lines represent the 95% confidence interval range for picking the 'best' transformation for the dependent variable" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-27)standard curve fitted by maximum likelihood, dashed lines represent the 95% confidence interval range for picking the 'best' transformation for the dependent variable</p>
</div>

**Question - Does the fit of the model improve with a square root transformation?** <select class='webex-select'><option value='blank'></option><option value=''>Yes</option><option value='answer'>No</option></select>

<button id="displayTextunnamed-chunk-28" onclick="javascript:toggle('unnamed-chunk-28');">Show Solution</button>

<div id="toggleTextunnamed-chunk-28" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
flyls_sqrt <- lm(sqrt(longevity) ~ type + thorax + sleep + type:sleep, data = fruitfly)

performance::check_model(flyls_sqrt)
```

<img src="18-Complex-models_files/figure-html/unnamed-chunk-52-1.png" width="100%" style="display: block; margin: auto;" />

Not really, despite the suggestion that a sqrt transformation would improve the model, residual fits are not really any better - if we examine R squared carefully, we can see that there is a very small increase in variance explained - but in my opinion, not worth the hassle of having a transformed dependent variable - so we might as well stick with the original scale.



</div></div></div>

## Model selection


```r
# use drop1 function to remove top-level terms
drop1(flyls1, test = "F")
```

<div class="kable-table">

|                    | Df|  Sum of Sq|      RSS|      AIC|     F value|    Pr(>F)|
|:-------------------|--:|----------:|--------:|--------:|-----------:|---------:|
|<none>              | NA|         NA| 14994.43| 612.3900|          NA|        NA|
|thorax_centered     |  1| 14347.4733| 29341.90| 694.3073| 112.9087541| 0.0000000|
|type:sleep_centered |  2|   130.1431| 15124.57| 609.4702|   0.5120865| 0.6005695|

</div>

Based on this ANOVA table, we do not appear to have a strong rationale for keeping the interaction term in the model (AIC or F-test). Therefore we can confidently remove the interaction, simplifying our model and making interpretation easier. 





```r
flyls2 <- lm(longevity ~ type + thorax + sleep, data = fruitfly)

drop1(flyls2, test = "F")
```

<div class="kable-table">

|       | Df|   Sum of Sq|      RSS|      AIC|    F value|    Pr(>F)|
|:------|--:|-----------:|--------:|--------:|----------:|---------:|
|<none> | NA|          NA| 15124.57| 609.4702|         NA|        NA|
|type   |  2|  7576.86233| 22701.43| 656.2337|  30.057833| 0.0000000|
|thorax |  1| 15282.82102| 30407.39| 694.7659| 121.255596| 0.0000000|
|sleep  |  1|    86.27949| 15210.85| 608.1813|   0.684551| 0.4096663|

</div>

**Question - Should we drop sleep from this model?** <select class='webex-select'><option value='blank'></option><option value=''>Yes</option><option value='answer'>No</option></select>

<button id="displayTextunnamed-chunk-32" onclick="javascript:toggle('unnamed-chunk-32');">Show Solution</button>

<div id="toggleTextunnamed-chunk-32" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

There is good reason to remove non-significant *interaction terms* from a model, they complicate estimates and make interpretations more difficult. For **main** effects things are a little more ambiguous. 

When the main aim is prediction, it makes sense to be cautious and retain non-significant terms, as extra terms make no difference to the R^2 of a model. 

When the focus is on hypothesis testing, then removal of non-significant terms can help produce a 'true' model, but this is optional. Generally speaking it is often simpler to leave main effects in the model (you should have carefully considered the terms which were included in the first place). 

In this example we can also see that AIC has not really changed - so the quality of the model is also not improved vby dropping this term. </div></div></div>


## Posthoc

Using the [emmeans](https://aosmith.rbind.io/2019/03/25/getting-started-with-emmeans/) package is a very easy way to produce the estimate mean values (rather than mean differences) for different categories `emmeans`. If the term `pairwise` is included then it will also include post-hoc pairwise comparisons between all levels with a tukey test `contrasts`.


```r
emmeans::emmeans(flyls2, specs = pairwise ~ type + thorax + sleep)
```

```
## $emmeans
##  type        thorax sleep emmean   SE  df lower.CL upper.CL
##  Control      0.821  23.5   61.3 2.26 120     56.8     65.8
##  Inseminated  0.821  23.5   64.9 1.59 120     61.8     68.1
##  Virgin       0.821  23.5   48.0 1.59 120     44.9     51.2
## 
## Confidence level used: 0.95 
## 
## $contrasts
##  contrast                                                                 
##  Control thorax0.82096 sleep23.464 - Inseminated thorax0.82096 sleep23.464
##  Control thorax0.82096 sleep23.464 - Virgin thorax0.82096 sleep23.464     
##  Inseminated thorax0.82096 sleep23.464 - Virgin thorax0.82096 sleep23.464 
##  estimate   SE  df t.ratio p.value
##     -3.63 2.77 120  -1.309  0.3929
##     13.25 2.76 120   4.796  <.0001
##     16.87 2.25 120   7.508  <.0001
## 
## P value adjustment: tukey method for comparing a family of 3 estimates
```

<div class="info">
<p>For continuous variables (sleep and thorax) - <code>emmeans</code>
has set these to the mean value within the dataset, so comparisons are
constant between categories at the average value of all continuous
variables.</p>
</div>

## Activity 3: Write-up

<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 
Can you write an Analysis section? </div></div>

<button id="displayTextunnamed-chunk-36" onclick="javascript:toggle('unnamed-chunk-36');">Show Solution</button>

<div id="toggleTextunnamed-chunk-36" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">
I constructed an ordinary least squares model to investigate the effects of sleep, mating type and body size on longevity in adult Drosophila melanogaster. I also included an interaction term between sleep and mating type. All Analyses and data cleaning was carried out in R ver 4.1.2 with the tidyverse range of packages (Wickham et al 2019), model residuals were checked with the performance package (Lüdecke et al 2021), and summary tables produced with broom (Robinson et al 2022) and kableExtra (Zhu 2020).</div></div></div>


<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 
Can you write a Results section? </div></div>

<button id="displayTextunnamed-chunk-38" onclick="javascript:toggle('unnamed-chunk-38');">Show Solution</button>

<div id="toggleTextunnamed-chunk-38" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">
I tested the hypothesis that sexual activity is costly for male *Drosophila melanogaster* fruitflies. Previous research indicated that sleep deprived males are less attractive to females, this would indicate that levels of sexual activity might be affected by sleep and impact the effect on longevity, as such this was included as an interaction term in the full model. Body size is also know to affect lifespan, as such this was included as a covariate in the mode. 

There was a small interaction effect of decreased lifespan with increasing sleep in the treatment groups compared to control in our samples, but this was not significantly different from no effect (F~2,118~ = 0.512, P = 0.6), and was therefore dropped from the full model (Table 15.1). 

```r
library(kableExtra)
flyls2 %>% broom::tidy(conf.int = T) %>% 
 select(-`std.error`) %>% 
mutate_if(is.numeric, round, 2) %>% 
kbl(col.names = c("Predictors",
                    "Estimates",
                    "Z-value",
                    "P",
                    "Lower 95% CI",
                    "Upper 95% CI"),
      caption = "Linear model coefficients", 
    booktabs = T) %>% 
   kable_styling(full_width = FALSE, font_size=16)
```

<table class="table" style="font-size: 16px; width: auto !important; margin-left: auto; margin-right: auto;">
<caption style="font-size: initial !important;">(\#tab:unnamed-chunk-53)Linear model coefficients</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Predictors </th>
   <th style="text-align:right;"> Estimates </th>
   <th style="text-align:right;"> Z-value </th>
   <th style="text-align:right;"> P </th>
   <th style="text-align:right;"> Lower 95% CI </th>
   <th style="text-align:right;"> Upper 95% CI </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> (Intercept) </td>
   <td style="text-align:right;"> -56.05 </td>
   <td style="text-align:right;"> -5.01 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> -78.18 </td>
   <td style="text-align:right;"> -33.91 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> typeInseminated </td>
   <td style="text-align:right;"> 3.63 </td>
   <td style="text-align:right;"> 1.31 </td>
   <td style="text-align:right;"> 0.19 </td>
   <td style="text-align:right;"> -1.86 </td>
   <td style="text-align:right;"> 9.11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> typeVirgin </td>
   <td style="text-align:right;"> -13.25 </td>
   <td style="text-align:right;"> -4.80 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> -18.71 </td>
   <td style="text-align:right;"> -7.78 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> thorax </td>
   <td style="text-align:right;"> 144.43 </td>
   <td style="text-align:right;"> 11.01 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 118.46 </td>
   <td style="text-align:right;"> 170.40 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> sleep </td>
   <td style="text-align:right;"> -0.05 </td>
   <td style="text-align:right;"> -0.83 </td>
   <td style="text-align:right;"> 0.41 </td>
   <td style="text-align:right;"> -0.18 </td>
   <td style="text-align:right;"> 0.07 </td>
  </tr>
</tbody>
</table>

There was a significant overall effect of treatment on male longevity (Linear model: F~2,120~ = 30.1, P < 0.001), with males paired to virgin females having the lowest mean longevity (48 days, [95%CI: 44.9 - 51.2]) (when holding body size and sleep constant), compared to control males (61.3 days [56.8 - 65.8]) and males paired with inseminated females (64.9 days [61.8 - 68.1 days]). 

Post hoc analysis showed that these differences were statistically significant for males paired with control females compared to the inseminated (Tukey test: t~120~ = 4.8, P < 0.001)  and virgin groups (t~120~ = 7.5, P < 0.001), but there was no overall evidence of a difference between inseminated and virgin groups (t~120~ = -1.309  P < 0.3929) (Figure 19.4). 

Comparing the treatment effects against other predictors of longevity such as body size and sleep, I found that sleep had a very small effect on longevity (mean change -0.05 days [-0.18 - 0.07]) which was not significantly different from no effect (Linear model: F~1,120~ = 0.68, P = 0.41). Body size (taken from thorax length) was a significant predictor of longevity (F~1,120~ = 121, P < 0.001), with each 0.1 mm increase in body size adding 14.4 days to the individual lifespan [11.8 - 17]. It appears as though body size has a stronger effect on longevity than treatment, indicating that while there is a measurable cost of sexual activity to males, it may be less severe than in females (not compared here), and less severe than other measurable predictors. 

<div class="figure" style="text-align: center">
<img src="18-Complex-models_files/figure-html/unnamed-chunk-54-1.png" alt=" A scatter plot of longevity against body size across three treatments of differening male sexual activity. Fitted model slopes are from the reduced linear model (main effects only of thorax size, sleep and treatment group), with 95% confidence intervals, circles are individual data points. Marginal plots are density plot distributions for thorax length and longevity split by treatments." width="100%" />
<p class="caption">(\#fig:unnamed-chunk-54) A scatter plot of longevity against body size across three treatments of differening male sexual activity. Fitted model slopes are from the reduced linear model (main effects only of thorax size, sleep and treatment group), with 95% confidence intervals, circles are individual data points. Marginal plots are density plot distributions for thorax length and longevity split by treatments.</p>
</div>
</div></div></div>

## Summary

In this chapter we have worked with our scientific knowledge to develop testable hypotheses and built statistical models to formally assess them. We now have a working pipeline for tackling complex datasets, developing insights and producing and explaining robust linear models. 

### Checklist

* Think carefully about the hypotheses to test, use your scientific knowledge and background reading to support this

* Import, clean and understand your dataset: use data visuals to investigate trends and determine if there is clear support for your hypotheses

* Fit a linear model, including interaction terms with caution

* Investigate the fit of your model, understand that parameters may never be perfect, but that classic patterns in residuals may indicate a poorly fitting model - sometimes this can be fixed with careful consideration of missing variables or through data transformation

* Test the removal of any interaction terms from a model, look at AIC and significance tests

* Make sure you understand the output of a model summary, sense check this against the graphs you have made

* The direction and size of any effects are the priority - produce estimates and uncertainties. Make sure the observations are clear.

* Write-up your significance test results, taking care to report not just significance (and all required parts of a significance test). Do you know *what* to report? Within a complex model - reporting *t* will indicate the slope of the line for that single term against the intercept, *F* is the overall effect of a predictor across all levels, *post-hoc* if you wish to compare across all levels. 

* Well described tables and figures can enhance your results sections - take the time to make sure these are informative and attractive. 


## Supplementary code

`sjPlot` A really nice package that helps produce model summaries for you automatically


```r
library(sjPlot)
tab_model(flyls2)
```

<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm;  text-align:left; ">&nbsp;</th>
<th colspan="3" style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm; ">longevity</th>
</tr>
<tr>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  text-align:left; ">Predictors</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">Estimates</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">CI</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">p</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">(Intercept)</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">&#45;56.05</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">&#45;78.18&nbsp;&ndash;&nbsp;-33.91</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>&lt;0.001</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">type [Inseminated]</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">3.63</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">&#45;1.86&nbsp;&ndash;&nbsp;9.11</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.193</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">type [Virgin]</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">&#45;13.25</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">&#45;18.71&nbsp;&ndash;&nbsp;-7.78</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>&lt;0.001</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">thorax</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">144.43</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">118.46&nbsp;&ndash;&nbsp;170.40</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>&lt;0.001</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">sleep</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">&#45;0.05</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">&#45;0.18&nbsp;&ndash;&nbsp;0.07</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">0.410</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm; border-top:1px solid;">Observations</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left; border-top:1px solid;" colspan="3">125</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">R<sup>2</sup> / R<sup>2</sup> adjusted</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">0.605 / 0.591</td>
</tr>

</table>


```r
library(gtsummary)
tbl_regression(flyls2)
```

```{=html}
<div id="nmkeywpxkj" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#nmkeywpxkj table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#nmkeywpxkj thead, #nmkeywpxkj tbody, #nmkeywpxkj tfoot, #nmkeywpxkj tr, #nmkeywpxkj td, #nmkeywpxkj th {
  border-style: none;
}

#nmkeywpxkj p {
  margin: 0;
  padding: 0;
}

#nmkeywpxkj .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#nmkeywpxkj .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#nmkeywpxkj .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#nmkeywpxkj .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#nmkeywpxkj .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#nmkeywpxkj .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nmkeywpxkj .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#nmkeywpxkj .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#nmkeywpxkj .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#nmkeywpxkj .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#nmkeywpxkj .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#nmkeywpxkj .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#nmkeywpxkj .gt_spanner_row {
  border-bottom-style: hidden;
}

#nmkeywpxkj .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#nmkeywpxkj .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#nmkeywpxkj .gt_from_md > :first-child {
  margin-top: 0;
}

#nmkeywpxkj .gt_from_md > :last-child {
  margin-bottom: 0;
}

#nmkeywpxkj .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#nmkeywpxkj .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#nmkeywpxkj .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#nmkeywpxkj .gt_row_group_first td {
  border-top-width: 2px;
}

#nmkeywpxkj .gt_row_group_first th {
  border-top-width: 2px;
}

#nmkeywpxkj .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nmkeywpxkj .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#nmkeywpxkj .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#nmkeywpxkj .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nmkeywpxkj .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nmkeywpxkj .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#nmkeywpxkj .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#nmkeywpxkj .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#nmkeywpxkj .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nmkeywpxkj .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#nmkeywpxkj .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#nmkeywpxkj .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#nmkeywpxkj .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#nmkeywpxkj .gt_left {
  text-align: left;
}

#nmkeywpxkj .gt_center {
  text-align: center;
}

#nmkeywpxkj .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#nmkeywpxkj .gt_font_normal {
  font-weight: normal;
}

#nmkeywpxkj .gt_font_bold {
  font-weight: bold;
}

#nmkeywpxkj .gt_font_italic {
  font-style: italic;
}

#nmkeywpxkj .gt_super {
  font-size: 65%;
}

#nmkeywpxkj .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#nmkeywpxkj .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#nmkeywpxkj .gt_indent_1 {
  text-indent: 5px;
}

#nmkeywpxkj .gt_indent_2 {
  text-indent: 10px;
}

#nmkeywpxkj .gt_indent_3 {
  text-indent: 15px;
}

#nmkeywpxkj .gt_indent_4 {
  text-indent: 20px;
}

#nmkeywpxkj .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Characteristic&lt;/strong&gt;"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Beta&lt;/strong&gt;"><strong>Beta</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;95% CI&lt;/strong&gt;&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>95% CI</strong><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;p-value&lt;/strong&gt;"><strong>p-value</strong></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">type</td>
<td headers="estimate" class="gt_row gt_center"></td>
<td headers="ci" class="gt_row gt_center"></td>
<td headers="p.value" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Control</td>
<td headers="estimate" class="gt_row gt_center">—</td>
<td headers="ci" class="gt_row gt_center">—</td>
<td headers="p.value" class="gt_row gt_center"></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Inseminated</td>
<td headers="estimate" class="gt_row gt_center">3.6</td>
<td headers="ci" class="gt_row gt_center">-1.9, 9.1</td>
<td headers="p.value" class="gt_row gt_center">0.2</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Virgin</td>
<td headers="estimate" class="gt_row gt_center">-13</td>
<td headers="ci" class="gt_row gt_center">-19, -7.8</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left">thorax</td>
<td headers="estimate" class="gt_row gt_center">144</td>
<td headers="ci" class="gt_row gt_center">118, 170</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
    <tr><td headers="label" class="gt_row gt_left">sleep</td>
<td headers="estimate" class="gt_row gt_center">-0.05</td>
<td headers="ci" class="gt_row gt_center">-0.18, 0.07</td>
<td headers="p.value" class="gt_row gt_center">0.4</td></tr>
  </tbody>
  
  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="4"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span> CI = Confidence Interval</td>
    </tr>
  </tfoot>
</table>
</div>
```
