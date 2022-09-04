USE magist;



-- Explore the Magist tables
-- 1. How many orders are there in the dataset?
-- 99441
SELECT 
	COUNT(order_id) AS Nr_Orders
FROM
	orders;

    

    
-- 2. Are orders actually delivered?
-- 96478 are delivered
-- 2963 are not delivered
SELECT 
	COUNT(order_status)
FROM 
	orders
WHERE NOT order_status = 'delivered';

SELECT 
    order_status, 
    COUNT(*) AS Orders
FROM
    orders
GROUP BY order_status;



-- 3. Is Magist having user growth?
-- Looks like from 'Sep 2016' to 'Oct 2018' they have a significant growth
-- With the mention of last 2 months low user number (looks very weierd)
SELECT 
    YEAR(order_purchase_timestamp) AS Year_,
    MONTH(order_purchase_timestamp) AS Month_,
    COUNT(customer_id)
FROM
    orders
GROUP BY Year_ , Month_
ORDER BY Year_ , Month_;



-- 4. How many products are there on the products table?
-- 32951 of different products
SELECT 
    COUNT(DISTINCT product_id) AS Nr_Products
FROM
    products;
    
    
    
-- 5. Which are the categories with the most products?
-- 3029 cama_mesa_banho, 2867 esporte_lazer, 
-- 2657 moveis_decoracao, 2444 beleza_saude, 
-- 2335 utilidades_domesticas
-- TOP 5 categories, none of them are 'expensive tech products'
SELECT 
    product_category_name, 
    COUNT(DISTINCT product_id) AS Nr_Products
FROM
    products
GROUP BY product_category_name
ORDER BY COUNT(product_id) DESC
LIMIT 5;




-- 6. How many of those products were present in actual transactions? 
-- 32951 
SELECT 
	count(DISTINCT product_id) AS Nr_Products_In_Transaction
FROM
	order_items;
    


-- 7. What’s the price for the most expensive and cheapest products?
-- Most espensive 6735 and cheapest 0.85    
SELECT
	MAX(price) AS Most_Exp,
    MIN(price) AS Cheapest
FROM order_items;



-- 8. What are the highest and lowest payment values?
-- Highest 13664.1 and lowest 0
SELECT 
	MAX(payment_value) AS Highest_Payment,
    MIN(payment_value) AS Lowest_Payment
FROM order_payments;



#------------------------------------------#



-- # Answer business questions # --

-- In relation to the products:
-- 1. What categories of tech products does Magist have?
-- I've selected 8(tech categories) out of 74(all categories)
SELECT 
	COUNT(DISTINCT(product_category_name)) AS Nr_Products_Categories
FROM products;

SELECT 
	DISTINCT(product_category_name) AS Category_Name
FROM products;

SELECT 
	DISTINCT(product_category_name) AS Tech_category_name
FROM products
WHERE
    product_category_name 
		IN ('informatica_acessorios',
			'telefonia',
            'eletronicos',
            'consoles_games',
            'audio',
            'pcs',
            'tablets_impressao_imagem',
            'pc_gamer'
            )
;



-- 2.a. How many products of tech categories have been sold?
-- 16802   
SELECT 
    COUNT(oi.product_id) AS Tech_Prod_Sold
FROM
    order_items oi
		INNER JOIN
    products p ON oi.product_id = p.product_id
        INNER JOIN
	orders o ON oi.order_id = o.order_id
        
WHERE
    p.product_category_name 
		IN ('informatica_acessorios',
			'telefonia',
            'eletronicos',
            'consoles_games',
            'audio',
            'pcs',
            'tablets_impressao_imagem',
            'pc_gamer'
            )
AND 
    o.order_status  
		IN ('delivered', 'shipped', 'invoiced');



-- 2.b. What percentage does that represent from the overall number of products sold?
-- overall number of products sold is 111382
SELECT 
    COUNT(oi.product_id)
FROM
    order_items oi
		INNER JOIN
    products p ON oi.product_id = p.product_id
        INNER JOIN
	orders o ON oi.order_id = o.order_id
WHERE 
    o.order_status  
		IN ('delivered', 'shipped','invoiced');

-- (16802/111741)*100 = 15.04 % 
SELECT 
    ROUND((16802 / COUNT(oi.product_id) * 100), 2) AS Percentage_Tech_Prod_Sold
FROM
    order_items oi
		INNER JOIN
    products p ON oi.product_id = p.product_id
        INNER JOIN
	orders o ON oi.order_id = o.order_id
WHERE 
    o.order_status  
		IN ('delivered', 'shipped','invoiced');
        

        
 -- 3. What’s the average price of the products being sold?
 -- 120.65
SELECT 
    ROUND(AVG(oi.price),2) AS AVG_Price_Prod_Sold
FROM
	order_items oi
		INNER JOIN
    products p ON oi.product_id = p.product_id
        INNER JOIN
	orders o ON oi.order_id = o.order_id;
 
 
-- 4. Are, expensive tech products, popular?
-- Q: What means 'popular'?
-- A: When they had bought a lot of them

-- Q: What means 'expensive tech products'?
-- A: Above middle range

-- Q: Where is middle range?
-- A: Divide the highest price of the TECH products being sold('delivered', 'shipped', 'invoiced')

-- Highest Price Of TECH Products:
-- 6729

-- Above middle range means:
-- price > 3364.5        
SELECT 
    ROUND(MAX(price),1) AS Highest_Price_Of_TECH_Products
FROM
	order_items oi
		INNER JOIN
	products p ON oi.product_id = p.product_id    
        INNER JOIN
    orders o ON oi.order_id = o.order_id
WHERE
    p.product_category_name 
		IN ('informatica_acessorios',
			'telefonia',
            'eletronicos',
            'consoles_games',
            'audio',
            'pcs',
            'tablets_impressao_imagem',
            'pc_gamer'
            )
AND 
    order_status  
		IN ('delivered', 'shipped', 'invoiced');



-- Conclusion for the QUERY below:
-- They don't buy to much EXPENSIVE TECH PRODUCTS
-- They buy much more cheaper products and lowcost products
-- That means the cheaper products are very popular on Magist univers/enviroment
SELECT 
    p.product_category_name AS Category_Name, 
    COUNT(p.product_category_name) AS Nr_Products_Bought,
    CASE
		WHEN price > 420.56 AND price < 1682.25 THEN 'low price tech'
        WHEN price > 841.12 AND price < 1682.25 THEN 'medium price tech'
        WHEN price > 1682.25 AND price < 3364.5 THEN 'high price tech'
        WHEN price > 3364.5 THEN 'Expensive TECH'
        ELSE 'cheaper'
    END AS Price_Category,
    ROUND(AVG(price),1) AS Price_AVG    
    FROM 
		order_items oi
		INNER JOIN
	products p ON oi.product_id = p.product_id    
        INNER JOIN
    orders o ON oi.order_id = o.order_id
WHERE
    p.product_category_name 
		IN ('informatica_acessorios',
			'telefonia',
            'eletronicos',
            'consoles_games',
            'audio',
            'pcs',
            'tablets_impressao_imagem',
            'pc_gamer'
            )
AND 
    order_status  
		IN ('delivered', 'shipped')
GROUP BY product_category_name, price_category
ORDER BY  ROUND(AVG(price),1) DESC;



-- In relation to the sellers:
-- 5. How many months of data are included in the magist database?
-- 25 months
SELECT 
	COUNT(DISTINCT MONTH(order_purchase_timestamp)) AS nr_months,
    YEAR(order_purchase_timestamp) AS year_
FROM
    orders
GROUP BY year_ 
ORDER BY year_ ;



-- 6.a. How many sellers are there? 
-- 3095 sellers
SELECT 
	COUNT(seller_id) AS Nr_Sellers
FROM 
	sellers;
    
    
    
-- 6.b. How many Tech sellers are there?
-- 477  Tech sellers
SELECT
	COUNT(DISTINCT s.seller_id) AS Nr_Tech_Sellers
FROM
	sellers s
		JOIN order_items oi 
			ON s.seller_id = oi.seller_id
		JOIN products p
			ON p.product_id = oi.product_id
WHERE
    p.product_category_name 
		IN ('informatica_acessorios',
			'telefonia',
            'eletronicos',
            'consoles_games',
            'audio',
            'pcs',
            'tablets_impressao_imagem',
            'pc_gamer'
            );

-- 6.c. What percentage of overall sellers are Tech sellers?
-- (477/3095)*100 = 15.41 %
SELECT 
	ROUND(477 / COUNT(seller_id) * 100, 2) AS Percentage_Tech_Sellers
FROM 
	sellers;



-- 7.a. What is the total amount earned by all sellers? 
-- 16 008 872
SELECT
	ROUND(SUM(payment_value), 0) AS TOTAL_Earned_By_All_Sellers
FROM
	order_payments;
    

    
-- 7.b. What is the total amount earned by all Tech sellers?
-- 2 837 497 TOTAL earned by all TECH sellers
SELECT
	ROUND(SUM(payment_value), 0) AS TOTAL_Eearned_By_All_TECH_Sellers
FROM
	order_payments op
		JOIN order_items oi
			ON oi.order_id = op.order_id
		JOIN products p
			ON p.product_id = oi.product_id
		JOIN orders o
			ON o.order_id = oi.order_id
WHERE
    p.product_category_name 
		IN ('informatica_acessorios',
			'telefonia',
            'eletronicos',
            'consoles_games',
            'audio',
            'pcs',
            'tablets_impressao_imagem',
            'pc_gamer'
            )
			AND
            o.order_status  
		IN ('delivered', 'shipped', 'invoiced');
            
            

-- 7.1.a. Can you work out the average monthly income of all sellers? 
-- 16 008 872 / 25 = 640 355 
SELECT
	ROUND(SUM(payment_value)/25,0) AS Monthly_Avg_Income_By_All_Sellers
FROM
	order_payments;

-- 7.1.b. Can you work out the average monthly income of Tech sellers?
-- 2 837 497 / 25 = 113 500
SELECT
	ROUND(SUM(payment_value)/25, 0) AS TOTAL_Eearned_By_All_TECH_Sellers
FROM
	order_payments op
		JOIN order_items oi
			ON oi.order_id = op.order_id
		JOIN products p
			ON p.product_id = oi.product_id
		JOIN orders o
			ON o.order_id = oi.order_id
WHERE
    p.product_category_name 
		IN ('informatica_acessorios',
			'telefonia',
            'eletronicos',
            'consoles_games',
            'audio',
            'pcs',
            'tablets_impressao_imagem',
            'pc_gamer'
            )
			AND
            o.order_status  
		IN ('delivered', 'shipped', 'invoiced');


-- In relation to the delivery time:
-- 8. What’s the average time between the order being placed and the product being delivered?
-- 12.5 days
SELECT 
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) ), 1)
		AS Avg_Days_Between
FROM 
	orders
WHERE
	order_status  
		IN ('delivered')
        AND 
			order_delivered_customer_date IS NOT NULL;



-- 9. How many orders are delivered on time vs orders delivered with a delay?
-- Orders_in_time 88476
SELECT
    COUNT(order_id) AS Orders_in_time
FROM 
	orders
    WHERE 
		DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 0;

-- Orders_delayed 8000
SELECT
    COUNT(order_id) AS Orders_delayed
FROM 
	orders
    WHERE 
		DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) <= 0;
        
        

-- 10. Is there any pattern for delayed orders, e.g. big products being delayed more often?
-- Seems like the weight doesn't have a direct impact
SELECT p.product_weight_g,
		DATEDIFF(o.order_estimated_delivery_date, o.order_delivered_customer_date)  AS days_delayed
FROM products p
	JOIN order_items oi
		ON oi.product_id = p.product_id
	JOIN orders o
		ON o.order_id = oi.order_id
WHERE 
		DATEDIFF(o.order_estimated_delivery_date, o.order_delivered_customer_date)  < 0;
        
