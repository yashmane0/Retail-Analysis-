----------------------------------------------------------E-Commerce Retail Data Analysis Case Study------------------------------------------------------------------------------------------------------------------------------------
  
  USE Project_1

  SELECT * FROM [Customers]
  SELECT * FROM [Prod_cat_info]
  SELECT * FROM [Transactions]
  
-------------------------------------------------------------DATA PREPARATION AND UNDERSTANDING------------------------------------------------------------------------------------------------------------------------------
  
  --1: What is the total number of rows in each of the 3 tables in the database?
  SELECT COUNT(*) AS Total_no_of_records_in_Trans
  FROM [Transactions]

  SELECT COUNT(*) AS Total_no_of_records_in_Prod
  FROM [Prod_cat_info]

  SELECT COUNT(*) AS Total_no_of_records_in_Cust
  FROM [Customers]


  --2: What is the total number of transactions that have a return?
  SELECT COUNT(*) AS Return_Transactions
  FROM [Transactions]
  WHERE total_amt < 0


  --3: What is the time range of the transaction data available for analysis? Show the output in number of days, months and years simultaneously in different columns.
  SELECT
  DATEDIFF(DAY, MIN(tran_date), MAX(tran_date)) AS Time_Range_in_Days,
  DATEDIFF(MONTH, MIN(tran_date), MAX(tran_date)) AS Time_Range_in_Months,
  DATEDIFF(YEAR, MIN(tran_date), MAX(tran_date)) AS Time_Range_in_Years
  FROM [Transactions]


  --4: Which product category does the sub-category “DIY” belong to?
  SELECT prod_cat,prod_subcat
  FROM [Prod_cat_info]
  WHERE prod_subcat = 'DIY'

---------------------------------------------------------------DATA ANALYSIS--------------------------------------------------------------------------------------------------------------------------------------------------

  --1: Which channel is most frequently used for transactions?
  SELECT TOP 1 Store_type, COUNT(*) AS Most_Used_Channel 
  FROM [Transactions]
  GROUP BY Store_type
  ORDER BY most_used_channel DESC


  --2: What is the count of Male and Female customers in the database?
  SELECT Gender, COUNT(*) AS Count_of_Gender
  FROM [Customers]
  WHERE Gender IS NOT NULL
  GROUP BY Gender


  --3: From which city do we have the maximum number of customers and how many?
  SELECT TOP 1 city_code, COUNT(customer_id) AS No_of_Customers
  FROM [Customers]
  GROUP BY city_code
  ORDER BY no_of_customers DESC


  --4: How many sub-categories are there under the Books category?
  SELECT prod_cat, COUNT(prod_subcat) AS No_of_Subcategories
  FROM [Prod_cat_info]
  WHERE prod_cat = 'Books'
  GROUP BY prod_cat


  --5: What is the maximum quantity of products ever ordered?
  SELECT MAX(qty) AS Max_Quantity_Ordered
  FROM [Transactions]


  --6: What is the net total revenue generated in categories Electronics and Books?
  SELECT prod_cat, SUM(total_amt) AS Net_Total_Revenue
  FROM [Transactions] trans
  INNER JOIN [Prod_cat_info] prod
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_sub_cat_code
  GROUP BY prod.prod_cat
  HAVING prod_cat IN ('Electronics', 'Books')


  --7: How many customers have >10 transactions with us, excluding returns?
  SELECT cust_id, COUNT(transaction_id) AS No_of_transactions
  FROM [Transactions]
  WHERE total_amt > 0
  GROUP BY cust_id
  HAVING COUNT(transaction_id) > 10


  --8: What is the combined revenue earned from the “Electronics” & “Clothing” categories, from “Flagship stores”?
  SELECT trans.Store_type, SUM(trans.total_amt) AS Combined_Revenue
  FROM [Transactions] trans
  INNER JOIN [Prod_cat_info] prod
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_sub_cat_code
  WHERE trans.total_amt > 0
  AND prod_cat IN ('Electronics', 'Clothing' )
  GROUP BY trans.Store_type
  HAVING trans.Store_type = 'Flagship store'


  --9: What is the total revenue generated from “Male” customers in “Electronics” category? Output should display total revenue by prod sub-cat.
  SELECT prod.prod_cat, prod.prod_subcat, SUM(trans.total_amt) AS Total_Revenue
  FROM [Transactions] trans
  INNER JOIN [Prod_cat_info] prod
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_sub_cat_code
  INNER JOIN [Customers] cust
  ON trans.cust_id = cust.customer_Id
  WHERE trans.total_amt > 0 and cust.Gender = 'M'
  GROUP BY prod.prod_cat, prod.prod_subcat
  HAVING prod.prod_cat = 'Electronics'   


  --10: What is percentage of sales and returns by product sub category; display only top 5 sub categories in terms of sales?
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

  --11: For all customers aged between 25 to 35 years find what is the net total revenue generated by these consumers in last 30 days of transactions from max transaction date available in the data?
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


  --12: Which product category has seen the max value of returns in the last 3 months of transactions?
  SELECT prod.prod_cat, COUNT(trans.Qty) AS No_of_returns, ABS(SUM(trans.total_amt)) AS Return_Amount
  FROM [Transactions] trans
  INNER JOIN [prod_cat_info] prod 
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_sub_cat_code
  WHERE trans.total_amt < 0 
  AND DATEDIFF(month, '2014-09-01',trans.tran_date)=3
  GROUP BY prod.prod_cat


  --13: Which store-type sells the maximum products; by value of sales amount and by quantity sold?
  SELECT TOP 1 Store_type, SUM(total_amt) AS Sales_Amount, COUNT(Qty) AS Number_of_Products
  FROM [Transactions]
  WHERE total_amt > 0 
  GROUP BY Store_type
  ORDER BY Sales_Amount DESC, Number_of_Products DESC


  --14: What are the categories for which average revenue is above the overall average.
  SELECT prod.prod_cat, AVG(trans.total_amt) AS Categorial_Average_Revenue
  FROM [Transactions] trans
  INNER JOIN [Prod_cat_info] prod
  ON trans.prod_cat_code = prod.prod_cat_code AND trans.prod_subcat_code = prod.prod_sub_cat_code
  WHERE trans.total_amt > 0 
  GROUP BY prod.prod_cat
  HAVING  AVG(trans.total_amt)  > (SELECT AVG(total_amt) AS Overall_Average_Revenue FROM [Transactions] WHERE total_amt > 0)


  --15: Find the average and total revenue by each subcategory for the categories which are among top 5 categories in terms of quantity sold.
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