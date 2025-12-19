--- Project: SQL Banking Analytics
--- Purpose: Database and table setup
--- Author: Belyne Lissa Bochere

CREATE DATABASE banking_analytics;
USE banking_analytics;

SHOW TABLES;

CREATE TABLE customers(
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender VARCHAR(10),
    region VARCHAR(50),
    account_open_date DATE
);

CREATE TABLE accounts(
    account_id INT PRIMARY KEY,
    customer_id INT,
    account_type VARCHAR(30),
    balance DECIMAL(15,2),
    open_date DATE,
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE transactions(
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_type VARCHAR(30),
    amount DECIMAL(15,2),
    transaction_date DATE,
    FOREIGN KEY(account_id) REFERENCES accounts(account_id)
);

CREATE TABLE loans(
    loan_id INT PRIMARY KEY,
    customer_id INT,
    loan_amount DECIMAL(15,2),
    interest_rate DECIMAL(5,2),
    loan_start_date DATE,
    loan_end_date DATE,
    status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
);

SHOW TABLES;

USE banking_analytics;
ALTER TABLE customers
ADD COLUMN annual_income DECIMAL(15,2) AFTER account_open_date;

DESCRIBE customers;
