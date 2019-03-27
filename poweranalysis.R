#-----------------------------------#
# Power analyis - Explore the relationship between power and effect sizes, where 
# 80% power is considered adequate 
# Power is caluclated by repeating:
# (i) simulate new values for the response variable 
# (ii) refit the model to the simulated response
# (iii) apply a statistical test to the simulated fit

library(simr)

# Create a simulated data frame with a size of 234, binomial response of 0 or 1, 
# a particular range in sMLH values, and finally adding the random effect as year
sim<-NULL
sim<-as.data.frame(rep(1,234))         
colnames(sim)[1]<-'y'
sim$z<-rbinom(234,1,0.5)                
sim$x<-runif(234,0.37,1.86)              # sim$x<-rep(1:13,each=18)  
sim$g<-as.factor(rep(1:13,each=18))    

#--------------------------------------------------------#

# Try simulating a dataframe a different way?
install.packages("simstudy")
library(simstudy)
sim2 <- defData(varname = "nr", dist = "nonrandom", form = 1, id = "idnum")
sim2 <- defData(sim2, varname = "z", dist = "binary", form = "0 + nr", link = "logit")
sim2 <- defData(sim2, varname = "x", dist = "uniform", form = "0.37;1.86")
sim2 <- defData(sim2, varname = "g", dist = "uniformInt", form = "0;10")

dt <- genData(200, sim2)

simmod <- glmer(z ~ x + (1|g), family="binomial", data = dt)
fixef(simmod)["x"] <- -0.05
powerSim(simmod)


#------------------------------------------------------#

# create a generic model, applying effect size as a function
model1 <- glmer(z ~ x + (1|g), family="binomial", data = sim)

# Looking at the summary, the estimated effect size is -0.122, which is not significant
# Let's first start out by specifying an effect size, then running the power analysis
fixef(model1)["x"] <- -0.05

powerSim(model1)
# summary: the power to reject the null hypothesis of zero trend in x is about 5.40% --> insufficient

# We would actually like to look at a range of effect sizes - between 0 and 1
# Apply this as a function, and run the power anaylsis
effects <- seq(0, 1, by = 0.1)
out <- lapply(effects, function(e) {
  fixef(model1)["x"]                                      
  return(summary(powerSim(model1)))
}) %>% 
  do.call('rbind',.)

#If the user wants to keep the random effects “fixed” at their estimated values,
#they can add the argument simOpts=list(use.u=TRUE).

out$x <- effects
# possibility to save (pa_sum <-lastResult())

# Plot power against effect size two different ways and save as .tiff
with(out, plot(x, mean))

pa_plot <-
  ggplot(data = out, aes(x, mean)) +
  geom_point(colour = "red") +
  geom_line(linetype="dashed") +
  geom_errorbar(aes(ymin = lower,ymax = upper),
                width = 0.1, alpha = 0.7, size = 0.1, colour = "black") +
  theme_classic() +
  theme(panel.border = element_blank(),
        strip.background = element_blank(),
        text = element_text(size = 12),
        aspect.ratio = 1,
        plot.margin = grid::unit(c(2,2,2,2), 'mm')) +
  xlab("Effect size") +
  ylab("Power")
pa_plot 

ggsave(pa_plot, filename = "pa_plot.tiff",
       units = "in", dpi = 300, width = 6, height = 6)