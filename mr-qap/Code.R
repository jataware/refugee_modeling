warnings()

library(foreign)
library(igraph) ### Remember this conflicts with statnet & sna
library(tidyverse)
library(corrr)
library(ggraph)
library(dplyr)
library(rlang)
library(naniar)
library(statnet)
library(sna)
library(network)
library(cluster)    # clustering algorithms
library(factoextra) # clustering visualization
library(dendextend) # for comparing two dendrograms
library(ggplot2)
library(fmsb)
library(sjmisc)
library(prettyR)

edges <- read.csv("Data_for_correlation network.csv")

########################################################
### Correlation Networks
########################################################
ref <- edges %>%
  dplyr::select(
    ref1990.flow,
    ref1991.flow,
    ref1992.flow,
    ref1993.flow,
    ref1994.flow,
    ref1995.flow,
    ref1996.flow,
    ref1997.flow,
    ref1998.flow,
    ref1999.flow,
    ref2000.flow,
    ref2001.flow,
    ref2002.flow,
    ref2003.flow,
    ref2004.flow,
    ref2005.flow,
    ref2006.flow,
    ref2007.flow,
    ref2008.flow,
    ref2009.flow,
    ref2010.flow,
    ref1991.flow,
    ref2012.flow,
    ref2013.flow,
    ref2014.flow,
    ref2015.flow,
    ref2016.flow
  )

#####################################################
# Matrix Creation
print("Matrix Creation")
#####################################################
edges.1 <- read.csv("Data_1.csv")
edges.2 <- read.csv("Data_2.csv")
edges.3 <- read.csv("Data_3.csv")
edges.4 <- read.csv("Data_4.csv")
edges.5 <- read.csv("Data_5_UPDATED.csv")

edges.1 <- edges.1 %>%
  select(
    -state.destination.name,
    -state.destination.abb,
    -state.origin.name,-state.origin.abb,
    -dyad.id
  )

edges.2 <- edges.2 %>%
  select(
    -state.destination.name,
    -state.destination.abb,
    -state.origin.name,-state.origin.abb,
    -dyad.id
  )

edges.3 <- edges.3 %>%
  select(
    -state.destination.name,
    -state.destination.abb,
    -state.origin.name,-state.origin.abb,
    -dyad.id
  )

edges.4 <- edges.4 %>%
  select(
    -state.destination.name,
    -state.destination.abb,
    -state.origin.name,-state.origin.abb,
    -dyad.id
  )

edges.5 <- edges.5 %>%
  select(
    -state.destination.name,
    -state.destination.abb,
    -state.origin.name,-state.origin.abb,
    -dyad.id
  )


edges.m1 <-
  merge(
    edges.1,
    edges.2,
    by.x = c("ccode1", "ccode2"),
    by.y = c("ccode1", "ccode2")
  )
edges.m2 <-
  merge(
    edges.m1,
    edges.3,
    by.x = c("ccode1", "ccode2"),
    by.y = c("ccode1", "ccode2")
  )
edges.m3 <-
  merge(
    edges.m2,
    edges.4,
    by.x = c("ccode1", "ccode2"),
    by.y = c("ccode1", "ccode2")
  )
edges.m4 <-
  merge(
    edges.m3,
    edges.5,
    by.x = c("ccode1", "ccode2"),
    by.y = c("ccode1", "ccode2")
  )

rm(edges.m1, edges.m2, edges.m3)

# get mean of immigration stocks for 2010 to split into 3 groups
immig_over_zero <-
  select(edges.m4, immigrant.population.2010) %>% filter(immigrant.population.2010 > 0)
immig_mean <- mean(immig_over_zero$immigrant.population.2010)
print(immig_mean)

# create new columns for immigration 2010 levels
edges.m4 <- mutate(
  edges.m4,
  immigration.2010.none = case_when(
    immigrant.population.2010 == 0  ~ 1,
    immigrant.population.2010 > 0  ~ 0
  ),
  immigration.2010.low = case_when(
    immigrant.population.2010 == 0 ~ 0,
    immigrant.population.2010 > 0 &
      immigrant.population.2010 < immig_mean  ~ 1,
    immigrant.population.2010 >= immig_mean  ~ 0,
  ),
  immigration.2010.high = case_when(
    immigrant.population.2010 == 0 ~ 0,
    immigrant.population.2010 > 0 &
      immigrant.population.2010 < immig_mean  ~ 0,
    immigrant.population.2010 >= immig_mean  ~ 1,
  )
)

igraph.edges.m4 <- graph_from_data_frame(edges.m4, directed = T)

#2016
print("2016")
ref2016.mat <-
  as.matrix(as_adjacency_matrix(
    igraph.edges.m4,
    type = "both",
    names = T,
    attr = "ref2016.flow"
  ))
ref2015.mat <-
  as.matrix(as_adjacency_matrix(
    igraph.edges.m4,
    type = "both",
    names = T,
    attr = "ref2015.flow"
  ))
defense.alliance.2016.mat <-
  as.matrix(
    as_adjacency_matrix(
      igraph.edges.m4,
      type = "both",
      names = T,
      attr = "alliance.defense.2016"
    )
  )
trade.2014.mat <-
  as.matrix(as_adjacency_matrix(
    igraph.edges.m4,
    type = "both",
    names = T,
    attr = "trade.2014"
  ))
riv.strategic.2016.mat <-
  as.matrix(
    as_adjacency_matrix(
      igraph.edges.m4,
      type = "both",
      names = T,
      attr = "riv.strategic.2016"
    )
  )
contiguity.any.mat <-
  as.matrix(as_adjacency_matrix(
    igraph.edges.m4,
    type = "both",
    names = T,
    attr = "contiguity.any"
  ))
polyarchy.2016.mat <-
  as.matrix(
    as_adjacency_matrix(
      igraph.edges.m4,
      type = "both",
      names = T,
      attr = "polyarchy.additive.2016.gradient"
    )
  )
pts.2015.mat <-
  as.matrix(
    as_adjacency_matrix(
      igraph.edges.m4,
      type = "both",
      names = T,
      attr = "pts.2015.gradient"
    )
  )
income.2015.gradient.mat <-
  as.matrix(
    as_adjacency_matrix(
      igraph.edges.m4,
      type = "both",
      names = T,
      attr = "gdppc.2015.gradient"
    )
  )
armsflows.inverse.2016.mat <-
  as.matrix(
    as_adjacency_matrix(
      igraph.edges.m4,
      type = "both",
      names = T,
      attr = "arms.inverse.2016"
    )
  )
immigrant.pop.2010.mat <-
  as.matrix(
    as_adjacency_matrix(
      igraph.edges.m4,
      type = "both",
      names = T,
      attr = "immigrant.population.2010"
    )
  )
immigrant.pop.2017.mat <-
  as.matrix(
    as_adjacency_matrix(
      igraph.edges.m4,
      type = "both",
      names = T,
      attr = "immigrant.population.2017"
    )
  )
immigrant.2010.none.mat <-
  as.matrix(
    as_adjacency_matrix(
      igraph.edges.m4,
      type = "both",
      names = T,
      attr = "immigration.2010.none"
    )
  )
immigrant.2010.low.mat <-
  as.matrix(
    as_adjacency_matrix(
      igraph.edges.m4,
      type = "both",
      names = T,
      attr = "immigration.2010.low"
    )
  )
immigrant.2010.high.mat <-
  as.matrix(
    as_adjacency_matrix(
      igraph.edges.m4,
      type = "both",
      names = T,
      attr = "immigration.2010.high"
    )
  )

#####################################################
# MRQAPs
print("Fit MRQAPs")
#####################################################

print("2016 refugee flow model")
nl.2016.rivagg <-
  netlm(
    ref2016.mat,
    # Dependent variable/network
    list(
      ref2015.mat,
      polyarchy.2016.mat,
      armsflows.inverse.2016.mat,
      riv.strategic.2016.mat,
      contiguity.any.mat,
      income.2015.gradient.mat,
      pts.2015.mat,
      defense.alliance.2016.mat,
      trade.2014.mat,
      immigrant.pop.2010.mat
    ),
    # List the independent variables/networks
    reps = 1000,
    nullhyp = "qapspp",
    test.statistic = "t-value"
  )


preds <- nl.2016.rivagg$coefficients[1] +
  nl.2016.rivagg$coefficients[2] * ref2015.mat +
  nl.2016.rivagg$coefficients[3] * polyarchy.2016.mat +
  nl.2016.rivagg$coefficients[4] * armsflows.inverse.2016.mat +
  nl.2016.rivagg$coefficients[5] * riv.strategic.2016.mat +
  nl.2016.rivagg$coefficients[6] * contiguity.any.mat +
  nl.2016.rivagg$coefficients[7] * income.2015.gradient.mat +
  nl.2016.rivagg$coefficients[8] * pts.2015.mat +
  nl.2016.rivagg$coefficients[9] * defense.alliance.2016.mat +
  nl.2016.rivagg$coefficients[10] * trade.2014.mat +
  nl.2016.rivagg$coefficients[11] * immigrant.pop.2010.mat

print("2017 immigration model")
nl.2017.immig <-
  netlm(
    immigrant.pop.2017.mat,
    # Dependent variable/network
    list(
      ref2016.mat,
      polyarchy.2016.mat,
      armsflows.inverse.2016.mat,
      riv.strategic.2016.mat,
      contiguity.any.mat,
      income.2015.gradient.mat,
      pts.2015.mat,
      defense.alliance.2016.mat,
      trade.2014.mat,
      immigrant.pop.2010.mat
    ),
    # List the independent variables/networks
    reps = 1000,
    nullhyp = "qapspp",
    test.statistic = "t-value"
  )

preds_immig <- nl.2017.immig$coefficients[1] +
  nl.2017.immig$coefficients[2] * ref2016.mat +
  nl.2017.immig$coefficients[3] * polyarchy.2016.mat +
  nl.2017.immig$coefficients[4] * armsflows.inverse.2016.mat +
  nl.2017.immig$coefficients[5] * riv.strategic.2016.mat +
  nl.2017.immig$coefficients[6] * contiguity.any.mat +
  nl.2017.immig$coefficients[7] * income.2015.gradient.mat +
  nl.2017.immig$coefficients[8] * pts.2015.mat +
  nl.2017.immig$coefficients[9] * defense.alliance.2016.mat +
  nl.2017.immig$coefficients[10] * trade.2014.mat +
  nl.2017.immig$coefficients[11] * immigrant.pop.2010.mat


print("2017 immigration model using time lagged immigration levels (2010)")
nl.2017.immig.factors <-
  netlm(
    immigrant.pop.2017.mat,
    # Dependent variable/network
    list(
      polyarchy.2016.mat,
      armsflows.inverse.2016.mat,
      riv.strategic.2016.mat,
      contiguity.any.mat,
      income.2015.gradient.mat,
      pts.2015.mat,
      defense.alliance.2016.mat,
      trade.2014.mat,
      immigrant.2010.low.mat,
      immigrant.2010.high.mat
    ),
    # List the independent variables/networks
    reps = 1000,
    nullhyp = "qapspp",
    test.statistic = "t-value"
  )

preds_immig.factors <- nl.2017.immig$coefficients[1] +
  nl.2017.immig$coefficients[2] * ref2016.mat +
  nl.2017.immig$coefficients[3] * polyarchy.2016.mat +
  nl.2017.immig$coefficients[4] * armsflows.inverse.2016.mat +
  nl.2017.immig$coefficients[5] * riv.strategic.2016.mat +
  nl.2017.immig$coefficients[6] * contiguity.any.mat +
  nl.2017.immig$coefficients[7] * income.2015.gradient.mat +
  nl.2017.immig$coefficients[8] * pts.2015.mat +
  nl.2017.immig$coefficients[9] * defense.alliance.2016.mat +
  nl.2017.immig$coefficients[10] * trade.2014.mat +
  nl.2017.immig$coefficients[11] * immigrant.2010.low.mat +
  nl.2017.immig$coefficients[12] * immigrant.2010.high.mat



ukr <-
  filter(edges.m4,
         ccode1 == 369,
         ccode2 %in% c(370, 365, 360, 290, 310, 317, 359))
ukr <-
  select(
    ukr,
    ccode1,
    ccode2,
    immigrant.population.2017,
    immigrant.population.2010,
    ref2015.flow,
    polyarchy.additive.2016.gradient,
    arms.inverse.2016,
    riv.strategic.2016,
    contiguity.any,
    gdppc.2015.gradient,
    pts.2015.gradient,
    alliance.defense.2016,
    trade.2014,
    immigration.2010.low,
    immigration.2010.high
  )

write.csv(preds, file = 'ref_flow_preds_2016.csv')
write.csv(preds_immig, file = 'immig_flow_preds_2017.csv')
write.csv(preds_immig.factors, file = 'immig_flow_preds_factors_2017.csv')