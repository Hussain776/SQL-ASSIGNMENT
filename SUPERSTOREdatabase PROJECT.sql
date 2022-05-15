CREATE DATABASE SuperStore;
USE superstore;
SELECT * FROM cust_dimen;
SELECT * FROM market_fact;
SELECT * FROM orders_dimen;
SELECT * FROM prod_dimen;
SELECT * FROM shipping_dimen;

/*
                           UNDERSTANDING THE DATA 
								 TASK 1
1. Describe the data in hand in your own words.

This data comprises of 5 tables namely-

1) cust_dimen: This table gives the details of customers .
2) market_fact: This table  enlists the sales alongwith discount , order quantity , profit , shipping cost and base margin .
3) orders_dimen: This table shows the date at which orders were booked with their order priority.
4) prod_dimen: This table shows product's category and it's sub-category.
5) shipping_dimen: This table shows the shipping details .

2. Identify and list the Primary Keys and Foreign Keys for this dataset provided to 
you(In case you don’t find either primary or foreign key, then specially mention 
this in your answer)


cust_dimen: PRIMARY KEY- Cust_id
            FOREIGN KEY- N/A
market_fact: PRIMARY KEY- N/A
             FOREIGN KEY- Ord_id ,Prod_id ,Ship_id , Cust_id
orders_dimen: PRIMARY KEY- Ord_id
              FOREIGN KEY- N/A
prod_dimen: PRIMARY KEY- Prod_id
		    FOREIGN KEY- N/A
shipping_dimen: PRIMARY KEY- Ship_id
		        FOREIGN KEY- Order_ID
*/ 

/*                   
											TASK 2
*/

/*
1. Write a query to display the Customer_Name and Customer Segment using alias 
name “Customer Name", "Customer Segment" from table Cust_dimen. 
*/
SELECT Customer_Name AS "Customer Name",Customer_Segment AS  "Customer Segment" FROM cust_dimen;

/*
2. Write a query to find all the details of the customer from the table cust_dimen 
order by desc.
*/
SELECT * FROM cust_dimen  ORDER BY Cust_id DESC;

/*
3. Write a query to get the Order ID, Order date from table orders_dimen where 
‘Order Priority’ is high.
*/
SELECT Order_ID,Order_Date FROM orders_dimen WHERE Order_Priority='HIGH';

/*
4. Find the total and the average sales (display total_sales and avg_sales) 
*/
SELECT SUM(Sales) AS 'total_sales' , AVG(Sales) AS 'avg_sales' FROM market_fact;

/*
5. Write a query to get the maximum and minimum sales from maket_fact table.
*/
SELECT MAX(Sales) AS 'MAX SALES' , MIN(Sales) AS 'MIN SALES' FROM market_fact;

/*
6. Display the number of customers in each region in decreasing order of 
no_of_customers. The result should contain columns Region, no_of_customers.
*/
SELECT Region,COUNT(*) AS 'no_of_customers' FROM cust_dimen GROUP BY Region ORDER BY no_of_customers DESC;

/*
7. Find the region having maximum customers (display the region name and 
max(no_of_customers)
*/
SELECT Region,COUNT(*) AS 'no_of_customers' FROM cust_dimen GROUP BY Region ORDER BY no_of_customers DESC LIMIT 1 ;

/*
8. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ 
and the number of tables purchased (display the customer name, no_of_tables 
purchased) 
*/

SELECT customer_name, COUNT(*) AS no_of_tables_purchased FROM market_fact AS m
	INNER JOIN
    cust_dimen AS c ON m.cust_id = c.cust_id
	WHERE c.region = 'atlantic' AND m.prod_id =( SELECT prod_id FROM prod_dimen WHERE product_sub_category = 'tables'	) GROUP BY m.cust_id;
    
/*
9. Find all the customers from Ontario province who own Small Business. (display 
the customer name, no of small business owners)
*/
SELECT Customer_Name AS 'customer name' ,COUNT(*) AS 'no of small business owners' FROM cust_dimen WHERE province='Ontario' AND Customer_Segment='Small Business' GROUP BY Customer_Name;
 
/*
10. Find the number and id of products sold in decreasing order of products sold 
(display product id, no_of_products sold) 
*/
SELECT Prod_id AS product_id,COUNT( Order_Quantity) AS no_of_products_sold FROM market_fact  GROUP BY Prod_id  ORDER BY no_of_products_sold DESC;

/*
11. Display product Id and product sub category whose produt category belongs to 
Furniture and Technlogy. The result should contain columns product id, product 
sub category.
*/
SELECT Prod_id AS 'product id', Product_Sub_Category AS 'product sub category'  FROM prod_dimen WHERE Product_Category = 'Furniture' OR 'Technlogy';

/*
12. Display the product categories in descending order of profits (display the product 
category wise profits i.e. product_category, profits)?
*/
SELECT Product_Category , SUM(m.Profit) AS profits FROM market_fact AS m 
INNER JOIN
prod_dimen AS p ON m.Prod_id=p.Prod_id
GROUP BY Product_Category ORDER BY Profit DESC;

/*
13. Display the product category, product sub-category and the profit within each 
subcategory in three columns.
*/
SELECT Product_Category ,Product_Sub_Category , SUM(m.Profit) AS profits FROM market_fact AS m 
INNER JOIN
prod_dimen AS p ON m.Prod_id=p.Prod_id
GROUP BY Product_Category,p.product_sub_category;

/*
14. Display the order date, order quantity and the sales for the order.
*/
SELECT o.Order_Date, SUM(Order_Quantity) AS 'Order Quantity' , SUM(Sales) AS Sales FROM market_fact AS m
INNER JOIN 
orders_dimen AS o ON m.Ord_id=o.Ord_id
GROUP BY Order_Date ORDER BY Order_Date;

/*
15. Display the names of the customers whose name contains the 
 i) Second letter as ‘R’
*/
SELECT Customer_Name FROM cust_dimen WHERE Customer_Name LIKE '_r%';

/*
ii) Fourth letter as ‘D’
*/
SELECT Customer_Name FROM cust_dimen WHERE Customer_Name LIKE '___d%';

/*
16. Write a SQL query to to make a list with Cust_Id, Sales, Customer Name and 
their region where sales are between 1000 and 5000.
*/
SELECT c.Cust_id ,  c.Customer_Name , c.Region ,m.Sales FROM cust_dimen AS c
INNER JOIN 
market_fact AS m ON c.Cust_id=m.Cust_id
WHERE sales BETWEEN 1000 AND 5000 ;

/*
17. Write a SQL query to find the 3rd highest sales.
*/
SELECT sales AS 3rd_Highest_sales FROM market_fact ORDER BY sales DESC LIMIT 2, 1;

/*
18. Where is the least profitable product subcategory shipped the most? For the least 
profitable product sub-category, display the region-wise no_of_shipments and the 
profit made in each region in decreasing order of profits (i.e. region, 
no_of_shipments, profit_in_each_region)
*/
SELECT c.region , COUNT(DISTINCT s.Ship_id) AS no_of_shipments , SUM(m.profit) AS profit_in_each_region FROM market_fact AS m
INNER JOIN 
cust_dimen AS c ON m.cust_id = c.cust_id
INNER JOIN 
shipping_dimen AS s ON m.ship_id = s.ship_id
INNER JOIN 
prod_dimen AS p ON m.prod_id = p.prod_id
WHERE p.Product_Sub_Category IN (SELECT p.Product_Sub_Category FROM market_fact AS m
											INNER JOIN
											prod_dimen AS p ON m.prod_id = p.prod_id
                                            GROUP BY Product_Sub_Category 
                                            HAVING SUM(m.profit)<=ALL
					(SELECT SUM(m.profit) FROM market_fact AS m
								INNER JOIN 
                                prod_dimen AS p ON m.prod_id = p.prod_id
								GROUP BY Product_Sub_Category)
                                )
GROUP BY c.region ORDER BY profit_in_each_region DESC;