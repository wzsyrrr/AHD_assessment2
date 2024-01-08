# 3D BMI Relationship Visualization App

## Compendium
|-- Desktop       <br />
    |-- README.md <br />
    |-- clean <br />
    |   |-- clean_dt.csv <br />
    |-- code <br />
    |   |-- model_compare.Rmd <br />
    |   |-- data_clean.R <br />
    |-- raw <br />
    |   |-- BMI.csv <br />
    |   |-- DEMO_D.csv <br />
    |   |-- FFQRAW_D.csv <br />
    |-- visualisation <br />
        |-- bmi_app.R <br />
        |-- model_compare.pdf <br />
        |-- bmi-boxplot.pdf <br />

## Introduction
This project focus on on analyzing and comparing two key columns - 'BMXBMI' and 'FFQ0102' - in the dataset provided in 'clean_dt.csv'. 
The aim is to uncover insights through comparison, identify trends, correlations, or anomalies that may exist between these two variables.
In addition, we add 'INDFMPIR' as a confounder. Finally, create a shiny app to use 3D plot to predict BMI based on frequency of eating potato chips and poverty income ratio.

## Installation
For this project, you will nedd R and the following R packages: `ggpplot2`, `dplyr`, `car`, `mfp`, `lspline`, `rms`

```R
install.packages(c("ggplot2", "dplyr", "car", "mfp", "lspline", "rms"))
```

## Usage
To use this project, load 'clean_dt.csv' into your data analysis environment. 

Then, proceed with your analysis, focusing on the 'BMXBMI' and 'FFQ0102' columns. For instance:
```
hist(dt$FFQ0102)

```
Then create different models and compare with them.
After that, check AIC and BIC for each model, and find the best fit. Then add 'INDFMPIR' into our model.

## 3D BMI Relationship Visualization App
This Shiny app visualizes the relationship between Body Mass Index (BMI), poverty income ratio (PIR), and the frequency of eating potato chips using a 3D plot. The app allows users to interactively explore data and input specific values to predict BMI based on the selected frequency of chip consumption and poverty income ratio.

- Interactive 3D plotting of BMI against chip consumption frequency and PIR.
- User input for prediction of BMI based on specific frequency and PIR.
- Fractional polynomial modeling to handle complex relationships in data.
- Data capping for PIR at a maximum value of 5.

## Run App
To run this app, you will need R and the following R packages: `shiny`, `dplyr`, `plotly`, and `mfp`. These can be installed using the following R commands:

```R
install.packages(c("shiny", "dplyr", "plotly", "mfp"))
```

