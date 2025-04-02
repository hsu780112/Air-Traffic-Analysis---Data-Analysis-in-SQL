# Air-Traffic-Analysis---Data-Analysis-in-SQL
This project aims to support investment decisions for BrainStation Mutual Fund’s potential stake in one of three major airline stocks. Using detailed flight and airport data, we will address specific business questions to uncover actionable insights into the airlines' performance, efficiency, and operational strengths. Our findings will offer clear, data-backed guidance to inform the fund managers' investment choices.

Alongside generating meaningful insights, this analysis will demonstrate advanced SQL skills, showcasing efficient data handling, querying, and analysis. This report will balance practical business implications with technical rigor, ensuring both the fund managers' informational needs and assessment criteria are met.

## Data Description
We have been provided with a cleaned version of data originally sourced from the open data portal at the Bureau of Transportation Statistics:
https://www.transtats.bts.gov/DatabaseInfo.asp?QO_VQ=EFD&DB_URL=

To load the necessary data required for this project, we downloaded the data file from https://api.brainstation.io/content/link/1HyDA2lldNXHAu5nJLPY3Y1yBAt8n7zrR?instanceId=6208 and follow the below steps: in MySQL Workbench, go to Server > Data Import, select 'Import from Self-Contained File', and specify 'AirTraffic' as the 'Default Target Schema'. 

The database contains two tables, flights and airports. The flights table contains flight data for 2018 and 2019 from the three most traveled airlines. The airports table contains data for all origin and destination airports, including full name and location. Details of each are as follows:

Table 1: flights

| **Column**                         | **Type**    | **Description**                                          |
|--------------------------------|--------|------------------------------------------------------|
| FlightID                      | int    | Unique ID number for each flight (Primary Key)      |
| FlightDate                    | date   | Date of flight departure                            |
| ReportingAirline              | string | DOT Unique Carrier Code                            |
| TailNumber                    | string | FAA Tail number identifying flight                 |
| FlightNumberReportingAirline  | string | Public flight number                               |
| OriginAirportID               | int    | Origin / departure airport code                   |
| DestAirportID                 | int    | Destination / arrival airport code                |
| CRSDepTime                    | string | Scheduled local departure time                    |
| DepTime                       | string | Actual local departure time                       |
| DepDelay                      | int    | Difference in minutes between scheduled and actual departure time |
| TaxiOut                       | int    | Taxi out time, in minutes                         |
| WheelsOff                     | string | Wheels off in local time                         |
| WheelsOn                      | string | Wheels on in local time                          |
| TaxiIn                        | int    | Taxi in time, in minutes                         |
| CRSArrTime                    | string | Scheduled arrival time                           |
| ArrTime                       | string | Actual arrival time                              |
| ArrDelay                      | int    | Difference in minutes between scheduled and actual arrival |
| Cancelled                     | int    | Cancelled indicator                              |
| Diverted                      | int    | Diverted indicator                               |
| AirTime                       | int    | Flight time (total time in the air) in minutes  |
| Distance                      | float  | Distance between airports in miles              |
| AirlineName                   | string | DOT full airline name                           |
| CancellationReason            | string | Reason for cancellation                         |


Table 2: airports

| **Column**     | **Type** | **Description**                       |
|----------------|----------|---------------------------------------|
| AirportID      | int      | Unique airport code (Primary Key)     |
| AirportName    | string   | Full name of airport                  |
| City           | string   | Airport city                          |
| Country        | string   | Airport country                       |
| State          | string   | Airport state                         |
| Latitude       | float    | Latitude of airport                   |
| Longitude      | float    | Longitude of airport                  |

