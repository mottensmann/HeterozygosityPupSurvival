## Power analyis 
## =============================================================================


## To do:
## First whats the power given the model i.e. the sampled data ?
## How large would the variance need to be to find moderate effects


## ten times variance:  1.23991   
## sampled variacne

library(lme4)
library(plyr)
library(ggplot2)

## load data
expdat <- read.csv("data/md.csv")

## some scaling parameter for variances
var_x <- 1

## simulate gaussian response
expdat$x <- rnorm(n = nrow(expdat), mean =  mean(expdat$All), sd = var_x * sd(expdat[["All"]])) 

## centre to zero
expdat$x <- scale(expdat$x, scale = F)
hist(expdat$x)

set.seed(101)
nsim <- 1000
beta2 <- c(qlogis(0.5), 1)
theta2 <- 0.00001

resp_sim <- simulate(~x + (1|year), nsim = nsim, family = binomial, newdata = expdat, newparams = list(theta = theta2,  beta = beta2))

expdat$resp <- resp_sim[, 1]

# fit1 <- glmer(resp ~ x + (1|year), family = binomial, data = expdat)
# summary(fit1)

fitsim <- function(i) {
  fit1 <- glmer(resp_sim[[i]] ~ x+ (1|year) , data = expdat , family = binomial,
                control = glmerControl(optimizer = "bobyqa"))
  coef(summary(fit1))["x","Pr(>|z|)" ]
}

t1 <- system.time(fitAll <- laply(seq(nsim), function(i) fitsim(i), .progress = 'text'))

fitAll <- setNames(as.data.frame(fitAll),  "pval")

with(fitAll, mean(pval < 0.05))
# ggplot(fitAll, aes(x = pval)) + geom_histogram() 
binom.test(table(factor(fitAll < 0.05, c(T, F))))$conf.int


# install.packages("SIMR")

# library(simr)
# model1 <- glmer(z ~ x + (1|g), family = "poisson", data=simdata)
# summary(model1)
# # fixed effect estimate  
# fixef(model1)["x"]
# 
# # test power to detect effect size -0.05
# fixef(model1)["x"] <- ‐0.05
# 
# set.seed(123)
# powerSim(model1)
# # 33.40% (30.48, 36.42)
# 
# ## test effect of increasing sample size
# model2 <- extend(model1, along = "x", n = 20)
# powerSim(model2)
# 
# # power and sample size
# pc2 <- powerCurve(model2)
# print(pc2)
# plot(pc2)