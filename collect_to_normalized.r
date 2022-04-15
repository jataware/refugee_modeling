library(tidyverse)

#bring in data V-Dem database for democracy index and justice for women
Dem=read_csv("V-Dem-CY-Core-v12.csv")

#read in data I collect manually from wiki and other sources
countries=read_csv("collected_data.csv")


#get unique list of countries that refugees migrated to
list_countries=unique(countries$country)
list_conflicts=unique(countries$conflict)

# add a few names that are different between databases
list_countries=c(list_countries, "Russian Federation","Russia", "South Sudan", "Tajikistan","Moldova","Slovakia","Turkmenistan")

#reduce the size of the dataframe to make it easier to work with
columnList=c("country_name","year","v2xeg_eqdr","v2x_libdem")
country_dem=Dem[,columnList]


for(row in rownames(countries)) {
    
    year_v=toString(countries[row,"conflict_start_year"]-1)
    year_v=as.numeric(year_v)
    country_v= toString(countries[row,"country"])
    print(year_v)
    print(country_v)
    if("Russian Federation"%in% country_v){
      country_v="Russia"
    }
    
    pulled_v2x_lib=country_dem%>% 
      dplyr::filter(country_name==country_v) %>% 
      dplyr::filter(year==year_v) %>% 
      pull(v2x_libdem)
    countries[row,'v2x_libdem']=pulled_v2x_lib
    pulled_eqdr=country_dem%>% 
      dplyr::filter(country_name==country_v) %>% 
      dplyr::filter(year==year_v) %>% 
      pull(v2xeg_eqdr)
    countries[row,'v2xeg_eqdr']=pulled_eqdr
  
  
}


# get remittance data
migration=read.csv('refugee_data/bilateral_migration.csv')


countries["bilateral_migration"]=0
for(row in rownames(countries)) {
 
  country_v= toString(countries[row,"country"])
  conflict_v= toString(countries[row,"conflict"])
  
  mig=migration %>% 
    dplyr::filter(Country.Origin.Name==conflict_v) %>% 
    dplyr::filter(Country.Dest.Name==country_v) %>% 
    pull(X2000..2000.)
  print(mig)
  if(length(mig)==0){
    print('here')
    countries[row,"bilateral_migration"]=0
  }else{
    countries[row,"bilateral_migration"]=as.numeric(mig)
    
  }
}


remittance=read.csv('bilateralremittancematrix2017Apr2018.csv')

countries['remittances']=NA

for(row in rownames(countries) ){
  country=toString(countries[row,'country'])
  conflict=toString(countries[row,'conflict'])
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
  countries[row,"remittances"]=as.double(remittance_value)
}

countries=countries %>% 
  group_by(conflict) %>% 
  mutate("percent_IndividualPerCountry_of_total"=individualPerCountry/Total_pop_left_conflict_zone) %>% 
  mutate("total_recored_migrants"=sum(individualPerCountry)) %>% 
  mutate("percent_IndividualPerCountry_of_recorded"=individualPerCountry/total_recored_migrants) 

conflict=countries[,c(1,2)]
countries=countries %>% mutate(value = 1)  %>% spread(conflict, value,  fill = 0) 

countries['conflict']=conflict$conflict

write.csv(countries, 'refugee_data/refugee_data_final.csv')
