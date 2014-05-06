################################################################################
#' This R script contains one functions "pwr.boot," which consists of 11 lines 
#' of R code. The rest is comments.
#' Description:
#' 1. calculates the statistical power for a nonparametric bootstrapping 
#' procedure for the following test: Is the mean of sample x different 
#' from 0? 
#' 2. calculates a two-sided confidence interval (CI) around the mean(x) and
#'    returns it with the sample size, the SEM, Cohen's d and the power.
#' This version of the script together with possible updates can be found on
#' GitHub.
#' URL: http://github.com/loladze/co2.git  
#' Author: Irakli Loladze <loladze@asu.edu>
#' License: MIT
################################################################################
#' Arguments:
#' 
#' @ x is the given sample for which the power is calculated for
#' 
#' @ aplha is Type I error for which power is calculated for. (default is 0.05)
#' 
#' @ delta is Effect size for which power is calculated for (default is 0.05) 
#'      Note that the default value is chosen for analyzing the CO2 data; 
#'      generally, 0.05 would not be suitable for other data sets.
#'      
#' @ rep is Number of bootstrap iterations with replacement (default is 10,000)
#' 
#' @ sdp is A priori estimate for the population standard deviation. If no 
#' estimate is available, then set "sdp" to 0 and it will be ignored (see the 
#' explanation below)
#'
#' Explanation for "sdp":
#' If sample x is small, then its variance can be << the population variance. 
#' This will result in the overestimation of Cohen's d and power. To avoid such
#' overestimations, an a priori estimate of the population variance can be used 
#' if available. For the CO2 dataset, we do have such an estimate, namely
#' the standard deviation of the entire dataset for minerals = ~0.21.
#' What counts as a "small sample is determined by parameter "small":
#' 
#' @ small is Sample size that is considered to be small (default is 20)
#' 
#' Usage examples: power.boot(c(1,-2,5,-6,0,5), sdp=0)
#'                power.boot(rnorm(100), rep=1000, sdp=0)     
################################################################################

pwr.boot <- function(x, alpha=0.05, rep=10000, delta=0.05, sdp=0.21, small=20)
  {
################################################################################ 
#' Gives out warning about bootstrapping very small samples (size < 7)
################################################################################
  if ( length(x) < 7 ) print("Small samples can yield inaccurate results!")
################################################################################   
#' 1) bootstrapping (sampling with replacement) vector x
#' 2) calculating the mean for each bootstrap sample
#' 3) Replicating R times steps 1-2 
#' 4) The end result of steps 1-3, is "mb" vector of length R.
#'    The following command accomplishes all of the above steps:
################################################################################     
    mb <- replicate(rep, mean(sample(x, replace=T)))
################################################################################     
#' calculating the CI. For default alpha = 0.05, the CI is (2.5%, 97.5%).
################################################################################ 
    ci <- quantile(mb, c(alpha/2, 1-alpha/2))
################################################################################
#' for small samples, adjusting sd using the sdp estimate if necessary
################################################################################ 
    if (length(x) < small)  sdx <- max(sd(x), sdp)   else sdx <- sd(x)
################################################################################
#' shifts x by the effect size delta (adjusted if necessary for small samples)
################################################################################    
    x.shift <- x + delta*(sd(x)/sdx)
################################################################################    
#' bootstrapping the shifted vector 'x.shift'
################################################################################ 
    mb.shift <- replicate(rep, mean(sample(x.shift, replace=T)))
################################################################################    
#' returns the fraction of the elements of mb.shift that fall outside of the CI 
#' for mb
################################################################################ 
    rejects= sum((mb.shift<ci[1] | mb.shift>ci[2])==T)
################################################################################    
#' The power of the test is the fraction of rejects among all the bootstraps
################################################################################
    pw <- rejects/rep
################################################################################    
#' grouping all the results: mean, CI, power, sample size, SEM, Cohen's d
################################################################################ 
    results <- c(mean=mean(x), ci, power=pw, "sample size"=length(x), 
                 SEM=sdx/sqrt(length(x)-1), "Cohen's d"=delta/sdx)
################################################################################
#' outputting all the results
################################################################################ 
    results 
}