-- Assessment_Q4.sql

-- : For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
-- Account tenure (months since signup)
-- Total transactions
-- Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
-- Order by estimated CLV from highest to lowest

-- Step 1: Calculate basic customer transaction info
WITH customer_transactions AS (
    SELECT
        s.owner_id,                              -- Identify customer by owner_id
        COUNT(*) AS total_transactions,         -- Count total transactions per customer
        SUM(s.confirmed_amount) AS total_value, -- Sum total transaction values (in kobo)
        MIN(u.date_joined) AS joined_date       -- Get the earliest signup date of customer
    FROM savings_savingsaccount s
    JOIN users_customuser u ON s.owner_id = u.id
    WHERE s.confirmed_amount IS NOT NULL AND s.confirmed_amount > 0  -- Only count valid positive transactions
    GROUP BY s.owner_id
),

-- Step 2: Calculate Customer Lifetime Value (CLV) and related metrics
clv_calc AS (
    SELECT
        ct.owner_id AS customer_id,                        -- Customer identifier
        u.name,                                           -- Customer name
        TIMESTAMPDIFF(MONTH, ct.joined_date, CURDATE()) AS tenure_months, -- Months since signup (account tenure)
        ct.total_transactions,                            -- Total number of transactions by customer
        ROUND((ct.total_value * 0.001) / ct.total_transactions, 2) AS avg_profit_per_tx,  -- Average profit per transaction assuming 0.1% of transaction value (kobo to units x 0.001)
        ROUND(
            (ct.total_transactions / TIMESTAMPDIFF(MONTH, ct.joined_date, CURDATE())) * 12 *   -- Normalize transactions per month to yearly transactions
            ((ct.total_value * 0.001) / ct.total_transactions), 2) AS estimated_clv            -- Estimated Customer Lifetime Value (CLV)
    FROM customer_transactions ct
    JOIN users_customuser u ON u.id = ct.owner_id
    WHERE TIMESTAMPDIFF(MONTH, ct.joined_date, CURDATE()) > 0     -- Only consider customers with tenure > 0 months
)

-- Step 3: Show results ordered by highest CLV first
SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;
