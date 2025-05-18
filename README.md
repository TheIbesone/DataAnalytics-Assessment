# Data Analytics SQL Assessment

This repository contains SQL queries for my SQL proficiency assessment. Each query addresses a specific business scenario using data from four relational tables.

---

## Question Breakdown & Approach

Q1. High-Value Customers with Multiple Products
- Goal: Identify customers who have both funded savings and investment plans.
- *Approach:* 
  - Used conditional aggregation on plans_plan joined with savings_savingsaccount.
  - Counted plan types and summed total deposits per user.
- *Challenge:* Filtering only funded plans while ensuring both plan types exist for each customer.

---

Q2. Transaction Frequency Analysis
- Goal: Segment customers based on transaction frequency per month.
- *Approach:* 
  - Calculated active months using AGE() on transaction dates.
  - Grouped users by calculated average transactions and applied a frequency category.
- *Challenge:* Handling division by zero in month calculation and null values for edge cases.

---

Q3. Account Inactivity Alert
- Goal: Detect plans with no inflows in the last 365 days.
- *Approach:* 
  - Queried most recent transaction per plan.
  - Filtered based on last transaction date and calculated inactivity days.
- *Challenge:* Ensuring NULL-safe logic for accounts with no transactions.

---

Q4. Customer Lifetime Value (CLV)
- *Goal:* Estimate CLV using simplified formula:  
  *CLV = (total_tx / tenure_months) × 12 × avg_profit_per_transaction*
- *Approach:*
  - Aggregated transaction data and joined with customer tenure.
  - Used kobo-to-naira conversion and profit margin of 0.1%.
- *Challenge:* Avoiding division by zero for new users with short tenure.

---

## How to Use
Each .sql file contains a single query that can be run directly in PostgreSQL or compatible SQL environment. Comments are provided to explain logic for each major step.

---

## Tables Used
- users_customuser: Customer demographic and sign-up info
- savings_savingsaccount: Deposit transactions and values
- plans_plan: Plan types (savings or investment)
- withdrawals_withdrawal: Withdrawals (not required in current tasks)

---

## Notes.
- All queries are formatted and include comments for clarity.