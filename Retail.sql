CREATE TABLE transactions (
transaction_id int PRIMARY KEY,
cust_id int,
tran_date DATE,
prod_subcat_code int,
prod_cat_code int,
qty int,
Rate int,
tax float,
total_amt float,
Store_type varchar
)

CREATE TABLE prod_cat_info(
prod_cat_code int ,
prod_cat varchar,
prod_subcat_code int ,
prod_subcat varchar

)
CREATE TABLE customers(
customer_id int PRIMARY KEY,
dob date,
gender varchar,
city_code int
)

ALTER TABLE transactions
ADD CONSTRAINT fk_customers
FOREIGN KEY (cust_id)
REFERENCES customers(customer_id);

SELECT * FROM Transactions

COPY customers
FROM 'D:/Project_RetailDataAnalysis/Datasets/customers.csv'
DELIMITER ','
CSV HEADER

COPY Transactions
FROM 'D:/Project_RetailDataAnalysis/Datasets/Transactions.csv'
DELIMITER ',' 
CSV HEADER;

COPY prod_cat_info
FROM 'D:/Project_RetailDataAnalysis/Datasets/prod_cat_info.csv'
DELIMITER ',' 
CSV HEADER;


ALTER TABLE transactions
ALTER COLUMN transaction_id TYPE BIGINT

ALTER TABLE transactions
DROP CONSTRAINT transactions_pkey

SELECT * FROM Customers
SELECT * FROM Prod_cat_info
SELECT * FROM Transactions

-- What is the total number of rows in each of the 3 tables in the database?
SELECT COUNT(*) AS Total_no_of_records_in_Transactions
FROM Transactions
SELECT COUNT(*) AS Total_no_of_records_in_Prod
FROM Prod_cat_info
SELECT COUNT(*) AS Total_no_of_records_in_Cust
FROM Customers

-- What is the total number of transactions that have a return?
SELECT COUNT(*) AS Return_Transactions
FROM Transactions
WHERE total_amt < 0

--What is the time range of the transaction data available for analysis? 
--Show the output in number of days, months and years simultaneously in different columns.
SELECT
    DATE_PART('year', MAX(tran_date)) - DATE_PART('year', MIN(tran_date)) AS time_range_in_years,
    (DATE_PART('year', MAX(tran_date)) - DATE_PART('year', MIN(tran_date))) * 12 +
    (DATE_PART('month', MAX(tran_date)) - DATE_PART('month', MIN(tran_date))) AS time_range_in_months,
    (MAX(tran_date) - MIN(tran_date))::int AS time_range_in_days
FROM transactions;

--Which product category does the sub-category “DIY” belong to?
  SELECT prod_cat,prod_subcat
  FROM Prod_cat_info
  WHERE prod_subcat = 'DIY'

--Which channel is most frequently used for transactions?
SELECT Store_type, COUNT(*) AS most_used_channel
FROM Transactions
GROUP BY Store_type
ORDER BY most_used_channel DESC
LIMIT 1;


--What is the count of Male and Female customers in the database?
  SELECT Gender, COUNT(*) AS Count_of_Gender
  FROM Customers
  WHERE Gender IS NOT NULL
  GROUP BY Gender

--From which city do we have the maximum number of customers and how many?
  SELECT city_code, COUNT(customer_id) AS No_of_Customers
  FROM Customers
  GROUP BY city_code
  ORDER BY no_of_customers DESC
  LIMIT 1

--How many sub-categories are there under the Books category?
  SELECT prod_cat, COUNT(prod_subcat) AS No_of_Subcategories
  FROM Prod_cat_info
  WHERE prod_cat = 'Books'
  GROUP BY prod_cat

--What is the maximum quantity of products ever ordered?
  SELECT MAX(qty) AS Max_Quantity_Ordered
  FROM Transactions

--What is the net total revenue generated in categories Electronics and Books?
  SELECT prod_cat, SUM(total_amt) AS Net_Total_Revenue
  FROM Transactions AS trans
  INNER JOIN Prod_cat_info AS prod
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_subcat_code
  GROUP BY prod.prod_cat
  HAVING prod_cat IN ('Electronics', 'Books')

--SELECT prod_cat, SUM(total_amt) AS Net_Total_Revenue
  FROM [Transactions] trans
  INNER JOIN [Prod_cat_info] prod
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_sub_cat_code
  GROUP BY prod.prod_cat
  HAVING prod_cat IN ('Electronics', 'Books')

--How many customers have >10 transactions with us, excluding returns?
  WITH Count_Customers AS 
  (
   SELECT cust_id, COUNT(transaction_id) AS No_of_transactions
   FROM Transactions
   WHERE total_amt > 0
   GROUP BY cust_id
   HAVING COUNT(transaction_id) > 10
  )
  SELECT COUNT(*) AS No_of_Customers FROM Count_Customers 

--What is the combined revenue earned from the “Electronics” & “Clothing” categories, from “Flagship stores”?
  SELECT trans.Store_type, SUM(trans.total_amt) AS Combined_Revenue
  FROM Transactions AS trans
  INNER JOIN Prod_cat_info AS prod
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_subcat_code
  WHERE trans.total_amt > 0
  AND prod_cat IN ('Electronics', 'Clothing' )
  GROUP BY trans.Store_type
  HAVING trans.Store_type = 'Flagship store' 

-- What is the total revenue generated from “Male” customers in “Electronics” category? 
--Output should display total revenue by prod sub-cat.
  SELECT prod.prod_cat, prod.prod_subcat, SUM(trans.total_amt) AS Total_Revenue
  FROM Transactions AS trans
  INNER JOIN Prod_cat_info AS prod
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_subcat_code
  INNER JOIN Customers AS cust
  ON trans.cust_id = cust.customer_Id
  WHERE trans.total_amt > 0 and cust.Gender = 'M'
  GROUP BY prod.prod_cat, prod.prod_subcat
  HAVING prod.prod_cat = 'Electronics'  

--What is percentage of sales and returns by product sub category; display only top 5 sub categories in terms of sales?
--Top 5 sub-categories in terms of sales
  SELECT  prod.prod_subcat, SUM(trans.total_amt) AS Sales_Amount
  FROM Transactions AS trans
  INNER JOIN Prod_cat_info AS prod
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_subcat_code
  WHERE trans.total_amt > 0
  GROUP BY prod.prod_subcat
  ORDER BY Sales_Amount
  LIMIT 5;

--Percentage sales and returns
 WITH Sales_Returns AS (
  SELECT  
    prod.prod_subcat,
    SUM(CASE WHEN trans.Qty > 0 THEN trans.Qty ELSE 0 END) AS Total_Sales,
    ABS(SUM(CASE WHEN trans.Qty < 0 THEN trans.Qty ELSE 0 END)) AS Returns_value
  FROM Transactions AS trans
  INNER JOIN Prod_cat_info AS prod
    ON trans.prod_cat_code = prod.prod_cat_code 
   AND trans.prod_subcat_code = prod.prod_subcat_code
  GROUP BY prod.prod_subcat
),
Top5 AS (
  SELECT *
  FROM Sales_Returns
  ORDER BY Total_Sales DESC
  LIMIT 5
)
SELECT 
  prod_subcat, 
  ROUND((Returns_value * 100.0 / (Returns_value + Total_Sales)), 2) AS Returns_Percentage,
  ROUND((Total_Sales * 100.0 / (Returns_value + Total_Sales)), 2) AS Sales_Percentage
FROM Top5;
--For all customers aged between 25 to 35 years find what is the net total revenue generated by 
--these consumers in last 30 days of transactions from max transaction date available in the data?
WITH Top_30_Dates AS (
  SELECT tran_date
  FROM Transactions
  GROUP BY tran_date
  ORDER BY tran_date DESC
  LIMIT 30
),

-- Step 2: Compute total revenue for customers aged 25–35 on those 30 dates
Age_Revenue AS (
  SELECT trans.tran_date, SUM(trans.total_amt) AS Total_amount
  FROM Customers AS cust
  JOIN Transactions AS trans ON trans.cust_id = cust.customer_id
  WHERE DATE_PART('year', AGE(current_date, cust.DOB)) BETWEEN 25 AND 35
    AND trans.tran_date IN (SELECT tran_date FROM Top_30_Dates)
  GROUP BY trans.tran_date
)

-- Step 3: Sum it up
SELECT SUM(Total_amount) AS Net_Total_Revenue
FROM Age_Revenue;
--product categories that have highest value of returns in the last 12 months of transactions?
SELECT 
  prod.prod_cat, 
  COUNT(trans.Qty) AS No_of_returns, 
  ABS(SUM(trans.total_amt)) AS Return_Amount
FROM Transactions AS trans
INNER JOIN prod_cat_info AS prod 
  ON trans.prod_cat_code = prod.prod_cat_code 
     AND trans.prod_subcat_code = prod.prod_subcat_code
WHERE trans.total_amt < 0
  AND trans.tran_date >= DATE '2014-01-01'
AND trans.tran_date < DATE '2015-01-01'
GROUP BY prod.prod_cat
ORDER BY COUNT(trans.Qty) DESC;
--Which store-type sells the maximum products; by value of sales amount and by quantity sold?
SELECT 
  Store_type, 
  SUM(total_amt) AS Sales_Amount, 
  COUNT(Qty) AS Number_of_Products
FROM Transactions
WHERE total_amt > 0 
GROUP BY Store_type
ORDER BY Sales_Amount DESC, Number_of_Products DESC
LIMIT 1;
-- What are the categories for which average revenue is above the overall average.
SELECT prod.prod_cat, AVG(trans.total_amt) AS Categorial_Average_Revenue
FROM Transactions AS trans
INNER JOIN Prod_cat_info AS prod
  ON trans.prod_cat_code = prod.prod_cat_code 
     AND trans.prod_subcat_code = prod.prod_subcat_code
WHERE trans.total_amt > 0
GROUP BY prod.prod_cat
HAVING AVG(trans.total_amt) > (
  SELECT AVG(total_amt) 
  FROM Transactions
  WHERE total_amt > 0
);

