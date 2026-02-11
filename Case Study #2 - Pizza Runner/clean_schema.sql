-- customer orders

CREATE TABLE pizza_runner.customer_orders_new AS 
SELECT order_id,
	   customer_id,
	   pizza_id,
	   CASE
	   WHEN exclusions IS NULL OR exclusions LIKE 'null' OR exclusions = '' THEN NULL
	   ELSE exclusions
	   END AS exclusions,
	   CASE
	   WHEN extras IS NULL OR extras LIKE 'null' OR extras = '' THEN NULL
	   ELSE extras
	   END AS extras,
	   order_time::TIMESTAMP AS order_time
  FROM pizza_runner.customer_orders;

-- pizza names

CREATE TABLE pizza_runner.runner_orders_new AS
SELECT order_id,
	   runner_id,
	   CASE
	   WHEN pickup_time IS NULL OR pickup_time LIKE 'null' THEN NULL
	   ELSE pickup_time
	   END::TIMESTAMP AS pickup_time,
	   CASE
	   WHEN distance LIKE 'null' THEN NULL
	   WHEN distance LIKE '%km' THEN TRIM('km' FROM distance)
	   ELSE distance
	   END::NUMERIC AS distance,
	   CASE
	   WHEN duration LIKE 'null' THEN NULL
	   WHEN duration LIKE '%minutes' THEN TRIM('minutes' FROM duration)
	   WHEN duration LIKE '%mins' THEN TRIM('mins' FROM duration)
	   WHEN duration LIKE '%minute' THEN TRIM('minute' FROM duration)
	   ELSE duration
	   END::INTEGER AS duration,
	   CASE
	   WHEN cancellation LIKE 'null' THEN NULL
	   WHEN cancellation LIKE '' THEN NULL
	   ELSE cancellation
	   END AS cancellation
  FROM pizza_runner.runner_orders; 
