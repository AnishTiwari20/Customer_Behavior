CREATE Database customers;
use customers;

SELECT * FROM customers_details;

ALTER TABLE customers_details
CHANGE COLUMN `purchase_amount_(usd)` purchase_amount INT;


# Q1. WHat is the total revenue generated male vs female?
SELECT gender, SUM(purchase_amount)
FROM customers_details
GROUP BY gender;


# Q2. How many customers used a discount but still spent more than the avg spent amount?
SELECT customer_id, purchase_amount
FROM customers_details
WHERE discount_applied = 'Yes' AND purchase_amount > (SELECT AVG(purchase_amount) FROM customers_details);

# Q3. Top 5 products with highest average review rating
SELECT item_purchased, ROUND(AVG(review_rating),2) as Average_Review_Rating
FROM customers_details
GROUP BY item_purchased
ORDER BY Average_Review_Rating DESC
LIMIT 5;

#Q4. Compare the average purchase amount between Standard and Express shipping
SELECT shipping_type, AVG(purchase_amount) as Average_Purchase_Amount
FROM customers_details
WHERE shipping_type in ('Standard', 'Express')
GROUP BY shipping_type;

# Q5. Compare average spent and total revenue between subscribers and non subscribers

SELECT subscription_status, count(customer_id) as number_of_customers, round(avg(purchase_amount),2) as average_spent, sum(purchase_amount) as total_revenue
from customers_details
group by subscription_status;


#Q6. WHich 5 products have the highest percentage of purchases with discounts applied
SELECT item_purchased,
ROUND(SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100,2) AS percentage
FROM customers_details
GROUP BY item_purchased
ORDER BY percentage DESC
LIMIT 5;


# Q7. Segment Customers into New, Returning and loyal based on the total number of purchase and show count of total purchases
WITH customer_type AS (
    SELECT customer_id, previous_purchases, 
        CASE 
            WHEN previous_purchases = 1 THEN 'New'
            WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
            ELSE 'Loyal'
        END AS customer_segment
    FROM customers_details
)
SELECT customer_segment, COUNT(*) AS count_of_customers
FROM customer_type
GROUP BY customer_segment;



# Q8. What are the three most purchased product in each category 
WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM customers_details
    GROUP BY category, item_purchased
)
SELECT item_rank,category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <=3;


#Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
SELECT subscription_status,
       COUNT(customer_id) AS repeat_buyers
FROM customers_details
WHERE previous_purchases > 5
GROUP BY subscription_status;

#Q10. What is the revenue contribution of eacch age group
select age_group, sum(purchase_amount) as revenue
from customers_details
group by age_group
order by revenue desc;



SELECT CURRENT_USER();

