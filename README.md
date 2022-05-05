# Ensemble Route Generation for Forced Migration Events
This repository contains a set of methods for modeling refugee movement in the case of a forced migration event such as a conflict or a natural disaster. Specifically, this repository focuses on modeling the Ukraine conflict by understanding two key drivers of human migration:

1. The attractiveness of destination or safe haven countries 
2. The proximity of each possible haven country or location

This repository has 3 key Jupyter Notebooks which are used for this modeling effort:

1. [Refugee-Attraction-Model](https://github.com/jataware/refugee_modeling/blob/main/Refugee-Attraction-Model.ipynb): this notebook uses historic conflict data to generate a linear model that predicts the attractiveness of each country as a haven for a given forced migration event.
2. [Ensemble-Attraction-Routing](https://github.com/jataware/refugee_modeling/blob/main/Ensemble-Attraction-Routing.ipynb): this notebook uses the linear model to generate an ensemble of routes for a given forced migration event. It uses the Google Distance Matrix and Directions APIs to identify potential routes, then uses the attraction model results to select the most attractive route based on maximizing attraction and minimzing distance from the conflict location to the border crossing.
3. [Results-Processing](https://github.com/jataware/refugee_modeling/blob/main/Results-Processing.ipynb): this notebook performs a comparative analysis of various modeling approaches and assesseses the perforamce of the model against the ground truth results from UNHCR.

If starting from scratch, these notebooks **_must_** be run in the order listed above. Note that directions produced by the Google Directions API are prone to change, particularly in conflict zones. Therefore it is crucial that you track when you produced your results, since those routes may be time bound. For example, if a highway or railway becomes impassible, it may no longer be used by Google Directions and results of the model may differ (e.g. they are non-deterministic) based on this factor.

Refugee and country level data were manually collected from a variety of sources and processed in R and Python. See the `data_prep` directory for more detail on how this was performed.

## Data Collection

 - **Refugee data**: data on the majority of conflicts was gathered from [UNHCR](https://data2.unhcr.org/en/situations). However, data for Venezuela came from [R4V](https://www.r4v.info/es/refugiadosymigrantes) and data for Afghanistan came from a [specific UNHCR report on that country](https://reporting.unhcr.org/sites/default/files/RPRP%20Afghanistan%20-%204-pager%20Summary%20of%20Plan.pdf). 
  
  
 - **GDP**: GDP was obtained from [World Bank](https://data.worldbank.org/indicator/NY.GDP.MKTP.KN?end=2020&most_recent_year_desc=false&start=2020&view=map).

 - **Language**: gathered from each country's Wikipedia page
 
 - **Population**: gathered from each country's Wikipedia page
    
 - **V-Dem**: [V-Dem](https://www.v-dem.net/) was used to obtain historic Liberal democracy index (`v2x_libdem`) and Access to Justice for Women (`v2xeg_eqdr`) indices.
   
 - **Migrant Ration**: For this indicator, we relied on the [Wiki page on immigrant population](https://en.wikipedia.org/wiki/List_of_sovereign_states_and_dependent_territories_by_immigrant_population).
   
 - **Trade Data**: For trade data [We used World Bank's export / import dataset](https://wits.worldbank.org/CountryProfile/en/Country/ZAR/Year/2018/TradeFlow/EXPIMP) for most countries and [OEC](https://oec.world/en/profile/country/som#historical-data) for Somalia and South Sudan.

 - **Bilateral Migration**: bilateral migration was collected from [Knomad](https://www.knomad.org/sites/default/files/2018-04/bilateralmigrationmatrix20170_Apr2018.xlsx)
