-- Assessment_Q1.sql

-- Find customers with both funded savings and funded investment plans, sorted by total deposits.

SELECT
    u.id AS owner_id,
    u.name AS customer_name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    SUM(s.confirmed_amount) AS total_deposits
FROM users_customuser u
JOIN plans_plan p ON u.id = p.owner_id
JOIN savings_savingsaccount s ON s.plan_id = p.id
GROUP BY u.id, u.name
HAVING COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) >= 1
   AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) >= 1
ORDER BY total_deposits DESC;