# (PART\*) Descriptive Statistics {.unnumbered}

# Data Quality








Before diving into data analysis, it is crucial to understand and address various aspects of data quality. Ensuring data quality is the foundation of robust and reliable insights. High-quality data leads to accurate analyses and valid conclusions, while poor-quality data can result in misleading findings and faulty decisions. This introductory guide outlines key dimensions of data quality, including completeness, consistency, accuracy, validity, uniformity, distribution, redundancy, integrity, temporal consistency, and bias checks. Understanding and evaluating these dimensions is an essential first step in generating insights from our data.

| Dimension                | Importance                                                                                      | Action                                                                                                    |
|--------------------------|-------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| Tidy data | Most of our dplyr functions and later modelling work on the assumption that data is tidy (each column is a unique variable, each row is a unique observation)      | Check that data visually conforms to tidy data principles            |
| Completeness: Missing Data and Duplicates | Missing data and duplicates can skew analysis results and reduce the reliability of insights.          | Identify and address missing values and duplicates to ensure a complete and accurate dataset.             |
| Accuracy: Range Checks and Outlier Detection | Inaccurate data can distort analysis outcomes and lead to incorrect conclusions.                          | Perform range checks and outlier detection to validate the accuracy of the data.                          |
| Validity: Data Types  | Data that does not conform to expected types can cause errors in analysis.          | Verify that each column of data is in the correct format.                         |
| Uniformity: Units, Formats, and Text Consistency | Inconsistent units, formatting, and text can complicate data integration and analysis.                        | Standardize units, formats, and text to ensure uniformity and facilitate seamless analysis.               |
| Distribution: Analyzing Variable Distributions | Understanding the distribution of variables is key to selecting appropriate analysis techniques.            | Analyze variable distributions to identify patterns, trends, and potential anomalies.                     |
| Bias Checks: Representativeness and Selection Bias | Biases can skew results and lead to misleading conclusions.                                                | Evaluate the representativeness of the data and check for selection bias to ensure unbiased analysis.      |



#### Data wrangling

Importantly you should have already generated an understanding of data checking and validation of your dataset during the [data wrangling](#data-wrangling-part-one) steps. Including gaining insights on: 

* The number of variables

* The data format of each variable

* Checked for missing data

* Checked for typos, duplications or other data errors

* Cleaned column or factor names

<div class="warning">
<p>It is very important to not lose site of the questions you are
asking</p>
<p>You should also play close attention to the data, and remind yourself
<strong>frequently</strong> how many variables do you have and what are
their names?</p>
<p>How many rows/observations do you have?</p>
<p>Pay close attention to the outputs, errors and warnings from the R
console.</p>
</div>

## Variable types

A quick refresher:

### Numerical

You **should** already be familiar with the concepts of numerical and categorical data. **Numeric** variables have values that describe a measure or quantity. This is also known as quantitative data. We can subdivide numerical data further:

* **Continuous numeric variables.** This is where observations can take any value within a range of numbers. Examples might include body mass (g), age, temperature or flipper length (mm). 
While in theory these values can have any numbers, within a dataset they are likely bounded (set within a minimum/maximum of observed or measurable values), and the accuracy may only be as precise as the measurement protocol allows. 

In a tibble these will be represented by the header `<dbl>`.

* **Discrete numeric variables** Observations are numeric but restricted to *whole values* e.g. 1,2,3,4,5 etc. These are also known as **integers**. Discrete variables could include the number of individuals in a population, number of eggs laid etc. Anything where it would make no sense to describe in fractions e.g. a penguin cannot lay 2 and a half eggs. Counting!

In a tibble these will be represented by the header `<int>`.

### Categorical

Values that describe a characteristic of data such as 'what type' or 'which category'. Categorical variables are mutually exclusive - one observation should not be able to fall into two categories at once - and should be exhaustive - there should not be data which does not *fit* a category (not the same as NA - not recorded). Categorical variables are qualitative, and often represented by non-numeric values such as words. It's a bad idea to represent categorical variables as numbers (R won't treat it correctly). Categorical variables can be defined further as:

* **Nominal variables** Observations that can take values that are not logically ordered. Examples include Species or Sex in the Penguins data. 
In a tibble these will be represented by the header `<chr>`.

* **Ordinal variables** Observations can take values that can be logically ordered or ranked. Examples include - activity levels (sedentary, moderately active, very active); size classes (small, medium, large). 

These will have to be coded manually see [Factors](#factors), and will then be represented in a tibble by the header `<fct>`

It is important to order Ordinal variables in the their logical order value when plotting data visuals or tables. Nominal variables are more flexible and could be ordered in whatever pattern works best for your data ( by default they will plot alphabetically, but perhaps you could order them according to the values of another numeric variable). 

#### Quick view of variables

Let's take a look at some of our variables, these functions will give a quick snapshot overview.


```r
glimpse(penguins)
summary(penguins)
```
Here we get insights into whether each variable is in a valid data type, information on range and the extent of any missingness.

Q. We can see that bill length contains numbers, and that many of these are fractions, but only down to 0.1mm. By comparison body mass all appear to be discrete number variables. Does this make body mass an integer? 

The underlying quantity (bodyweight) is clearly continuous, it is clearly possible for a penguin to weigh 3330.7g but it might *look* like an integer because of the way it was measured. This illustrates the importance of understanding the the type of variable you are working with - just looking at the values isn't enough. 

On the other hand, how we choose to measure and record data *can* change the way it is presented in a dataset. If the researchers had decided to simply record small, medium and large classes of bodyweight, then we would be dealing with ordinal categorical variables (factors). These distinctions can become less clear if we start to deal with multiple classes of ordinal categories - for example if the researchers were measuring body mass to the nearest 10g. It might be reasonable to treat these as integers...

## Missing data

The first issue we will cover is missing data. There is a whole host of reasons that your data could have missing values. 

This can be broken down into three broad categories: 

| Missing Data Mechanism            | Description                                                                 | Example                                                                                  |
|-----------------------------------|-----------------------------------------------------------------------------|------------------------------------------------------------------------------------------|
| **MCAR (Missing Completely at Random)** | The probability of missing data is independent of any observed or unobserved data.       | Leaf samples lost randomly due to a labeling error in a plant growth study.              |
| **MAR (Missing at Random)**       | The probability of missing data is related to some observed data but not to the missing data itself. | Blood pressure readings missing more frequently for older patients in a drug trial.      |
| **MNAR (Missing Not at Random)**  | The probability of missing data is related to the value of the missing data itself.       | Heavier birds in a wildlife study are harder to capture and weigh, leading to missing weight data. |

Understanding which type of process is causing your missing data is important, for any type of missingness at random we can process our data accordingly. But if the missing data is Not at Random we may have to consider collecting more data. 

### Deletion


```r
penguins_listwise <- drop_na(penguins)
```

As you can see, penguins_listwise now only contains data for penguins with a complete set of data—i.e., observations in each column.

While this might seem beneficial and sometimes is the most appropriate option, there are a couple of important points to consider.

First, let's say the blood isotopes might not be part of our primary analysis; it might just be there as additional information. If we don't plan to include these in any of our analyses, using listwise deletion (removing rows with any missing values) might unnecessarily exclude observations that are otherwise complete for the relevant variables. This means we might be discarding valuable data.

Additionally, using a listwise deletion approach can result in significant data loss. Compare the original penguins dataset to penguins_listwise. The original dataset had 344 observations. After using drop_na(), we only have 34 observations, meaning we've lost a huge portion of our data with this approach! Only a handful of observations have accompanying notes in the comments column

Note: If you use a listwise deletion approach, it's also important to check that the missing values are not concentrated in a particular group (i.e., ensure the missing data is random and not biased).

To address these issues, you can modify the use of drop_na() to exclude specific columns, such as comments and isotopes, from the deletion criteria. This ensures you don't exclude observations based on irrelevant columns. For example, run the code below:


```r
penguins_listwise2 <- drop_na(penguins, -delta_15n, -delta_13c, -comments)
```


Q. How many observations does `penguins_listwise2` have?

<select class='webex-select'><option value='blank'></option><option value=''>34</option><option value=''>323</option><option value='answer'>333</option><option value=''>344</option></select>

This approach removes rows with NAs based on all columns except comments and isotopes.
Alternatively, you could choose to remove participants with NAs based only on specific columns relevant to your analysis, such as bill length and flipper length:

This demonstrates the flexibility of `drop_na()` — you have a lot of control as long as you plan your approach in advance.

### Pairwise deletion

An alternative to listwise deletion is pairwise deletion. This method removes cases depending on the analysis. For example, if we calculate correlations between bill length, flipper length, and body mass without first removing observations with missing data, we'll use different numbers of observations in each correlation based on the available data for each pair of variables.

Consider the following correlations:


```r
# Correlation between bill_length_mm and flipper_length_mm
cor.test(penguins$body_mass_g, penguins$delta_15n)
# Output example:
# t = 11.556, df = 328, p-value < 2.2e-16
# cor = -0.537

# Correlation between bill_length_mm and body_mass_g
cor.test(penguins$body_mass_g, penguins$delta_13c)
# Output example:
# t = -7.32, df = 329, p-value = 1.808e-12
# cor = -0.37
```

You can see that the correlation between body mass and delta_15n has df = 328, whereas the correlation between body mass and delta_13c has df = 329. This indicates that the correlation is calculated only on the observations with available data for both columns—pairwise deletion.

The challenge here is to remember to report the degrees of freedom (dfs) accordingly, as they change and may differ from the total number of observations mentioned in your methods section. Therefore, it is crucial to thoroughly examine your data!

### Summarising data with missing values

When running inferential tests like correlations, and later, linear models, the analysis will usually know to ignore missing values. However, when calculating descriptive statistics or if you want to calculate the average score of a number of different items, you need to explicitly state to ignore the missing values. We can do this through `na.rm = TRUE`


```r
penguins %>% 
  group_by(species) %>% 
  summarise(mean = mean(body_mass_g))
```

<div class="kable-table">

|species   |     mean|
|:---------|--------:|
|Adelie    |       NA|
|Chinstrap | 3733.088|
|Gentoo    |       NA|

</div>

As you can see, the mean score for body mass in Adelie and Gentoo penguins shows as `NA`. This is because we are trying to calculate an average of a variable that has missing data and that just isn't doable. As such we need to calculate the mean but ignoring the missing values by adding `na.rm = TRUE`


```r
penguins %>% 
  group_by(species) %>% 
  summarise(mean = mean(body_mass_g, na.rm = T))
```

<div class="kable-table">

|species   |     mean|
|:---------|--------:|
|Adelie    | 3700.662|
|Chinstrap | 3733.088|
|Gentoo    | 5076.016|

</div>

When working with data, it’s crucial to consider whether you want to calculate your descriptive statistics from observations with missing data. For instance, if you are calculating the average body mass from hundreds of measurements, a few missing data points won’t significantly impact the validity of the mean. However, if the missing data is biased in some way, or you only have values for 30% of the total dataset, it may not be appropriate to calculate a mean score from the remaining data. 


```r
penguins %>% 
    group_by(species) %>% 
    summarise(count_na = is.na(body_mass_g) %>% sum())
```

<div class="kable-table">

|species   | count_na|
|:---------|--------:|
|Adelie    |        1|
|Chinstrap |        0|
|Gentoo    |        1|

</div>

## Implausible values

### Categorical data

Along with looking for missing values, an additional crucial step of data screening is checking for implausible values - values that should not exist in your data. What is implausible depends on the data you've collected!

The first place to look for implausible values is in character and factorial data - typos will be incorrectly processed as unique levels to a variable


```r
penguins %>% distinct(sex)

penguins %>% distinct(species)
```

<div class="kable-table">

|sex    |
|:------|
|MALE   |
|FEMALE |
|NA     |

</div><div class="kable-table">

|species   |
|:---------|
|Adelie    |
|Gentoo    |
|Chinstrap |

</div>

Or you could combine these into a single run


```r
penguins %>% 
  dplyr::select(sex, species, region, island) %>% 
  distinct()
```

<div class="kable-table">

|sex    |species   |region |island    |
|:------|:---------|:------|:---------|
|MALE   |Adelie    |Anvers |Torgersen |
|FEMALE |Adelie    |Anvers |Torgersen |
|NA     |Adelie    |Anvers |Torgersen |
|FEMALE |Adelie    |Anvers |Biscoe    |
|MALE   |Adelie    |Anvers |Biscoe    |
|FEMALE |Adelie    |Anvers |Dream     |
|MALE   |Adelie    |Anvers |Dream     |
|NA     |Adelie    |Anvers |Dream     |
|FEMALE |Gentoo    |Anvers |Biscoe    |
|MALE   |Gentoo    |Anvers |Biscoe    |
|NA     |Gentoo    |Anvers |Biscoe    |
|FEMALE |Chinstrap |Anvers |Dream     |
|MALE   |Chinstrap |Anvers |Dream     |

</div>

### Continuous data

Additional functions we can put inside a `summarise()` function are `min()` and `max()`.


```r
penguins %>%
    summarise_at(c("body_mass_g", "flipper_length_mm"),
               c(max = max, min = min),
               na.rm = TRUE)
```

<div class="kable-table">

| body_mass_g_max| flipper_length_mm_max| body_mass_g_min| flipper_length_mm_min|
|---------------:|---------------------:|---------------:|---------------------:|
|            6300|                   231|            2700|                   172|

</div>

Or we could use `summary` or `skimr::skim`

### Visualise continuous data

There are a number of different ways to visualise the data as you know and this depends on the data, and your preferences. You could produce histograms, or violin-boxplots with the data points on top to check the distributions as follows:


```r
penguins %>% 
  ggplot()+
  geom_histogram(aes(x=body_mass_g),
                 bins=10)
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-14-1.png" width="100%" style="display: block; margin: auto;" />



<div class="try">
<p>Change the value specified to the bins argument and observe how the
figure changes. It is usually a very good idea to try more than one set
of bins in order to have better insights into the data</p>
</div>



```r
penguins %>% 
  ggplot(aes(x=body_mass_g, y = 0))+
  geom_boxplot()+
  geom_jitter(height =.2)
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-16-1.png" width="100%" style="display: block; margin: auto;" />


To get the most out of your data, combine data you collected from the `summary()` function and your visuals here 

* Which values are the most common? <select class='webex-select'><option value='blank'></option><option value=''>< 3500g</option><option value='answer'>3500-4000g</option><option value=''>4000-4500g</option><option value=''>4500-5000g</option><option value=''>5000-5500g</option><option value=''>5500-6000g</option><option value=''>>6500g</option></select>

* Which values are rare? Why? Does that match your expectations?
<select class='webex-select'><option value='blank'></option><option value=''>< 3500g</option><option value=''>3500-4000g</option><option value=''>4000-4500g</option><option value=''>4500-5000g</option><option value=''>5000-5500g</option><option value=''>5500-6000g</option><option value='answer'>>6500g</option></select>

* Can you see any unusual patterns? <select class='webex-select'><option value='blank'></option><option value=''>Yes</option><option value='answer'>No</option></select>

* How many observations are missing body mass information? <input class='webex-solveme nospaces' size='1' data-answer='["2"]'/>


<button id="displayTextunnamed-chunk-17" onclick="javascript:toggle('unnamed-chunk-17');">Show Solution</button>

<div id="toggleTextunnamed-chunk-17" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">
Penguins weighing less than 3kg and more than 6kg are rare. 
The most common weight appears to be just under 4kg. 

There appear to be more data points to the right of the peak of the histogram than there are too the left. E.g. the histogram is not symmetrical. But there is no evidence for any extreme outliers. </div></div></div>


If you found atypical values at this point, you could decide to exclude them from the dataset (using `filter()`, or impute the data (see below)). BUT you should only do this at this stage if you have a very strong reason for believing this is a mistake in the data entry, rather than a true outlier. 

### Impute data

One method for dealing with NA or implausible data is to remove it. An alternative method for dealing with implausible data is to impute the data, i.e., to replace missing data with substituted values. There are many methods of doing this, for example, you can replace missing values with the mean value of the distribution. Although there are more sophisticated methods available [see here](https://www.r-bloggers.com/2015/10/imputing-missing-data-with-r-mice-package/).

The code for imputing missing data uses `mutate()` and `replace_na()`: 


```r
penguins_imputed <- penguins %>% 
                    group_by(species, sex) %>% 
                    mutate(body_mass_g = replace_na(body_mass_g, mean(body_mass_g, na.rm = T))) %>% 
                    ungroup()
```

If you check the dataset, you can see that they have been given the value of the mean of the distribution in this new variable and then can be used in different analyses!


## Categorical variables

#### Frequency


```r
penguins %>% 
  group_by(species) %>% 
  summarise(n = n())
```

<div class="kable-table">

|species   |   n|
|:---------|---:|
|Adelie    | 152|
|Chinstrap |  68|
|Gentoo    | 124|

</div>


It might be useful for us to make some quick data summaries here, like relative frequency


```r
prob_obs_species <- penguins %>% 
  group_by(species) %>% 
  summarise(n = n()) %>% 
  mutate(prob_obs = n/sum(n))

prob_obs_species
```

<div class="kable-table">

|species   |   n|  prob_obs|
|:---------|---:|---------:|
|Adelie    | 152| 0.4418605|
|Chinstrap |  68| 0.1976744|
|Gentoo    | 124| 0.3604651|

</div>

So about 44% of our sample is made up of observations from Adelie penguins. We also know that our Chinstrap penguins make up less than 20% of the dataset. When it comes to making summaries about categorical data, that's about the best we can do, we can make observations about the most common categorical observations, and the relative proportions. 

Here it is important to consider whether we have any evidence for sampling bias. Or just to understand that the power of any analyses might be limited by the least abundant group. Either way it will be important to record and report these numbers when producing any analyses. 


```r
penguins %>% 
  ggplot()+
  geom_bar(aes(x=species))
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-21-1.png" width="100%" style="display: block; margin: auto;" />

This chart is ok - but can we make anything better?

We could go for a stacked bar approach


```r
penguins %>% 
  ggplot(aes(x="",
             fill=species))+ 
  # specify fill = species to ensure colours are defined by species
  geom_bar(position="fill")+ 
  # specify fill forces geom_bar to calculate percentages
  scale_y_continuous(labels=scales::percent)+ 
  #use scales package to turn y axis into percentages easily
  labs(x="",
       y="")+
  theme_minimal()
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-22-1.png" width="100%" style="display: block; margin: auto;" />

This graph is OK *but not great*, the height of each section of the bar represents the relative proportions of each species in the dataset, but this type of chart becomes increasingly difficult to read as more categories are included. Colours become increasingly samey,and it is difficult to read where on the y-axis a category starts and stops, you then have to do some subtraction to work out the values. 

The best graph is then probably the first one we made - with a few minor tweak we can rapidly improve this. 


```r
penguins %>% 
  mutate(species=factor(species, levels=c("Adelie",
                                          "Gentoo",
                                          "Chinstrap"))) %>% 
  # set as factor and provide levels
  ggplot()+
  geom_bar(aes(x=species),
           fill="steelblue",
           width=0.8)+
  labs(x="Species",
       y = "Number of observations")+
  geom_text(data=prob_obs_species,
            aes(y=(n+10),
                x=species,
                label=scales::percent(prob_obs)))+
  coord_flip()+
  theme_minimal()
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-23-1.png" width="100%" style="display: block; margin: auto;" />

This is an example of a figure we might use in a report or paper. Having cleaned up the theme, added some simple colour, made sure our labels are clear and descriptive, ordered our categories in ascending frequency order, and included some simple text of percentages to aid readability. 

#### Two categorical variables

<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 
Think about what might be a suitable confounding variable to investigate and graph here? </div></div>


Understanding how frequency is broken down by species and sex might be useful information to have. 


```r
penguins %>% 
  group_by(species, sex) %>% 
  summarise(n = n()) %>% 
  mutate(prob_obs = n/sum(n))
```

<div class="kable-table">

|species   |sex    |  n|  prob_obs|
|:---------|:------|--:|---------:|
|Adelie    |FEMALE | 73| 0.4802632|
|Adelie    |MALE   | 73| 0.4802632|
|Adelie    |NA     |  6| 0.0394737|
|Chinstrap |FEMALE | 34| 0.5000000|
|Chinstrap |MALE   | 34| 0.5000000|
|Gentoo    |FEMALE | 58| 0.4677419|
|Gentoo    |MALE   | 61| 0.4919355|
|Gentoo    |NA     |  5| 0.0403226|

</div>

## Continuous variables


#### Central tendency

Central tendency is a descriptive summary of a dataset through a single value that reflects the center of the data distribution. The three most widely used measures of central tendency are **mean**, **median** and **mode**.

The **mean** is defined as the sum of all values of the variable divided by the total number of values. The **median** is the middle value. If N is odd and if N is even, it is the average of the two middle values. The **mode** is the most frequently occurring observation in a data set, but is arguable least useful for understanding biological datasets.

We can find both the mean and median easily with the summarise function. The **mean** is usually the best measure of central tendency when the distribution is symmetrical, and the **mode** is the best measure when the distribution is asymmetrical/skewed. 


```r
penguin_body_mass_summary <- penguins %>% 
    summarise(mean_body_mass=mean(body_mass_g, na.rm=T), 
              sd = sd(body_mass_g, na.rm = T),
              median_body_mass=median(body_mass_g, na.rm=T), 
              iqr = IQR(body_mass_g, na.rm = T))

penguin_body_mass_summary
```

<div class="kable-table">

| mean_body_mass|       sd| median_body_mass|  iqr|
|--------------:|--------:|----------------:|----:|
|       4201.754| 801.9545|             4050| 1200|

</div>


```r
penguins %>% 
ggplot()+
  geom_histogram(aes(x=body_mass_g),
               alpha=0.8,
               bins = 10,
               fill="steelblue",
               colour="darkgrey")+
   geom_vline(data=penguin_body_mass_summary,
             aes(xintercept=mean_body_mass),
             colour="red",
             linetype="dashed")+
     geom_vline(data=penguin_body_mass_summary,
             aes(xintercept=median_body_mass),
             colour="black",
             linetype="dashed")+
  labs(x = "Body mass (g)",
       y = "Count")+
  theme_classic()
```

<div class="figure" style="text-align: center">
<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-27-1.png" alt="Red dashed line represents the mean, Black dashed line is the median value" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-27)Red dashed line represents the mean, Black dashed line is the median value</p>
</div>



#### Normal distribution

From our histogram we can likely already tell whether we have normally distributed data. 

<div class="info">
<p>Normal distribution, also known as the “Gaussian distribution”, is a
probability distribution that is symmetric about the mean, showing that
data near the mean are more frequent in occurrence than data far from
the mean. In graphical form, the normal distribution appears as a “bell
curve”.</p>
</div>

If our data follows a normal distribution, then we can predict the spread of our data, and the likelihood of observing a datapoint of any given value with only the mean and standard deviation. 

Here we can simulate what a normally distributed dataset would look like with our sample size, mean and standard deviation.


```r
norm_mass <- rnorm(n = 344,
      mean = 4201.754,
      sd = 801.9545) %>% 
  as_tibble()

norm_mass %>% 
  as_tibble() %>% 
  ggplot()+
  geom_histogram(aes(x = value),
                 bins = 10)
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-29-1.png" width="100%" style="display: block; margin: auto;" />

#### QQ-plot

A QQ plot is a classic way of checking whether a sample distribution is the same as another (or theoretical distribution). They look a bit odd at first, but they are actually fairly easy to understand, and very useful! The qqplot distributes your data on the y-axis, and a theoretical normal distribution on the x-axis. If the residuals follow a normal distribution, they should meet to produce a perfect diagonal line across the plot.

Watch this video to see [QQ plots explained](https://www.youtube.com/watch?v=okjYjClSjOg)

<div class="figure" style="text-align: center">
<img src="images/qq_example.png" alt="Examples of qqplots with different deviations from a normal distribution" width="80%" />
<p class="caption">(\#fig:unnamed-chunk-30)Examples of qqplots with different deviations from a normal distribution</p>
</div>

In our example we can see that *most* of our residuals can be explained by a normal distribution, except at the low end of our data. 

So the fit is not perfect, but it is also not terrible!


```r
ggplot(penguins, aes(sample = body_mass_g))+
  stat_qq() + 
  stat_qq_line()
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-31-1.png" width="100%" style="display: block; margin: auto;" />

**How do we know how much deviation from an idealised distribution is ok?**


```r
penguins %>% 
  pull(body_mass_g) %>% 
  car::qqPlot()
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-32-1.png" width="100%" style="display: block; margin: auto;" />

```
## [1] 170 186
```

The qqPlot() function from the R package car provides 95% confidence interval margins to help you determine how severely your quantiles deviate from your idealised distribution.


With the information from the qqPlot which section of the distribution deviates most clearly from a normal distribution <select class='webex-select'><option value='blank'></option><option value='answer'><3500g</option><option value=''>3500-4000g</option><option value=''>4000-4500g</option><option value=''>5000-5500g</option><option value=''>>5500g</option></select>

<button id="displayTextunnamed-chunk-33" onclick="javascript:toggle('unnamed-chunk-33');">Show Solution</button>

<div id="toggleTextunnamed-chunk-33" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">
There are is a 'truncated' left tail of our normal distribution. We would predict more penguins with body masses lower than 3000g under the normal distribution.</div></div></div>


#### Variation

Dispersion (how spread out the data is) is an important component towards understanding any numeric variable. While measures of central tendency are used to estimate the central value of a dataset, measures of dispersion are important for describing the spread of data. 

Two data sets can have an equal mean (that is, measure of central tendency) but vastly different variability. 

Important measures for dispersion are **range**, **interquartile range**, **variance** and **standard deviation**. 

* The **range** is defined as the difference between the highest and lowest values in a dataset. The disadvantage of defining range as a measure of dispersion is that it does not take into account all values for calculation.

* The **interquartile range** is defined as the difference between the third quartile denoted by 𝑸_𝟑   and the lower quartile denoted by  𝑸_𝟏 . 75% of observations lie below the third quartile and 25% of observations lie below the first quartile.

* **Variance** is defined as the sum of squares of deviations from the mean, divided by the total number of observations. The standard deviation is the positive square root of the variance.  The **standard deviation** is preferred instead of variance as it has the same units as the original values.


#### Interquartile range

We used the IQR function in `summarise()` to find the interquartile range of the body mass variable.

The IQR is also useful when applied to the summary plots 'box and whisker plots'. We can also calculate the values of the IQR margins, and add labels with `scales` @R-scales. 


```r
penguins %>%
  summarise(q_body_mass = quantile(body_mass_g, c(0.25, 0.5, 0.75), na.rm=TRUE),
            quantile = scales::percent(c(0.25, 0.5, 0.75))) # scales package allows easy converting from data values to perceptual properties
```

<div class="kable-table">

| q_body_mass|quantile |
|-----------:|:--------|
|        3550|25%      |
|        4050|50%      |
|        4750|75%      |

</div>

We can see for ourselves the IQR is obtained by subtracting the body mass at tht 75% quantile from the 25% quantile (4750-3550 = 1200).

#### Standard deviation

standard deviation (or $s$) is a measure of how dispersed the data is in relation to the mean. Low standard deviation means data are clustered around the mean, and high standard deviation indicates data are more spread out. As such it makes sense only to use this when the mean is a good measure of our central tendency. 

<div class="info">
<p><span class="math inline">\(\sigma\)</span> = a known population
standard deviation</p>
<p><span class="math inline">\(s\)</span> = a sample standard
deviation</p>
</div>

<div class="panel panel-default"><div class="panel-heading"> Task </div><div class="panel-body"> 
If we know we have a normal distribution, then we can use `summarise()` to quickly produce a mean and standard deviation. </div></div>

<button id="displayTextunnamed-chunk-37" onclick="javascript:toggle('unnamed-chunk-37');">Show Solution</button>

<div id="toggleTextunnamed-chunk-37" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```
penguins %>% 
  summarise(mean = mean(body_mass_g, na.rm = T),
            sd = sd(body_mass_g, na.rm = T),
            n = n())
```
</div></div></div>


#### Visualising dispersion

<div class="figure" style="text-align: center">
<img src="images/distribution_gif.gif" alt="Visualising dispersion with different figures" width="80%" />
<p class="caption">(\#fig:unnamed-chunk-38)Visualising dispersion with different figures</p>
</div>


```r
colour_fill <- "darkorange"
colour_line <- "steelblue"
lims <- c(0,7000)

body_weight_plot <- function(){
  
  penguins %>% 
  ggplot(aes(x="",
             y= body_mass_g))+
  labs(x= " ",
       y = "Mass (g)")+
  scale_y_continuous(limits = lims)+
    theme_minimal()
}

plot_1 <- body_weight_plot()+
  geom_jitter(fill = colour_fill,
               colour = colour_line,
               width = 0.2,
              shape = 21)

plot_2 <- body_weight_plot()+
  geom_boxplot(fill = colour_fill,
               colour = colour_line,
               width = 0.4)

plot_3 <- penguin_body_mass_summary %>% 
  ggplot(aes(x = " ",
             y = mean_body_mass))+
  geom_bar(stat = "identity",
           fill = colour_fill,
           colour = colour_line,
               width = 0.2)+
  geom_errorbar(data = penguin_body_mass_summary,
                aes(ymin = mean_body_mass - sd,
                    ymax = mean_body_mass + sd),
                colour = colour_line,
                width = 0.1)+
  labs(x = " ",
       y = "Body mass (g)")+
  scale_y_continuous(limits = lims)+
  theme_minimal()

#library(patchwork)
plot_1 + plot_2 + plot_3 
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-39-1.png" width="80%" style="display: block; margin: auto;" />

We now have several compact representations of the body_mass_g including a histogram, boxplot and summary calculations. You can *and should* generate the same summaries for your other numeric variables. These tables and graphs provide the detail you need to understand the central tendency and dispersion of numeric variables. 

### What is an outlier?

Outliers are data points that deviate significantly from other observations in a dataset. They can be identified using various methods, such as the Interquartile Range (IQR), which defines outliers as values lying outside 1.5 times the IQR above the third quartile or below the first quartile. 

Other definitions may include standard deviations from the mean or z-scores.

However, it's crucial to approach outliers with caution. Removing them without context can lead to the loss of valuable information, as these points might reveal important insights or reflect underlying trends. Additionally, outliers can change when data transformations are applied or when models are fitted. Therefore, a thoughtful analysis of outliers is essential, considering their potential impact on conclusions and the overall integrity of the data.


## Categorical and continuous variables

It’s common to want to explore the distribution of a continuous variable broken down by a categorical variable. 



<div class='webex-solution'><button>Think about which other variables might affect body mass?</button>


<div class="figure" style="text-align: center">
<img src="images/body-mass-interaction.png" alt="Species and sex are both likely to affect body mass" width="80%" />
<p class="caption">(\#fig:unnamed-chunk-40)Species and sex are both likely to affect body mass</p>
</div>



So it is reasonable to think that perhaps either species or sex might affect the morphology of beaks directly - or that these might affect body mass (so that if there is a direct relationship between mass and beak length, there will also be an indirect relationship with sex or species).


</div>


The best and simplest place to start exploring these possible relationships is by producing simple figures. 

Let's start by looking at the distribution of body mass by species. 


## Activity 1: Produce a plot which allows you to look at the distribution of penguin body mass observations by species


<button id="displayTextunnamed-chunk-41" onclick="javascript:toggle('unnamed-chunk-41');">Show Solution</button>

<div id="toggleTextunnamed-chunk-41" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
jitter_plot <- penguins %>% 
    ggplot(aes(x = species,
               y = body_mass_g))+
    geom_jitter(shape = 21,
                fill = colour_fill,
                colour = colour_line,
                width = 0.2)+
  coord_flip()

box_plot <- penguins %>% 
    ggplot(aes(x = species,
               y = body_mass_g))+
    geom_boxplot(fill = colour_fill,
                colour = colour_line,
                width = 0.2)+
  coord_flip()

histogram_plot <- penguins %>% 
    ggplot(aes(fill = species))+
    geom_histogram(aes(x = body_mass_g,
                       y = ..density..),
                   position = "identity",
                   alpha = 0.6,
                colour = colour_line)

jitter_plot/box_plot/histogram_plot
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-70-1.png" width="100%" style="display: block; margin: auto;" />

So it is reasonable to think that perhaps either species or sex might affect body mass, and we can visualise this in a number of different ways. The last method, a density histogram, looks a little crowded now, so I will use the excellent `ggridges` package to help out
</div></div></div>



## GGridges

The package `ggridges` (@R-ggridges) provides some excellent extra geoms to supplement `ggplot`. One if its most useful features is to to allow different groups to be mapped to the y axis, so that histograms are more easily viewed. 

<button id="displayTextunnamed-chunk-42" onclick="javascript:toggle('unnamed-chunk-42');">Show Solution</button>

<div id="toggleTextunnamed-chunk-42" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
library(ggridges)

penguins %>% 
ggplot(aes(x = body_mass_g, y = species)) + 
  ggridges::stat_binline(fill = colour_fill,
                alpha = 0.8)
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-71-1.png" width="100%" style="display: block; margin: auto;" />

</div></div></div>

## QQplots by group

**Q. Does each species have a data distribution that appears to be normally distributed?**

* Gentoo <select class='webex-select'><option value='blank'></option><option value='answer'>Yes</option><option value=''>No</option></select>

* Chinstrap <select class='webex-select'><option value='blank'></option><option value='answer'>Yes</option><option value=''>No</option></select>

* Adelie <select class='webex-select'><option value='blank'></option><option value='answer'>Yes</option><option value=''>No</option></select>

<button id="displayTextunnamed-chunk-43" onclick="javascript:toggle('unnamed-chunk-43');">Show Solution</button>

<div id="toggleTextunnamed-chunk-43" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
penguins %>% 
  group_split(species) %>% 
  map(~ pull(.x, body_mass_g) 
      %>% car::qqPlot())
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-72-1.png" width="100%" style="display: block; margin: auto;" /><img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-72-2.png" width="100%" style="display: block; margin: auto;" /><img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-72-3.png" width="100%" style="display: block; margin: auto;" />

```
## [[1]]
## [1] 110 102
## 
## [[2]]
## [1] 38 39
## 
## [[3]]
## [1] 18 41
```

While the Gentoo density plot appears to show two peaks, our qqplot indicates this does not deviate from what me might expect from a normal distribution. But we could still investigate whether there are "two populations" here. 
</div></div></div>

If we wanted to we could also apply more formal tests of normality here: 


```r
penguins %>% 
  group_by(species) %>% 
  rstatix::shapiro_test(body_mass_g)
```

<div class="kable-table">

|species   |variable    | statistic|         p|
|:---------|:-----------|---------:|---------:|
|Adelie    |body_mass_g | 0.9807079| 0.0323970|
|Chinstrap |body_mass_g | 0.9844938| 0.5605082|
|Gentoo    |body_mass_g | 0.9859276| 0.2336165|

</div>

What's interesting to note here is that the qqplots were very similar to each other, and Shapiro's W is basically the same for all three species. Therefore the difference comes down to sample size. There are over twice as many Adelie penguins as Chinstrap's - so the power to detect small deviations from normality is higher. 



```r
penguins %>% drop_na %>% ggplot(aes(x = body_mass_g, y = species)) + 
    geom_density_ridges(aes(fill = sex),
                        colour = colour_line,
                        alpha = 0.8,
                        bandwidth = 175)
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-45-1.png" width="100%" style="display: block; margin: auto;" />

```r
# try playing with the bandwidth argument - this behaves similar to binning which you should be familiar with from using geom_histogram
```

If we take important subpopulations into account such as species and sex (these penguins have sexual dimorphism) - we see no evidence for any deviation from normality (despite the unexplained peaks we can still observe).


```r
penguins %>% 
    group_by(species,sex) %>% 
  drop_na()%>% 
  rstatix::shapiro_test(body_mass_g)
```

<div class="kable-table">

|species   |sex    |variable    | statistic|         p|
|:---------|:------|:-----------|---------:|---------:|
|Adelie    |FEMALE |body_mass_g | 0.9465622| 0.6983379|
|Adelie    |MALE   |body_mass_g | 0.9121815| 0.4509030|
|Chinstrap |FEMALE |body_mass_g | 0.9135586| 0.4210624|
|Chinstrap |MALE   |body_mass_g | 0.9377618| 0.6186508|
|Gentoo    |FEMALE |body_mass_g | 0.9622138| 0.7928330|
|Gentoo    |MALE   |body_mass_g | 1.0000000| 1.0000000|

</div>


## Activity 2: Test yourself

**Question 1.** Write down some insights you have made about the data and relationships you have observed. Compare these to the ones below. Do you agree with these? Did you miss any? What observations did you make that are **not** in the list below.


<div class='webex-solution'><button>What data insights have you made?</button>


This is revealing some really interesting insights into the shape and distribution of body sizes in our penguin populations now. 

For example:

* Gentoo penguins appear to show strong sexual dimorphism with almost all males being larger than females (little overlap on density curves).

* Gentoo males and females are on average larger than the other two penguin species

* Gentoo females have two distinct peaks of body mass. 

* Chinstrap penguins also show evidence of sexual dimorphism, though with greater overlap.

* Adelie penguins have larger males than females on average, but a wide spread of male body mass, (possibly two groups?)

Note how we are able to understand our data better, by spending time making data visuals. While descriptive data statistics (mean, median) and measures of variance (range, IQR, sd) are important. They are not substitutes for spending time thinking about data and making exploratory analyses. 


</div>



**Question 2.** Using `summarise` we can quickly calculate $s$ but can you replicate this by hand with `dplyr` functions?  -  do this for total $s$ (not by category). 

* Residuals

* Squared residuals

* Sum of squares

* Variance = SS/df

* $s=\sqrt{Variance}$

<button id="displayTextunnamed-chunk-47" onclick="javascript:toggle('unnamed-chunk-47');">Show Solution</button>

<div id="toggleTextunnamed-chunk-47" style="display: none"><div class="panel panel-default"><div class="panel-heading panel-heading1"> Solution </div><div class="panel-body">

```r
mean <- penguins %>% 
    summarise(mean = mean(body_mass_g, na.rm = T))

penguins %>% 
    mutate(residuals = (body_mass_g - pull(mean)),
           sqrd_resid = residuals^2) %>% 
    drop_na(sqrd_resid) %>% 
    summarise(sum_squares = sum(sqrd_resid),
              variance = sum_squares/(n=n())-1,
              sd = sqrt(variance))
```

<div class="kable-table">

| sum_squares| variance|       sd|
|-----------:|--------:|--------:|
|   219307697| 641249.6| 800.7806|

</div>
</div></div></div>


# Data insights






In this chapter we are concentrating on generating insights into our data using visualisations and descriptive statistics. The easiest way to do this is to use questions as tools to guide your investigation. When you ask a question, the question focuses your attention on a specific part of your dataset and helps you decide which graphs, models, or transformations to make.

Understanding the relationship between two or more variables is often the basis of most of our scientific questions. These might include comparing variables of the same type (numeric against numeric) or different types (numeric against categorical). In this chapter we will see how we can use descriptive statistics and visuals to explore associations

## Associations between numerical variables

#### Correlations

A common measure of association between two numerical variables is the **correlation coefficient**. The correlation metric is a numerical measure of the *strength of an association*

There are several measures of correlation including:

* **Pearson's correlation coefficient** : good for describing linear associations

* **Spearman's rank correlation coefficient**: a rank ordered correlation - good for when the assumptions for Pearson's correlation is not met. 

Pearson's correlation coefficient *r* is designed to measure the strength of a linear (straight line) association. Pearson's takes a value between -1 and 1. 

* A value of 0 means there is no linear association between the variables

* A value of 1 means there is a perfect *positive* association between the variables

* A value of -1 means there is a perfect *negative* association between the variables

A *perfect* association is one where we can predict the value of one variable with complete accuracy, just by knowing the value of the other variable. 


We can use the `cor` function in R to calculate Pearson's correlation coefficient. 



```r
library(rstatix)

penguins %>% 
  cor_test(culmen_length_mm, culmen_depth_mm)
```

<div class="kable-table">

|var1             |var2            |   cor| statistic|        p|   conf.low|  conf.high|method  |
|:----------------|:---------------|-----:|---------:|--------:|----------:|----------:|:-------|
|culmen_length_mm |culmen_depth_mm | -0.24| -4.459093| 1.12e-05| -0.3328072| -0.1323004|Pearson |

</div>
This tells us two features of the association. It's *sign* and *magnitude*. The coefficient is negative, so as bill length increases, bill depth decreases. The value -0.22 indicates that only about 22% of the variation in bill length can be explained by changes in bill depth (and *vice-versa*), suggesting that the variables are not closely related. 


<div class="figure" style="text-align: center">
<img src="images/correlation_examples.png" alt="Different relationships between two numeric variables. Each number represents the Pearson's correlation coefficient of each association" width="80%" />
<p class="caption">(\#fig:unnamed-chunk-50)Different relationships between two numeric variables. Each number represents the Pearson's correlation coefficient of each association</p>
</div>

* Because Pearson's coefficient is designed to summarise the strength of a linear relationship, this can be misleading if the relationship is *not linear* e.g. curved or humped. This is why it's always a good idea to plot the relationship *first* (see above).

* Even when the relationship is linear, it doesn't tell us anything about the steepness of the association (see above). It *only* tells us how often a change in one variable can predict the change in the other *not* the value of that change. 

This can be difficult to understand at first, so carefully consider the figure above. 

* The first row above shows differing levels of the strength of association. If we drew a perfect straight line between two variables, how closely do the data points fit around this line. 

* The second row shows a series of *perfect* linear relationships. We can accurately predict the value of one variable just by knowing the value of the other variable, but the steepness of the relationship in each example is very different. This is **important** because it means a perfect association can still have a small effect.

* The third row shows a series of associations where there is *clearly* a relationship between the two variables, but it is also not linear so would be inappropriate for a Pearson's correlation. 

#### Non-linear correlations

So what should we do if the relationship between our variables is non-linear? Instead of using Pearson's correlation coefficient we can calculate something called a **rank correlation**. 

Instead of working with the raw values of our two variables we can use rank ordering instead. The idea is pretty simple if we start with the lowest vaule in a variable and order it as '1', then assign labels '2', '3' etc. as we ascend in rank order. We can see a way that this could be applied manually with the function `dense_rank` from dplyr below:



```r
penguins %>% select(culmen_length_mm, 
                    culmen_depth_mm) %>% 
  drop_na() %>% 
  mutate(rank_length=dense_rank((culmen_length_mm)), 
         rank_depth=dense_rank((culmen_depth_mm))) %>% 
  head()
```

<div class="kable-table">

| culmen_length_mm| culmen_depth_mm| rank_length| rank_depth|
|----------------:|---------------:|-----------:|----------:|
|             39.1|            18.7|          43|         57|
|             39.5|            17.4|          46|         44|
|             40.3|            18.0|          52|         50|
|             36.7|            19.3|          23|         63|
|             39.3|            20.6|          45|         75|
|             38.9|            17.8|          41|         48|

</div>

Measures of rank correlation then are just a comparison of the rank orders between two variables, with a value between -1 and 1 just like Pearsons's. We already know from our Pearson's correlation coefficient, that we expect this relationship to be negative. So it should come as no surprise that the highest rank order values for bill_length_mm appear to be associated with lower rank order values for bill_depth_mm. 


To calculate Spearman's $\rho$ 'rho' is pretty easy, you can use the cor functions again, but this time specify a hidden argument to `method="spearman"`. 


```r
penguins %>% 
  cor_test(culmen_length_mm, culmen_depth_mm, method="spearman")
```

<div class="kable-table">

|var1             |var2            |   cor| statistic|        p|method   |
|:----------------|:---------------|-----:|---------:|--------:|:--------|
|culmen_length_mm |culmen_depth_mm | -0.22|   8145268| 3.51e-05|Spearman |

</div>
What we can see in this example is that Pearson's *r* and Spearman's $\rho$ are basically identical. 

#### Graphical summaries between numeric variables

Correlation coefficients are a quick and simple way to attach a metric to the level of association between two variables. They are limited however in that a single number can never capture the every aspect of their relationship. This is why we visualise our data. 

We have already covered scatter plots and `ggplot2()` extensively in previous chapters, so here we will just cover some of the different ways in which you could present the nature of a relationship


```r
length_depth_scatterplot <- ggplot(penguins, aes(x= culmen_length_mm, 
                     y= culmen_depth_mm)) +
    geom_point()

length_depth_scatterplot
```

<div class="figure" style="text-align: center">
<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-53-1.png" alt="A scatter plot of bill depth against bill length in mm" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-53)A scatter plot of bill depth against bill length in mm</p>
</div>

> **Note - Remember there are a number of different options available when constructing a plot including changing alpha to produce transparency if plots are lying on top of each other, colours (and shapes) to separate subgroups and ways to present third numerical variables such as setting aes(size=body_mass_g). 


```r
library(patchwork) # package calls should be placed at the TOP of your script

bill_depth_marginal <- penguins %>% 
  ggplot()+
  geom_density(aes(x=culmen_depth_mm), fill="darkgrey")+
  theme_void()+
  coord_flip() # this graph needs to be rotated

bill_length_marginal <- penguins %>% 
  ggplot()+
  geom_density(aes(x=culmen_length_mm), fill="darkgrey")+
  theme_void()

layout <- "
AA#
BBC
BBC"
# layout is easiest to organise using a text distribution, where ABC equal the three plots in order, and the grid is how much space they take up. We could easily make the main plot bigger and marginals smaller with

# layout <- "
# AAA#
# BBBC
# BBBC"
# BBBC

bill_length_marginal+length_depth_scatterplot+bill_depth_marginal+ # order of plots is important
  plot_layout(design=layout) # uses the layout argument defined above to arrange the size and position of plots
```

<div class="figure" style="text-align: center">
<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-54-1.png" alt="Using patchwork we can easily arrange extra plots to fit as marginals - these could be boxplots, histograms or density plots" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-54)Using patchwork we can easily arrange extra plots to fit as marginals - these could be boxplots, histograms or density plots</p>
</div>

These efforts allow us to capture details about the spread and distribution of both variables **and** how they relate to each other. This figure provides us with insights into

* The central tendency of each variable

* The spread of data in each variable

* The correlation between the two variables

## Associations between Categorical variables

Exploring associations between different categorical variables is not quite as simple as the previous numeric-numeric examples. Generally speaking we are interested in whether different combinations of categories are uniformally distributed or show evidence of clustering leading to *over- or under-represented* combinations. 
The simplest way to investigate this is to use `group_by` and `summarise` as we have used previously.


```r
island_species_summary <- penguins %>% 
  group_by(island, species) %>% 
  summarise(n=n(),
            n_distinct=n_distinct(individual_id)) %>% 
  ungroup() %>% # needed to remove group calculations
  mutate(freq=n/sum(n)) # then calculates percentage of each group across WHOLE dataset

island_species_summary
```

<div class="kable-table">

|island    |species   |   n| n_distinct|      freq|
|:---------|:---------|---:|----------:|---------:|
|Biscoe    |Adelie    |  44|         44| 0.1279070|
|Biscoe    |Gentoo    | 124|         94| 0.3604651|
|Dream     |Adelie    |  56|         56| 0.1627907|
|Dream     |Chinstrap |  68|         58| 0.1976744|
|Torgersen |Adelie    |  52|         52| 0.1511628|

</div>
> **Note - remember that group_by() applies functions which comes after it in a group-specific pattern.

What does the above tell us, that 168 observations were made on the Island of Biscoe, with three times as many Gentoo penguin observations made as Adelie penguins (remeber this is observations made, not individual penguins). When we account for penguin ID we see there are around twice as many Gentoo penguins recorded. We can see there are no Chinstrap penguins recorded on Biscoe. Conversely we can see that Gentoo penguins are **only** observed on Biscoe. 
The island of Dream has two populations of Adelie and Chinstrap penguins of roughly equal size, while the island of Torgensen appears to have a population comprised only of Adelie penguins. 

We could also use a bar chart in ggplot to represent this count data. 


```r
penguins%>% 
  ggplot(aes(x=island, fill=species))+
  geom_bar(position=position_dodge())+
  coord_flip()
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-56-1.png" width="100%" style="display: block; margin: auto;" />

This is fine, but it looks a bit odd, because the bars expand to fill the available space on the category axis. Luckily there is an advanced version of the postion_dodge argument. 



```r
penguins%>% 
  ggplot(aes(x=island, fill=species))+
  geom_bar(position=position_dodge2(preserve="single"))+ 
  #keeps bars to appropriate widths
  coord_flip()
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-57-1.png" width="100%" style="display: block; margin: auto;" />
> **Note the default for bar charts would have been a stacked option, but we have already seen how that can produce graphs that are difficult to read. 

An alternative approach would be to look at the 'relative proportions' of each population in our overall dataset. Using the same methods as we used previously when looking at single variables. Let's add in a few aesthetic tweaks to improve the look. 


```r
penguins %>% 
  ggplot(aes(x=island, fill=species))+
  geom_bar(position=position_dodge2(preserve="single"))+ 
  #keeps bars to appropriate widths
    labs(x="Island",
       y = "Number of observations")+
  geom_text(data=island_species_summary, # use the data from the summarise object
            aes(x=island,
                y= n+10, # offset text to be slightly to the right of bar
                group=species, # need species group to separate text
                label=scales::percent(freq) # automatically add %
                ),
            position=position_dodge2(width=0.8))+ # set width of dodge
  scale_fill_manual(values=c("cyan",
                            "darkorange",
                            "purple"
                            ))+
  coord_flip()+
  theme_minimal()+
  theme(legend.position="bottom") # put legend at the bottom of the graph
```

<div class="figure" style="text-align: center">
<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-58-1.png" alt="A dodged barplot showing the numbers and relative proportions of data observations recorded by penguin species and location" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-58)A dodged barplot showing the numbers and relative proportions of data observations recorded by penguin species and location</p>
</div>

## Associations between Categorical-numerical variables

Exploring associations between categorical and numerical variables is essential for uncovering how different categories influence numerical outcomes. 

Descriptive statistics and visualizations play a vital role in this process. Summary statistics such as mean, median, and range, grouped by categorical variables, can reveal significant differences and trends across categories. 

Visualizations like box plots and histograms with color-coded categories provide intuitive insights into data distribution, variability, and potential outliers. By leveraging these tools, you can identify patterns, assess the strength and direction of associations, and detect any anomalies.


```r
penguins %>% 
  ggplot(aes(x=species,
             y=body_mass_g))+
  geom_boxplot()+
  labs(y="Body mass (g)",
         x= "Species")
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-59-1.png" width="100%" style="display: block; margin: auto;" />


```r
penguins %>% 
  ggplot(aes(x=body_mass_g,
             fill=species))+
  geom_histogram(alpha=0.6,
         bins=30,
         position="identity")+
  facet_wrap(~species,
             ncol=1)
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-60-1.png" width="100%" style="display: block; margin: auto;" />

## Avoiding Bias

When evaluating data, it's crucial to consider the presence of bias at every stage of analysis. Bias refers to systematic errors or distortions in data collection, analysis, interpretation, and reporting that can skew conclusions and affect the reliability of findings.  We already considered issues like data quality problems (such as missing data or measurement errors) - but must remain aware of the need to address biases that may influence our insights.

Common issues include:

- **Confirmation bias**: This bias is often considered the most important and common because it can affect every stage of the research process—from hypothesis formation to data collection, analysis, and interpretation. We can reduce this by subjecting our hypotheses to carefully constructed statistical models that test for weight of evidence against the null hypothesis of no effect

- **Sampling bias**: Occurs when samples are collected leading to some members of the population being less likely to be included than others. We need to be aware of potential sampling bias, and report numbers in our data clearly. 

- **Multicollinearity**: When multiple variables are highly correlated, making it difficult to separate cause and effect roles.

- **Sample size issues**: Small sample sizes can lead to unreliable estimates and a low statistical power

- **Omitted variable bias**: Occurs when we fail to include important variables leading to biased estimates


### Multicollinearity

Using correlation plots is a quick and effective method to check for collinearity in your data. Collinearity occurs when predictor variables in a regression model are highly correlated with each other, which can lead to unstable estimates and inflated standard errors. A correlation plot visually displays the strength and direction of relationships between pairs of variables. High correlations (close to +1 or -1) indicate potential collinearity issues. By examining these plots, you can identify pairs of variables that may need further investigation or consideration for exclusion from your analysis to improve the robustness of your statistical models.


```r
penguins %>%  
  dplyr::select(culmen_length_mm, culmen_depth_mm, flipper_length_mm, body_mass_g) %>%  
  GGally::ggpairs()
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-61-1.png" width="100%" style="display: block; margin: auto;" />

Here for example we can see that several morphological features are highly correlated in size, not unsurprising - but we should therefore think carefully about using both body mass and flipper length as predictor variables in the same model. There are formal checks of multicollinearity we can also apply later. 

```r
penguins %>% 
  GGally::ggpairs(columns = 10:12, ggplot2::aes(colour = species))
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-62-1.png" width="100%" style="display: block; margin: auto;" />

### Omitted variable bias

Visualizations, such as scatterplots allow you to inspect relationships between variables that may not be captured by numerical summaries alone. By visually examining these relationships, you can identify potential confounding variables that should be included in your analyses to ensure accurate and unbiased estimates.

<img src="images/complexity.png" alt="Variables such as species or sex may directly or indirectly affect the relationship between body mass and beak length" width="80%" style="display: block; margin: auto;" />

For example it is reasonable to think that perhaps either species or sex might affect the morphology of beaks directly - or that these might affect body mass (so that if there is a direct relationship between mass and beak length, there will also be an indirect relationship with sex or species).

Failure to account for complex interactions can lead to misleading insights about your data including biased estimates of models and type 1 and 2 statistical errors. One of the most striking examples of omitted variable bias is "Simpson's paradox".  


#### Simpson's Paradox

Remember when we first correlated bill length and bill depth against each other we found an overall negative correlation of -0.22. However, this is because of a confounding variable we had not accounted for - species. 


<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-64-1.png" width="100%" style="display: block; margin: auto;" />

This is another example of why carefully studying your data - and carefully considering those variables which are likely to affect each other are studied or controlled for. It is an entirely reasonable hypothesis that different penguin species might have different bill shapes that might make an overall trend misleading. We can easily check the effect of a categoricial variable on our two numeric variables by assigning the aesthetic colour. 


```r
colours <- c("cyan",
             "darkorange",
             "purple")

length_depth_scatterplot_2 <- ggplot(penguins, aes(x= culmen_length_mm, 
                     y= culmen_depth_mm,
                     colour=species)) +
    geom_point()+
  geom_smooth(method="lm",
              se=FALSE)+
  scale_colour_manual(values=colours)+
  theme_classic()+
  theme(legend.position="none")+
    labs(x="Bill length (mm)",
         y="Bill depth (mm)")

length_depth_scatterplot
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-65-1.png" width="100%" style="display: block; margin: auto;" />

```r
bill_depth_marginal_2 <- penguins %>% 
  ggplot()+
  geom_density(aes(x=culmen_depth_mm,
                   fill=species),
               alpha=0.5)+
  scale_fill_manual(values=colours)+
  theme_void()+
  coord_flip() # this graph needs to be rotated

bill_length_marginal_2 <- penguins %>% 
  ggplot()+
  geom_density(aes(x=culmen_length_mm,
                   fill=species),
               alpha=0.5)+
  scale_fill_manual(values=colours)+
  theme_void()+
  theme(legend.position="none")

layout2 <- "
AAA#
BBBC
BBBC
BBBC"

bill_length_marginal_2+length_depth_scatterplot_2+bill_depth_marginal_2+ # order of plots is important
  plot_layout(design=layout2) # uses the layout argument defined above to arrange the size and position of plots
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-65-2.png" width="100%" style="display: block; margin: auto;" />

We now clearly see a striking reversal of our previous trend, that in fact *within* each species of penguin there is an overall positive association between bill length and depth. 

This should prompt us to re-evaluate our correlation metrics:


```r
penguins %>% 
  group_by(species) %>% 
  cor_test(culmen_length_mm, culmen_depth_mm)
```

<div class="kable-table">

|species   |var1             |var2            |  cor| statistic|     p|  conf.low| conf.high|method  |
|:---------|:----------------|:---------------|----:|---------:|-----:|---------:|---------:|:-------|
|Adelie    |culmen_length_mm |culmen_depth_mm | 0.39|  5.193285| 7e-07| 0.2472226| 0.5187796|Pearson |
|Chinstrap |culmen_length_mm |culmen_depth_mm | 0.65|  7.014647| 0e+00| 0.4917326| 0.7717134|Pearson |
|Gentoo    |culmen_length_mm |culmen_depth_mm | 0.64|  9.244703| 0e+00| 0.5262952| 0.7365271|Pearson |

</div>

We now see that the correlation values for all three species is >0.22 - indicating these associations are much closer than previously estimated. 


### Three or more variables

In the above example therefore, we saw the importance of exploring relationships among more than two variables at once. Broadly speaking there are two ways top do this

1. Layer an extra aesthetic mapping onto ggplot - such as size, colour, or shape


```r
penguins %>% 
  drop_na(sex) %>% 
ggplot(aes(x= culmen_length_mm, 
                     y= culmen_depth_mm,
                     colour=sex)) + # colour aesthetic set to sex
    geom_point(aes(shape = species))+
  geom_smooth(aes(group = species),
              method="lm",
              se=FALSE)+
  scale_colour_manual(values=c("#1B9E77", "#D95F02"))+ # pick two colour scheme
  theme_classic()+
  theme(legend.position="none")+
    labs(x="Bill length (mm)",
         y="Bill depth (mm)")
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-67-1.png" width="100%" style="display: block; margin: auto;" />

2. Use facets to construct multipanel plots according to the values of a categorical variable

If we want we can also adopt both of these approaches at the same time:


```r
penguins %>% 
  drop_na(sex) %>% 
ggplot(aes(x= culmen_length_mm, 
                     y= culmen_depth_mm,
                     colour=sex)) + # colour aesthetic set to sex
    geom_point()+
  geom_smooth(method="lm",
              se=FALSE)+
  scale_colour_manual(values=c("#1B9E77", "#D95F02"))+ # pick two colour scheme
  theme_classic()+
  theme(legend.position="none")+
    labs(x="Bill length (mm)",
         y="Bill depth (mm)")+
  facet_wrap(~species, ncol=1) # specify plots are stacked split by species
```

<img src="10-Data-insights-part-1_files/figure-html/unnamed-chunk-68-1.png" width="100%" style="display: block; margin: auto;" />

Here we can see that the trends are the same across the different penguin sexes. Although by comparing the slopes of the lines, lengths of the lines and amounts of overlap we can make insights into how "sexually dimorphic" these different species are e.g. in terms of beak morphology do some species show greater differences between males and females than others?

## Summing up

This is our last data handling workshop. We have built up towards being able to discover and examine relationships and differences among variables in our data. You now have the skills to handle many different types of data, tidy it, and produce visuals to generate insight and communicate this to others. 

A note of caution is required - it is very easy to spot and identify patterns.

When you do spot a trend, difference or relationship, it is important to recognise that you may not have enough evidence to assign a reason behind this observation. As scientists it is important to develope hypotheses based on knowledge and understanding, this can help (sometimes) with avoiding spurious associations. 

Sometimes we may see a pattern in our data, but it has likely occurred due to random chance, rather than as a result of an underlying process. This is where formal statistical analysis, to quantitatively assess the evidence, assess probability and study effect sizes can be incredibly powerful. We will delve into these exciting topics next term. 

That's it! Thank you for taking the time to get this far. Be kind to yourself if you found it difficult. You have done incredibly well.


