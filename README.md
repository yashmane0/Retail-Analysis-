<div align="center">
  <h1>Retail Data Analysis</h1>
</div>


<div align="center">
Retail Data Analysis is to understand customer behavior using their point of sales data.
  
</div>



<div align="center">
  <img src="https://static.vecteezy.com/system/resources/thumbnails/008/150/836/small_2x/women-with-shopping-cart-and-commercial-flat-illustration-vector.jpg" alt="ecommerce-01">
</div>




## Tools
-Data Visualisation: Power BI
- Database Management System: PostgreSQL
- SQL Editor: pgAdmin



## Dashboard (Power BI)
![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/Count%20Trans.png)


## Dataset Description: 

### Customers

**Variables:**
- Customer_ID (int): Unique identifier for each customer.
- DOB (date): Date of birth of the customer.
- Gender (varchar): Gender of the customer.
- City_Code (int): City code of the customer.

**Schema:**
- Number of variables: 4
- Number of records: 5647

**Purpose:**
This dataset is used to store customer demographics and information.

### Prod_cat_info

**Variables:**
- Prod_cat_code (int): Product category code.
- Prod_cat (varchar): Product category.
- Prod_subcat_code (int): Product subcategory code.
- Prod_subcat (varchar): Product subcategory.

**Schema:**
- Number of variables: 4
- Number of records: 23

**Purpose:**
This dataset is used for categorizing products based on their category and subcategory.

### Transactions

**Variables:**
- transaction_id (int): Unique identifier for each transaction.
- cust_id (int): Customer ID associated with the transaction.
- tran_date (date): Date of the transaction.
- prod_subcat_code (int): Product subcategory code.
- prod_cat_code (int): Product category code.
- Qty (int): Quantity of products purchased (Negative if it is a return order).
- Rate (decimal): Unit rate of the product (Negative if it is a return order).
- Tax (decimal): Tax amount for the transaction.
- total_amt (decimal): Total amount of the transaction (Negative if it is a return order).
- Store_type (varchar): Type of store where the transaction occurred.

**Schema:**
- Number of columns: 10
- Number of rows: 23053

**Purpose:**
This dataset is used for analyzing transactional data, including customer purchase behavior and store performance metrics.





# Data Preparation and Understanding: 
## Create tables with required column names, constraints & data types
**Query:**
```
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
```
**Methods used:**
- CREATE TABLE (DDL command) (used to create structure for new table)


## Import data from CSV to database
**Query:**
```
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
```

## 1. What is the total number of rows in each of the 3 tables in the database?

**Query:**
```
  SELECT COUNT(*) AS Total_no_of_records_in_Trans
  FROM [Transactions]

  SELECT COUNT(*) AS Total_no_of_records_in_Prod
  FROM [Prod_cat_info]

  SELECT COUNT(*) AS Total_no_of_records_in_Cust
  FROM [Customer]
```

**Methods used:**
- Functions - COUNT (aggregate) (used to count the number of rows)

**Schema:**
- Number of variables: 1
- Number of records: 3 (seperate)

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/Count%20Trans.png)
![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/Count%20Prod.png)
![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/Count%20Cust.png)


**Business Solution:**
- These queries are used to count the records in each table which can help to know data volume.



## 2. What is the total number of transactions that have a return?

**Query:**
```
  SELECT COUNT(*) AS return_transactions
  FROM [Transactions]
  WHERE total_amt < 0
```

**Methods used:**
- Functions - COUNT (aggregate) (used to count the number of rows)
- Filter - WHERE (used to filter rows based on a specified condition/s)

**Schema:**
- Number of variables: 1
- Number of records: 1 

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/What%20is%20the%20total%20number%20of%20transactions%20that%20have%20a%20return.png)

**Business Solution:**
- This query will display the number of returns which can help to improve product quality, inventory management and customer satisfaction.



## 3. What is the time range of the transaction data available for analysis? Show the output in number of days, months and years simultaneously in different columns.

**Query:**
```
  SELECT
  DATEDIFF(DAY, MIN(tran_date), MAX(tran_date)) AS Time_Range_in_Days,
  DATEDIFF(MONTH, MIN(tran_date), MAX(tran_date)) AS Time_Range_in_Months,
  DATEDIFF(YEAR, MIN(tran_date), MAX(tran_date)) AS Time_Range_in_Years
  FROM [Transactions]
```

**Methods used:**
- Functions - DATE_PART (used to get specific year, month or day from date)
- Functions - MIN (aggregate) (used to find the minimum values)
- Functions - MAX (aggregate) (used to find the maximum values)

**Schema:**
- Number of variables: 3
- Number of records: 1

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/What%20is%20the%20time%20range%20of%20the%20transaction%20data%20available%20for%20analysis%20Show%20the%20output%20in%20number%20of%20days%2C%20months%20and%20years%20simultaneously%20in%20different%20columns.png)

**Business Solution:**
- Here we have the timespan of data in number of days, months, years which can be used for data analysis and documentation purpose.



## 4. Which product category does the sub-category “DIY” belong to?

**Query:**
```
  SELECT prod_cat,prod_subcat
  FROM [Prod_cat_info]
  WHERE prod_subcat = 'DIY'
```

**Methods used:**
- Filter - WHERE (used to filter rows based on a specified condition/s)

**Schema:**
- Number of variables: 2
- Number of records: 1

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/Which%20product%20category%20does%20the%20sub-category%20%E2%80%9CDIY%E2%80%9D%20belong%20to.png)

**Business Solution:**
- The Books category has DIY subcategory. Queries like this can be used to find which subcategory belongs to which category.



# Data Analysis: 

## 1. Which channel is most frequently used for transactions?

**Query:**
```
  SELECT TOP 1 Store_type, COUNT(*) AS Most_Used_Channel 
  FROM [Transactions]
  GROUP BY Store_type
  ORDER BY most_used_channel DESC
```

**Methods used:**
- Functions - COUNT (aggregate) (used to count the number of rows)
- Grouping clause - GROUP BY (used to group rows that have the same values into summary rows)
- Sorting clause - ORDER BY (used to sort the result set of a query based on one or more columns)

**Schema:**
- Number of variables: 2
- Number of records: 1

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/Which%20channel%20is%20most%20frequently%20used%20for%20transactions.png)

**Business Solution:**
- e-Shop channel is most frequently used by customers for transactions. This can help in planning channel-specific strategies and analysis for enhancing customer experiences etc.



## 2. What is the count of Male and Female customers in the database?

**Query:**
```
  SELECT Gender, COUNT(*) AS Count_of_Gender
  FROM [Customers]
  WHERE Gender IS NOT NULL
  GROUP BY Gender
```

**Methods used:**
- Functions - COUNT (aggregate) (used to count the number of rows)
- Filter - WHERE (used to filter rows based on a specified condition/s)
- Grouping clause - GROUP BY (used to group rows that have the same values into summary rows)

**Schema:**
- Number of variables: 2
- Number of records: 2

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/What%20is%20the%20count%20of%20Male%20and%20Female%20customers%20in%20the%20database.png)

**Business Solution:**
- This data shows the number of male customer and female customers which can be used to plan gender specific strategies, identifying trends.



## 3. From which city do we have the maximum number of customers and how many?

**Query:**
```
  SELECT TOP 1 city_code, COUNT(customer_id) AS No_of_Customers
  FROM [Customers]
  GROUP BY city_code
  ORDER BY no_of_customers DESC
```

**Methods used:**
- Limiting clause - LIMIT (used to limit the number of rows returned by a query)
- Functions - COUNT (aggregate) (used to count the number of rows)
- Grouping clause - GROUP BY (used to group rows that have the same values into summary rows)
- Sorting clause - ORDER BY (used to sort the result set of a query based on one or more columns)

**Schema:**
- Number of variables: 2
- Number of records: 1

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/From%20which%20city%20do%20we%20have%20the%20maximum%20number%20of%20customers%20and%20how%20many.png)

**Business Solution:**
- This data shows the city with city_code 3 has maximum as in 595 customers which can help to plan market broadening in future.



## 4. How many sub-categories are there under the Books category?

**Query:**
```
  SELECT prod_cat, COUNT(prod_subcat) AS No_of_Subcategories
  FROM [Prod_cat_info]
  WHERE prod_cat = 'Books'
  GROUP BY prod_cat
```

**Methods used:**
- Functions - COUNT (aggregate) (used to count the number of rows)
- Filter - WHERE (used to filter rows based on a specified condition/s)
- Grouping clause - GROUP BY (used to group rows that have the same values into summary rows)

**Schema:**
- Number of variables: 2
- Number of records: 1

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/How%20many%20sub-categories%20are%20there%20under%20the%20Books%20category.png)

**Business Solution:**
- There are 6 subcategories under the Books category. Queries like this can be used to retrieve subcategory data.



## 5. What is the maximum quantity of products ever ordered?

**Query:**
```
  SELECT MAX(qty) AS Max_Quantity_Ordered
  FROM [Transactions]
```

**Methods used:**
- Functions - MAX (aggregate) (used to find the maximum value in a set of values)

**Schema:**
- Number of variables: 1
- Number of records: 1

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/What%20is%20the%20maximum%20quantity%20of%20products%20ever%20ordered.png)

**Business Solution:**
- 5 is the maximum quantity of products ever ordered. Queries like this can be used for to get data on products.



## 6. What is the net total revenue generated in categories Electronics and Books?

**Query:**
```
  SELECT prod_cat, SUM(total_amt) AS Net_Total_Revenue
  FROM [Transactions] trans
  INNER JOIN [Prod_cat_info] prod
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_sub_cat_code
  GROUP BY prod.prod_cat
  HAVING prod_cat IN ('Electronics', 'Books')
```

**Methods used:**
- Functions - SUM (aggregate) (used to calculate the sum of values in a column or expression)
- INNER JOIN (used to combine rows from two or more tables based on a related column between them)
- Grouping clause - GROUP BY (used to group rows that have the same values into summary rows)
- Filter - HAVING (used in combination with the GROUP BY clause to filter the rows in a result set based on aggregated values)

**Schema:**
- Number of variables: 2
- Number of records: 2

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/What%20is%20the%20net%20total%20revenue%20generated%20in%20categories%20Electronics%20and%20Books.png)

**Business Solution:**
- 10722463.635 is net total revenue generated in Electronics and 12822694.04 in Books which can used to get total revenue generated also considering the returns data. This can help to analysis category specific trends.



## 7. How many customers have >10 transactions with us, excluding returns?

**Query:**
```
  WITH Count_Customers AS 
  (
   SELECT cust_id, COUNT(transaction_id) AS No_of_transactions
   FROM [Transactions]
   WHERE total_amt > 0
   GROUP BY cust_id
   HAVING COUNT(transaction_id) > 10
  )
  SELECT COUNT(*) AS No_of_Customers FROM Count_Customers 
```

**Methods used:**
- Functions - COUNT (aggregate) (used to count the number of rows)
- Filter - WHERE (used to filter rows based on a specified condition/s)
- Grouping clause - GROUP BY (used to group rows that have the same values into summary rows)
- Filter - HAVING (used in combination with the GROUP BY clause to filter the rows in a result set based on aggregated values)
- CTE (temporary table that you can reference within a query)

**Schema:**
- Number of variables: 2
- Number of records: 6

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/How%20many%20customers%20have%20less%20than%2010%20transactions%20with%20us%2C%20excluding%20returns.png)



**Business Solution:**
- This data shows 6 customers who have more than 10 transactions excluding returns which can be helpful to understand customer preference,to improve customer satisfaction and introduce loyalty programs.



## 8. What is the combined revenue earned from the “Electronics” & “Clothing” categories, from “Flagship stores”?

**Query:**
```
  SELECT trans.Store_type, SUM(trans.total_amt) AS Combined_Revenue
  FROM [Transactions] trans
  INNER JOIN [Prod_cat_info] prod
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_sub_cat_code
  WHERE trans.total_amt > 0
  AND prod_cat IN ('Electronics', 'Clothing' )
  GROUP BY trans.Store_type
  HAVING trans.Store_type = 'Flagship store'
```

**Methods used:**
- Functions - SUM (aggregate) (used to calculate the sum of values in a column or expression)
- INNER JOIN (used to combine rows from two or more tables based on a related column between them)
- Filter - WHERE (used to filter rows based on a specified condition/s)
- Grouping clause - GROUP BY (used to group rows that have the same values into summary rows)
- Filter - HAVING (used in combination with the GROUP BY clause to filter the rows in a result set based on aggregated values)

**Schema:**
- Number of variables: 2
- Number of records: 1

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/What%20is%20the%20combined%20revenue%20earned%20from%20the%20%E2%80%9CElectronics%E2%80%9D%20%26%20%E2%80%9CClothing%E2%80%9D%20categories%2C%20from%20%E2%80%9CFlagship%20stores.png)

**Business Solution:**
- 3851454.295 is the combined revenue earned from Electronics and Category from Flagship stores. This can be used to understand Flagship stores performance.



## 9. What is the total revenue generated from “Male” customers in “Electronics” category? Output should display total revenue by prod sub-cat.

**Query:**
```
  SELECT prod.prod_cat, prod.prod_subcat, SUM(trans.total_amt) AS Total_Revenue
  FROM [Transactions] trans
  INNER JOIN [Prod_cat_info] prod
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_sub_cat_code
  INNER JOIN [Customers] cust
  ON trans.cust_id = cust.customer_Id
  WHERE trans.total_amt > 0 and cust.Gender = 'M'
  GROUP BY prod.prod_cat, prod.prod_subcat
  HAVING prod.prod_cat = 'Electronics'  
```

**Methods used:**
- Functions - SUM (aggregate) (used to calculate the sum of values in a column or expression)
- INNER JOIN (used to combine rows from two or more tables based on a related column between them)
- Filter - WHERE (used to filter rows based on a specified condition/s)
- Grouping clause - GROUP BY (used to group rows that have the same values into summary rows)
- Filter - HAVING (used in combination with the GROUP BY clause to filter the rows in a result set based on aggregated values)

**Schema:**
- Number of variables: 3
- Number of records: 5

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/What%20is%20the%20total%20revenue%20generated%20from%20%E2%80%9CMale%E2%80%9D%20customers%20in%20%E2%80%9CElectronics%E2%80%9D%20category%20Output%20should%20display%20total%20revenue%20by%20prod%20sub-cat.png)

**Business Solution:**
- This data displays male customer purchases in Electronics which will help to understand gender specific customer satisfaction and to get category specific data analysis.



## 10. What is percentage of sales and returns by product sub category; display only top 5 sub categories in terms of sales?

**Query:**
```
  --Top 5 sub-categories in terms of sales
  SELECT TOP 5 prod.prod_subcat, SUM(trans.total_amt) AS Sales_Amount
  FROM [Transactions] trans
  INNER JOIN [Prod_cat_info] prod
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_sub_cat_code
  WHERE trans.total_amt > 0
  GROUP BY prod.prod_subcat
  ORDER BY Sales_Amount;

  --Percentage sales and returns
  WITH Sales_Returns AS
  (
  SELECT TOP 5 prod.prod_subcat,
  SUM(CASE WHEN trans.Qty > 0 THEN trans.Qty ELSE 0 END) AS Sales_value,
  ABS(SUM(CASE WHEN trans.Qty < 0 THEN trans.Qty ELSE 0 END)) AS Returns_value
  FROM [Transactions] trans
  INNER JOIN [Prod_cat_info] prod
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_sub_cat_code
  GROUP BY prod.prod_subcat
  ORDER BY Sales_value DESC
  )
  SELECT prod_subcat, ROUND(((Returns_value / (Returns_value + Sales_value))*100), 2) AS Returns_Percentage,
  ROUND(((Sales_value / (Returns_value + Sales_value))*100), 2) AS Sales_Percentage
  FROM Sales_Returns
```

**Methods used:**
- Limiting clause - TOP (used to limit the number of rows returned by a query)
- Functions - SUM (aggregate) (used to calculate the sum of values in a column or expression)
- INNER JOIN (used to combine rows from two or more tables based on a related column between them)
- Filter - WHERE (used to filter rows based on a specified condition/s)
- Grouping clause - GROUP BY (used to group rows that have the same values into summary rows)
- Sorting clause - ORDER BY (used to sort the result set of a query based on one or more columns)
- CASE (used to evaluate conditions and return different values based on those conditions)
- Functions - ABS (scalar) (used to returns the absolute value of a numeric expression/ removes any negative sign from a negative number)
- Functions - ROUND (scalar) (used to round a numeric value to a specified number of decimal places)
- CTE (temporary table that you can reference within a query)

**Schema:**
- Number of variables: 2, 3
- Number of records: 5, 5

**Result:**
![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/What%20is%20percentage%20of%20sales%20and%20returns%20by%20product%20sub%20category%3B%20display%20only%20top%205%20sub%20categories%20in%20terms%20of%20sales.png)

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/What%20is%20percentage%20of%20sales%20and%20returns%20by%20product%20sub%20category%3B%20display%20only%20top%205%20sub%20categories%20in%20terms%20of%20sales1.png)

**Business Solution:**
- The data provides information on sales and returns percentages within the top product categories. This help in improving overall profitability and customer satisfaction.



## 11. For all customers aged between 25 to 35 years find what is the net total revenue generated by these consumers in last 30 days of transactions from max transaction date available in the data?

**Query:**
```
  --Top 30 transaction dates
  SELECT TOP 30 tran_date 
  FROM [Transactions]
  GROUP BY tran_date
  ORDER BY tran_date DESC;

  --Revenue in those 30 days
  WITH Age_Revenue AS
  (
  SELECT TOP 30 trans.tran_date, SUM(trans.total_amt) AS Total_amount 
  FROM [Customers] cust
  INNER JOIN [Transactions] trans
  ON trans.cust_id = cust.customer_id
  WHERE DATEDIFF(YEAR, cust.DOB, GETDATE()) BETWEEN 25 AND 35
  GROUP BY trans.tran_date
  ORDER BY trans.tran_date DESC
  )
  SELECT SUM(Total_amount) AS Net_Total_Revenue FROM Age_Revenue
```

**Methods used:**
- Limiting clause - LIMIT (used to limit the number of rows returned by a query)
- Grouping clause - GROUP BY (used to group rows that have the same values into summary rows)
- Sorting clause - ORDER BY (used to sort the result set of a query based on one or more columns)
- Functions - SUM (aggregate) (used to calculate the sum of values in a column or expression)
- INNER JOIN (used to combine rows from two or more tables based on a related column between them)
- Filter - WHERE (used to filter rows based on a specified condition/s)
- Functions - DATE_PART_ (used to calculate the difference between two dates)
- CTE (temporary table that you can reference within a query)

**Schema:**
- Number of variables: 1, 1
- Number of records: 30, 1

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/For%20all%20customers%20aged%20between%2025%20to%2035%20years%20find%20what%20is%20the%20net%20total%20revenue%20generated%20by%20these%20consumers%20in%20last%2030%20days%20of%20transactions%20from%20max%20transaction%20date%20available%20in%20the%20data.png)
![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/For%20all%20customers%20aged%20between%2025%20to%2035%20years%20find%20what%20is%20the%20net%20total%20revenue%20generated%20by%20these%20consumers%20in%20last%2030%20days%20of%20transactions%20from%20max%20transaction%20date%20available%20in%20the%20data1.png)


**Business Solution:**
- The data gives revenue in last 30 days for customers aged 25-35. This can help in understanding purchasing behavior of the specific age group within the specified timeframe which can be used to improve customer enagagement.



## 12. Which product category that have highest value of returns in the last 12 months of transactions?

**Query:**
```
  SELECT prod.prod_cat, COUNT(trans.Qty) AS No_ of_returns, ABS(SUM(trans.total_amt)) AS Return_Amount
  FROM [Transactions] trans
  INNER JOIN [prod_cat_info] prod 
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_sub_cat_code
  WHERE trans.total_amt < 0 
  AND DATEDIFF(month, '2014-09-01',trans.tran_date)=3
  GROUP BY prod.prod_cat
```

**Methods used:**
- Functions - COUNT (aggregate) (used to count the number of rows)
- Functions - ABS (scalar) (used to returns the absolute value of a numeric expression/ removes any negative sign from a negative number)
- Functions - SUM (aggregate) (used to calculate the sum of values in a column or expression)
- INNER JOIN (used to combine rows from two or more tables based on a related column between them)
- Filter - WHERE (used to filter rows based on a specified condition/s)
- Functions - DATE_PART (used to calculate the difference between two dates)
- Grouping clause - GROUP BY (used to group rows that have the same values into summary rows)

**Schema:**
- Number of variables: 3
- Number of records: 1

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/Which%20product%20category%20has%20seen%20the%20max%20value%20of%20returns%20in%20the%20last%2012%20months%20of%20transactions.png)

**Business Solution:**
- Category Home and Kitchen has the maximum (1) returns in last 3 months. Queries like this can be used to improve product quality, customer satisfaction and customer interaction.



## 13. Which store-type sells the maximum products; by value of sales amount and by quantity sold?

**Query:**
```
  SELECT TOP 1 Store_type, SUM(total_amt) AS Sales_Amount, COUNT(Qty) AS Number_of_Products
  FROM [Transactions]
  WHERE total_amt > 0 
  GROUP BY Store_type
  ORDER BY Sales_Amount DESC, Number_of_Products DESC
```

**Methods used:**
- Functions - SUM (aggregate) (used to calculate the sum of values in a column or expression)
- Functions - COUNT (aggregate) (used to count the number of rows)
- Filter - WHERE (used to filter rows based on a specified condition/s)
- Grouping clause - GROUP BY (used to group rows that have the same values into summary rows)
- Sorting clause - ORDER BY (used to sort the result set of a query based on one or more columns)

**Schema:**
- Number of variables: 3
- Number of records: 1

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/Which%20store-type%20sells%20the%20maximum%20products%3B%20by%20value%20of%20sales%20amount%20and%20by%20quantity%20sold.png)

**Business Solution:**
- e-Shop store sells maximum products both by quantity and sales amount. Queries like this can help with Inventory management, planning future strategies for sales etc.



## 14. What are the categories for which average revenue is above the overall average.

**Query:**
```
  SELECT prod.prod_cat, AVG(trans.total_amt) AS Categorial_Average_Revenue
  FROM [Transactions] trans
  INNER JOIN [Prod_cat_info] prod
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_sub_cat_code
  WHERE trans.total_amt > 0 
  GROUP BY prod.prod_cat
  HAVING  AVG(trans.total_amt)  > (SELECT AVG(total_amt) AS Overall_Average_Revenue FROM [Transactions] WHERE total_amt > 0)
```

**Methods used:**
- Functions - AVG (aggregate) (used to calculate the average value of a set of values within a column)
- INNER JOIN (used to combine rows from two or more tables based on a related column between them)
- Filter - WHERE (used to filter rows based on a specified condition/s)
- Grouping clause - GROUP BY (used to group rows that have the same values into summary rows)
- Filter - HAVING (used in combination with the GROUP BY clause to filter the rows in a result set based on aggregated values)
- Nested query - SUBQUERY (used to retrieve data that will be used as a condition or criteria within the main query)

**Schema:**
- Number of variables: 2
- Number of records: 4

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/What%20are%20the%20categories%20for%20which%20average%20revenue%20is%20above%20the%20overall%20average.png)

**Business Solution:**
- Categories Bags, Books, Clothing, Electronics whose average revenue (sales excluding returns) exceeds the overall average. This data can be used to plan strategies for high-performing categories which can maximize profit.



## 15. Find the average and total revenue by each subcategory for the categories which are among top 5 categories in terms of quantity sold.

**Query:**
```
  SELECT TOP 5 prod.prod_cat, COUNT(trans.Qty) AS Quantity_Sold 
  FROM [Transactions] trans
  INNER JOIN [prod_cat_info] prod 
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_sub_cat_code
  WHERE trans.total_amt > 0
  GROUP BY prod.prod_cat
  ORDER BY Quantity_Sold DESC

  SELECT prod.prod_cat, prod.prod_subcat, ROUND(SUM(trans.total_amt), 3) AS Total_Revenue, ROUND(AVG(trans.total_amt), 3) AS Average_Revenue  
  FROM [Transactions] trans
  INNER JOIN [prod_cat_info] prod 
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_sub_cat_code
  WHERE trans.total_amt > 0 AND prod.prod_cat IN ('Books', 'Electronics', 'Home and kitchen', 'Footwear', 'Clothing')
  GROUP BY prod_cat, prod_subcat
  ORDER BY CASE WHEN prod_cat = 'Books' THEN 1
                WHEN prod_cat = 'Electronics' THEN 2
                WHEN prod_cat = 'Home and kitchen' THEN 3
                WHEN prod_cat = 'Footwear' THEN 4
                ELSE 5
                END
```

**Methods used:**
- Functions - COUNT (aggregate) (used to count the number of rows)
- INNER JOIN (used to combine rows from two or more tables based on a related column between them)
- Filter - WHERE (used to filter rows based on a specified condition/s)
- Grouping clause - GROUP BY (used to group rows that have the same values into summary rows)
- Sorting clause - ORDER BY (used to sort the result set of a query based on one or more columns)
- Functions - ROUND (scalar) (used to round a numeric value to a specified number of decimal places)
- Functions - SUM (aggregate) (used to calculate the sum of values in a column or expression)
- Functions - AVG (aggregate) (used to calculate the average value of a set of values within a column)
- CASE (used to evaluate conditions and return different values based on those conditions)

**Schema:**
- Number of variables: 2, 4
- Number of records: 5, 21

**Result:**

![image](https://github.com/yashmane0/Retail-Analysis-/blob/master/outputs/Find%20the%20average%20and%20total%20revenue%20by%20each%20subcategory%20for%20the%20categories%20which%20are%20among%20top%205%20categories%20in%20terms%20of%20quantity%20sold.png)

**Business Solution:**
- This analysis can be used to compare dynamics in revenue across subcategories within the most popular product categories, which can be helpful to plan strategies and broaden the sectors.
