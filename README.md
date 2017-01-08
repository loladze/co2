The R sript 'pwr.boot.R' allows to reproduce individual results reported in:

Loladze (2014) "Hidden shift of the ionome of plants exposed to elevated CO2 
depletes minerals at the base of human nutrition" eLife, freely available at 
(open-access):
http://elifesciences.org/content/3/e02245

The analytical dataset is available here (at the same GitHub depository) in CSV and XLSX formats: 'co2df.csv' and 'CO2 Dataset.xlsx'

The dataset reflects 7,761 observations of elevated CO2 effects on the plant 
ionome, covering 27 chemical elements (carbon and 26 minerals) for 130 plant varieties (125 C3-plants and 
five C4-plants), including:
wheat, rice, barely, bean, potato, rye, tomato, radish, 
cucumber, soybean, turnip, lettuce, carrot, alfalfa, celery, spinach, 
strawberry, rapeseed, and many trees and grasses.

It includes data on Nitrogen (N), Phosphorus (P), Calcium (Ca), Copper (Cu), 
Sulfur (S), Magnesium (Mg), Manganese (Mn), Iron (Fe), and Zinc (Zn) – the 
latter being deficient in diets of over two billion people.

The full list of chemical elements covered:
Al B Ba Br C Ca Cd Cl Co Cr Cu Fe K Mg Mn Mo N Na Ni P Pb S Se Si Sr V Zn

The data comes from four continents and many countries, including:

Australia, Bangladesh, Belgium, China, Denmark, Finland, Germany, India, Japan, 
Philippines, Sweden,  UK, USA.  

For details on how I complied and generated the dataset, please, see "Materials 
and methods" section of the paper:
http://elifesciences.org/content/3/e02245

For any questions or assistance with the script or the dataset, please, email:
Irakli Loladze at loladze@asu.edu

The following instructions assume basic familiarity with R.

1) Download 'pwr.boot.R' script file
2) Open it in R-Studio or on your R implementation
3) Run the script

Now you are ready to calculate the mean, 95% CI, SEM, Cohen’s d, and statistical
power for any subset in the co2df.csv dataset

Examples.
(Note that quotes in 'wheat' and other examples are NOT “smart quotes”, i.e. not
‘wheat’ or “wheat”)

To generate results for:

1) calcium (Ca) in wheat grains:
```
> co2df %>%
        filter(name == 'wheat', tissue == 'grain', element == 'Ca') %>%
        .$log.r %>% pwr.boot()
        
       mean        2.5%       97.5%       power sample size         SEM   Cohen's d 
-0.10529048 -0.16998095 -0.04269000  0.34870000 21.00000000  0.03442054  0.32481594 
```
2) iron (Fe) for all the foliar tissues:
```
> co2df %>%
      filter(fol.ed == 'F', element == 'Fe') %>%
      .$log.r %>% pwr.boot()
       mean        2.5%       97.5%       power sample size         SEM   Cohen's d 
-0.09630615 -0.17929973 -0.01692485  0.24540000 65.00000000  0.04245147  0.14722696 
```

3) nitrogen (N) in all the edible tissues:

```
> co2df %>%
        filter(fol.ed == 'E', element == 'N') %>% .$log.r %>% pwr.boot()
       mean        2.5%       97.5%       power sample size         SEM   Cohen's d 
-0.15065250 -0.18214769 -0.11573969  0.81630000 40.00000000  0.01747011  0.45829166 
```

4) magnesium (Mg) in C3 plants:
```
> co2df %>%
      filter(c3.c4 == 'C3', element == 'Mg') %>%
      .$log.r %>% pwr.boot()
        mean         2.5%        97.5%        power  sample size          SEM    Cohen's d 
 -0.09987317  -0.12900039  -0.07361217   0.95290000 123.00000000   0.01421605   0.31842785 
 ```

5) all the minerals (not counting carbon (C) or N) in edible tissues:
```
> co2df %>%
       filter(fol.ed == 'E', !(element %in% c('C', 'N'))) %>%
       .$log.r %>% pwr.boot()
         mean          2.5%         97.5%         power   sample size           SEM     Cohen's d 
 -0.066409551  -0.081599288  -0.051955346   1.000000000 534.000000000   0.007532951   0.287502259 
 ```

NOTE: Since the input in co2df.csv is given as the log response ratio, you can 
translate the output back from the log form by calculating expt(result)-1. 
For example, suppose the mean is -0.096, i.e. the change is -9.6%. Calculating 
exp(-0.096)-1=-0.0915, yields the decline of 9.15%.

All the results reported in the eLife article are already back-translated from 
the log form.