-- Databricks notebook source
--Questions 1–5  —  Extract Date Parts
--Q1 Return each order with the day name of the order date
SELECT 
      order_id,
      customer_id,
      order_date,
DAYNAME(order_date) AS day_name
FROM joins.default.orders;

--Q2 Return each customer with the name of the month in which they signed up. 
SELECT
    customer_id,
    customer_name,
    signup_date,
    MONTHNAME(signup_date) AS signup_month_name
FROM joins.default.customer_signups;

--Q3 Return each sale with the month number extracted from sale_date.
SELECT
    sale_id,
    product_name,
    sale_date,
    MONTH(sale_date) AS sale_month
FROM joins.default.sales;

--Q4 Return each transaction with the year extracted from transaction_date.
SELECT
    transaction_id,
    customer_id,
    transaction_date,
    YEAR(transaction_date) AS transaction_year
FROM joins.default.transactions;

--Q5 Return each delivery with the day of the month extracted from delivery_date.
SELECT
    delivery_id,
    customer_id,
    delivery_date,
    DAY(delivery_date) AS day_of_month
FROM joins.default.deliveries;

--Questions 6–10  —  Current Date, Convert & Format
--Q6 Return all employees and add a column showing today's date
SELECT
    employee_id,
    employee_name,
    department,
    CURRENT_DATE() AS today_date
FROM joins.default.employees;

--Q7 ext string column into a proper date column.
SELECT
    order_id,
    customer_id,
    order_date_text,
    TO_DATE(order_date_text) AS order_date
FROM joins.default.online_orders;

--Q8 Format payment_date as a text string in the format YYYY-MM-DD.
SELECT
    payment_id,
    customer_id,
    payment_date,
    TO_CHAR(payment_date, 'yyyy-MM-dd') AS formatted_payment_date
FROM joins.default.payment_dates;

--Q9 Calculate how many days have passed since each customer's last purchase. Use today's date.
SELECT
    customer_id,
    customer_name,
    last_purchase_date,
    DATEDIFF(CURRENT_DATE(), last_purchase_date) AS days_since_last_purchase
FROM joins.default.customer_purchases;

--Q10 Calculate the expected delivery date by adding 7 days to the order_date.
SELECT
    order_id,
    customer_id,
    order_date,
    DATE_ADD(order_date, 7) AS expected_delivery_date
FROM joins.default.shipping_orders;

--Questions 11–15  —  Multi-Extract & Date Filtering
--Q11 Extract the year, month number, and day from booking_date into three separate columns.
SELECT
    booking_id,
    customer_id,
    booking_date,
    YEAR(booking_date) AS booking_year,
    MONTH(booking_date) AS booking_month,
    DAY(booking_date) AS booking_day
FROM joins.default.bookings;

--Q12 Return only orders from the year 2026.
SELECT
    order_id,
    customer_id,
    order_date,
    YEAR(order_date) AS order_year,
    amount
FROM joins.default.yearly_orders
WHERE YEAR(order_date) = 2026;

--Q13 Return only orders placed in March (month number 3).
SELECT
     order_id,
     customer_id,
     order_date,
     MONTH(order_date) AS order_month,
     amount
FROM joins.default.monthly_orders
WHERE MONTH(order_date) = 3;

--Q14 Return the last day of the month for each subscription start date.
SELECT
     subscription_id,
     customer_id,
     start_date,
     LAST_DAY(start_date) AS month_end_date
FROM joins.default.subscriptions;

--Q15 Return the first day of the month for each campaign send date.
SELECT
    send_id,
    customer_id,
    send_date,
    DATE_TRUNC('MONTH', send_date) AS month_start_date
FROM joins.default.campaign_sends;

--Questions 16–20  —  Advanced Date Work
--Q16 Format invoice_date as a text string showing month name and year. Example: January 2026.
SELECT
    invoice_id,
    customer_id,
    invoice_date,
    DATE_FORMAT(invoice_date, 'MMMM yyyy') AS invoice_month_year
FROM joins.default.invoice_dates;

--Q17 Calculate each customer's age in years using their date of birth and today's date.
SELECT
    customer_id,
    customer_name,
    date_of_birth,
    YEAR(CURRENT_DATE()) - YEAR(date_of_birth) AS customer_age
FROM joins.default.customer_birthdays;

--Q18 Classify each order as Weekend or Weekday based on the day name of the order date. Saturday and Sunday = Weekend. All others = Weekday.
SELECT
    order_id,
    customer_id,
    order_date,
    DAYNAME(order_date) AS day_name,
 CASE
        WHEN DAYNAME(order_date) IN ('Saturday', 'Sunday') THEN 'Weekend' ELSE 'Weekday'
    END AS day_type
FROM joins.default.weekend_orders;

--Q19 Extract the quarter number from each transaction date.
SELECT
    transaction_id,
    customer_id,
    transaction_date,
    QUARTER(transaction_date) AS transaction_quarter,
    amount
FROM joins.default.quarterly_transactions;

--Q20 Return only orders that are more than 30 days old from today. Calculate days_since_order using today's date.
SELECT
    order_id,
    customer_id,
    order_date,
    DATEDIFF(CURRENT_DATE(), order_date) AS days_since_order,
    amount
FROM joins.default.recent_orders
WHERE DATEDIFF(CURRENT_DATE(), order_date) > 30;

--Bonus Question Calculate days_since_last_purchase for each customer using CURRENT_DATE. Then use CASE to classify: ≤ 30 days = Active Customer, 31–90 days = At Risk Customer, > 90 days = Inactive Customer.
SELECT
    customer_id,
    customer_name,
    last_purchase_date,
    total_spend,
    DATEDIFF(CURRENT_DATE(), last_purchase_date) AS days_since_last_purchase,
    CASE
        WHEN DATEDIFF(CURRENT_DATE(), last_purchase_date) <= 30 THEN 'Active Customer'
        WHEN DATEDIFF(CURRENT_DATE(), last_purchase_date) BETWEEN 31 AND 90 THEN 'At Risk Customer'
       ELSE 'Inactive Customer'
 END AS customer_status
FROM joins.default.customer_recency;
