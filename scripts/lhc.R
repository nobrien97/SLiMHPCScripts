# Generate combinations of variables and save as a csv

library(DoE.wrapper)
library(tidyverse)
library(GGally)

lhc <- lhs.design(nruns = 256, 
nfactors = 3, type = "maximin", 
factor.names = list(
    "N" = c(100, 10000),
    "s" = c(-0.1, 0.1),
    "r" = c(0.0, 0.5)
    ))

ggpairs(lhc)
write.csv(lhc, "./hypercube.csv")
