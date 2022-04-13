library(tidyverse)

#bring in data V-Dem database for democracy index and justice for women
Dem=read.csv("V-Dem-CY-Core-v12.csv")

#read in data I collect manually from wiki and othe sources
countries=read_csv("collected_data.csv")


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
data=merge(countries,features,by.x=c("country"), by.y=c( "country_name"))

#set Uzbekistan to values found here https://www.v-dem.net/data_analysis/VariableGraph/ The two features are Access to Justic for women and Liberal Dem index
data[data$country=="Uzbekistan",]["v2xeg_eqdr"]=0.2
data[data$country=="Uzbekistan",]["v2x_libdem"]=0.09
data[data$country=="Slovakia",]["v2x_libdem"]=0.77

# get remittance data
remittance=read.csv('bilateralremittancematrix2017Apr2018.csv')
list_conflicts=unique(data$conflict)


data['remittances']=NA


for(row in rownames(data) ){
  country=toString(data[row,'country'])
  conflict=toString(data[row,'conflict'])
  if("Iran" %in% country){
    country="Iran..Islamic.Rep."
  }
  if("Democratic Republic of the Congo"%in% country){
    country="Congo..Dem..Rep."
  }
  if("Republic of the Congo"%in% country){
    country="Congo..Rep."
  }
  if("South Sudan"%in% country){
    country="South.Sudan"
  }
  if("Central African Republic"%in% country){
    country="Central.African.Republic"
  }
  if("South Africa"%in% country){
    country="South.Africa"
  }
  if("Yemen"%in% country){
    country="Yemen..Rep."
  }
  if("Egypt"%in% country){
    country="Egypt..Arab.Rep."
  }
  if("Russian Federation"%in% country){
    country="Russian.Federation"
  }
  if("Slovakia" %in% country){
    country="Slovak.Republic"
  }
  if("Costa Rica" %in% country){
    country="Costa.Rica"
  }
  if("Dominican Republic" %in% country){
    country="Dominican.Republic"
  }
  
  #conflict naming 
  
  if("Democratic Republic of the Congo"%in% conflict){
    conflict="Congo, Dem. Rep."
  }
  if("Syria"%in% conflict){
    conflict="Syrian Arab Republic"
  }
  if("Venezuela"%in% conflict){
    conflict="Venezuela, RB"
  }
  remittance_value=remittance %>% 
    dplyr::filter(Remittance.receiving.country_across.Remittance.sending.country_down==conflict) %>% 
    dplyr::pull(country)
  data[row,"remittances"]=as.double(remittance_value)
}

# Calculating by each conflict
data=data %>% 
  group_by(conflict) %>% 
  mutate("percent_IndividualPerCountry_of_total"=individualPerCountry/Total_pop_left_conflict_zone) %>% 
  mutate("total_recored_migrants"=sum(individualPerCountry)) %>% 
  mutate("percent_IndividualPerCountry_of_recorded"=individualPerCountry/total_recored_migrants) 

# calculate gdp per cap
data['gdp_per_cap']=data['gdp_millions']/data['population']

#normalize the features
data=data %>% 
  group_by(conflict) %>% 
  mutate('normalized_pop'=(population-mean(population))/sd(population)) %>% 
  mutate('normalized_refugee'=(individualPerCountry-mean(individualPerCountry))/sd(individualPerCountry)) %>% 
  mutate('normalized_gdp'=(gdp_millions -mean(gdp_millions))/sd(gdp_millions)) %>% 
  mutate('normalized_qrdp'=(v2xeg_eqdr-mean(v2xeg_eqdr))/sd(v2xeg_eqdr)) %>% 
  mutate('normalized_lib'=(v2x_libdem-mean(v2x_libdem))/sd(v2x_libdem)) %>% 
  mutate("normalized_migr_ratio"=(migrant_ratio-mean(migrant_ratio))/sd(migrant_ratio)) %>% 
  mutate('normalized_bilateral_migr'=(bilateral_migration-mean(bilateral_migration))/sd(bilateral_migration)) %>% 
  mutate('normalized_export_trade'=(export_trade_share-mean(export_trade_share))/sd(export_trade_share)) %>% 
  mutate("normalized_remittances"=(remittances-mean(remittances))/sd(remittances)) %>% 
  mutate("normalized_touching"=(touching-mean(touching))/sd(touching)) %>% 
  mutate("normalized_same_language"=(same_language-mean(same_language))/sd(same_language)) 
  
# where normalized data is NaN means there is no spread and all the data is the same for that conflict. Let fix the two columns effected by that
data$normalized_touching[is.na(data$normalized_touching)]<-0
data$normalized_same_language[is.na(data$normalized_same_language)]<-0

# one-hot encoding for conflict
data=data %>% mutate(value = 1)  %>% spread(conflict, value,  fill = 0 ) 
#save

write.csv(data, 'refugee_data/refugee_Model_Data.csv')
