SELECT * FROM competitors
SELECT * FROM corruption_convictions_per_capita
SELECT * FROM health_spending
SELECT * FROM population
SELECT * FROM property_prices
SELECT * FROM state_income

--- create and merge tables with the same column names

CREATE TABLE merged_data_7 AS
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
	
--- SET 6 Final Project

---Calculate the total profit, research & development expenditure, administration expenditure, and marketing expenditure for each state.
---Rank the states based on their total profit and identify the top 5 states.
---Calculate the average health spending, property prices, state income, and population for the top 5 states and compare them.

-- 1.
SELECT
    competitors_state_usa AS state,
    ROUND(SUM(profit)) AS total_profit,
    ROUND(SUM(research_development_spent)) AS total_rnd_expenditure,
    ROUND(SUM(administration)) AS total_admin_expenditure,
    ROUND(SUM(marketing_spent)) AS total_marketing_expenditure
FROM
    merged_data
GROUP BY
    state;
	
-- 2.
SELECT competitors_state_usa, ROUND(SUM(profit)) AS total_profit
FROM merged_data
GROUP BY competitors_state_usa
ORDER BY total_profit DESC
LIMIT 5;

-- 3.
SELECT competitors_state_usa,
       ROUND(AVG(avg_spending), 2) AS avg_health_spending,
       ROUND(AVG(avg_price), 2) AS avg_property_price,
       ROUND(AVG(average_income), 2) AS avg_state_income,
       ROUND(SUM(estimate)) AS total_population
FROM merged_data
GROUP BY competitors_state_usa
ORDER BY total_population DESC
LIMIT 5;