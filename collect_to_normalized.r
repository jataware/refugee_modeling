library(tidyverse)

#bring in data V-Dem database for democracy index and justice for women
Dem=read.csv("V-Dem-CY-Core-v12.csv")
#read in data I collect manually from wiki and othe sources
countries=read_csv("collected_data.csv")

summary(countries$export_trade_share)
countries$export_trade_share=as.numeric(countries$export_trade_share)

sum(is.na(countries$export_trade_share))
#get unique list of countries that refugees migrated to
list_countries=unique(countries$country)
# add a few names that are different between databases
list_countries=c(list_countries, "Russian Federation","Russia", "South Sudan", "Tajikistan","Moldova","Slovakia")
#reduce the size of the dataframe to make it easier to work with
reduced=Dem %>% 
  filter(country_name==list_countries)

#columns we are interested in

columnList=c("country_name","year","v2xeg_eqdr","v2x_libdem")
country_dem=reduced[,columnList]

#create a new column for latest year recorded
latestYear=country_dem %>% 
  group_by(country_name) %>% 
  mutate(maxyear=max(year))
#return only data from the latest year for each country
latestYear=latestYear %>% 
  group_by(country_name) %>% 
  filter(year==maxyear)

# select columns we are interested in 
features<-latestYear[,c(1,3,4)]

#change name to match other data
features[3,1]
#if you want to add Russia you can run this next line and Russia will be added
#features[3,1]="Russian Federation"

# merge the data
merged_data=merge(countries,features,by.x=c("country"), by.y=c( "country_name"))

#resetting the name for ease of use
data=merged_data


#set Uzbekistan to values found here https://www.v-dem.net/data_analysis/VariableGraph/ The two features are Access to Justic for women and Liberal Dem index
data[data$country=="Uzbekistan",]["v2xeg_eqdr"]=0.2
data[data$country=="Uzbekistan",]["v2x_libdem"]=0.09
data[data$country=="Slovakia",]["v2x_libdem"]=0.77

# calculate percent of refugees traveling to each country out of all refugees leaving

# Calculating means for each feature.
data=data %>% 
  group_by(conflict) %>% 
  mutate("percent_IndividualPerCountry_of_total"=individualPerCountry/Total_pop_left_conflict_zone) %>% 
  mutate("average_pop"=mean(population)) %>% 
  mutate("average_refugee"=mean(individualPerCountry)) %>% 
  mutate("average_gdp"=mean(gdp_millions)) %>% 
  mutate("total_recored_migrants"=sum(individualPerCountry)) %>% 
  mutate("percent_IndividualPerCountry_of_recorded"=individualPerCountry/total_recored_migrants) %>% 
  mutate("average_eqdr"=mean(v2xeg_eqdr)) %>% 
  mutate("average_lib"=mean(v2x_libdem)) %>% 
  mutate("average_bilateral_migration"=mean(bilateral_migration)) %>% 
  mutate("average_export_trade_share"=mean(export_trade_share)) %>% 
  mutate("average_migr_ratio"=mean(migrant_ratio))

# calculate gdp per cap

data['gdp_per_cap']=data['gdp_millions']/data['population']

#normalize the features
data=data %>% 
  group_by(conflict) %>% 
  mutate('normalized_pop'=(population-average_pop)/sd(population)) %>% 
  mutate('normalized_refugee'=(individualPerCountry-average_refugee)/sd(individualPerCountry)) %>% 
  mutate('normalized_gdp'=(gdp_millions -average_gdp)/sd(gdp_millions)) %>% 
  mutate('normalized_qrdp'=(v2xeg_eqdr-average_eqdr)/sd(v2xeg_eqdr)) %>% 
  mutate('normalized_lib'=(v2x_libdem-average_lib)/sd(v2x_libdem)) %>% 
  mutate("normalized_migr_ratio"=(migrant_ratio-average_migr_ratio)/sd(migrant_ratio)) %>% 
  mutate('normalized_bilateral_migr'=(bilateral_migration-average_bilateral_migration)/sd(bilateral_migration)) %>% 
  mutate('normalized_export_trade'=(export_trade_share-average_export_trade_share)/sd(export_trade_share))
  

# one-hot encoding for conflict
data=data %>% mutate(value = 1)  %>% spread(conflict, value,  fill = 0 ) 
#save
write.csv(data, 'individualsPerCountry_normalized_withoutRussia.csv')


