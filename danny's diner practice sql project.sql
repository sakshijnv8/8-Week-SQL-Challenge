use dannys_diner
CREATE TABLE sales (
   customer_id VARCHAR(1),
   order_date DATE,
   product_id INTEGER
);

INSERT INTO sales
  (customer_id,  order_date , product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
   product_id INTEGER,
   product_name VARCHAR(5),
   price INTEGER
);

INSERT INTO menu
  (product_id , product_name , price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
   customer_id VARCHAR(1),
   join_date DATE
);
INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  -- 1.What is the total amount each customer spent at the restaurant?
  select customer_id,sum(price) as total_spent
  from sales s
  join menu m on s.product_id =m.product_id
  group by customer_id
  -- 2. How many days has each customer visited the restaurant?
  select customer_id,count(order_date) as no_of_days_visit
  from sales 
  group by customer_id
  -- 3. What was the first item from the menu purchased by each customer?
WITH ranked_purchases AS (
    SELECT s.customer_id,m.product_id,m.product_name,s.order_date,ROW_NUMBER() 
    OVER (
            PARTITION BY s.customer_id
            ORDER BY s.order_date
        ) AS rn
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
)
SELECT customer_id, product_id, product_name
FROM ranked_purchases
WHERE rn = 1;
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT m.product_name, COUNT(*) AS total_item
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_id, m.product_name
ORDER BY total_item DESC
LIMIT 1;
-- 5. Which item was the most popular for each customer?
WITH item_count AS (
    SELECT s.customer_id,m.product_name,COUNT(*) AS total_item,
        RANK() OVER (
            PARTITION BY s.customer_id
            ORDER BY COUNT(*) DESC
        ) AS rnk
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
    GROUP BY s.customer_id, m.product_id, m.product_name
)
SELECT customer_id, product_name, total_item
FROM item_count
WHERE rnk = 1;
-- 6. Which item was purchased first by the customer after they became a member?
WITH first_purchase AS (
    SELECT
        s.customer_id,
        s.product_id,
        m.product_name,
        s.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY s.customer_id
            ORDER BY s.order_date
        ) AS rn
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
    JOIN members r ON s.customer_id = r.customer_id
    WHERE s.order_date >= r.join_date
)
SELECT customer_id, product_id, product_name
FROM first_purchase
WHERE rn = 1;
-- 7. Which item was purchased just before the customer became a member?
WITH first_purchase AS (
    SELECT
        s.customer_id,
        s.product_id,
        m.product_name,
        s.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY s.customer_id
            ORDER BY s.order_date desc
        ) AS rn
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id
    JOIN members r ON s.customer_id = r.customer_id
    WHERE s.order_date < r.join_date
)
SELECT customer_id, product_id, product_name
FROM first_purchase
WHERE rn = 1;
-- 8. What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id,COUNT(*) AS total_items,SUM(m.price) AS total_price
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members r ON s.customer_id = r.customer_id
WHERE s.order_date < r.join_date
GROUP BY s.customer_id;
-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT s.customer_id,
    SUM(
        CASE
            WHEN m.product_name = 'sushi' THEN m.price * 20
            ELSE m.price * 10
        END
    ) AS total_points
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi -
-- how many points do customer A and B have at the end of January?
SELECT
    s.customer_id,
    SUM(
        CASE
            WHEN s.order_date BETWEEN r.join_date AND DATE_ADD(r.join_date, INTERVAL 6 DAY)
                THEN m.price * 20
            WHEN m.product_name = 'sushi'
                THEN m.price * 20
            ELSE m.price * 10
        END
    ) AS total_points
FROM sales s
JOIN menu m
    ON s.product_id = m.product_id
JOIN members r
    ON s.customer_id = r.customer_id
WHERE s.customer_id IN ('A', 'B')
  AND s.order_date <= '2021-01-31'
GROUP BY s.customer_id;

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  