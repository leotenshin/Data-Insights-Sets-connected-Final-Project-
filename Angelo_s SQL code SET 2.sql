SELECT * FROM competitors
SELECT * FROM corruption_convictions_per_capita
SELECT * FROM health_spending
SELECT * FROM population
SELECT * FROM property_prices
SELECT * FROM state_income

--- create and merge tables with the same column names

CREATE TABLE merged_data AS
SELECT
    c.research_development_spent,
    c.administration,
    c.marketing_spent,
    c.state_usa AS competitors_state_usa,
    c.profit,
    ccp.convictions_per_capita,
    hs.avg_spending,
    hs.min_spending,
    hs.max_spending,
    p.estimate,
    pp.avg_price,
    pp.min_price,
    pp.max_price,
    si.average_income,
    si.minimum_income,
    si.maximum_income
FROM
    competitors AS c
JOIN
    corruption_convictions_per_capita AS ccp
    ON c.state_usa = ccp.state_usa
JOIN
    health_spending AS hs
    ON c.state_usa = hs.state_usa
JOIN
    population AS p
    ON c.state_usa = p.state_usa
JOIN
    property_prices AS pp
    ON c.state_usa = pp.state_usa
JOIN
    state_income AS si
    ON c.state_usa = si.state_usa;
	
--- SET 2 Final Project

---Calculate the percentage of property prices and population by state in relation to the total amount of property price and population. Is there any observable connection between property prices and population?
---Identify the states with the highest and lowest average property prices.
---Identify the states with the highest and lowest population.

-- 1.
SELECT competitors_state_usa,
       ROUND((SUM(avg_price) / (SELECT SUM(avg_price) FROM merged_data)) * 100, 2) AS price_percentage,
       ROUND((SUM(estimate) / (SELECT SUM(estimate) FROM merged_data)) * 100, 2) AS population_percentage
FROM merged_data
GROUP BY competitors_state_usa;

-- 2. 
SELECT competitors_state_usa, SUM(avg_price) AS total_avg_price
FROM merged_data
GROUP BY competitors_state_usa
ORDER BY total_avg_price DESC
LIMIT 5; -- Highest Average Property Price


SELECT competitors_state_usa, SUM(avg_price) AS total_avg_price
FROM merged_data
GROUP BY competitors_state_usa
ORDER BY total_avg_price ASC
LIMIT 5; -- Lowest Average Property Price

-- 3.
SELECT competitors_state_usa, SUM(estimate) AS total_population
FROM merged_data
GROUP BY competitors_state_usa
ORDER BY total_population DESC
LIMIT 5; -- Highest population

SELECT competitors_state_usa, SUM(estimate) AS total_population
FROM merged_data
GROUP BY competitors_state_usa
ORDER BY total_population ASC
LIMIT 5; -- Lowest population