# Introduction to Power Analysis









In this chapter, we will introduce some basic concepts of power analysis. 
Null hypothesis significance testing (NHST), aims to determine whether the null hypothesis (𝐻0) can be rejected. Statistical power is the probability of rejecting the null hypothesis when it is false. Power analysis is a method for planning sample sizes for a future study to ensure a high probability of rejecting the null hypothesis.

For example, if you want to plan a study with 80% power, a power analysis will answer the question:

“If I were to repeat my experiment many times, what sample size would allow me to reject the null hypothesis in 80% of these cases?”

Let’s consider a biology-based example. Suppose we are studying the effect of a new fertilizer on plant growth. We estimate that the true mean difference in growth between plants with and without the fertilizer is 𝛿= 0.50, meaning the growth difference is 0.5 standard deviations. To determine how many plants we need in each group to detect this difference with 80% probability, we can use a power analysis.

By running simulations with different sample sizes, we can find the sample size where 80% of our simulated studies show a significant growth difference, allowing us to correctly reject the null hypothesis that the fertilizer has no effect.

## Key Concepts in Null Hypothesis Significance Testing (NHST)

* The **null hypothesis** which states that the compared values **are equivalent** and, when referring to means, is written as: $H_0: \mu_1 = \mu_2$ 
* And the **alternative hypothesis** which states that the compared values **are not equivalent** and, when referring to means, is written as: $H_1: \mu_1 \ne \mu_2$.

Now, each decision about a hypothesis is prone to some degree of error and, as you will learn, the two main types of error that we worry about are:

* **Type I error** - or **False Positives**, is the error of rejecting the null hypothesis when it should not be rejected (otherwise called **alpha** or $\alpha$). In other words, you conclude that there is a real "effect" when in fact there is no effect. The field standard rate of acceptable false positives is $\alpha = .05$ meaning that in theory 1 in 20 studies may be a false positive.

* **Type II error** - or **False Negatives**, is the error of retaining the null hypothesis when it is false (otherwise called **beta** or $\beta$). In other words, you conclude that there was no real "effect" when in fact there was one. The field standard rate of acceptable false negatives is $\beta = .2$ meaning that in theory 1 in 5 studies may be a false negative. 

## Power and Effect sizes

### Introduction to Power and Effect Size

Understanding power and effect size is crucial in designing and interpreting research studies. Two key relationships to grasp are:

1. **Effect Size and Power**: For a given sample size and \(\alpha\) level, the power of your study is higher if the effect you are looking for is large rather than small. Large effects are easier to detect.
   
2. **Sample Size and Power**: For a given effect size and \(\alpha\) level, the power of your study increases with a larger sample size.

Since you have little control over the size of the effect in the real world, you can enhance the power of your study by increasing the sample size and reducing sources of noise and measurement error. When planning a study, researchers should consider four key elements, often referred to as the APES:

- **Alpha (\(\alpha\))**: The false positive rate or Type I error, usually set at \(\alpha = 0.05\).
- **Power**: The probability of rejecting the null hypothesis for a given effect size and sample size. A common target is power = 0.8, corresponding to a false negative rate (Type II error) of \(\beta = 0.2\).
- **Effect Size**: This can be measured in standardized or unstandardized forms to quantify the magnitude of the association or difference you are trying to detect.
- **Sample Size**: The number of observations (e.g., participants) in your study.

## Standardized Effect Sizes

Standardized effect sizes are useful for comparing results across different studies and measures. Here are some common standardized effect sizes and when they are typically used:

- **Cohen's d**: Measures the standardized mean difference between two groups. It is used when comparing the difference in means between groups, with values of 0.2, 0.5, and 0.8 representing small, medium, and large effects respectively.
  
- **Pearson's correlation coefficient (\(r\))**: Measures the strength and direction of a linear relationship between two variables. It is used when examining the association between continuous variables, with values of 0.1, 0.3, and 0.5 indicating small, medium, and large effects respectively.

- **Cohen's \(f^2\)**: Measures the effect size in linear models, indicating the proportion of variance explained. It is used in analyses involving categorical and continuous predictors, with values of 0.02, 0.15, and 0.35 representing small, medium, and large effects respectively.

### Effect Size Magnitudes

| Effect Size Measure | Small Effect | Medium Effect | Large Effect |
|---------------------|--------------|---------------|--------------|
| Cohen's d           | 0.2          | 0.5           | 0.8          |
| Pearson's \(r\)     | 0.1          | 0.3           | 0.5          |
| Cohen's \(f^2\)     | 0.02         | 0.15          | 0.35         |

These effect size magnitudes provide benchmarks for interpreting the strength of relationships or differences observed in research studies. By understanding and applying these standardized measures, researchers can effectively communicate the practical significance of their findings.

There are a number of different effect sizes that you can choose to calculate, but a common one for t-tests is Cohen's d: the standardized difference between two means (in units of SD) and is written as \( d = \text{effect-size-value} \). The key point is that Cohen's d is a standardized difference, meaning that it can be used to compare against other studies regardless of how the measurement was made.

Take, for example, height differences between men and women, which is estimated at about 5 inches (12.7 cm). That difference is an effect size, but it is an unstandardized effect size. For every sample tested, that difference depends on the measurement tools, the scale used, and the errors within them. Using a standardized effect size allows comparisons across studies regardless of measurement error.


### Cohen's d

**Definition**: Cohen's d measures the standardized difference between two means, expressed in units of standard deviation (SD).

#### Cohen's d (Unpaired)

Cohen's d for unpaired data measures the standardized difference between two independent groups:

\[ d = \frac{\text{mean of group 1} - \text{mean of group 2}}{\text{pooled standard deviation}} \]

where:
- Pooled standard deviation = \( \sqrt{\frac{{\text{sd1}^2 + \text{sd2}^2}}{2}} \)
- sd1, sd2 are the standard deviations of group 1 and group 2, respectively.

#### Cohen's d (Paired)

Cohen's d for paired data measures the standardized mean difference between two related groups:

\[ d = \frac{\text{mean of differences}}{\text{standard deviation of differences}} \]

where:
- Mean of differences = \( \text{mean of (group 1 - group 2)} \)
- Standard deviation of differences = \( \text{standard deviation of (group 1 - group 2)} \)

### Pearson's r

**Definition**: Pearson's correlation coefficient (r) measures the strength and direction of the linear relationship between two continuous variables.

\[ r = \frac{\text{Cov}(X, Y)}{SD(X) \times SD(Y)} \]

where:
- Cov(X, Y) is the covariance of X and Y.
- SD(X) and SD(Y) are the standard deviations of X and Y, respectively.

### Cohen's F

**Definition**: Cohen's F is used in linear models to measure the effect size for the overall model, related to the proportion of variance explained by the independent variable(s).

\[ \text{Cohen's F} =\sqrt{\frac{R^2}{1-R^2}} \]

where:
- \( R^2 \) ( sometimes referred to as eta squared) is the proportion of variance in the dependent variable explained by the independent variable(s).


## Introduction to Unstandardized Effect Sizes
While standardized effect sizes like Cohen's d and Pearson's 𝑟
r are valuable for comparing findings across studies, unstandardized effect sizes provide a direct measure of the magnitude of an effect within the original units of measurement. One common example is the beta coefficient (𝛽) in linear regression models.

Beta coefficient (𝛽): In the context of linear regression, the beta coefficient represents the change in the outcome variable (dependent variable) for a one-unit change in the predictor variable (independent variable), holding all other variables constant. Unlike standardized effect sizes, which are expressed in standard deviation units, the beta coefficient is in the original units of the variables involved in the regression model.
Understanding the beta coefficient allows researchers to interpret how changes in predictor variables influence the outcome variable directly within the context of their study. This direct interpretation is particularly useful when the focus is on understanding the real-world implications of relationships between variables in specific research contexts.
