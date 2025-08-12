# Population Health Data From County Health Rankings

An R script to query, clean, and prepare County Health Rankings data.

<https://www.countyhealthrankings.org/>

## Table of Contents

-   [Scripts](#scripts)
-   [Data](#data)
-   [Geography Levels](#geography-levels)
-   [Measures](#measures)
    -   [Population Health and Well-Being](#population-health-and-well-being)
        -   [Length of Life](#length-of-life)
        -   [Quality of Life](#quality-of-life)
    -   [Community Conditions](#community-conditions)
        -   [Health Infrastructure](#health-infrastructure)
        -   [Physical Environment](#physical-environment)
        -   [Social and Economic Factors](#social-and-economic-factors)
    -   [Demographics](#demographics)
-   [Trends Measures](#trends-measures)
-   [Installation](#installation)
-   [Required Packages](#required-packages)
-   [Update Schedule](#update-schedule)
-   [Important Considerations](#important-considerations)

## Scripts:

-   `refine_measures.R`: a script to retrieve latest County Health Rankings data at the national, state, and county level and filter to important measures.

## Data:

-   `2025_county_health.xlsx`: Excel file from County Health Rankings with full data set and documentation
-   `chr_trends_csv_2025.csv`: CSV file from County Health Rankings with updated trends data for select measures
-   `2025-county-health-filtered.csv`: CSV file from R script that contains cleaned and filtered data and an added geography level (US)

## Geography Levels:

-   National
-   State
-   County

## Measures:

Further descriptions of data fields, years, and sources included for each field can be found in `data/2025_county_health.xlsx` under the `Select Measure Sources and Years` sheet as well as the `Additional Measure Sources and Years` sheet.

### Population Health and Well-Being 

#### Length of Life 

| Field                    | Description                                                                          | Year(s)     |
|--------------------------|--------------------------------------------------------------------------------------|-------------|
| years_pot_life_lost_rate | Years of potential life lost before age 75 per 100,000 population (age-adjusted).    | 2020 - 2022 |
| life_expectancy          | Average number of years people are expected to live.                                 | 2020 - 2022 |
| premature_mortality      | Number of deaths among residents under age 75 per 100,000 population (age-adjusted). | 2020 - 2022 |
| child_mortality_rate     | Number of deaths among residents under age 20 per 100,000 population.                | 2019 - 2022 |
| infant_mortality_rate    | Number of infant deaths (within 1 year) per 1,000 live births.                       | 2016 - 2022 |

------------------------------------------------------------------------

#### Quality of Life 

| Field            | Description                                                                                                                                  | Year(s) |
|------------------|----------------------------------------------------------------------------------------------------------------------------------------------|---------|
| pct_poor_health  | Percentage of adults reporting fair or poor health (age-adjusted).                                                                           | 2022    |
| pct_obese_adults | Percentage of the adult population (age 18 and older) that reports a body mass index (BMI) greater than or equal to 30 kg/m2 (age-adjusted). | 2022    |

------------------------------------------------------------------------

### Community Conditions 

#### Health Infrastructure 

| Field                     | Description                                                                                     | Year(s)     |
|---------------------------|-------------------------------------------------------------------------------------------------|-------------|
| pct_uninsured             | Percentage of population under age 65 without health insurance.                                 | 2022        |
| prev_hospitalization_rate | Rate of hospital stays for ambulatory-care sensitive conditions per 100,000 Medicare enrollees. | 2022        |
| pct_smokers               | Percentage of adults who are current smokers (age-adjusted).                                    | 2022        |
| drug_overdose_death       | Number of drug poisoning deaths per 100,000 population.                                         | 2020 - 2022 |

------------------------------------------------------------------------

#### Physical Environment 

| Field                    | Description                                                                                                                                                   | Year(s)          |
|--------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| pct_sev_housing_problems | Percentage of households with at least 1 of 4 housing problems: overcrowding, high housing costs, lack of kitchen facilities, or lack of plumbing facilities. | 2017 - 2021      |
| pct_voter_turnout        | Percentage of citizen population aged 18 or older who voted in the 2020 U.S. Presidential election.                                                           | 2020 & 2016-2020 |
| pct_homeowners           | Percentage of owner-occupied housing units.                                                                                                                   | 2019 - 2023      |

------------------------------------------------------------------------

#### Social and Economic Factors 

| Field                         | Description                                                                                                                                                                                                                                                                                                                                                                                                                      | Year(s)            |
|-------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------|
| labor_force                   | Size of the labor force                                                                                                                                                                                                                                                                                                                                                                                                          | 2023               |
| pct_unemployed                | Percentage of population ages 16 and older unemployed but seeking work.                                                                                                                                                                                                                                                                                                                                                          | 2023               |
| pct_child_poverty             | Percentage of people under age 18 in poverty.                                                                                                                                                                                                                                                                                                                                                                                    | 2023 & 2019 - 2023 |
| income_ratio                  | Ratio of household income at the 80th percentile to income at the 20th percentile.                                                                                                                                                                                                                                                                                                                                               | 2019 - 2023        |
| pct_discon_youth              | Percentage of teens and young adults ages 16-19 who are neither working nor in school.                                                                                                                                                                                                                                                                                                                                           | 2019 - 2023        |
| ave_grade_performance_reading | Average grade level performance for 3rd graders on English Language Arts standardized tests.                                                                                                                                                                                                                                                                                                                                     | 2019               |
| ave_grade_performance_math    | Average grade level performance for 3rd graders on math standardized tests.                                                                                                                                                                                                                                                                                                                                                      | 2019               |
| school_funding_adequacy       | The average gap in dollars between actual and required spending per pupil among public school districts. Required spending is an estimate of dollars needed to achieve U.S. average test scores in each district.                                                                                                                                                                                                                | 2022               |
| gender_pay_gap                | Ratio of women's median earnings to men's median earnings for all full-time, year-round workers, presented as "cents on the dollar."                                                                                                                                                                                                                                                                                             | 2019 - 2023        |
| school_segregation_index      | The extent to which students within different race and ethnicity groups are unevenly distributed across schools when compared with the racial and ethnic composition of the local population. The index ranges from 0 to 1 with lower values representing a school composition that approximates race and ethnicity distributions in the student populations within the county, and higher values representing more segregation. | 2023 - 2024        |

### Demographics 

| Field     | Description                                                     | Year(s) |
|-----------|-----------------------------------------------------------------|---------|
| pct_rural | Percentage of population living in a census-defined rural area. | 2020    |

------------------------------------------------------------------------

## Trends Measures 

| Field                                | Description                                                                                                                                                                                                       |
|--------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 'Premature Death'                    | Years of potential life lost before age 75 per 100,000 population (age-adjusted).                                                                                                                                 |
| 'Uninsured adults'                   | Percentage of population under age 65 without health insurance.                                                                                                                                                   |
| 'Primary care physicians'            | Ratio of population to primary care physicians.                                                                                                                                                                   |
| 'Preventable hospital stays'         | Rate of hospital stays for ambulatory-care sensitive conditions per 100,000 Medicare enrollees.                                                                                                                   |
| 'Unemployment rate'                  | Percentage of population ages 16 and older unemployed but seeking work.                                                                                                                                           |
| 'Children in poverty'                | Percentage of people under age 18 in poverty.                                                                                                                                                                     |
| 'Sexually transmitted infections'    | Number of newly diagnosed chlamydia cases per 100,000 population.                                                                                                                                                 |
| 'Mammography screening'              | Percentage of female Medicare enrollees ages 65-74 who received an annual mammography screening.                                                                                                                  |
| 'Uninsured'                          | Percentage of population under age 65 without health insurance.                                                                                                                                                   |
| 'Dentists'                           | Ratio of population to dentists.                                                                                                                                                                                  |
| 'Uninsured children'                 | Percentage of children under age 19 without health insurance.                                                                                                                                                     |
| 'Air pollution - particulate matter' | Average daily density of fine particulate matter in micrograms per cubic meter (PM2.5).                                                                                                                           |
| 'Alcohol-impaired driving deaths     | Percentage of driving deaths with alcohol involvement.                                                                                                                                                            |
| 'Flue vaccinations'                  | Percentage of fee-for-service (FFS) Medicare enrollees who had an annual flu vaccination.                                                                                                                         |
| 'School funding'                     | The average gap in dollars between actual and required spending per pupil among public school districts. Required spending is an estimate of dollars needed to achieve U.S. average test scores in each district. |

## Installation

-   Clone the repository
-   Run `refine_measurements.R` to add or delete measures or to update data.
-   Download files from `data/` separately if no updates are needed.
-   When reading in `2025-county-health-filtered`, make sure to delete the apostrophe in `fips` values (apostrophe was needed to keep `fips` as a character field).

## Required Packages 

-   `dplyr`
-   `tidyr`
-   `readxl`
-   `readr`

## Update Schedule

-   County Health Rankings program releases annual data each spring, typically in March.
-   Data is delivered via bulk CSV files <https://www.countyhealthrankings.org/health-data/methodology-and-sources/data-documentation>
-   Data is updated, but each measure may be updated to different years. See documentation.

## Important Considerations

-   New data releases are not always in the same format and may contain variable names that have changed. When updating the data make sure to reformat and clean data for current release.
-   `US` geography level was formed by averaging or summing data from all the states. It was not a provided geography from County Health Rankings.
