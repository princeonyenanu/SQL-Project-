

/* Besic Questions*/

/* Question 1 */

select count(order_id)  As  Total_Orders
from orders;











/* Question 2 */

SELECT round(SUM(p.price * o.quantity),2) AS total_revenue
FROM pizzas AS p
JOIN order_details AS o
ON p.pizza_id = o.pizza_id;



/* Question 3 */

SELECT top 1 pizza_id AS highest_priced_pizza, price
FROM pizzas
ORDER BY price DESC










/* Question 4 */

SELECT top 1 p.size, COUNT(p.size) AS size_count
FROM order_details AS o
LEFT JOIN pizzas AS p 
    ON p.pizza_id = o.pizza_id
GROUP BY p.size
ORDER BY size_count DESC









/* Question 5 */

SELECT TOP 5 pizza_id, 
       SUM(quantity) AS most_bought
FROM order_details
GROUP BY pizza_id
ORDER BY most_bought DESC;






/*Question 6*/

SELECT TOP 5 pizza_id, 
       SUM(quantity) AS least_bought
FROM order_details
GROUP BY pizza_id
ORDER BY least_bought asc;








/*Intermediate Questions*/

/*Question 1*/

SELECT pt.category, 
       SUM(o.quantity) AS total_quantity
FROM order_details AS o
LEFT JOIN pizzas AS p 
    ON p.pizza_id = o.pizza_id
JOIN pizza_types AS pt 
    ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity DESC;



/*Question 2*/

SELECT DATEPART(hour, time) AS hour, 
       COUNT( DATEPART(hour,time)) AS frequency_per_hour
FROM orders
GROUP BY DATEPART(hour, time)
ORDER BY frequency_per_hour desc;








/*Question 3*/

sELECT top 3  p.pizza_type_id, pt.name, sum(p.price * o.quantity) AS revenue
FROM pizzas AS p
JOIN order_details AS o
ON p.pizza_id = o.pizza_id
join pizza_types as pt
on p.pizza_type_id = pt.pizza_type_id
group by p.pizza_type_id, pt.name
order by revenue desc;






/*Question 4*/

SELECT   p.pizza_type_id,p.size ,sum(p.price * o.quantity) AS revenue
FROM pizzas AS p
JOIN order_details AS o
ON p.pizza_id = o.pizza_id
where p.size ='s' or p.size = 'S'
group by p.pizza_type_id ,p.size
order by revenue desc;

SELECT   p.pizza_type_id,p.size ,sum(p.price * o.quantity) AS revenue
FROM pizzas AS p
JOIN order_details AS o
ON p.pizza_id = o.pizza_id
where p.size ='m' or p.size = 'M'
group by p.pizza_type_id ,p.size
order by revenue desc;

SELECT   p.pizza_type_id,p.size ,sum(p.price * o.quantity) AS revenue
FROM pizzas AS p
JOIN order_details AS o
ON p.pizza_id = o.pizza_id
where p.size ='l' or p.size = 'L'
group by p.pizza_type_id ,p.size
order by revenue desc;


/*Question 4*/

SELECT 
    p.pizza_type_id,
    SUM(CASE WHEN p.size = 's' OR p.size = 'S' THEN p.price * o.quantity ELSE 0 END) AS revenue_S,
    SUM(CASE WHEN p.size = 'm' OR p.size = 'M' THEN p.price * o.quantity ELSE 0 END) AS revenue_M,
    SUM(CASE WHEN p.size = 'l' OR p.size = 'L' THEN p.price * o.quantity ELSE 0 END) AS revenue_L
FROM pizzas AS p
JOIN order_details AS o
    ON p.pizza_id = o.pizza_id
GROUP BY p.pizza_type_id
ORDER BY revenue_S DESC, revenue_M DESC, revenue_L DESC;






/*AVANCE QUESTION*/

/*Question 1*/


WITH PizzaRevenue AS (
    SELECT 
        pt.pizza_type_id, 
        pt.name, 
        pt.category, 
        SUM(p.price * o.quantity) AS revenue,
        ROW_NUMBER() OVER (
            PARTITION BY pt.category 
            ORDER BY SUM(p.price * o.quantity) DESC
        ) AS rank
    FROM pizzas AS p
    JOIN order_details AS o
        ON p.pizza_id = o.pizza_id
    JOIN pizza_types AS pt
        ON pt.pizza_type_id = p.pizza_type_id
    GROUP BY pt.pizza_type_id, pt.name, pt.category
)
SELECT 
    pizza_type_id, 
    name, 
    category, 
    revenue
FROM PizzaRevenue
WHERE rank <= 3
ORDER BY category, revenue DESC;


/*Question 2*/

SELECT 
    o.date, 
      ROUND(SUM(p.price * od.quantity), 2) AS total_sales
FROM orders AS o
JOIN order_details AS od 
    ON o.order_id = od.order_id
JOIN pizzas AS p 
    ON od.pizza_id = p.pizza_id
GROUP BY o.date
ORDER BY o.date;








/*Question 3*/

/*Daily Sales Trend*/

SELECT 
    o.date, 
    ROUND(SUM(p.price * od.quantity), 2) AS total_sales
FROM orders AS o
JOIN order_details AS od 
    ON o.order_id = od.order_id
JOIN pizzas AS p 
    ON od.pizza_id = p.pizza_id
GROUP BY o.date
ORDER BY total_sales desc;


/*Weekly Sales Trend*/

SELECT 
    DATEPART(YEAR, o.date) AS year,
    DATEPART(WEEK, o.date) AS week_number,
    ROUND(SUM(p.price * od.quantity), 2) AS total_sales
FROM orders AS o
JOIN order_details AS od 
    ON o.order_id = od.order_id
JOIN pizzas AS p 
    ON od.pizza_id = p.pizza_id
GROUP BY DATEPART(YEAR, o.date), DATEPART(WEEK, o.date)
ORDER BY  total_sales desc;


/*Monthly Sales Trend*/

SELECT 
    DATEPART(YEAR, o.date) AS year,
    DATEPART(MONTH, o.date) AS month,
    ROUND(SUM(p.price * od.quantity), 2) AS total_sales
FROM orders AS o
JOIN order_details AS od 
    ON o.order_id = od.order_id
JOIN pizzas AS p 
    ON od.pizza_id = p.pizza_id
GROUP BY DATEPART(YEAR, o.date), DATEPART(MONTH, o.date)
ORDER BY total_sales desc;
