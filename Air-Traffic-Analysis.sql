/* THE AIR TRAFFIC ANALYSIS */

/* Question 1  

The managers of the BrainStation Mutual Fund want to know some basic details about the data. Use fully commented SQL queries to address each of the following questions: */

/* Question 1.1: How many flights were there in 2018 and 2019 separately?*/

/* Answer 1.1 : I used two seperate queries for 2018 and 2019 respectively to get a detailed analysis */

SELECT YEAR(FlightDate) AS YEAR,
       COUNT(id) AS NUMBER_OF_FLIGHTS
FROM flights
WHERE YEAR(FlightDate) IN (2018, 2019)
GROUP BY YEAR;
    
/* Query Results and Interpretation 1.1 : 

The query above was designed to determine the total number of flights that operated separately in 2018 and 2019. 
The results show 3,218,653 flights in 2018 and 3,302,708 flights in 2019, indicating an increase of 84,055 flights year-over-year. 
Fund managers can use this data to evaluate trends in flight operations, as the growth observed in 2019 suggests 
a strong operational performance and potentially profitable conditions within the industry over the 12-month period.  */


/* Question 1.2: In total, how many flights were cancelled or departed late over both years?*/

/* Answer 1.2: Please find the below query that provides a total flights that were either cancelled or departed late. */

SELECT 
    COUNT(*) AS NUMBER_OF_FLIGHTS_CANCELLED
FROM flights
WHERE Cancelled = '1' OR DepDelay > 0;

/* Query Results and Interpretation 1.2 :

A total of 2,633,237 flights were either canceled or departed late. 
However, since this analysis spans only two years and lacks data from previous years or other airlines for comparison, 
it’s challenging to draw definitive conclusions about the broader impact of this figure on overall operations and revenue. */

/* Question 1.3: Show the number of flights that were cancelled broken down by the reason for cancellation*/

/* Answer 1.3: See the below query that has a broken down analysis of the reasons for flight cancellations 2018-2019 */ 

SELECT 
    COUNT(id) AS NUMBER_OF_FLIGHTS, CancellationReason
FROM flights
WHERE Cancelled = '1'
GROUP BY CancellationReason;

/* Query Results and Interpretation 1.3:

The highest number of cancellations, totaling 50,225 flights in 2018-2019, were due to unavoidable external factors such as weather. 
The second-highest cause of cancellations was related to airline carriers themselves, accounting for 34,141 flights. 
These insights could help identify strategies to minimize avoidable cancellations in the future, 
improving both revenue and customer service. */

/* Question 1.4: For each month in 2019, report both the total number of flights and percentage of flights cancelled. Based on your results, what might you say about the cyclic nature of airline revenue?*/

/* Answer 1.4 : 

TABLE 1 : For this question, I created two seperate tables for an even more detailed analysis and combined both as a seperate query to derive at the desired result as an asnwer to the question. 

I first ran a table to find out the total number of flights that was operated in 2019 each month. Please see the below query: */

CREATE TABLE IF NOT EXISTS totalflights2019 AS
SELECT 
    YEAR(FlightDate) AS YEAR,
    MONTH(FlightDate) AS MONTH,
    COUNT(id) AS TOTAL_FLIGHTS
FROM flights
WHERE YEAR(FlightDate) = 2019
GROUP BY YEAR, MONTH
ORDER BY YEAR, MONTH;

/* Query Results and Interpretation TABLE 1:

This query provides the total number of flights operated each month in 2019. 
Observing the data reveals a steady increase in monthly flight operations, peaking in July 2019, likely due to the holiday season. 
These insights can help guide future strategies to boost revenue and adjust flight availability during peak periods.  */

/* TABLE 2 : The following table displays the total number of canceled flights for each month in 2019, helping to identify trends in cancellations throughout the year.*/

CREATE TABLE IF NOT EXISTS cancelledflights2019 AS
SELECT 
    YEAR(FlightDate) AS YEAR,
    MONTH(FlightDate) AS MONTH,
    COUNT(Cancelled) AS TOTAL_FLIGHTS_CANCELLED
FROM flights
WHERE YEAR(FlightDate) = 2019
    AND Cancelled = 1
GROUP BY YEAR, MONTH
ORDER BY YEAR, MONTH;

/* Query Results and Interpretation TABLE 2: 

This query provides the total number of flights canceled each month in 2019, although the specific reasons for these cancellations are not identified. 
Notably, April 2019 saw the highest number of cancellations, followed by March, May, and June. 
These trends suggest potential issues or patterns during these months, warranting further investigation to understand and address underlying causes.  */

/* Additional Supportive Query to TABLE 2:  I ran an additional query to identify which airline had the highest number of cancellations in 2019. 
This analysis helps to estimate the potential revenue impact of these cancellations for each airline. 
Since the focus was on 2019 data, the query was limited to that year. */

SELECT 
    AirlineName,
    COUNT(Cancelled) AS TOTAL_FLIGHTS_CANCELLED,
    CancellationReason
FROM flights
WHERE YEAR(FlightDate) = 2019 
    AND Cancelled = 1
GROUP BY AirlineName, CancellationReason
ORDER BY TOTAL_FLIGHTS_CANCELLED DESC;

/* Query Results and Interpretation Additional Supportive Query to TABLE 2:

This analysis provided valuable insights into cancellation trends. 
Southwest Airlines recorded the highest number of cancellations in 2019, with 16,706 flights canceled due to carrier-related issues and 14,498 due to weather. 
American Airlines followed, with 11,912 weather-related cancellations and 6,667 carrier-related cancellations.

These findings suggest inefficiencies in Southwest Airlines' management and flight planning. 
While the data doesn’t specify exact causes, high cancellations due to the airline could indicate issues like frequent industrial strikes, staffing shortages, or low employee and customer satisfaction. 
Such a high rate of cancellations reflects poorly on the company’s reputation and operational reliability. 
Further investigation would be required to understand the underlying causes in more detail.

/* Answer 1.4 : Finally, I combined the previous two tables (TABLE 1 and TABLE 2) using a join to calculate the percentage of flights canceled, addressing question 1.4. 
The query used is provided below: */

SELECT 
    Yr,
    Mth,
    TOTAL_FLIGHTS,
    TOTAL_FLIGHTS_CANCELLED,
    CONCAT(ROUND((TOTAL_FLIGHTS_CANCELLED / TOTAL_FLIGHTS) * 100, 2), '%') AS CANCELLED_FLIGHTS_PERCENTAGE
FROM
    (SELECT 
        tf.Yr, 
        tf.Mth, 
        tf.TOTAL_FLIGHTS, 
        cf.TOTAL_FLIGHTS_CANCELLED
     FROM 
        totalflights2019 tf
     LEFT JOIN 
        cancelledflights2019 cf 
     ON 
        tf.Mth = cf.Mth) AS TOTAL_FLIGHTS_2019;

    
/* Query Results and Interpretation 1.4:- 

This query provides the monthly cancellation rate as a percentage of total flights in 2019. 
The data reveals that while July saw the highest number of flights operated, it had a relatively low cancellation rate, whereas April had a high number of cancellations despite a solid level of flight operations. 
To draw more definitive conclusions, further analysis is needed, considering factors like weather conditions, air traffic control restrictions, and staffing issues.

The cyclical nature of airline revenue is suggested by fluctuations in cancellation rates throughout the year. 
Notably, the percentage of cancellations started at 2.21% in January, with some variation between February and May, followed by a steady decline, indicating an improvement in operations. 
Observing these trends provides insights into seasonal patterns and the potential revenue impact, highlighting areas for operational and strategic enhancements. */

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  

/* Question 2 */

/* Question 2.1 : Create two new tables, one for each year (2018 and 2019) showing the total miles traveled and number of flights broken down by airline. */

/* Answer 2.1 : TABLE 1 - As part of the analysis, TABLE 1 has been designated as totalmiles2018. Below is the corresponding query to calculate the year-over-year percentage change in flights and miles traveled:*/

CREATE TABLE IF NOT EXISTS totalmiles2018 AS
SELECT 
    AirlineName AS Airline,
    SUM(Distance) AS TOTAL_MILES,
    COUNT(id) AS TOTAL_FLIGHTS
FROM
    flights
WHERE
    YEAR(FlightDate) = 2018
GROUP BY AirlineName;


/* Query Results TABLE 1:- 

The above table provides a breakdown of the total number of flights and the total miles operated in 2018. 
Southwest Airlines led with the highest number of flights, operating 1,352,552 flights and traveling a significant total of 1,012,847,097 miles. 
Delta Airlines followed with 949,283 flights, but with a lower total mileage of 842,409,169 miles. 
Meanwhile, American Airlines also demonstrated a respectable number of flights and mileage. */

/* TABLE 2 - Second table named totalmiles2019 has been created below. */

CREATE TABLE IF NOT EXISTS totalmiles2019 AS
SELECT 
    AirlineName AS Airline,
    SUM(Distance) AS TOTAL_MILES,
    COUNT(id) AS TOTAL_FLIGHTS
FROM
    flights
WHERE
    YEAR(FlightDate) = 2019
GROUP BY AirlineName;

/* Query Results TABLE 2:

The above table breaks down by the Total number of Flights and the total Miles they operated in 2019 */

/* Question 2.2 :- Using your new tables, find the year-over-year percent change in total flights and miles traveled for each airline. */

/* Answer 2.2 : Using the data from the tables created above (TABLE 1 and TABLE 2), below is the calculation of the year-over-year percentage change in both the number of flights and the miles traveled. */

SELECT 
    t9.AirlineName AS Airline,
    CONCAT(ROUND(((t9.TOTAL_MILES / t8.TOTAL_MILES) - 1) * 100, 3), '%') AS yoy_miles,
    CONCAT(ROUND(((t9.TOTAL_FLIGHTS / t8.TOTAL_FLIGHTS) - 1) * 100, 3), '%') AS yoy_flights
FROM
    totalmiles2019 t9
JOIN
    totalmiles2018 t8 ON t9.AirlineName = t8.AirlineName;
    
/* Query Results and Interpretation 2.2 :

The year-over-year percentage change has been calculated for 2018-2019. 
According to the results, Southwest Airlines experienced a decline in total miles traveled and no significant increase in flight operations. 
This suggests that the airline may have canceled several long-haul flights while potentially introducing more short-haul flights for operational reasons, warranting further investigation.

American Airlines, on the other hand, saw a modest increase of 3.2% in the number of flights; however, the total miles traveled showed no substantial change. 
This could indicate that the airline has increased the frequency of flights to popular short-haul destinations without introducing any new routes. 
Unfortunately, specific data on operational flights and cancellations is not available.

In contrast, Delta Airlines demonstrated a steady increase of 4.5% in flights and an impressive 5.6% increase in miles traveled, indicating strong growth and operational efficiency. */

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  

/* Question 3 */

/* Question 3.1 : What are the names of the 10 most popular destination airports overall? For this question, generate a SQL query that first joins flights and airports then do the necessary aggregation */

/* Answer 3.1 : Please find the required query below */

SELECT 
    a.AirportName, 
    f.AirlineName, 
    COUNT(f.id) AS totalflights  -- Counting total flights per airline at each airport
FROM
    flights f
JOIN
    airports a ON f.DestAirportID = a.AirportID
GROUP BY 
    a.AirportName, 
    f.AirlineName
ORDER BY 
    totalflights DESC
LIMIT 10;  -- Retrieve the top 10 airports with the highest number of flights

/* Query Results and Interpretation 3.1: 

Hartsfield-Jackson Atlanta International Airport recorded the highest number of flights, making it the most popular destination. 
Delta Airlines operates the most flights to this airport, totaling 489,092.

This raises the question of whether this airport is the busiest across all major airlines, which warrants further analysis to understand trends for future growth. 
Conducting benchmarking studies among various large airline competitors could provide a more comprehensive understanding.

The query execution took 42 seconds, likely due to the need to join two large tables with a single join to retrieve just two columns of data. 
If the query had not been limited to the top 10 results, the runtime would have increased to 44 seconds. 
Additionally, incorporating the Airline Name in the query further extended the runtime to 63 seconds. */

/* Question 3.2 : Answer the same question but using a subquery to aggregate & limit the flight data before your join with the airport information, hence optimizing your query runtime. */

/* Answer 3.2 : Please find the required query below */

SELECT 
    a.AirportName, 
    TOTALFLIGHTS.totalflights
FROM
    airports a
JOIN
    (SELECT 
        f.DestAirportID, 
        COUNT(f.id) AS totalflights
     FROM
        flights f
     GROUP BY 
        f.DestAirportID
     ORDER BY 
        totalflights DESC
     LIMIT 10) AS TOTALFLIGHTS ON a.AirportID = TOTALFLIGHTS.DestAirportID; 

/* Query Results and Interpretation 3.2 : 

The results were the same as the previous Query 
This query executed in only 10 seconds. I utilized a subquery to perform the aggregation, which typically consumes the most resources. 
I believe the relatively short runtime in this case is attributed to the efficient use of a subquery, allowing me to combine two operations into one. 
This approach effectively reduced the overall load, streamlining the query execution process.*/

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  

/* Question 4 

The fund managers are interested in operating costs for each airline. We don't have actual cost or revenue information available, but we may be able to infer a general overview of how each airline's costs 
compare by looking at data that reflects equipment and fuel costs */

/* Question 4.1 : 
A flight's tail number is the actual number affixed to the fuselage of an aircraft, much like a car license plate. As such, each plane has a unique tail number and the number of unique tail numbers for each airline should
approximate how many planes the airline operates in total. Using this information, determine the number of unique aircrafts each airline operated in total over 2018-2019 */

/* Answer 4.1 : The following query was designed to determine the total number of aircraft fleets held by each airline. This information will aid in assessing whether additional fleets are needed or if reductions should be made to enhance future business prospects. 
Please see the query below: */

SELECT 
    AirlineName,
    COUNT(DISTINCT Tail_Number) AS NUMBER_OF_AIRCRAFTS
FROM
    flights
WHERE
    YEAR(FlightDate) BETWEEN 2018 AND 2019
GROUP BY AirlineName;

/* Query Results and Interpretation 4.1 :

American Airlines holds the highest number of fleets, with a total of 993 aircraft. 
This likely contributes to the observed year-over-year increase in the number of flights for this airline from 2018 to 2019. 
Delta Airlines follows closely with 988 aircraft. 
While their fleet size is slightly smaller than that of American Airlines, Delta experienced significant growth during this period, 
with a 4.5% increase in total flights and a 5.6% increase in miles (refer to Q2.2).

Understanding fleet size is essential for evaluating operational capabilities and potential costs. 
In contrast, Southwest Airlines operates a substantial number of flights—1,352,552 in 2018 and 1,363,946 in 2019 (refer to Q2.2)—despite having only 754 aircraft. 
This discrepancy indicates that their fleet size warrants a detailed review to ensure it aligns with their operational demands. */

/* Question 4.2 : Similarly, the total miles traveled by each airline gives an idea of total fuel costs and the distance traveled per plane gives an approximation of total equipment costs. 
What is the average distance traveled per aircraft for each of the three airlines? */

/* Answer 4.2 : This metric will provide us insights into the efficiency of aircraft utilization and route planning. Please find the query below */

SELECT 
    f.AirlineName, 
    COUNT(DISTINCT Tail_Number) AS Total_Fleets, 
    SUM(f.Distance) AS Total_Distance, 
    ROUND(SUM(f.Distance) / COUNT(DISTINCT Tail_Number), 2) AS Total_Dist_per_Fleet
FROM 
    flights f
GROUP BY 
    f.AirlineName;

/* Query Results and Interpretation 4.2 :

This analysis provides insight into the average distance traveled per aircraft for each airline. 
Despite operating the fewest fleets, Southwest Airlines stands out by traveling the greatest distance, averaging 2,684,921.66 miles per aircraft. 
This suggests that either their aircraft operate more frequently, they conduct more long-haul flights, or a combination of both. 
Understanding this aspect can shed light on their route planning efficiency, fuel costs, and overall equipment expenses.

Southwest Airlines not only operates the highest number of flights but also covers the most miles compared to American Airlines and Delta Airlines (refer to Q2.1). 
However, this raises questions about how efficiently they utilize their fleets. Additionally, we should consider how many passengers choose Southwest over Delta and American Airlines for revenue generation analysis. 
With a limited number of aircraft, their tendency to overutilize them could be a significant concern. We should also investigate the age of their aircraft to assess potential implications for maintenance and operational efficiency.

In contrast, Delta Airlines, while operating a larger fleet of 988 aircraft, has traveled fewer miles overall. Nonetheless, they have shown a steady increase in operations in 2019, indicating potential for future growth. */

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  

/* Question 5 

Finally, the fund managers would like you to investigate the three airlines and major airports in terms of on-time performance as well. For each of the following questions, 
consider early departures and arrivals (negative values) as on-time (0 delay) in your calculations.

Question 5.1 : Next, we will look into on-time performance more granularly in relation to the time of departure. We can break up the departure times into three categories as follows

Find the average departure delay for each time-of-day across the whole data set. Can you explain the pattern you see? */

/* Answer 5.1 : The following query was designed to identify the times of day when flight delays are most frequent, allowing for better planning in response to these delays. 
Please take a look at the query below. */

SELECT 
    CASE
        WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN '1-morning'
        WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN '2-afternoon'
        WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN '3-evening'
        ELSE '4-night'
    END AS time_of_day,
    AVG(CASE
        WHEN DepDelay < 0 THEN 0
        ELSE DepDelay
    END) AS avg_dep_delay
FROM
    flights
GROUP BY time_of_day
ORDER BY time_of_day;


/* Query Results and Interpretation 5.1:

time_of_day    avg_departure_delay
1-morning	         7.9055
2-afternoon	        13.6596
3-evening	        18.3138
4-night  	         7.7866 

The results indicate that the highest delays occur in the evening. 
This may be attributed to weather conditions, which tend to have a significant impact during that time. 
Additionally, if there are numerous flights scheduled across all three airlines in the evening, the increased volume of operations can lead to delayed departures.

There are also external factors to consider, such as the timely performance of services provided to the aircraft, including catering, water, drainage, flight crew, and fuel. 
If these services are delayed in reaching the aircraft, it can impact departure times. Moreover, with a higher number of flights operating during specific times of the day, delays become more likely.

Most flight operations involve multiple turnarounds, meaning that if inbound flights experience delays, it can create a cascading effect on departures. 
Both morning and night flights show similar average delays, which are considerably lower than those observed in the afternoon and evening. 
It will be important to further investigate the reasons behind the increased delays in these time periods with the data currently available.

To enhance our understanding for this project, I have also broken down the delays by airline and the total number of flights operated during each time of day.

Additional supportive SQL Query 1 for Answer 5.1 : The following query was created to identify which airline typically experiences the highest and lowest delays during the day, along with the number of flights they operate. This information will be useful for our analysis. 
Please refer to the query below: */

SELECT AirlineName, COUNT(id) AS Num_of_planes,
    CASE
        WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN '1-morning'
        WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN '2-afternoon'
        WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN '3-evening'
        ELSE '4-night'
    END AS time_of_day,
    AVG(CASE
        WHEN DepDelay < 0 THEN 0
        ELSE DepDelay
    END) AS avg_dep_delay
FROM
    flights
GROUP BY AirlineName, time_of_day
ORDER BY time_of_day;    

/* Additonal Query 1 Results and Interpretation :

Let's focus on evening departures, as they exhibit the highest average delays based on our previous analysis. 
Among the three airlines, American Airlines experiences the longest departure delays, averaging 19.7346 minutes. 
Southwest Airlines follows with an average delay of 18.9774 minutes, while Delta Airlines has the lowest average delay at 15.9406 minutes.

In the afternoons, the pattern is similar, with American Airlines again topping the list with an average delay of 15.9615 minutes. 
Southwest Airlines comes next at 13.7689 minutes, and Delta Airlines is third at 11.3467 minutes. 
Mornings and nights have significantly lower delays compared to afternoons and evenings, so we can set those aside for this analysis.

Interestingly, American Airlines operates the fewest flights in the evening, with a total of 446,900, yet it has the highest delays. 
We need to investigate the factors contributing to these delays, as the available data does not provide a clear explanation for why such a small number of flights would result in such high delays.

As previously noted, Southwest Airlines consistently operates the highest number of flights throughout the year compared to the other two airlines (please refer to Q2.1). 
While they rank second in delays across all time periods, the ratio of delays to the number of flights indicates that their average delay figure is relatively low. 
This suggests that there is potential for improvement if their issues are addressed effectively.

Delta Airlines maintains a commendable performance with the least delays, even during peak times in the afternoons and evenings. 
Their flight operations are moderate, with the highest number of flights occurring in the mornings, totaling 636,430.
*/

/* Question 5.2 : Now, find the average departure delay for each airport and time-of-day combination. */

/* Answer 5.2: In this report, I have included the airline name in my query to provide a detailed analysis of the results. 
Additionally, I have incorporated supplementary queries to support my findings. Please see the query for the aforementioned analysis below.
 */

SELECT 
    a.AirportName, 
    f.AirlineName,
    CASE
        WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN '1-morning'
        WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN '2-afternoon'
        WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN '3-evening'
        ELSE '4-night'
    END AS time_of_day,
    AVG(CASE
        WHEN DepDelay < 0 THEN 0
        ELSE DepDelay
    END) AS avg_dep_delay
FROM
    flights f
        JOIN
    airports a ON f.OriginAirportID = a.AirportID
GROUP BY 
    a.AirportName, f.AirlineName, time_of_day
ORDER BY 
    avg_dep_delay DESC;

/* Query Results and Interpretation 5.2 :

I have provided three additional supportive queries below to enhance understanding after my initial analysis.

This query has identified airports with the highest and lowest average delays. 
Notably, Rapid City Regional Airport recorded the highest average delay of 308.5 minutes in the afternoon, specifically for Delta Airlines. 
We lack comprehensive data about this airport and the contributing factors. Since Delta is the only airline operating from this location, there may be several underlying issues that warrant further investigation. 
It is worth noting that there were no delays recorded in the mornings and only seven at night, which is encouraging. 
Upon conducting additional query searches (refer to Additional Supportive Query 1 for Answer 5.2), it became apparent that a significant delay occurred on August 11, 2019. 
Given that this incident appears to be an isolated occurrence, we can reasonably conclude that Delta Airlines generally maintains good operational performance from this airport throughout the day.

The second-highest average delay was again attributed to Delta Airlines, this time from Charlottesville Albemarle Airport in the evening. 
Further investigation (see Additional Supportive Query 2 for Answer 5.2) revealed that delays occurred on three occasions: two in August 2018 (on the 18th and 29th) and one on December 1, 2019, which involved a substantial delay. 
Since this was a one-time significant delay, it may not significantly impact our overall analysis.

The third-highest average delay was recorded by American Airlines from Hector International Airport in the evening, with an average delay of 105.6 minutes. 
A review of the dates associated with these delays (see Additional Supportive Query 3 for Answer 5.2) indicates that a massive delay of 1,017 minutes occurred on December 20, 2019, along with smaller delays on the 23rd, 26th, 30th, and 31st of the same month. 
Given the pattern of delays during December, it would be prudent to investigate the reasons behind these frequent occurrences, particularly in the evenings, to identify possible preventive measures.

Additionally, there are approximately 18 airports where both Delta and American Airlines recorded zero departure delays. 
We can leverage these airports as benchmarks for future studies to understand the factors contributing to the absence of delays, which may assist airlines in minimizing delays at other locations.*/


/* Additional supportive Query 1 for Answer 5.2 : Below I have written a query for Rapid City Regional Airport and dates to assertain when the major delay occured to understand if this was a one off occurance or a sequential one. The details of
my explanations are given above in my Query Results and Interpretation 5.2*/

SELECT 
    a.AirportName, 
    f.AirlineName, 
    CASE
        WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN '1-morning'
        WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN '2-afternoon'
        WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN '3-evening'
        ELSE '4-night'
    END AS time_of_day,
    AVG(CASE
        WHEN DepDelay < 0 THEN 0
        ELSE DepDelay
    END) AS avg_dep_delay
FROM
    flights f
        JOIN
    airports a ON f.OriginAirportID = a.AirportID
WHERE 
    a.AirportName = 'Rapid City Regional' 
    AND HOUR(CRSDepTime) BETWEEN 12 AND 16
GROUP BY 
    a.AirportName, 
    f.AirlineName, 
    time_of_day
ORDER BY 
    avg_dep_delay DESC;

/* Additional supportive Query 2 for Answer 5.2 : Below I have written a query for Charlottesville Albemarle airport and dates to assertain when the major delay occured to understand if this was a one off occurance or a sequential one. The details of
my explanations are given above in my Query Results and Interpretation 5.2*/

SELECT 
    a.AirportName, 
    f.AirlineName, 
    CASE
        WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN '1-morning'
        WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN '2-afternoon'
        WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN '3-evening'
        ELSE '4-night'
    END AS time_of_day,
    AVG(CASE
        WHEN DepDelay < 0 THEN 0
        ELSE DepDelay
    END) AS avg_dep_delay
FROM
    flights f
        JOIN
    airports a ON f.OriginAirportID = a.AirportID
WHERE 
    a.AirportName = 'Charlottesville Albemarle' 
    AND HOUR(CRSDepTime) BETWEEN 17 AND 21
GROUP BY 
    a.AirportName, 
    f.AirlineName, 
    time_of_day
ORDER BY 
    avg_dep_delay DESC;

/* Additional supportive Query 3 for Answer 5.2 : Below I have written a query for Hector International Airport and dates to assertain when the major delay occured to understand if this was a one off occurance or a sequential one. The details of
my explanations are given above in my Query Results and Interpretation 5.2*/

SELECT 
    a.AirportName, 
    f.AirlineName, 
    CASE
        WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN '1-morning'
        WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN '2-afternoon'
        WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN '3-evening'
        ELSE '4-night'
    END AS time_of_day,
    AVG(CASE
        WHEN DepDelay < 0 THEN 0
        ELSE DepDelay
    END) AS avg_dep_delay
FROM
    flights f
        JOIN
    airports a ON f.OriginAirportID = a.AirportID
WHERE 
    a.AirportName = 'Hector International' 
    AND HOUR(CRSDepTime) BETWEEN 17 AND 21
GROUP BY 
    a.AirportName, 
    f.AirlineName, 
    time_of_day
ORDER BY 
    avg_dep_delay DESC;

/* Question 5.3 : Next, limit your average departure delay analysis to morning delays and airports with at least 10,000 flights */

/* Answer 5.3 : This query aims to analyze average delays at airports that have operated over 10,000 flights, allowing us to identify which airline experiences the highest delays in these busy airports. 
I've included the airline names to enhance the understanding of the trends. Below is the query:. */

SELECT 
    a.AirportName, 
    f.AirlineName, 
    AVG(CASE
            WHEN f.DepDelay < 0 THEN 0
            ELSE f.DepDelay
        END) AS avg_dep_delay
FROM
    airports a
        JOIN
    Flights f ON a.AirportID = f.OriginAirportID
WHERE
    HOUR(CRSDepTime) BETWEEN 7 AND 11
GROUP BY 
    a.AirportName, 
    f.AirlineName
HAVING 
    COUNT(f.id) >= 10000
ORDER BY
    avg_dep_delay DESC;

/* Query Results and Interpretation 5.3 :

The results from the previous query revealed that San Francisco International Airport has the highest average departure delay at 17.9901 minutes, attributed to American Airlines, which operates 10,209 flights during the morning. 
The reasons behind these significant delays remain unclear. Following this, Los Angeles International Airport shows the second highest delays at 13.1962 minutes, also by American Airlines, which runs 29,635 morning flights. 
The third highest average departure delay of 11.4379 minutes was recorded at Dallas/Fort Worth International Airport, again for American Airlines, with a substantial total of 95,329 flights (refer to Additional Supportive Query 1 for Question 5.3).

I also wanted to analyze the performance of the other two airlines at busy airports. 
Delta Airlines exhibited minimal delays, typically ranging between 5 and 9 minutes. The top three delays were as follows: Los Angeles International Airport had the highest delay for Delta Airlines at 9.9272 minutes, with 26,584 flights. 
The second highest delay occurred at Logan International Airport, at 9.9164 minutes, with 12,507 flights, while Seattle/Tacoma International Airport recorded a delay of 9.3740 minutes among 23,296 flights (see Additional Supportive Query 2 for Question 5.3).

For Southwest Airlines, the delays ranged from 4 to 10 minutes. The highest delay was noted at Chicago Midway International Airport, with an average of 10.2439 minutes across 44,837 flights. 
The second highest delay was at Los Angeles International Airport, at 9.4615 minutes for 26,082 flights, followed by Phoenix Sky Harbor International Airport with an average delay of 8.3867 minutes across 41,200 flights (see Additional Supportive Query 3 for Question 5.3).

From these trends, it’s evident that Los Angeles International Airport is a common hub for all three airlines, with American Airlines experiencing the highest delays, while Delta and Southwest Airlines maintain relatively comparable performance. 
Further investigation is warranted to uncover the underlying causes of these significant delays. */

/* Additional supportive Query 1 to Question 5.3:- I used below queries to see how many flights did American Airlines traveled from San Francisco International, Los Angeles International and Dallas/Fort Worth International in the morning */

SELECT AirportID, AirportName 
FROM airtraffic.airports
WHERE AirportName IN ('San Francisco International', 'Los Angeles International', 'Dallas/Fort Worth International'); -- Query to Get Airport IDs

SELECT OriginAirportID, COUNT(id) AS Num_of_Flights
FROM flights
WHERE OriginAirportID IN ('14771', '12892', '11298')  AND HOUR(CRSDepTime) BETWEEN 7 AND 11 AND AirlineName = 'American Airlines Inc.'
GROUP BY OriginAirportID; -- I used this query to get number of flights. 10209, 29635 and 95329 flights respectively

/* Additional supportive Query 2 to Question 5.3:- I used below queries to see how many flights did Delta Airlines traveled from Los Angeles International, Logan International and Seattle/Tacoma International in the morning */

SELECT AirportID, AirportName FROM airtraffic.airports
WHERE AirportName IN ('Los Angeles International', 'Logan International', 'Seattle/Tacoma International')
GROUP BY AirportID, AirportName; -- I used this query to find out the Airport ID so we can find the required data from the flights table.

SELECT OriginAirportID, COUNT(id) AS Num_of_Flights
FROM flights
WHERE OriginAirportID IN ('12892', '10721', '14747') AND HOUR(CRSDepTime) BETWEEN 7 AND 11 AND AirlineName = 'Delta Air Lines Inc.'
GROUP BY OriginAirportID; -- 26584, 12507 and 23296 flights respectively

/* Additional supportive Query 3 to Question 5.3:- I used below queries to see how many flights did Southwest Airlines traveled from Chicago Midway International, Logan International and Seattle/Tacoma International in the morning */

SELECT AirportID, AirportName FROM airtraffic.airports
WHERE AirportName IN ('Chicago Midway International', 'Los Angeles International', 'Phoenix Sky Harbor International' )
GROUP BY AirportID, AirportName; -- I used this query to find out the Airport ID so we can find the required data from the flights table.

SELECT OriginAirportID, COUNT(id) AS Num_of_Flights
FROM flights
WHERE OriginAirportID IN ('13232', '12892','14107') AND HOUR(CRSDepTime) BETWEEN 7 AND 11 AND AirlineName = 'Southwest Airlines Co.'
GROUP BY OriginAirportID; -- 44837, 26082 and 41200 flights respectively

/* Question 5.4 :- By extending the query from the previous question, name the top-10 airports (with >10000 flights) with the highest average morning delay. In what cities are these airports located? */

/* Answer 5.4 :- I used below query find out what cities these 10 busy airports were located in and I have added the airline name to find out again which ones should we have an eye on for the highest delays. Please see the query below */

SELECT 
    a.AirportName, 
    a.City, 
    f.AirlineName, 
    AVG(CASE WHEN f.DepDelay < 0 THEN 0 ELSE f.DepDelay END) AS avg_dep_delay
FROM
    airports a
JOIN
    Flights f ON a.AirportID = f.OriginAirportID
WHERE
    HOUR(f.CRSDepTime) BETWEEN 7 AND 11
GROUP BY 
    a.AirportName, 
    a.City, 
    f.AirlineName
HAVING 
    COUNT(f.id) > 10000
ORDER BY 
    avg_dep_delay DESC
LIMIT 10;

/* Query Results and Interpretation 5.4 :

The results of this query build upon the previous analysis, providing a deeper look into the top three busiest airports by airline and their corresponding highest delay times. 
Among the three airlines, American Airlines experiences the most significant delays. However, it’s noteworthy that they operate 95,329 flights from Dallas/Fort Worth International, yet their delay rate remains relatively low compared to the total number of flights.

Given the limited data available and the lack of additional information, it is challenging to form a comprehensive hypothesis regarding which airline performs best among the three. */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  

/*My Findings and Recomendations :

Based on the data and the analyses conducted, I recommend that the BrainStation Mutual Fund managers consider investing in Delta Airlines for the following reasons:

1. Sufficient Fleet Size: Delta Airlines operates a total of 988 aircraft, eliminating the immediate need to purchase new planes unless there are plans for significant business expansion (Refer to row 285).

2. Low Cancellation Rates: The airline reported only 553 flight cancellations in 2019, significantly lower than its competitors. 
This suggests that minimal adjustments could enhance their operations and revenue while reducing existing delay patterns (Refer to Additional Supportive Query to TABLE 2 at row 107).

3. Positive Growth Trend: There was a steady year-on-year increase in percentage change from 2018 to 2019, indicating growth potential. With an adequate number of aircraft, Delta has the opportunity to expand operations to long-haul destinations and increase flight frequency to popular routes (Refer to row 195).

4. Attractive Destinations: Delta operates flights to two of the most sought-after destinations, particularly during peak holiday seasons. 
The airline's most frequent flights are to Hartsfield-Jackson Atlanta International Airport, which is the busiest airport, making it appealing to travelers. Expanding to additional popular destinations could further enhance their market attractiveness (Refer to row 222).

5. Efficient Fleet Utilization: Despite having the largest fleet, Delta Airlines travels the least distance compared to its competitors. 
This suggests that their aircraft are not overused, potentially leading to lower rates of wear and tear, which can result in greater durability, reliability, and insurability.

6. Operational Efficiency: Delta consistently exhibits the least average delays across all times of day, demonstrating their capability to manage operations effectively despite challenges such as weather and air traffic restrictions (Refer to Row 360).

7. Experienced Management Team: The airline appears to have a well-informed and experienced management team that understands the intricacies of the airline industry. 
Delta tends to have isolated incidents of significant delays, unlike its competitors, indicating superior management of operational challenges (Refer to row 393).

8. Stability at Busy Airports: Delta Airlines maintains a low average delay range (between 4 and 9 minutes) at airports with over 10,000 flights, reflecting a stable and reliable operational framework. 
Although they already have effective strategies in place, minor business adjustments could further solidify their appeal to potential investors (Refer to Row 526).








