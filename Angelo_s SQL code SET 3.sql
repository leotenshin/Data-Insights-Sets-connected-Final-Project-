SELECT * FROM competitors
SELECT * FROM corruption_convictions_per_capita
SELECT * FROM health_spending
SELECT * FROM population
SELECT * FROM property_prices
SELECT * FROM state_income

--- create and merge tables with the same column names

CREATE TABLE merged_data_4 AS
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
	
--- SET 3 Final Project

---Calculate the percentage of healthcare spending and competitor spending by state in relation to the total amount of healthcare spending and competitor spending. Is there any observable connection between healthcare spending and competitor spending?
---Identify the states with the highest and lowest average healthcare spending.
---Identify the states with the highest and lowest competitor spending.

-- 1. 
SELECT competitors_state_usa,
       ROUND((sum(avg_spending) / total_healthcare_spending) * 100, 2) AS healthcare_spending_percentage,
       ROUND((sum(avg_spending) / total_competitor_spending) * 100, 2) AS competitor_spending_percentage
FROM merged_data
CROSS JOIN (
    SELECT sum(avg_spending) AS total_healthcare_spending,
           sum(research_development_spent + administration + marketing_spent) AS total_competitor_spending
    FROM merged_data
) totals
GROUP BY competitors_state_usa, total_healthcare_spending, total_competitor_spending;

-- 2.
SELECT competitors_state_usa, SUM(avg_spending) AS total_avg_spending
FROM merged_data
GROUP BY competitors_state_usa
ORDER BY total_avg_spending DESC
LIMIT 5; -- Highest Healthcare Spending

SELECT competitors_state_usa, SUM(avg_spending) AS total_avg_spending
FROM merged_data
GROUP BY competitors_state_usa
ORDER BY total_avg_spending ASC
LIMIT 5; -- Lowest Healthcare Spending

-- 3.
SELECT competitors_state_usa, 
       ROUND(SUM(research_development_spent + administration + marketing_spent), 2) AS total_competitor_spending
FROM merged_data
GROUP BY competitors_state_usa
ORDER BY total_competitor_spending DESC
LIMIT 5; -- Highest Competitor Spending

SELECT competitors_state_usa, 
       ROUND(SUM(research_development_spent + administration + marketing_spent), 2) AS total_competitor_spending
FROM merged_data
GROUP BY competitors_state_usa
ORDER BY total_competitor_spending ASC
LIMIT 5; -- Lowest Competitor Spending