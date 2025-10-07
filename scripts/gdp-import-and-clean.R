library(tidyverse)
library(readxl)

## Import and clean the data


read_excel("data_raw/a-millennium-of-macroeconomic-data-for-the-uk.xlsx",
         sheet = "A21. GDP per capita 1086+") |>
  View("First try")



# Only select the rows and columns with data
gdp_per_capita <- read_excel("data_raw/a-millennium-of-macroeconomic-data-for-the-uk.xlsx",
           sheet = 28,
           range = "A5:K936")
View(gdp_per_capita)


# Rename first column to year and select Real GDP and Population columns,
# give them shorter names
gdp_per_capita <- gdp_per_capita |>
  select(year = ...1, gdp = `Real GDP, 2013 market prices`, pop = Population)
View(gdp_per_capita)

# Remove rows before 1270
gdp_per_capita <- gdp_per_capita |>
  filter(year >= 1270)
View(gdp_per_capita)


# Save the data
write_csv(gdp_per_capita, "data/gdp_per_capita.csv")

gdp_per_capita <- gdp_per_capita |>
  filter(year == 1347)
