# 📊 Banking Analytics: Customer Value & Credit Risk Analysis (SQL)

## Project Overview
This project simulates a **real-world retail banking analytics workflow** using SQL.  
It focuses on **customer segmentation, transaction behavior, loan portfolio analysis, and credit risk insights** to demonstrate how SQL is used in professional financial analytics environments.

The objective is to move beyond basic queries and showcase **business-driven SQL analysis** aligned with banking decision-making.

---

## Data Model
The project is built on four relational tables:

### 1. customers
Customer demographic and financial profile.
- customer_id  
- first_name  
- last_name  
- date_of_birth  
- gender  
- region  
- account_open_date  
- annual_income  

### 2. accounts
Customer banking products and balances.
- account_id  
- customer_id  
- account_type  
- balance  
- open_date  

### 3. transactions
Customer transaction activity across channels.
- transaction_id  
- account_id  
- transaction_date  
- amount  
- channel (mobile, branch, atm, online)  

### 4. loans
Customer loan exposure and repayment status.
- loan_id  
- customer_id  
- loan_amount  
- interest_rate  
- start_date  
- end_date  
- status (Active, Closed, Defaulted)  

All tables are linked using **customer_id** (and account_id where applicable).

---

## Business Questions Addressed

### 1️⃣ Customer Segmentation & Value Analysis
- How many customers does the bank have?
- Where are customers geographically concentrated?
- How are customers distributed across income segments?
- Who are the **top 10% high-value customers** by total account balance?

### 2️⃣ Customer Behavior Analysis
- Which transaction channels are most used?
- How does transaction value vary by income segment?
- Which customer segments drive higher transaction volumes?

### 3️⃣ Loan Portfolio & Credit Risk Analysis
- How is loan exposure distributed across income segments?
- What is the breakdown of loan status (active vs defaulted)?
- Which customer segments show higher credit risk signals?

---

## SQL Techniques Demonstrated
- Relational schema design  
- Data loading and staging  
- Multi-table joins  
- Common Table Expressions (CTEs)  
- Window functions (`NTILE`, `OVER`)  
- Aggregations and segmentation logic  
- Business-focused analytical querying  

---

## Tools & Technologies
- MySQL 8.0  
- SQL  
- VS Code  
- Git & GitHub  

---

## Outcome
This project demonstrates how SQL can be used to transform raw banking data into **actionable insights** for:
- Customer value optimization  
- Transaction behavior analysis  
- Credit risk and loan portfolio monitoring  

It reflects **practical analytics workflows** used in banking, fintech, and financial services environments.

---

If you want, next we will:
- Refine **loan default risk metrics**
- Build **customer lifetime risk scoring**
- Prepare **portfolio KPIs** suitable for dashboards
