############## Setting the working directory and installing packages ###########
# Load required packages
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(tidyverse, MASS, sandwich, lmtest, dplyr, stargazer, ggplot2)

outcomes <- read.csv("merged_data.csv") #merged ACS and CDC PLACES dataset

# Create index variables from the data
outcomes <- outcomes %>%
  mutate(
    Poverty_Rate = (Population_Below_Poverty / Total_Population_Poverty) * 100,
    Unemployment_Rate = (Unemployed / Civilian_Labor_Force) * 100,
    Pct_Less_9th_Grade = (Population_Less_9th_Grade / Population_25Plus) * 100,
    Vacancy_Rate = (Vacant_Housing_Units / Total_Housing_Units) * 100
  )

#select variables for index
index_vars <- c(
  'Poverty_Rate',
  'Unemployment_Rate',
  'Pct_Less_9th_Grade',
  'Vacancy_Rate'
)

#standardize variables (z-scores)
outcomes <- outcomes %>%
  mutate(across(all_of(index_vars),
                list(z = ~scale(., center = TRUE, scale = TRUE)[,1]),
                .names = '{.col}_z'))

outcomes <- outcomes %>%
  mutate(disadvantage_index = rowMeans(
    cbind(Poverty_Rate_z, Unemployment_Rate_z, Pct_Less_9th_Grade_z, Vacancy_Rate_z), 
    na.rm = TRUE
  ))

summary(outcomes$disadvantage_index)


#check
summary(outcomes$disadvantage_index)
cor(outcomes$disadvantage_index, outcomes$MHLTH_CrudePrev, use = "complete.obs")
cor(outcomes$disadvantage_index, outcomes$OBESITY_CrudePrev, use = "complete.obs")

# Regression Model - Mental Health
model_mh_primary <- lm(MHLTH_CrudePrev ~ disadvantage_index, data = outcomes)
summary(model_mh_primary)

# Regression Model - Obesity
model_ob_primary <- lm(OBESITY_CrudePrev ~ disadvantage_index, data = outcomes)
summary(model_ob_primary)


########################### Robustness Check 1 #################################
#huber weighting
robust_mh_huber <- rlm(MHLTH_CrudePrev ~ disadvantage_index, data = outcomes, psi = psi.huber)
robust_ob_huber <- rlm(OBESITY_CrudePrev ~ disadvantage_index, data = outcomes, psi = psi.huber)

summary(robust_mh_huber)
summary(robust_ob_huber)

#bisquare weighting
robust_mh_bi <- rlm(MHLTH_CrudePrev ~ disadvantage_index, data = outcomes, psi = psi.bisquare)
robust_ob_bi <- rlm(OBESITY_CrudePrev ~ disadvantage_index, data = outcomes, psi = psi.bisquare)

summary(robust_mh_bi)
summary(robust_ob_bi)

########################### Robustness Check 2 #################################
# Heteroscedasticity-Robust Standard Errors
coeftest(model_mh_primary, vcov = vcovHC(model_mh_primary, type = "HC3"))
coeftest(model_ob_primary, vcov = vcovHC(model_ob_primary, type = "HC3"))

########################### Robustness Check 3 #################################
# Exclude extreme values in outcomes
p01_mh <- quantile(outcomes$MHLTH_CrudePrev, 0.01, na.rm = TRUE)
p99_mh <- quantile(outcomes$MHLTH_CrudePrev, 0.99, na.rm = TRUE)

p01_ob <- quantile(outcomes$OBESITY_CrudePrev, 0.01, na.rm = TRUE)
p99_ob <- quantile(outcomes$OBESITY_CrudePrev, 0.99, na.rm = TRUE)

outcomes_no_outliers <- outcomes %>%
  filter(MHLTH_CrudePrev >= p01_mh & MHLTH_CrudePrev <= p99_mh) %>%
  filter(OBESITY_CrudePrev >= p01_ob & OBESITY_CrudePrev <= p99_ob)

model_mh_no_outliers <- lm(MHLTH_CrudePrev ~ disadvantage_index, data = outcomes_no_outliers)
model_ob_no_outliers <- lm(OBESITY_CrudePrev ~ disadvantage_index, data = outcomes_no_outliers)

summary(model_mh_no_outliers)
summary(model_ob_no_outliers)


