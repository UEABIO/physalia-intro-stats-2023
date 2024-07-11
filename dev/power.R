
# Simple power analysis====

library(pwr)
library(simr)


## Cohen's d = (M2 - M1) ⁄ SDpooled ====

pwr.t.test(n=20, d = 1, sig.level = 0.05)

num_significant <- 0
sims <- 1000

## Simulation approach ====

set.seed(123)
for(i in 1:sims){
 
  sample1 <- rnorm(n=20, mean = 2, sd =1)
  
  sample2 <- rnorm(n=20, mean = 1, sd = 1)
  
  lm_model <- lm(c(sample1, sample2) ~ rep(c("Group1", "Group2"), each = 20))
  
  if (summary(lm_model)$coefficients[2,4] < 0.05) {
    num_significant <- num_significant + 1
  }
}
print(num_significant/sims)


## Linear model ====

pwr.f2.test(u = 2, f2 = 0.15,
            sig.level = 0.05, v = 57)

sample_size <- seq(10,100, by =10)

power <- lapply(sample_size, function(x){ power <- pwr.f2.test(u = 2, f2 = 0.15,
                                                     sig.level = 0.05, v = x ) 
                                  return(power$power)})
power
plot(sample_size, power)
lines(sample_size, power)


# get the effect size for ANOVA

R2 <- summary(lsmodel_frogs1) %>%
  glance() %>% 
  pull(r.squared)

# calculate Cohen's f2
R2 / (1 - R2)

## Simulation

## Frogs

frogs <- read_csv(here("book", "files", "frogs_messy_data.csv"))
#___________________________----

# TIDY DATA ----
frogs <- frogs %>% 
  rename("13" = Temperature13,
         "18" = Temperature18,
         "25" = Temperature25,
         frogspawn_id = `Frogspawn sample id`) %>% 
  pivot_longer(`13`:`25`, names_to="temperature", values_to="days") %>% 
  drop_na(days)



r_squared <- summary(lsmodel_frogs1)$adj.r.squared

# Calculate f^2
f_squared <- r_squared / (1 - r_squared)


effectsize::cohens_f(lsmodel_frogs1)



sample_size <- seq(3,10, by =1)

power <- lapply(sample_size, function(x){ power <- pwr.f2.test(u = 2, f2 = 3.06,
                                                               sig.level = 0.05, v = x ) 
return(power$power)})



## Pooled standard deviation
summary_frogs <- frogs %>% 
  group_by(temperature) %>% 
  summarise(mean = mean(days), 
            sd = sd(days), 
            n = n(),
            var = sd^2 * n-1) %>% 
  summarise(pooled_var = sum(var)/(sum(n)-3), pooled_sd = sqrt(pooled_var))




# Calculate the pooled standard deviation
pooled_sd <- sqrt(((n1 - 1) * sd1^2 + (n2 - 1) * sd2^2 + (n3 - 1) * sd3^2) / (n1 + n2 + n3 - k))

# Print the result
pooled_sd

n <- 20  # Number of samples per group

group <- rep(c("A", "B", "C"), each = n)

y <- c(rnorm(n, mean = 26.3, sd = summary_frogs$pooled_sd), 
       rnorm(n, mean = 21, sd = summary_frogs$pooled_sd), # change this? to same as group A - should be equal variance
       rnorm(n, mean = 15.9, sd =summary_frogs$pooled_sd))

y <- c(rnorm(n, mean = 1, sd = 0.04), # standardised drops in effects. 
       rnorm(n, mean = .84, sd = 0.04), 
       rnorm(n, mean = .61, sd = 0.04))

y <- c(rnorm(n, mean = 1, sd = 0.04), # standardised drops in effects. 
       rnorm(n, mean = .95, sd = 0.04), 
       rnorm(n, mean = .9, sd = 0.04))

# Create data frame
data <- data.frame(group = factor(group), y = y)

lm_model <- lm(y ~ group, data = data)

r_squared <- summary(lm_model)$adj.r.squared

# Calculate f^2
f_squared <- r_squared / (1 - r_squared)

# Print R^2 and f^2
cat("R^2:", r_squared, "\n")
cat("f^2:", f_squared, "\n")

# Calculate the standardized coefficients


sims <- 1000
n <- seq(10,100, by = 10)

for(i in 1:length(n)){

num_significant <- 0


for(j in 1:sims){
  
  #group_1 <- rnorm(n=n[[i]], mean =26.3, sd =.25*sqrt(n[[i]]))
  #group_2 <- rnorm(n=n[[i]], mean =21, sd =.25*sqrt(n[[i]]))
  #group_3 <- rnorm(n=n[[i]], mean =15.9, sd =.25*sqrt(n[[i]]))
  
  group_1 <- rnorm(n=n[[i]], mean =1, sd =.04*sqrt(n[[i]]))
  group_2 <- rnorm(n=n[[i]], mean =.95, sd =.04*sqrt(n[[i]]))
  group_3 <- rnorm(n=n[[i]], mean =.9, sd =.04*sqrt(n[[i]]))
  

  lm_model <- lm(c(group_1, group_2, group_3) ~ rep(c("Group1", "Group2", "Group3"), each = n[[i]]))
  
  if (anova(lm_model)[1,5]  < 0.05) {
    num_significant <- num_significant + 1
  }
}

print(num_significant/sims)

}

### 

# Example parameters
f_squared <- 0.15  # Desired f^2 effect size
alpha <- 0.05      # Significance level
num_simulations <- 1000

# Calculate R^2 from f^2
R_squared <- f_squared / (1 + f_squared)

# Calculate beta (standardized effect size)
beta <- sqrt(R_squared)

# Standardized coefficients for a model with one predictor (e.g., dummy variables for three levels)
# Assuming standard deviations of predictors (X1, X2, etc.) are known or set to 1 for simplicity
sd_X1 <- 1  # Standard deviation of predictor X1 (dummy variable 1)
sd_X2 <- 1  # Standard deviation of predictor X2 (dummy variable 2)

# Standardized coefficients
standardized_beta_0 <- beta  # Intercept (beta_0)
standardized_beta_1 <- beta / sd_X1  # Coefficient for X1 (beta_1)
standardized_beta_2 <- beta / sd_X2  # Coefficient for X2 (beta_2)

# Print the results
cat("Standardized coefficients:\n")
cat("Intercept (Beta_0):", standardized_beta_0, "\n")
cat("X1 (Beta_1):", standardized_beta_1, "\n")
cat("X2 (Beta_2):", standardized_beta_2, "\n")

# Simulation function to calculate power

num_significant <- 0
sims <- 1000
sample_size = 60
alpha = 0.05

for(i in 1:sims){
  
  # Generate data
  X <- sample(c(1, 2, 3), sample_size, replace = TRUE)
  Y <- (X*beta) + rnorm(sample_size)
  
  # Create data frame
  data <- data.frame(Y = Y, X = X)
  
  # Fit the linear model
  model <- lm(Y ~ as.factor(X), data = data)
  

  if (anova(model)[1,5]  < 0.05) {
    num_significant <- num_significant + 1
  }
}
print(num_significant/sims)

# Perform simulations to calculate power

power <- mean(replicate(num_simulations, simulate_power(sample_size = 60, beta = beta, alpha = alpha)))

cat("\nPower for the specified effect size (f^2 =", f_squared, "):", power, "\n")


# Turn unstandardised responses into effect sizes = check the effect size of simulated data and check power. 


## Generalised Linear models



## simr ====

fixed <- c(26.2, -5.01, -10.7)


model <- makeLmer(y ~ temperature, fixef=fixed, data=sim_frogs)

## Mixed models??? ====

