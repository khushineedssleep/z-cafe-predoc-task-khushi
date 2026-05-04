
############## Setting the working directory and installing packages ###########
# Load required packages
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(tidyverse, MASS, sandwich, lmtest, dplyr, stargazer, ggplot2)

source('02_index_and_models.r', encoding = "UTF-8")

########################### Table 1 #################################
summary_table <- outcomes[, c('MHLTH_CrudePrev', 'OBESITY_CrudePrev', 'Poverty_Rate', 
                              'Unemployment_Rate', 'Pct_Less_9th_Grade', 'Vacancy_Rate', 'disadvantage_index')]

stargazer(summary_table, 
          title = "Summary Statistics",
          label = "tab:summary_stats",
          summary.stat = c("mean", "sd", "min", "max", "n"),
          digits = 2,
          out = "table1_summary_stats.tex")

########################### Table 2 #################################
stargazer(model_mh_primary, model_ob_primary,
          title = "Primary Regression Results: Disadvantage Index and Health Outcomes",
          label = "tab:primary_results",
          column.labels = c("Mental Health", "Obesity"),
          dep.var.caption = "Outcome Variable",
          dep.var.labels = c("MHLTH\\_CrudePrev (%)", "OBESITY\\_CrudePrev (%)"),
          covariate.labels = c("Disadvantage Index"),
          omit.stat = c("f", "ser"),
          digits = 4,
          notes = "Standard errors in parentheses. *** p<0.001",
          out = "table2_primary_results.tex")

############################## PLOT 1 ##########################################
p1 <- ggplot(outcomes, aes(x = disadvantage_index)) +
  geom_histogram(bins = 50, fill = "steelblue", alpha = 0.7, color = "white") +
  geom_vline(aes(xintercept = mean(disadvantage_index, na.rm = TRUE)), 
             color = "red", linetype = "dashed", linewidth = 1, label = "Mean") +
  geom_vline(aes(xintercept = median(disadvantage_index, na.rm = TRUE)), 
             color = "green", linetype = "dotted", linewidth = 1, label = "Median") +
  labs(title = "Distribution of Neighborhood Disadvantage Index",
       subtitle = "Across 72,335 US Census Tracts (2015-2019)",
       x = "Disadvantage Index",
       y = "Number of Census Tracts",
       caption = "Index components: Poverty Rate, Unemployment Rate, Education (% <9th Grade), Housing Vacancy Rate") +
  annotate("text", x = 3.5, y = 6000, 
           label = paste("Mean =", round(mean(outcomes$disadvantage_index, na.rm = TRUE), 2),
                         "\nSD =", round(sd(outcomes$disadvantage_index, na.rm = TRUE), 2),
                         "\nN =", sum(!is.na(outcomes$disadvantage_index))),
           size = 3.5, hjust = 1, bbox = list(boxstyle = "round", fill = "white", alpha = 0.8)) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 14),
        plot.subtitle = element_text(size = 11, color = "gray40"),
        plot.caption = element_text(size = 9, hjust = 0))

ggsave('index_distribution_informative.png', plot = p1, width = 10, height = 6)

############################### PLOTS 2 and 3 ###################################
# 2. Index vs Mental Health
ggplot(outcomes, aes(x = disadvantage_index, y = MHLTH_CrudePrev)) +
  geom_point(alpha = 0.3, size = 1) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(title = "Disadvantage Index vs Mental Health Prevalence",
       x = "Disadvantage Index",
       y = "Poor Mental Health Rate (%)") +
  theme_minimal()

ggsave("index_vs_mental_health.png", width = 8, height = 5)

# 3. Index vs Obesity
ggplot(outcomes, aes(x = disadvantage_index, y = OBESITY_CrudePrev)) +
  geom_point(alpha = 0.3, size = 1) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(title = "Disadvantage Index vs Obesity Prevalence",
       x = "Disadvantage Index",
       y = "Obesity Rate (%)") +
  theme_minimal()

ggsave("index_vs_obesity.png", width = 8, height = 5)