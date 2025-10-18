
--1 Query to Fetch Student Information Based on Faculty Details

SELECT s.student_id,
       s.student_name,
       sub.subject_name,
       f.faculty_name
FROM student AS s
JOIN student_subjects AS ss ON s.student_id = ss.student_id
JOIN subject AS sub ON ss.subject_id = sub.subject_id
JOIN faculty AS f  ON sub.faculty_id = f.faculty_id
WHERE f.faculty_id = 105;


--2 Business Expansion Solutions SQL Solution

SELECT 
    c.user_account_id,
    ua.first_name,
    ua.last_name,
    c.customer_id,
    cu.customer_name,
    COUNT(*) AS numbers
FROM contact AS c
JOIN user_account AS ua ON c.user_account_id = ua.id
JOIN customer AS cu ON c.customer_id = cu.id
GROUP BY 
    c.user_account_id, 
    ua.first_name, 
    ua.last_name, 
    c.customer_id, 
    cu.customer_name
HAVING COUNT(*) > 1;

---3 HR Employees with High Bonus SQL Solution

SELECT e.employee_id,
       e.employee_name,
       e.division,
       b.bonus
FROM employee_information AS e
JOIN last_quarter_bonus AS b 
  ON e.employee_id = b.employee_id
WHERE e.division = 'HR'
  AND b.bonus >= 5000;

---4 Products Sales Per City solved

SELECT cty.city_name,
p.product_name,
ROUND(SUM(ii.line_total_price), 2) as total_sales
FROM invoice_items AS ii
JOIN product AS p on ii.product_id = p.id    ---No direct connections between city and product,
JOIN invoice as inv on ii.invoice_id = inv.id  --- so tables are strung together in between
JOIN customer AS cus ON inv.customer_id = cus.id
JOIN city AS cty ON cus.city_id = cty.id
GROUP by cty.city_name, p.product_name
ORDER BY total_sales, cty.city_name, p.product_name

---5 Student Information and Examination Marks Query

select a.roll_number, a.name
from student_information as a
join examination_marks as b 
on a.roll_number = a.roll_number
where COALESCE(b.student_one, 0)
    +COALESCE(b.student_two, 0)
    +COALESCE(b.student_three,0) <100;

---6 Customer Spending Analysis SQL Answer

SELECT c.customer_id,
       c.customer_name,
       SUM(i.total_price) as total_spent
FROM customer AS c
JOIN invoice AS  i on c.customer_id = i.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(i.total_price) < 0.25*(SELECT AVG(total_price) From invoice)
ORDER by total_spent;

---7 Customers with Full Phone Numbers

select a.customer_name,
       concat('+',b.country_code,' ',a.phone_number) as full_phone
FROM customers as a
LEFT JOIN country_codes AS b ON a.country = b.country
ORDER BY a.customer_id;

---8 Quarterly Transaction Volume by Coin

SELECT c.Algorithm,
       SUM(CASE WHEN DATEPART(QUARTER, t.dt)=1 THEN t.Volume ELSE 0 END) AS Q1 -- ELSE 0!!
       SUM(CASE WHEN DATEPART(QUARTER, t.dt)=2 THEN t.Volume ELSE 0 END) AS Q2
       SUM(CASE WHEN DATEPART(QUARTER, t.dt)=3 THEN t.Volume ELSE 0 END) AS Q3
       SUM(CASE WHEN DATEPART(QUARTER, t.dt)=4 THEN t.Volume ELSE 0 END) AS Q4
FROM coins AS c
LEFT JOIN transactions AS t 
  ON c.code = t.coin_code 
 AND YEAR (t.dt) = 2020 ----This!!!!!
GROUP BY c.algorithm
ORDER BY
    C.Algorithm ASC;; 

---9 Products Without Sales

SELECT p.sku,
        p.product_name
FROM  products AS p
where not exists (     ----THIS!!!! NOT EXISTS OVER NOT IN 
    select 1 from invoice_item as ii 
    where ii.product_id =p.id
)
ORDER by p.product_name;

---10 Countries Whose Avg Invoice > Global Average

SELECT co.country_name,
       COUNT(DISTINCT cu.id) AS total_customers, ---here
       ROUND(AVG(i.total_price), 2) AS avg_invoice
FROM country AS co
JOIN city     AS ci ON co.id = ci.country_id
JOIN customer AS cu ON ci.id = cu.city_id
JOIN invoice  AS i  ON cu.id = i.customer_id
GROUP BY co.country_name
HAVING AVG(i.total_price) > (SELECT AVG(total_price) FROM invoice) --here
ORDER BY avg_invoice DESC;

---11 Customers Averaging ≤ ¼ of Global Avg Invoice

SELECT c.customer_name,
       ROUND(AVG(i.total_price), 2) AS avg_invoice
FROM customer AS c
JOIN invoice AS i ON c.customer_id = i.customer_id
GROUP BY c.customer_name
HAVING AVG(i.total_price) <= (SELECT AVG(total_price)/4 FROM invoice)
ORDER BY avg_invoice DESC;

---12 Stocks Whose Price Rises Tomorrow

SELECT a.stock_code,
       a.price  AS today_price,
       b.price  AS tomorrow_price
FROM price_today    AS a
JOIN price_tomorrow AS b ON a.stock_code = b.stock_code
WHERE b.price > a.price;

---13 Monthly Weather Summary

SELECT 
    MONTH(record_date) AS [month],
    MAX(CASE WHEN data_type = 'max' THEN data_value END) AS max_value,
    MIN(CASE WHEN data_type = 'min' THEN data_value END) AS min_value,
    ROUND(AVG(CASE WHEN data_type = 'avg' THEN data_value END), 0) AS avg_value
FROM weather
GROUP BY MONTH(record_date)
ORDER BY [month];

---14 Weekend Hours Worked per Employee

SET DATEFIRST 1;

WITH Lagged AS (
    SELECT 
        emp_id,
        [timestamp],
        LAG([timestamp]) OVER (
            PARTITION BY emp_id, CAST([timestamp] AS date)
            ORDER BY [timestamp]
        ) AS prev_ts
    FROM attendance
    WHERE DATEPART(WEEKDAY, [timestamp]) IN (6, 7)  -- 6=Saturday, 7=Sunday when DATEFIRST=1
),
Worked AS (
    SELECT 
        emp_id,
        DATEDIFF(SECOND, prev_ts, [timestamp]) / 3600.0 AS hours_worked
    FROM Lagged
    WHERE prev_ts IS NOT NULL
)
SELECT 
    emp_id,
    ROUND(SUM(hours_worked), 2) AS weekend_hours
FROM Worked
GROUP BY emp_id;

---15 Crypto Sequences ≥150 in <1-Hour Gaps

WITH Diff AS (
  SELECT sender,
         dt,
         amount,
         LAG(dt) OVER (PARTITION BY sender ORDER BY dt) AS prev_dt
  FROM krypto
),
SeqFlags AS (
  SELECT sender,
         dt,
         amount,
         CASE WHEN prev_dt IS NULL 
               OR EXTRACT(EPOCH FROM (dt - prev_dt))/60 >= 60 
              THEN 1 ELSE 0 END AS is_new_seq
  FROM Diff
),
Numbered AS (
  SELECT sender,
         dt,
         amount,
         SUM(is_new_seq) OVER (
             PARTITION BY sender 
             ORDER BY dt 
             ROWS UNBOUNDED PRECEDING
         ) AS seq_id
  FROM SeqFlags
)
SELECT sender,
       MIN(dt) AS seq_start,
       MAX(dt) AS seq_end,
       COUNT(*) AS txn_count,
       SUM(amount) AS total_amount
FROM Numbered
GROUP BY sender, seq_id
HAVING SUM(amount) >= 150
ORDER BY sender, seq_start;

---16 Duplicate Customer Contacts

SELECT ua.first_name, ua.last_name, c.customer_name, COUNT(*) AS total_contacts
FROM contact AS ct
JOIN user_account AS ua ON ct.user_account_id = ua.user_account_id
JOIN customer AS c ON ct.customer_id = c.customer_id
GROUP BY ua.first_name, ua.last_name, c.customer_name
HAVING COUNT(*) > 1;

---17 Top-Selling Product per City

WITH CitySales AS (
  SELECT ci.city_name,
         p.product_name,
         SUM(ii.line_total_price) AS total_sales
  FROM invoice_item AS ii
  JOIN product AS p ON ii.product_id = p.id
  JOIN invoice AS i ON ii.invoice_id = i.id
  JOIN customer AS cu ON i.customer_id = cu.id
  JOIN city AS ci ON cu.city_id = ci.id
  GROUP BY ci.city_name, p.product_name
),
Ranked AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY city_name ORDER BY total_sales DESC) AS rnk
  FROM CitySales
)
SELECT city_name, product_name, total_sales
FROM Ranked
WHERE rnk = 1;

---18 Customers with Below-Average Spending

SELECT c.customer_name,
       ROUND(AVG(i.total_price),2) AS avg_invoice
FROM customer AS c
JOIN invoice AS i ON c.customer_id = i.customer_id
GROUP BY c.customer_name
HAVING AVG(i.total_price) <= (SELECT AVG(total_price)/4 FROM invoice)
ORDER BY avg_invoice;

----19- 15 Days of Learning SQL

WITH RECURSIVE date_list AS (
    -- Step 1: Generate all distinct submission dates in order
    SELECT MIN(submission_date) AS submission_date
    FROM submissions
    UNION ALL
    SELECT (
        SELECT MIN(submission_date)
        FROM submissions
        WHERE submission_date > d.submission_date
    )
    FROM date_list d
    WHERE (
        SELECT MIN(submission_date)
        FROM submissions
        WHERE submission_date > d.submission_date
    ) IS NOT NULL
),
-- Step 2: Count unique hackers (active up to each date)
unique_hackers AS (
    SELECT d.submission_date,
           COUNT(DISTINCT s.hacker_id) AS unique_hackers
    FROM date_list d
    JOIN submissions s
      ON s.submission_date <= d.submission_date
    GROUP BY d.submission_date
),
-- Step 3: Count submissions per hacker per day
count_submissions AS (
    SELECT submission_date,
           hacker_id,
           COUNT(*) AS num_submissions
    FROM submissions
    GROUP BY submission_date, hacker_id
),
-- Step 4: Find max submissions per date
max_submissions AS (
    SELECT submission_date,
           MAX(num_submissions) AS max_num
    FROM count_submissions
    GROUP BY submission_date
),
-- Step 5: Identify hacker(s) with that max count
final_hackers AS (
    SELECT c.submission_date,
           MIN(c.hacker_id) AS hacker_id  -- tie-break by lowest ID
    FROM count_submissions c
    JOIN max_submissions m
      ON m.submission_date = c.submission_date
     AND m.max_num = c.num_submissions
    GROUP BY c.submission_date
)
-- Step 6: Final output
SELECT u.submission_date,
       u.unique_hackers,
       f.hacker_id,
       h.name AS hacker_name
FROM unique_hackers u
JOIN final_hackers f ON f.submission_date = u.submission_date
JOIN hackers h ON h.hacker_id = f.hacker_id
ORDER BY u.submission_date;

--- 20 Hierarchical Employee Reporting (Recursion / Self-Join)

WITH RECURSIVE hierarchy AS (
  SELECT id, name, manager_id, name AS top_manager
  FROM employees
  WHERE manager_id IS NULL
  UNION ALL
  SELECT e.id, e.name, e.manager_id, h.top_manager
  FROM employees e
  JOIN hierarchy h ON e.manager_id = h.id
)
SELECT * FROM hierarchy ORDER BY top_manager, name;

---21 Consecutive Login Streaks

WITH dated AS (
  SELECT user_id,
         login_date,
         login_date - INTERVAL ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_date) DAY AS grp
  FROM logins
)
SELECT user_id, COUNT(*) AS streak_length
FROM dated
GROUP BY user_id, grp
HAVING COUNT(*) = (
   SELECT MAX(cnt)
   FROM (
      SELECT user_id, COUNT(*) AS cnt FROM dated GROUP BY user_id, grp
   ) t WHERE t.user_id = dated.user_id
);

---22 Running Totals and Rank (Cumulative Queries)

SELECT customer_id,
       invoice_date,
       SUM(total_price) OVER (PARTITION BY customer_id ORDER BY invoice_date) AS running_total
FROM invoices;

---23 Stock Market Session Gains

SELECT stock_code,
       trade_date,
       price,
       LAG(price) OVER (PARTITION BY stock_code ORDER BY trade_date) AS prev_price
FROM stock_prices
WHERE price > LAG(price) OVER (PARTITION BY stock_code ORDER BY trade_date);

---24 Daily Cumulative User Growth

WITH RECURSIVE dates AS (
  SELECT MIN(signup_date) AS d FROM users
  UNION ALL
  SELECT d + INTERVAL 1 DAY FROM dates
  WHERE d + INTERVAL 1 DAY <= (SELECT MAX(signup_date) FROM users)
)
SELECT d AS date,
       COUNT(DISTINCT u.user_id) AS total_users
FROM dates
LEFT JOIN users u ON u.signup_date <= d
GROUP BY d
ORDER BY d;

---25 Employee Salary Progression

SELECT emp_id,
       salary_date,
       salary,
       salary - LAG(salary) OVER (PARTITION BY emp_id ORDER BY salary_date) AS diff
FROM salary_history;

---26 Detect Gaps in Data (Missing Dates)

WITH RECURSIVE calendar AS (
  SELECT DATE '2023-01-01' AS dt
  UNION ALL
  SELECT dt + INTERVAL 1 DAY FROM calendar
  WHERE dt < DATE '2023-12-31'
)
SELECT p.product_id, c.dt
FROM products p
CROSS JOIN calendar c
LEFT JOIN sales s
  ON s.product_id = p.product_id AND s.sale_date = c.dt
WHERE s.sale_date IS NULL;

---27 Longest Increasing Sequence (Advanced)

WITH ranked AS (
  SELECT submission_date,
         hacker_id,
         COUNT(*) AS submissions,
         DENSE_RANK() OVER (PARTITION BY submission_date ORDER BY COUNT(*) DESC, hacker_id ASC) AS rnk
  FROM submissions
  GROUP BY submission_date, hacker_id
)
SELECT submission_date, hacker_id
FROM ranked
WHERE rnk = 1;

---28 Cumulative Percentage Contribution

SELECT product_id,
       SUM(sales) OVER (ORDER BY sales DESC) * 100.0 / SUM(sales) OVER () AS cumulative_percentage
FROM product_sales
ORDER BY sales DESC;

--29 Occupations

WITH RankedOccupations AS (
    SELECT 
        Name,
        Occupation,
        ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
    FROM OCCUPATIONS
)

SELECT 
    MAX(CASE WHEN Occupation = 'Doctor'    THEN Name END) AS Doctor,
    MAX(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
    MAX(CASE WHEN Occupation = 'Singer'    THEN Name END) AS Singer,
    MAX(CASE WHEN Occupation = 'Actor'     THEN Name END) AS Actor
FROM RankedOccupations
GROUP BY rn
ORDER BY rn;