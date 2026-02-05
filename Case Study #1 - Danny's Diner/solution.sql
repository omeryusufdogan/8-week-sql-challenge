/*-----------------------------------
  Danny's Dinner Case Study Questions
  -----------------------------------*/

-- 1. What is the total amount each customer spent at the restaurant?

SELECT s.customer_id AS customer_id, 
       SUM(m.price) AS total_amount 
  FROM sales AS s
       INNER JOIN menu AS m
	   ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_amount DESC;

-- 2. How many days has each customer visited the restaurant?

SELECT s.customer_id AS customer_id,
	   COUNT(DISTINCT s.order_date) AS number_of_days
  FROM sales AS s
GROUP BY s.customer_id
ORDER BY number_of_days DESC;

-- 3. What was the first item from the menu purchased by each customer?

WITH first_item AS (
	 SELECT s.customer_id AS customer_id,	
		    s.product_id AS product_id,
		    s.order_date AS order_date,
		    m.product_name AS product_name,
		    DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rank_num
	   FROM sales AS s
	        INNER JOIN menu AS m
		    ON s.product_id = m.product_id	
)

SELECT customer_id,
	   product_id
  FROM first_item
 WHERE rank_num = 1
GROUP BY customer_id, product_id;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT s.product_id AS product_id,
	   m.product_name AS product_name,
	   COUNT(*) AS number_of_purchase
  FROM sales AS s
       INNER JOIN menu AS m
	   ON s.product_id = m.product_id 
GROUP BY s.product_id, m.product_name
ORDER BY number_of_purchase DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?

WITH pop AS (
     SELECT s.customer_id AS customer_id,
	     	m.product_name AS product_name,
		    COUNT(s.product_id) AS number_of_purchase,
	    	DENSE_RANK() OVER(
	    	PARTITION BY s.customer_id 
		    ORDER BY COUNT(s.product_id) DESC
		  ) AS rank_num
	   FROM sales AS s
	        INNER JOIN menu AS m
		    ON s.product_id = m.product_id
	 GROUP BY s.customer_id, m.product_name
)

SELECT customer_id,
	   product_name,
	   number_of_purchase
  FROM pop
 WHERE rank_num = 1;

-- 6. Which item was purchased first by the customer after they became a member?

WITH first_item_after AS (
	 SELECT s.customer_id AS customer_id, 
		    m.product_name AS product_name,
		    s.order_date AS order_date,
		    DENSE_RANK() OVER(
			PARTITION BY s.customer_id 
			ORDER BY s.order_date ASC
		  ) AS rank_num	
	   FROM sales AS s
	        INNER JOIN menu AS m
		    ON s.product_id = m.product_id
	
		    INNER JOIN members AS mem
		    ON s.customer_id = mem.customer_id
	  WHERE s.order_date >= mem.join_date
)
SELECT customer_id,
	   product_name,
	   order_date
  FROM first_item_after
 WHERE rank_num = 1;
	


			
-- 7. Which item was purchased just before the customer became a member?

WITH first_item_before AS (
	 SELECT s.customer_id AS customer_id, 
		    m.product_name AS product_name,
		    s.order_date AS order_date,
		    DENSE_RANK() OVER(
		    PARTITION BY s.customer_id 
		    ORDER BY s.order_date DESC
		  ) AS rank_num	
	   FROM sales AS s
	        INNER JOIN menu AS m
		    ON s.product_id = m.product_id
	
		    INNER JOIN members AS mem
		    ON s.customer_id = mem.customer_id
	  WHERE s.order_date < mem.join_date
)
SELECT customer_id,
	   product_name,
	   order_date
  FROM first_item_before
 WHERE rank_num = 1;
			
-- 8. What is the total items and amount spent for each member before they became a member?

SELECT s.customer_id AS customer_id,
	   COUNT(*) AS total_items,
	   SUM(m.price) AS amount_spent
  FROM sales AS s
       INNER JOIN menu AS m
	   ON s.product_id = m.product_id

	   INNER JOIN members AS mem
	   ON mem.customer_id = s.customer_id 
 WHERE s.order_date < mem.join_date
GROUP BY s.customer_id
	
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT s.customer_id AS customer_id,
	   SUM(CASE
		   WHEN m.product_name = 'Sushi' THEN m.price * 20
		   ELSE m.price * 10
		   END) AS total_point
  FROM sales AS s
       INNER JOIN menu AS m
	   ON s.product_id = m.product_id
GROUP BY s.customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

SELECT s.customer_id AS customer_id,
	   SUM(CASE 
		   WHEN s.order_date BETWEEN mem.join_date AND (mem.join_date + INTERVAL '6 Days') THEN m.price * 20
		   WHEN m.product_name = 'Sushi' THEN m.price * 20
		   ELSE m.price * 10 
		   END) AS total_points
		
  FROM sales AS s
       INNER JOIN menu AS m
	   ON s.product_id = m.product_id
	   
       INNER JOIN members AS mem
	   ON s.customer_id = mem.customer_id
 WHERE s.order_date <= '2021-01-31'
GROUP BY s.customer_id;
	
































