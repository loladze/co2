#####
#This version of the script together with updates can be found on
# GitHub. URL: http://github.com/loladze/co2.git  
# Author: Irakli Loladze <loladze@asu.edu>
# License: MIT
# 
### This R script:
# 1) reads directly from Github the dataset of the effects of elevated CO2 on 27 
#    chemical elements in crops & wild plants generated on four continents.
# 2) Sources 'pwr.boot' function.

# load necessary packages
library(tidyverse) 

# load co2df.csv from Github into R
co2df <- read_csv('https://raw.githubusercontent.com/loladze/co2/master/co2df.csv')
           
### Description of pwr.boot function (11 lines of code, the rest is comments)
#
# OUTPUT. For sample x (a subset of the dataset), the function outputs:
# mean, sample size, 95% confidence intervals (CI), SEM, Cohen's d and the 
# statistical power.
# 95%CI and the statistical power are calculated without making any normality
# assumptions, Instead, it relies on a nonparametric procedure (bootstrapping).
# The test is as follows: "Is the mean of sample x different from 0?" 

# INPUT. The arguments of 'pwr.boot' function are:
# x is a sample (an array of numbers)
# aplha is Type I error (default is .05)
# delta is the effect size (default is 0.05, suitable for the CO2 data here).
# rep is the number of bootstrap iterations with replacement (default is 10,000)
# sdp is a priori estimate for the population standard deviation. If no 
# estimate is available, then set "sdp" to 0 and it will be ignored (see the 
# explanation below)
#
# Explanation for "sdp":
# If sample x is small (defined by the parameter 'small'), then its variance can 
# be << the population variance. This will result in the overestimation of 
# Cohen's d and power. To avoid such an overestimation, a priori estimate of 
# the population variance can be used if available. For the CO2 dataset, we do 
# have such an estimate, namely the standard deviation for the entire dataset 
# for all the minerals = ~0.21. 
# small is the sample size that is considered to be small (default is 20). For 
# a small sample x, its sd = max(sd(x), sdp)

# ### Examples of usage: 
# pwr.boot(c(1, -2, 5, -6, 0 ,5, 10, 3, 1), sdp=0) 
# co2df %>% filter(name == 'wheat', element == 'Ca') %>% .$log.r %>% pwr.boot()
# co2df %>% filter(name == 'rice', tissue == 'grain') %>% .$log.r %>% pwr.boot()
# co2df %>% filter(element == 'Zn') %>% .$log.r %>% pwr.boot()

pwr.boot <- function(x, alpha=0.05, rep=10000, delta=0.05, sdp=0.21, small=20)
  {
# Warning for very small samples (size < 7). Boostrapping procedure can give 
# grossly inaccurate results for sample sizes < 7.
  if ( length(x) < 7 ) print("Very small samples can yield inaccurate results!")

# Bootsrap: 
# 1) sample with replacement the array x
# 2) calculate the mean for each bootstrap sample
# 3) Replicate steps 1-2 above for 'rep' times 
# 4) The end result of steps 1-3, is 'mb' vector of length 'rep'.
#    The following command accomplishes all of the above four steps:
    mb <- replicate(rep, mean(sample(x, replace = T)))
  
# calculating the CI. For default alpha = 0.05, the CI is (2.5%, 97.5%).
  ci <- quantile(mb, c(alpha/2, 1  - alpha/2)) 

# for a small sample, substitute the sample sd with the population sd if larger
    if (length(x) < small)  sdx <- max(sd(x), sdp) else sdx <- sd(x)

# shift x by the effect size delta
    x.shift <- x + delta*(sd(x)/sdx)
    
# bootstrap the shifted vector 'x.shift'
    mb.shift <- replicate(rep, mean(sample(x.shift, replace = T)))
    
# calculate the fraction of the elements of 'mb.shift' that fall outside of the 
# condidence interval for 'mb' 
    rejects = sum((mb.shift < ci[1] | mb.shift > ci[2]) == T)
  
# The statistical power of the test is the fraction of rejects among all 
# the bootstraps
    pw <- rejects/rep
   
# grouping all the results: mean, CI, power, sample size, SEM, Cohen's d
    results <- c(mean = mean(x), ci, power = pw, 'sample size' = length(x), 
                 SEM = sdx/sqrt(length(x) - 1), "Cohen's d" = delta/sdx)
# output all the results
    results 
}
