/*******************************************************************************
Project Name: Retail Analytics
Dataset: Superstore Retail Orders
Author: Gaurav Singh
Role Target: Data Analyst
Description: End-to-end exploratory data analysis (EDA) and business metrics
             extraction to evaluate profitability, shipping efficiency, 
             and customer segmentation.
*******************************************************************************/
-- 1. Sales Analysis
     SELECT SUM(sales) AS Total_Sales,
     SUM(profit) AS Total_Profit, 
     SUM(quantity) AS Total_Quantity_Sold,
     COUNT(DISTINCT order_id) AS No_Of_Unique_Orders,
     COUNT(DISTINCT customer_id) AS Total_Unique_Customer FROM retail_orders;

-- 2. Category Analysis
	  -- 2.1 Sales by Category
         SELECT category, SUM(sales) AS total_sales 
         FROM retail_orders 
         GROUP BY category 
         ORDER BY total_sales DESC;
      -- 2.2 Profit by Category
         SELECT category, SUM(profit) AS total_profit 
         FROM retail_orders 
         GROUP BY category 
         ORDER BY total_profit DESC;
	 -- 2.3 Sales by sub_category
         SELECT sub_category, SUM(sales) AS total_sales
         FROM retail_orders 
         GROUP BY sub_category
         ORDER BY total_sales DESC;
	-- 2.4 Profit by sub_category
         SELECT sub_category, SUM(profit) AS total_profit
		 FROM retail_orders 
		 GROUP BY sub_category
		 ORDER BY total_profit DESC;
	-- 2.5 top 3 loss making sub_category
         SELECT sub_category, SUM(profit) AS total_loss
		 FROM retail_orders 
		 GROUP BY sub_category
		 ORDER BY total_loss ASC
         LIMIT 3;
-- 3. Customer Analysis
	-- 3.1 top 10 customer by sales
		SELECT customer_id, customer_name, SUM(sales) AS total_sales, SUM(profit) AS total_profit, COUNT(DISTINCT order_id) AS total_orders
        FROM retail_orders
        GROUP BY customer_id, customer_name
        ORDER BY total_sales DESC
        LIMIT 10;
	-- 3.2 top 10 customer by profit
		SELECT customer_id, customer_name, SUM(sales) AS total_sales, SUM(profit) AS total_profit, COUNT(DISTINCT order_id) AS total_orders
        FROM retail_orders
        GROUP BY customer_id, customer_name
        ORDER BY total_profit DESC
        LIMIT 10;
	-- 3.3 top 5 customers in every region
		WITH RankedCustomers AS(
			SELECT customer_id, customer_name, region,  SUM(sales) AS total_sales, SUM(profit) AS total_profit, 
			SUM(quantity) AS total_quantity, DENSE_RANK() OVER(PARTITION BY region ORDER BY SUM(sales) DESC) AS rnk
			FROM retail_orders GROUP BY region, customer_id, customer_name
		)
        SELECT customer_id, customer_name, region, total_sales, total_profit, total_quantity, rnk
        FROM RankedCustomers WHERE rnk <= 5;

	-- 3.4 customers whose sales exceed 10000
		SELECT customer_id, customer_name, SUM(sales) AS total_sales
        FROM retail_orders GROUP BY customer_id, customer_name HAVING SUM(sales) > 10000;
        
-- 4. Regional Analysis
	-- 4.1 Region-wise Sales
		SELECT region, SUM(sales) AS total_sales
        FROM retail_orders
        GROUP BY region
        ORDER BY total_sales DESC;
	-- 4.2 State-wise Profit
		SELECT state, SUM(profit) AS total_profit
        FROM retail_orders
        GROUP BY state
        ORDER BY total_profit DESC
        LIMIT 10;
	-- 4.3 top 10 states by sales 
		SELECT state, SUM(sales) AS total_sales
        FROM retail_orders
        GROUP BY state
        ORDER BY total_sales DESC
        LIMIT 10;
	-- 4.3 bottom 10 states by sales 
		SELECT state, SUM(sales) AS total_sales
        FROM retail_orders
        GROUP BY state
        ORDER BY total_sales 
        LIMIT 10;
-- 5. Discount Analysis
	-- 5.1 avg discount by category
		SELECT category, ROUND(AVG(discount),2) AS avg_discount
        FROM retail_orders
        GROUP BY category
        ORDER BY avg_discount DESC;
	-- 5.2 Profit by discount level
		SELECT 
            CASE 
			   WHEN discount = 0.0 THEN 'no discount'
               WHEN discount <= 0.2 THEN 'low'
               WHEN discount > 0.20 AND discount < 0.4 THEN 'med'
               ELSE 'high'
			END AS discount_level,
            SUM(sales) AS total_sales,
            SUM(quantity) AS total_quantity,
            SUM(profit) AS total_profit
		FROM retail_orders
        GROUP BY discount_level
        ORDER BY total_profit DESC;
        
-- 6. Product Analysis
	-- 6.1 Top 10 products by sales
		SELECT product_id, product_name, SUM(sales)  AS total_sales
        FROM retail_orders
        GROUP BY product_id, product_name
        ORDER BY total_sales DESC
        LIMIT 10;
	-- 6.2 Top 10 products by profit
		SELECT product_id, product_name, SUM(profit)  AS total_profit
        FROM retail_orders
        GROUP BY product_id, product_name
        ORDER BY total_profit DESC
        LIMIT 10;
	-- 6.3 Top 10 products by profit
		SELECT product_id, product_name, SUM(profit)  AS total_profit
        FROM retail_orders
        GROUP BY product_id, product_name
        ORDER BY total_profit ASC
        LIMIT 10;
	-- 6.4 Avg discount by product
		SELECT product_id, product_name, ROUND(AVG(discount), 2) AS avg_discount
		FROM retail_orders
		GROUP BY product_id, product_name
		HAVING avg_discount > 0.4
		ORDER BY avg_discount DESC;
        
-- 7. Shipping Analysis
	-- 7.1 Sales by shipping_mode
		SELECT ship_mode, SUM(sales) AS total_sales
        FROM retail_orders
        GROUP BY ship_mode
        ORDER BY total_sales DESC;
	-- 7.2 Profit by shipping_mode
		SELECT ship_mode, SUM(profit) AS total_profit
        FROM retail_orders
        GROUP BY ship_mode
        ORDER BY total_profit DESC;
	-- 7.3 Orders by shipping_mode
		SELECT ship_mode, COUNT(DISTINCT order_id) AS total_order
        FROM retail_orders
        GROUP BY ship_mode
        ORDER BY total_order DESC;

-- 8. Time Analysis
	-- 8.1 Monthly Sales, Profit
		SELECT 
			DATE_FORMAT(Order_Date, '%Y-%m') AS yearmonth,
			COUNT(DISTINCT Order_ID) AS total_orders,
			ROUND(SUM(sales), 2) AS total_sales,
			ROUND(AVG(sales), 2) AS avg_order_value
		FROM retail_orders
		GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
		ORDER BY yearmonth ASC;
    
