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
	
--- SET 1 Final Project

---Calculate the percentage of income by state and corruption convictions per capita in relation to the total amount of income by state and corruption convictions per capita. Is there any observable connection between income by state and corruption convictions per capita?
---Identify the states with the highest and lowest average income.
---Identify the states with the highest and lowest corruption conviction rates.

-- 1.
SELECT competitors_state_usa,
       ROUND((SUM(average_income) / (SELECT SUM(average_income) FROM merged_data)) * 100, 2) AS income_percentage,
       ROUND((SUM(convictions_per_capita) / (SELECT SUM(convictions_per_capita) FROM merged_data)) * 100, 2) AS convictions_percentage
FROM merged_data
GROUP BY competitors_state_usa;

-- 2. 
SELECT competitors_state_usa, SUM(average_income) AS total_income
FROM merged_data
GROUP BY competitors_state_usa
ORDER BY total_income DESC
LIMIT 5; -- Highest Average Income

SELECT competitors_state_usa, SUM(average_income) AS total_income
FROM merged_data
GROUP BY competitors_state_usa
ORDER BY total_income ASC
LIMIT 5; -- Lowest Average Income

-- 3.
SELECT competitors_state_usa, ROUND(AVG(convictions_per_capita), 2) AS avg_conviction_rate
FROM merged_data
GROUP BY competitors_state_usa
ORDER BY avg_conviction_rate DESC
LIMIT 5; -- Highest Conviction Rate

SELECT competitors_state_usa, ROUND(AVG(convictions_per_capita), 2) AS avg_conviction_rate
FROM merged_data
GROUP BY competitors_state_usa
ORDER BY avg_conviction_rate ASC
LIMIT 5; -- Lowest Conviction Rate