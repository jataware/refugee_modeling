# refugee_modeling
Model refugee migration based on county level features and distance of travel.

Refugee and country level data were manually from a variety of sources and processed the data in r. After normalizing the data we used the jupyter notebook to run the linear model, collect distance data with google's directions api, and view the results.

**Data collection:**

 - For refugee data (individualPerCountry,country,conflict) most conflicts were collected from-[https://data2.unhcr.org/en/situations](https://data2.unhcr.org/en/situations).
   For VENEZUELA I also used- 
   [https://www.r4v.info/es/refugiadosymigrantes](https://www.r4v.info/es/refugiadosymigrantes)
  
  
 - GDP was collected from [https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(nominal)](https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(nominal))
   
 - Same language (same_language) and population (population) were collected from each country's official Wiki page.
   
 - We used google maps to determine if a country was bordering or touching (touching) the conflict country .
   
 - Liberal democracy index (v2x_libdem) and Access to Justice for Women (v2xeg_eqdr) we used
   [https://www.v-dem.net/data_analysis/MapGraph/](https://www.v-dem.net/data_analysis/MapGraph/)
   and 
   [https://www.v-dem.net/vdemds.html](https://www.v-dem.net/vdemds.html)
   for raw csv data.
   
 - For migrant (migrant_ratio) ratio we used  [https://en.wikipedia.org/wiki/List_of_sovereign_states_and_dependent_territories_by_immigrant_population](https://en.wikipedia.org/wiki/List_of_sovereign_states_and_dependent_territories_by_immigrant_population)
   
 - For trade (export_trade_share) data   [https://wits.worldbank.org/CountryProfile/en/Country/ZAR/Year/2018/TradeFlow/EXPIMP](https://wits.worldbank.org/CountryProfile/en/Country/ZAR/Year/2018/TradeFlow/EXPIMP)
   for most countries 
   [https://oec.world/en/profile/country/som#historical-data](https://oec.world/en/profile/country/som#historical-data)
   for Somalia and 
   [https://oec.world/en/profile/country/ssd#historical-data](https://oec.world/en/profile/country/ssd#historical-data)
   for South Sudan
   
 - Bilateral migration (bilateral_migration) was collected from

   [https://www.knomad.org/sites/default/files/2018-04/bilateralmigrationmatrix20170_Apr2018.xlsx](https://www.knomad.org/sites/default/files/2018-04/bilateralmigrationmatrix20170_Apr2018.xlsx)
