USE banking_project;

CREATE TABLE customers (
customer_id INT PRIMARY KEY,
first_name varchar(50), 
last_name varchar(50),
date_of_birth DATE,
gender varchar(50),
region varchar(50),
account_open_date DATE);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers_1000.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(customer_id, first_name, last_name, date_of_birth, gender, region, account_open_date);

SELECT * FROM customers;


CREATE TABLE accounts (
account_id INT PRIMARY KEY,
customer_id INT,
account_type varchar(50),
balance DECIMAL(12,2),
open_date DATE,
CONSTRAINT fk_accounts_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
ON DELETE CASCADE
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/accounts_1000.csv'
INTO TABLE accounts
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(account_id, customer_id, account_type, balance, open_date);

SELECT * FROM accounts;



