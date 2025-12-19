--- Staging and Data loading script
USE banking_analytics;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers_1000.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(customer_id, first_name, last_name, date_of_birth, gender, region, account_open_date);

USE banking_analytics;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/accounts_1000.csv'
INTO TABLE accounts
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(account_id, customer_id, account_type, balance, open_date);

USE banking_analytics;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions_10000.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(transaction_id, account_id, transaction_type, amount, transaction_date, channel);

USE banking_analytics;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/loans_1000.csv'
INTO TABLE loans 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(loan_id, customer_id, loan_amount, interest_rate, loan_start_date, loan_end_date, status);

SELECT * FROM customers;
SELECT * FROM accounts;
SELECT * FROM transactions;
SELECT * FROM loans;

--- Add data to annual_income column on customers table

USE banking_analytics;
CREATE TABLE customers_income_staging(
    customer_id INT,
    annual_income INT
);

USE banking_analytics;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers_annual_income.csv'
INTO TABLE customers_income_staging
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(customer_id, annual_income);

USE banking_analytics;
UPDATE customers 
JOIN customers_income_staging 
ON customers.customer_id = customers_income_staging.customer_id
SET customers.annual_income = customers_income_staging.annual_income;

SELECT * FROM customers;