CREATE Database olist;
USE olist;
SHOW TABLES;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*)
FROM `olist store analysis project copy`;
DESC orders;
DESC `olist store analysis project copy`;

ALTER TABLE orders
CHANGE COLUMN `ï»¿order_id` order_id TEXT;
DESC orders;
DESC `olist store analysis project copy`;
ALTER TABLE `olist store analysis project copy`
CHANGE COLUMN `ï»¿order_id` order_id TEXT;
DESC `olist store analysis project copy`;
SELECT COUNT(*) AS Total_Orders
FROM orders;


SELECT order_purchase_timestamp
FROM orders
LIMIT 10;

-- FINAL QUERY -------------------------------------------------------------------------------------------------------------

Select
    Case
        When dayofweek(
           str_to_date(o.order_purchase_timestamp,'%m/%d/%Y %H:%i')
        ) in (1,7)
        Then 'Weekend'
        Else 'Weekday'
    end as Day_Type,

    count(distinct o.order_id) as Total_Orders,

    round(sum(p.payment_value),2) as Total_Payment,

    round(avg(p.payment_value),2) as  Average_Payment

from orders o
join `olist store analysis project copy` p
on o.order_id = p.order_id
group by Day_Type;


