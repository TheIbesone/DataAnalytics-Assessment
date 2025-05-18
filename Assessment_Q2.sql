-- Assessment_Q2.sql

-- Calculate the average number of transactions per customer per month and categorize them:
-- "High Frequency" (≥10 transactions/month)
-- "Medium Frequency" (3-9 transactions/month)
-- "Low Frequency" (≤2 transactions/month)


WITH transaction_summary AS (
    SELECT
        s.owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) + 1 AS active_months
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),
frequency_stats AS (
    SELECT
        ts.owner_id,
        u.name,
        ROUND(ts.total_transactions / ts.active_months, 2) AS avg_tx_per_month
    FROM transaction_summary ts
    JOIN users_customuser u ON ts.owner_id = u.id
),
category_table AS (
    SELECT
        CASE
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        COUNT(*) AS customer_count,
        ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month
    FROM frequency_stats
    GROUP BY frequency_category
)

SELECT * FROM category_table
ORDER BY avg_transactions_per_month DESC;