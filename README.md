# refugee_modeling
Model refugee migration based on county level features and distance of travel.

I collected data manually from a variety of sources and processed the data in r.After normalizing the data I uploading the data to a python jupyter notebook to run the linear model and view the results.

Data collection:

For refugee data (individualPerCountry,country,conflict) most conflicts were collected from- https://data2.unhcr.org/en/situations. For VENEZUELA I also used- https://www.r4v.info/es/refugiadosymigrantes


For GDP I collected that from 
https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(nominal)

For language (same_language), population  (population) I used each country's offical Wiki page.

For touching I use google maps.

For the liberal democracy index and access to justice for women I use https://www.v-dem.net/data_analysis/MapGraph/ and https://www.v-dem.net/vdemds.html for raw csv data. 


For migrant (migrant_ratio) stock per pop
https://en.wikipedia.org/wiki/List_of_sovereign_states_and_dependent_territories_by_immigrant_population

For trade (export_trade_share) data I used 
https://wits.worldbank.org/CountryProfile/en/Country/ZAR/Year/2018/TradeFlow/EXPIMP for most countries
https://oec.world/en/profile/country/som#historical-data for Somalia
and https://oec.world/en/profile/country/ssd#historical-data for South Sudan

Bilateral migration (bilateral_migration) was collected from https://www.knomad.org/sites/default/files/2018-04/bilateralmigrationmatrix20170_Apr2018.xlsx

