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
 
# A tibble: 1 × 7
     mean  `2.5%` `97.5%`  power  size    SEM `Cohen's d`
    <dbl>   <dbl>   <dbl>  <dbl> <dbl>  <dbl>       <dbl>
1 -0.1053 -0.1691 -0.0423 0.3451    21 0.0344      0.3248
```
2) Individual chemical elements in wheat (all tissues):

```
> co2df %>%
        filter(name=='wheat') %>%
        group_by(element) %>%
        do(pwr.boot(.$log.r))
        
   element    mean    `5%`   `95%`  power  size    SEM `Cohen's d`
     <chr>   <dbl>   <dbl>   <dbl>  <dbl> <dbl>  <dbl>       <dbl>
1        B  0.0987      NA      NA     NA     6 0.0939      0.2381
2        C  0.1417      NA      NA     NA     2     NA          NA
3       Ca -0.1210 -0.1721 -0.0715 0.5113    29 0.0320      0.2956
4       Cd -0.0076      NA      NA     NA     6 0.0939      0.2381
5       Co -0.3567      NA      NA     NA     1     NA          NA
6       Cr -0.0094      NA      NA     NA     2     NA          NA
7       Cu -0.0612 -0.1062 -0.0166 0.5866    25 0.0279      0.3655
8       Fe -0.1421 -0.1842 -0.1037 0.6968    33 0.0253      0.3495
9        K -0.0314 -0.0760  0.0132 0.5811    25 0.0278      0.3672
10      Mg -0.1295 -0.1870 -0.0799 0.5309    24 0.0346      0.3017
# ... with 11 more rows
```
3) Iron (Fe) for all the foliar tissues:
```
> co2df %>%
      filter(fol.ed == 'F', element == 'Fe') %>%
      .$log.r %>% pwr.boot()
      
# A tibble: 1 × 7
     mean  `2.5%` `97.5%`  power  size    SEM `Cohen's d`
    <dbl>   <dbl>   <dbl>  <dbl> <dbl>  <dbl>       <dbl>
1 -0.0963 -0.1801 -0.0144 0.2278    65 0.0425      0.1472
```

4) Individual elements in all the edible tissues:

```
> co2df %>%
        filter(fol.ed == 'E') %>%
        group_by(element) %>% 
        do(pwr.boot(.$log.r))
        
   element    mean  `2.5%` `97.5%`  power  size    SEM `Cohen's d`
     <chr>   <dbl>   <dbl>   <dbl>  <dbl> <dbl>  <dbl>       <dbl>
1       Al  0.4812      NA      NA     NA     1     NA          NA
2        B  0.0767 -0.0038  0.1619 0.1079     9 0.0742      0.2381
3       Ba -0.0943      NA      NA     NA     1     NA          NA
4        C  0.0915  0.0176  0.1754 0.1068    10 0.0700      0.2381
5       Ca -0.0474 -0.0828 -0.0134 0.8188    55 0.0182      0.3746
6       Cd -0.1048 -0.3102  0.0535 0.1210    18 0.0984      0.1233
7       Co -0.3567      NA      NA     NA     1     NA          NA
8       Cr -0.0936 -0.2268  0.0389 0.1169     7 0.0857      0.2381
9       Cu -0.0703 -0.1298 -0.0159 0.4459    52 0.0300      0.2337
10      Fe -0.1025 -0.1533 -0.0536 0.5230    65 0.0261      0.2398
# ... with 13 more rows
```

5) magnesium (Mg) in C3 plants:
```
> co2df %>%
      filter(c3.c4 == 'C3', element == 'Mg') %>%
      .$log.r %>% pwr.boot()
      
# A tibble: 1 × 7
     mean  `2.5%` `97.5%`  power  size    SEM `Cohen's d`
    <dbl>   <dbl>   <dbl>  <dbl> <dbl>  <dbl>       <dbl>
1 -0.0999 -0.1282 -0.0736 0.9489   123 0.0142      0.3184
 ```

6) all the minerals (not counting carbon (C) or nitrogen (N)) in edible tissues:
```
> co2df %>%
       filter(fol.ed == 'E', !(element %in% c('C', 'N'))) %>%
       .$log.r %>% pwr.boot()
       
# A tibble: 1 × 7
     mean  `2.5%` `97.5%` power  size    SEM `Cohen's d`
    <dbl>   <dbl>   <dbl> <dbl> <dbl>  <dbl>       <dbl>
1 -0.0664 -0.0812  -0.052     1   534 0.0075      0.2875
 ```

NOTE: Since the input in co2df.csv is given as the log response ratio, you can 
translate the output back from the log form by calculating expt(result)-1. 
For example, suppose the mean is -0.096, i.e. the change is -9.6%. Calculating 
exp(-0.096)-1=-0.0915, yields the decline of 9.15%.

All the results reported in the eLife article are already back-translated from 
the log form.