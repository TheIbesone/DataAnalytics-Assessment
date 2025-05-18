-- Assessment_Q3.sql

-- Find active plans with no transactions in the last 365 days

WITH last_tx AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        CASE
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
        END AS plan_type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM plans_plan p
    LEFT JOIN savings_savingsaccount s ON s.plan_id = p.id
    WHERE p.is_regular_savings = 1 OR p.is_a_fund = 1
    GROUP BY p.id, p.owner_id, plan_type
),
inactivity_check AS (
    SELECT *,
        DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
    FROM last_tx
    WHERE last_transaction_date IS NOT NULL
      AND DATEDIFF(CURDATE(), last_transaction_date) > 365
)

SELECT plan_id, owner_id, plan_type, last_transaction_date, inactivity_days
FROM inactivity_check
ORDER BY inactivity_days DESC;
