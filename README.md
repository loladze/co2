This R code is provided for analyzing the CO2 dataset available at the Dryad depository:
www.datadryad.org, under DOI: 10.5061/dryad.6356f

For any questions or assistance with running it, please, email Irakli Loladze at loladze@asu.edu

The following instructions assume basic familiarity with R.

1) download co2df.csv from Dryad and place it into your working directory for R.

2) download pwr.boot.R file from GitHub and place it into your working directory for R.

3) load the dataset by running: co2df <- read.csv('co2df.csv')

4) Source pwr.boot function by running: source('REPLACE WITH YOUR WORKING DIRECTORY PATH/pwr.boot.R')

Now you are ready to calculate the mean, 95% CI, SEM, Cohen’s d, and statistical power for any subsample in the co2df.csv dataset

————————————————————————————————————————————————————————————————
Examples.
(Note that quotes in 'wheat' and similar are NOT “smart quotes”, i.e. not ‘wheat’ or “wheat”)

To generate results for:

1) calcium (Ca) in wheat grains, run:
pwr.boot(subset(co2df, name == 'wheat' & tissue =='grain' & element== 'Ca')$log.r)

The output should look like this:

   mean           2.5%      97.5%       power          m          SEM    Cohen's d 
-0.10529048 -0.16904833 -0.04044714  0.32030000 21.00000000  0.03442054  0.32481594 

2) iron (Fe) for all the foliar tissues, run:
pwr.boot(subset(co2df, fol.ed == 'F' & element== 'Fe')$log.r)

The output should look like this:

      mean      2.5%           97.5%      power       m           SEM    Cohen's d 
-0.09630615 -0.17924931 -0.01793754  0.24660000 65.00000000  0.04245147  0.14722696 

3) nitrogen (N) in all the edible tissues, run:
pwr.boot(subset(co2df, fol.ed == 'E' & element== 'N')$log.r)

The output should look like this:

      mean       	 2.5%       97.5%      power       m            SEM     Cohen's d 
-0.15065250 -0.18356163 -0.11618881  0.81640000 40.00000000  0.01747011  0.45829166 


4) magnesium (Mg) in C3 plants, run:
pwr.boot(subset(co2df, c3.c4 == 'C3' & element== 'Mg')$log.r)

The output should look like this:

    mean          2.5%        97.5%          power      m              SEM      Cohen's d 
 -0.09987317  -0.12946441  -0.07359177   0.94680000 123.00000000   0.01421605   0.31842785


5) all the minerals (not counting carbon (C) or N) in edible tissues, run:
pwr.boot(subset(co2df, fol.ed == 'E' & element!= 'C' & element!= 'N' )$log.r)

The output should look like this:

      mean          2.5%          97.5%         power         m            SEM        Cohen's d 
 -0.066409551  -0.081671479  -0.051776339   1.000000000 534.000000000   0.007532951   0.287502259 


NOTE: Since the input in co2df.csv is given as the log response ratio, you can translate the output back from the log form by calculating expt(result)-1. 
For example, suppose the mean is -0.096, i.e. the decline of -9.6%. Calculating exp(-0.096)-1=-0.0915, yields the decline of 9.15%.

All the results reported in the paper are already back-translated from the log form.
