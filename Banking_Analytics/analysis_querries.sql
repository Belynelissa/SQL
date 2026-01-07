-- CUSTOMER SEGMENTATION AND VALUE ANALYSIS

-- How many customers does the bank have (sanity check) 
USE banking_analytics;
SELECT COUNT(*) AS total_customers
FROM customers;
-- This confirms data has been loaded correctly and establishes scale


-- Where are the bank's customers located (geographical segmentation)
SELECT region, COUNT(*) AS customer_count
FROM customers 
GROUP BY region ORDER BY customer_count DESC;
-- Shows market concentration. Helps with branch expansion and marketing decisions


-- Income-based customer segmentation (income bands)
SELECT 
CASE 
WHEN annual_income < 30000 THEN 'Low Income'
WHEN annual_income BETWEEN 30000 AND 70000 THEN 'Middle Income'
ELSE 'High Income'
END AS income_segment, COUNT(*) AS customer_count
FROM customers
GROUP BY income_segment ORDER BY customer_count;
-- Income bands drive product targeting, loan eligibilty and risk appetite


-- Customer value (balances per customer)
SELECT customers.customer_id, customers.first_name, customers.last_name, SUM(accounts.balance) AS total_balance
FROM customers JOIN accounts ON customers.customer_id = accounts.customer_id
GROUP BY customers.customer_id
ORDER BY total_balance DESC;

-- Identify high-value customers(Top 10%)
SELECT customer_id, first_name, last_name, total_balance,
NTILE(10) OVER(ORDER BY total_balance DESC) AS balance_decile
FROM (
SELECT customers.customer_id, customers.first_name, customers.last_name, SUM(accounts.balance) AS total_balance
FROM customers JOIN accounts ON customers.customer_id = accounts.customer_id
GROUP BY customers.customer_id, customers.first_name, customers.last_name) t;
-- Splits customers into 10 equal groups(decile 1 is highest to 10 is lowest)

-- Extract top 10% customers
SELECT * FROM(
SELECT customer_id, first_name, last_name, total_balance, NTILE(10) OVER(ORDER BY total_balance DESC) AS balance_decile
FROM(
SELECT customers.customer_id, customers.first_name, customers.last_name, SUM(accounts.balance) AS total_balance
FROM customers JOIN accounts ON customers.customer_id = accounts.customer_id
GROUP BY customers.customer_id)t)
RANKED WHERE balance_decile = 1;


-- Income vs balance relationship
SELECT 
CASE
WHEN customers.annual_income < 30000 THEN 'Low Inome'
WHEN customers.annual_income BETWEEN 30000 AND 70000 THEN 'Middle Income'
ELSE 'High Income'
END AS income_segment,
AVG(accounts.balance) AS avg_account_balance
FROM customers JOIN accounts ON customers.customer_id = accounts.customer_id 
GROUP BY income_segment ORDER BY avg_account_balance DESC;


-- Transaction per channel
SELECT channel, COUNT(*) AS transaction_count
FROM transactions 
GROUP BY channel ORDER BY transaction_count DESC;
-- Helps design channel specific marketing or digital strategy


-- Average transaction amount per channel
SELECT channel, ROUND(AVG(amount),2) AS avg_txn_amount
FROM transactions 
GROUP BY channel ORDER BY avg_txn_amount DESC;
-- Channels that handle high value transaction amounts


-- Active customers per channel
SELECT transactions.channel, COUNT(DISTINCT accounts.customer_id) AS unique_customers
FROM transactions JOIN accounts ON transactions.account_id = accounts.account_id
GROUP BY transactions.channel ORDER BY unique_customers;
-- Shows channel reach


-- Merge with income segments
WITH income_seg AS (
SELECT customer_id, 
CASE 
WHEN annual_income < 30000 THEN 'Low Income'
WHEN annual_income BETWEEN 30000 AND 70000 THEN 'Middle Income'
ELSE 'High Income'
END AS income_segment FROM customers)
SELECT transactions.channel, income_segment, COUNT(*) AS transaction_count, ROUND(AVG(transactions.amount), 2) AS avg_amount
FROM transactions 
JOIN accounts ON transactions.account_id = accounts.account_id
JOIN income_seg ON accounts.customer_id = income_seg.customer_id
GROUP BY transactions.channel, income_segment ORDER BY transactions.channel, avg_amount DESC;
-- Cross analysis


-- Count of loans by status
SELECT status, COUNT(*) AS loan_count
FROM loans 
GROUP BY status ORDER BY loan_count DESC;

SELECT * FROM loans LIMIT 3;
-- Loan balance by segment
SELECT loans.status,
CASE
WHEN customers.annual_income < 30000 THEN 'Low Income'
WHEN customers.annual_income BETWEEN 30000 AND 70000 THEN 'Middle Income'
ELSE 'Low Income'
END AS income_segment, 
SUM(loans.loan_amount) AS total_loan_amount
FROM loans JOIN customers ON loans.customer_id = customers.customer_id
GROUP BY loans.status,
CASE 
WHEN customers.annual_income < 30000 THEN 'Low Income'
WHEN customers.annual_income BETWEEN 30000 AND 70000 THEN 'Middle Income'
ELSE 'Low Income'
END
ORDER BY total_loan_amount DESC;


-- Loan portfolio and defaut risk analysis

-- Overall loanbook size
SELECT COUNT(*) AS total_loans, SUM(loan_amount) AS total_loan_book FROM loans;


-- Loan distribution by status(How healthy is the loanbook)
SELECT status, COUNT(*) AS loan_count, SUM(loan_amount) AS total_loan_amount FROM loans 
GROUP BY status ORDER BY total_loan_amount DESC;


-- Default rate
SELECT ROUND( 
SUM(CASE WHEN status = 'Defaulted' THEN 1 ELSE 0 END)
/ COUNT(*) * 100,
2) AS default_rate_percentage
FROM loans;

-- Default risk by income segment (Risky income groups)
SELECT 
CASE
WHEN  customers.annual_income < 30000 THEN 'Low Income'
WHEN customers.annual_income BETWEEN 30000 AND 70000 THEN 'Middle Income'
ELSE 'High Income'
END AS income_segment,
COUNT(loans.loan_id) AS total_loans, 
SUM(CASE WHEN loans.status = 'Defaulted' THEN 1 ELSE 0 END) AS defaulted_loans,
ROUND(SUM(
CASE WHEN loans.status = 'Defaulted' THEN 1 ELSE 0 END)
/ COUNT(loans.loan_id)*100,
2) AS default_rate_percentage
FROM LOANS JOIN customers ON loans.customer_id = customers.customer_id
GROUP BY income_segment ORDER BY default_rate_percentage DESC;


-- Loan exposure at risk(Where bank is losing money)
SELECT 
    CASE 
        WHEN customers.annual_income < 30000 THEN 'Low Income'
        WHEN customers.annual_income BETWEEN 30000 AND 70000 THEN 'Middle Income'
        ELSE 'High Income'
    END AS income_segment,
    SUM(CASE WHEN loans.status = 'Defaulted' THEN loans.loan_amount ELSE 0 END) 
        AS defaulted_amount,
    SUM(loans.loan_amount) AS total_amount,
    ROUND(
        SUM(CASE WHEN loans.status = 'Defaulted' THEN loans.loan_amount ELSE 0 END)
        / SUM(loans.loan_amount) * 100,
    2) AS exposure_at_risk_percentage
FROM loans
JOIN customers
ON loans.customer_id = customers.customer_id
GROUP BY income_segment
ORDER BY exposure_at_risk_percentage DESC;


-- Loan size vs default behaviour
SELECT 
    CASE 
        WHEN loan_amount < 5000 THEN 'Small Loans'
        WHEN loan_amount BETWEEN 5000 AND 20000 THEN 'Medium Loans'
        ELSE 'Large Loans'
    END AS loan_size_band,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN status = 'Defaulted' THEN 1 ELSE 0 END) AS defaulted_loans,
    ROUND(
        SUM(CASE WHEN status = 'Defaulted' THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
    2) AS default_rate_percentage
FROM loans
GROUP BY loan_size_band
ORDER BY default_rate_percentage DESC;


-- High risk customer identification
SELECT 
    customers.customer_id,
    customers.first_name,
    customers.last_name,
    customers.annual_income,
    loans.loan_amount,
    loans.status
FROM loans
JOIN customers
ON loans.customer_id = customers.customer_id
WHERE loans.status = 'Defaulted'
ORDER BY loans.loan_amount DESC;


-- Repayment behaviour analysis

-- Customer transaction strength
SELECT
    customers.customer_id,
    COUNT(transactions.transaction_id) AS transaction_count,
    SUM(transactions.amount) AS total_transaction_amount,
    ROUND(AVG(transactions.amount), 2) AS avg_transaction_amount
FROM customers
JOIN accounts
    ON customers.customer_id = accounts.customer_id
JOIN transactions
    ON accounts.account_id = transactions.account_id
GROUP BY customers.customer_id;


-- Repayment behaviour vs loan exposure
SELECT
    customers.customer_id,
    SUM(loans.loan_amount) AS total_loan_amount,
    COALESCE(SUM(transactions.amount), 0) AS total_transaction_amount,
    ROUND(
        COALESCE(SUM(transactions.amount), 0) / NULLIF(SUM(loans.loan_amount), 0),
        2
    ) AS transaction_to_loan_ratio
FROM customers
JOIN loans
    ON customers.customer_id = loans.customer_id
LEFT JOIN accounts
    ON customers.customer_id = accounts.customer_id
LEFT JOIN transactions
    ON accounts.account_id = transactions.account_id
GROUP BY customers.customer_id;


-- Early warning indicators
-- Customers with loans but weak activity
SELECT
    customers.customer_id,
    SUM(loans.loan_amount) AS total_loan_amount,
    COALESCE(SUM(transactions.amount), 0) AS total_transaction_amount,
    ROUND(
        COALESCE(SUM(transactions.amount), 0) / NULLIF(SUM(loans.loan_amount), 0),
        2
    ) AS transaction_to_loan_ratio
FROM customers
JOIN loans
    ON customers.customer_id = loans.customer_id
LEFT JOIN accounts
    ON customers.customer_id = accounts.customer_id
LEFT JOIN transactions
    ON accounts.account_id = transactions.account_id
GROUP BY customers.customer_id;


-- High exposure + Negative cash flow
SELECT
    customers.customer_id,
    SUM(loans.loan_amount) AS total_loan_amount,
    COALESCE(SUM(transactions.amount), 0) AS net_transaction_amount
FROM customers
JOIN loans
    ON customers.customer_id = loans.customer_id
LEFT JOIN accounts
    ON customers.customer_id = accounts.customer_id
LEFT JOIN transactions
    ON accounts.account_id = transactions.account_id
GROUP BY customers.customer_id
HAVING net_transaction_amount < 0;


-- Customer lifetime risk scoring
-- Risk profiles per customer
SELECT
    customers.customer_id,
    customers.annual_income,
    COUNT(DISTINCT loans.loan_id) AS total_loans,
    SUM(CASE WHEN loans.status = 'Defaulted' THEN 1 ELSE 0 END) AS defaulted_loans,
    SUM(loans.loan_amount) AS total_loan_exposure,
    COALESCE(SUM(transactions.amount), 0) AS lifetime_transaction_value
FROM customers
LEFT JOIN loans
    ON customers.customer_id = loans.customer_id
LEFT JOIN accounts
    ON customers.customer_id = accounts.customer_id
LEFT JOIN transactions
    ON accounts.account_id = transactions.account_id
GROUP BY customers.customer_id, customers.annual_income;

-- Lifetime risk categorisation
SELECT
    customers.customer_id,
    CASE
        WHEN SUM(CASE WHEN loans.status = 'Defaulted' THEN 1 ELSE 0 END) >= 2
            THEN 'High Risk'
        WHEN SUM(CASE WHEN loans.status = 'Defaulted' THEN 1 ELSE 0 END) = 1
            THEN 'Medium Risk'
        WHEN SUM(loans.loan_amount) > customers.annual_income * 2
            THEN 'Medium Risk'
        WHEN COALESCE(SUM(transactions.amount), 0) < SUM(loans.loan_amount) * 0.4
            THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS lifetime_risk_category
FROM customers
LEFT JOIN loans
    ON customers.customer_id = loans.customer_id
LEFT JOIN accounts
    ON customers.customer_id = accounts.customer_id
LEFT JOIN transactions
    ON accounts.account_id = transactions.account_id
GROUP BY customers.customer_id, customers.annual_income;



































