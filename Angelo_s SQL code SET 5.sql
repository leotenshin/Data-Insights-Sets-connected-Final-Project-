SELECT * FROM competitors
SELECT * FROM corruption_convictions_per_capita
SELECT * FROM health_spending
SELECT * FROM population
SELECT * FROM property_prices
SELECT * FROM state_income

--- create and merge tables with the same column names

CREATE TABLE merged_data_6 AS
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

--- SET 5 Final Project

---Find the top 5 states with the highest income per capita.
---Calculate the average income for each state and rank them by their income.
---Join the competitor dataset with the population dataset to see if there is any correlation between population and profit.

-- 1.
SELECT competitors_state_usa, SUM(average_income) AS total_income
FROM merged_data
GROUP BY competitors_state_usa
ORDER BY total_income DESC
LIMIT 5;

-- 2.
SELECT competitors_state_usa, ROUND(SUM(average_income)) AS avg_income
FROM merged_data
GROUP BY competitors_state_usa
ORDER BY avg_income DESC;

-- 3.
SELECT
    competitors.state_usa,
    SUM(competitors.profit) AS total_profit,
    SUM(population.estimate) AS total_estimate
FROM
    competitors
JOIN
    population
    ON competitors.state_usa = population.state_usa
GROUP BY
    competitors.state_usa;