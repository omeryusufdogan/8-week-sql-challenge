/*-----------------------------------
  Pizza Runner Case Study Questions
  
  A. Pizza Metrics
  -----------------------------------*/

-- 1. How many pizzas were ordered?

SELECT COUNT(*) AS orders
  FROM customer_orders_new;

-- 2. How many unique customer orders were made?

SELECT COUNT(DISTINCT order_id) AS unique_orders
  FROM customer_orders_new;

-- 3. How many successful orders were delivered by each runner?

SELECT runner_id,
	   COUNT(order_id) AS orders
  FROM runner_orders_new
 WHERE cancellation IS NULL
GROUP BY runner_id;

-- 4. How many of each type of pizza was delivered?

SELECT c.pizza_id,
	   COUNT(*) AS delivered_pizza_amount
  FROM runner_orders_new AS r
	   INNER JOIN customer_orders_new AS c
	   ON r.order_id = c.order_id
 WHERE r.cancellation IS NULL
GROUP BY c.pizza_id;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
 
SELECT c.customer_id,
       p.pizza_name,
       COUNT(order_id) AS order_amount
  FROM customer_orders_new AS c
       INNER JOIN pizza_names AS p
       ON c.pizza_id = p.pizza_id
 WHERE p.pizza_name IN ('Meatlovers', 'Vegetarian')
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id ASC;

-- 6. What was the maximum number of pizzas delivered in a single order?

SELECT DISTINCT c.order_id,
                COUNT (c.pizza_id) AS delivered_pizza_amount
  FROM customer_orders_new AS c
       INNER JOIN runner_orders_new AS r
       ON c.order_id = r.order_id
 WHERE r.cancellation IS NULL
GROUP BY c.order_id
ORDER BY delivered_pizza DESC
LIMIT 1;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT c.customer_id,
	   SUM(CASE 
	       WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 1 
	       ELSE 0
	       END) AS least_1_changes,
	   SUM(CASE
	   	   WHEN exclusions IS NULL AND extras IS NULL THEN 1
	   	   ELSE 0
	       END) AS no_changes
  FROM customer_orders_new AS c
       INNER JOIN runner_orders_new AS r
       ON c.order_id = r.order_id
 WHERE r.cancellation IS NULL
GROUP BY c.customer_id
ORDER BY c.customer_id ASC;

-- 8. How many pizzas were delivered that had both exclusions and extras?

SELECT SUM(CASE
		   WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 1
		   ELSE 0
           END) AS both_changes
  FROM customer_orders_new AS c
      INNER JOIN runner_orders_new AS r
      ON c.order_id = r.order_id
 WHERE r.cancellation IS NULL;
 
-- 9. What was the total volume of pizzas ordered for each hour of the day?

SELECT EXTRACT(HOUR FROM c.order_time) AS hour_of_day,
       COUNT(c.pizza_id) AS amount_pizza
  FROM customer_orders_new AS c
GROUP BY hour_of_day
ORDER BY hour_of_day DESC;

-- 10. What was the volume of orders for each day of the week?

SELECT TO_CHAR(c.order_time, 'Day') AS day_of_week,
       COUNT (c.order_id) AS amount_order
  FROM customer_orders_new AS c
GROUP BY day_of_week
ORDER BY amount_order DESC;
