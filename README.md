# Neighborhood Disadvantage and Health Outcomes Analysis
 
Analysis of how neighborhood socioeconomic disadvantage predicts mental health and obesity prevalence across US census tracts.
 
## Project Structure
 
```
├── 01_data_prep.ipynb          # Download ACS data via Census API, merge with PLACES
├── 02_index_and_models.r       # Construct disadvantage index, run regressions
├── 03_tables_figures.r         # Generate summary statistics tables and visualizations
│
├── data/
│   ├── acs_2015_2019.csv       # Raw ACS data (download from Census API)
│   ├── merged_data.csv         # Cleaned merged ACS + PLACES data
│   └── PLACES_Census_Tract_...csv   # Raw PLACES 2021 data
│
├── figures/
│   ├── index_distribution_informative.png
│   ├── index_vs_mental_health.png
│   └── index_vs_obesity.png
│
├── report.pdf                  # Final written report
└── README.md                   # This file
```
 
## Data Requirements
 
### Public Data (Free)
 
1. **ACS 2015-2019**: Download via Census Bureau API
   - Get free API key: https://api.census.gov/data/key_signup.html
   - Procure your own API key: No API key has been pushed on this public repo
   - Script: `01_data_prep.ipynb`
2. **CDC PLACES 2021**: Download from CDC website
   - Source: https://chronicdata.cdc.gov/browse?category=Health+Outcomes
   - File: `PLACES__Census_Tract_Data__GIS_Friendly_Format__2021_release.csv`
   - Place in `data/` folder
   
## Running the Analysis
 
### Step 1: Data Preparation (Python)
```bash 
# Run notebook
jupyter notebook 01_data_prep.ipynb
```
Outputs: `merged_data.csv`
 
### Step 2: Index Construction & Models (R)
```r
source('02_index_and_models.r')
```
Outputs: Index construction, primary regressions, robustness checks
 
### Step 3: Tables & Figures (R)
```r
source('03_tables_figures.r')
```
Outputs: Summary statistics, regression tables, visualizations
 
 
## Report
 
See `report.pdf` for full analysis including:
- Data & methodological decisions
- Index construction reasoning
- Regression results
- Robustness checks
- Critical reflection on limitations
## Requirements
 
**Python 3.8+**
- pandas
- requests
- numpy
**R 4.0+**
- tidyverse
- MASS
- sandwich
- lmtest
- stargazer
## Notes
- Analysis is cross-sectional (2015-2019 ACS, 2021 PLACES)
- Causality not claimed; associations only
- 11 missing values in mental health outcome; 0 missing in obesity
- No outliers removed from primary models
- All results robust across sensitivity analyses

 
**Reproducibility**: All code, data, and outputs documented. Analysis fully reproducible.
