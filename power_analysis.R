## Power analyis 

# install.packages("SIMR")

library(simr)
model1 <‐ glmer(z ~ x + (1|g), family="poisson", data=simdata)
summary(model1)
# fixed effect estimate  
fixef(model1)["x"]

# test power to detect effect size -0.05
fixef(model1)["x"] <‐ ‐0.05

set.seed(123)
powerSim(model1)


## test effect of increasing sample size
model2 <‐ extend(model1, along="x", n=20)
powerSim(model2)

# power and sample size
pc2 <‐ powerCurve(model2)
print(pc2)
plot(pc2)


