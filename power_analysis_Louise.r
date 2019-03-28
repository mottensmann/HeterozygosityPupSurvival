### Power analysis

library(lme4)
library(plyr)
library(ggplot2)



expdat <- read.csv('C:/Users/louis/Documents/AFS_Internship/data_Viv.csv',sep=";")
expdat$x <-rnorm(234, 1, 0.3) 

#disp parameter
expdat$Obs <- factor(seq(nrow(expdat))) 



set.seed(101)
nsim <- 1000
beta2 <- c(qlogis(0.5), 1)
theta2 <- 0.00001


ss <- simulate(~x + (1|Year), nsim = nsim, family = binomial, newdata = expdat, newparams = list(theta = theta2,  beta = beta2))

expdat$resp <- ss[, 1]

fit1 <- glmer(resp ~ x + (1|Year), family = binomial, data = expdat)

summary(fit1)

fitsim <- function(i) {
  
  fit1 <- glmer(ss[[i]] ~ x+ (1|Year) , data = expdat,family=binomial,control=glmerControl(optimizer="bobyqa"))
  coef(summary(fit1))["x","Pr(>|z|)" ]
}


t1 <- system.time(fitAll <- laply(seq(nsim), function(i) fitsim(i), .progress='text'))


fitAll <- setNames(as.data.frame(fitAll),  "pval")


with(fitAll, mean(pval < 0.05))

ggplot(fitAll, aes(x = pval)) + geom_histogram() 
binom.test(table(factor(fitAll < 0.05, c(T, F))))$conf.int
