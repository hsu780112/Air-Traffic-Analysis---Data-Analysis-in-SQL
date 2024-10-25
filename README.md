# Air-Traffic-Analysis
This project aims to support investment decisions for BrainStation Mutual Fund’s potential stake in one of three major airline stocks. Using detailed flight and airport data, we will address specific business questions to uncover actionable insights into the airlines' performance, efficiency, and operational strengths. Our findings will offer clear, data-backed guidance to inform the fund managers' investment choices.

Alongside generating meaningful insights, this analysis will demonstrate advanced SQL skills, showcasing efficient data handling, querying, and analysis. This report will balance practical business implications with technical rigor, ensuring both the fund managers' informational needs and assessment criteria are met.

## Data Description
The database contains two tables, flights and airports. The flights table contains flight data for 2018 and 2019 from the three most traveled airlines. The airports table contains data for all origin and destination airports, including full name and location. Details of each are as follows:

Table 1: flights

| **Project Component**              | **Description**                                                                                                                                                  |
|------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Objective**                      | Support investment decisions for BrainStation Mutual Fund in one of three major airline stocks.                                                                  |
| **Data Sources**                   | Flight and airport data                                                                                                                                            |
| **Goals**                          | 1. Address business questions to uncover insights on airline performance, efficiency, and operational strengths. <br> 2. Demonstrate advanced SQL skills.       |
| **Deliverables**                   | Clear, data-backed insights to inform fund managers' investment choices; demonstration of SQL proficiency.                                                        |
| **Approach**                       | Analyze data using SQL queries to extract actionable insights, answering the fund managers' business questions and ensuring high data handling proficiency.        |
| **Expected Outcomes**              | 1. Insightful guidance on each airline's performance and strengths. <br> 2. A demonstration of technical rigor and SQL expertise.                                 |

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

