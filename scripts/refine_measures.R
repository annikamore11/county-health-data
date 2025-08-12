library(dplyr)
library(sf)
library(tigris)
library(leaflet)
library(tidyr)
library(htmltools)
library(readxl)
library(readr)
library(ggplot2)

# Read select measures for 2025 data release
measures_1 <- read_excel("2025_county_health.xlsx", sheet = "Select Measure Data", skip = 1)

# Read additional measures for 2025 data release
measures_2 <- read_excel("2025_county_health.xlsx", sheet = "Additional Measure Data", skip = 1)

# Read in available trends data
trends <- read_csv("chr_trends_csv_2025.csv")

# Used for different formatted data releases in different years
#################################################################
measures <- c("FIPS", "State", "County", "Deaths", "Years of Potential Life Lost Rate", 
             "% Excessive Drinking", "% Uninsured", "Preventable Hospitalization Rate",
             "Labor Force","% Unemployed", "% Children in Poverty", "% Children in Poverty (Black)", 
             "% Children in Poverty (Hispanic)", "% Children in Poverty (White)",
             "80th Percentile Income", "20th Percentile Income", "Income Ratio", "% Severe Housing Problems")
matched_vars <- intersect(measures, names(measures_1))

#print(matched_vars)
#################################################################


# filter and rename
#names(measures_1)
measures_1_new <- measures_1 %>% select(FIPS, State, County, Deaths, `Years of Potential Life Lost Rate`, `% Fair or Poor Health`, `% Uninsured`, `Preventable Hospitalization Rate`,
                                        `Labor Force`,`% Unemployed`, `% Children in Poverty`, `Income Ratio`, `% Severe Housing Problems`) %>%
  rename(
    fips = FIPS,
    state = State,
    county = County,
    deaths_under_75 = Deaths,
    years_pot_life_lost_rate = `Years of Potential Life Lost Rate`,
    pct_poor_health = `% Fair or Poor Health`,
    pct_uninsured = `% Uninsured`,
    prev_hospitalization_rate = `Preventable Hospitalization Rate`,
    labor_force = `Labor Force`,
    pct_unemployed = `% Unemployed`,
    pct_child_poverty = `% Children in Poverty`,
    income_ratio = `Income Ratio`,
    pct_sev_housing_problems = `% Severe Housing Problems`
)


# filter and rename
#names(measures_2)
measures_2_new <- measures_2 %>% select(FIPS, State, County, `Life Expectancy`, `Age-Adjusted Death Rate`, `% Adults with Obesity`, `% Adults Reporting Currently Smoking`, `Child Mortality Rate`, `Infant Mortality Rate`,
                                        `# Drug Overdose Deaths`, `% Disconnected Youth`, `Average Grade Performance...246`, `Average Grade Performance...252`, `School Funding Adequacy`, `Gender Pay Gap`, `% Voter Turnout`, `% Homeowners`, `Segregation Index...287`,
                                        `% Rural`) %>%
  rename(
    fips = FIPS,
    state = State,
    county = County,
    life_exectancy = `Life Expectancy`,
    premature_mortality = `Age-Adjusted Death Rate`,
    pct_obese_adults = `% Adults with Obesity`,
    pct_smokers = `% Adults Reporting Currently Smoking`,
    child_mortality_rate = `Child Mortality Rate`,
    infant_mortality_rate = `Infant Mortality Rate`,
    drug_overdose_death = `# Drug Overdose Deaths`,
    pct_discon_youth = `% Disconnected Youth`,
    ave_grade_performance_reading = `Average Grade Performance...246`,
    ave_grade_performance_math = `Average Grade Performance...252`,
    school_funding_adequacy = `School Funding Adequacy`,
    gender_pay_gap = `Gender Pay Gap`,
    pct_voter_turnout = `% Voter Turnout`,
    pct_homeowners = `% Homeowners`,
    school_segregation_index = `Segregation Index...287`,
    pct_rural = `% Rural`
  )

# join measures by fips code
all_measures_df <- left_join(measures_1_new, measures_2_new, by = "fips") %>%
  rename(
    state = state.x,
    county = county.x
  ) %>%
  select(-state.y, -county.y)

# separate state and county data
state_df = all_measures_df %>% filter(is.na(county)) %>% select(-county)
county_df = all_measures_df %>% filter(!is.na(county))

# aggregate state data to get national averages
us_df <- state_df %>%
  summarise(
    deaths_under_75 = sum(deaths_under_75, na.rm = TRUE),
    years_pot_life_lost_rate = mean(years_pot_life_lost_rate, na.rm = TRUE),
    pct_poor_health = mean(pct_poor_health, na.rm = TRUE),
    pct_uninsured = mean(pct_uninsured, na.rm = TRUE),
    prev_hospitalization_rate = mean(prev_hospitalization_rate, na.rm = TRUE),
    labor_force = sum(labor_force, na.rm = TRUE),
    pct_unemployed = mean(pct_unemployed, na.rm = TRUE),
    income_ratio = mean(income_ratio, na.rm = TRUE),
    pct_sev_housing_problems = mean(pct_sev_housing_problems, na.rm = TRUE),
    life_exectancy = mean(life_exectancy, na.rm = TRUE),
    premature_mortality = sum(premature_mortality, na.rm = TRUE),
    pct_obese_adults = mean(pct_obese_adults, na.rm = TRUE),
    pct_smokers = mean(pct_smokers, na.rm = TRUE),
    child_mortality_rate = sum(child_mortality_rate, na.rm = TRUE),
    infant_mortality_rate = sum(infant_mortality_rate, na.rm = TRUE),
    drug_overdose_death = sum(drug_overdose_death, na.rm = TRUE),
    pct_discon_youth = mean(pct_discon_youth, na.rm = TRUE),
    ave_grade_performance_reading = mean(ave_grade_performance_reading, na.rm = TRUE),
    ave_grade_performance_math = mean(ave_grade_performance_math, na.rm = TRUE),
    school_funding_adequacy = mean(school_funding_adequacy, na.rm = TRUE),
    gender_pay_gap = mean(gender_pay_gap, na.rm = TRUE),
    pct_voter_turnout = mean(pct_voter_turnout, na.rm = TRUE),
    pct_homeowners = mean(pct_homeowners, na.rm = TRUE),
    school_segregation_index = mean(school_segregation_index, na.rm = TRUE),
    pct_rural = mean(pct_rural, na.rm = TRUE)
  ) %>%
  mutate(fips = "00000",
         state = "US") %>%
  select(fips, state, everything())


# Get the full dataset with state, county, and national data
full_measures <- bind_rows(all_measures_df, us_df)

# append apostrophe on the fips code so that it does not convert to numeric
full_measures$fips <- paste0("'", sprintf("%05s", as.character(full_measures$fips)))
write_csv(full_measures, "data/2025-county-health-filtered.csv")









