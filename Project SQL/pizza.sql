-- Create Table
CREATE TABLE menus (
  menuid INT,
  itemname TEXT,
  price REAL
);

CREATE TABLE customers (
  customerid INT,
  name VARCHAR(20),
  phone INT
);

CREATE TABLE orders (
  orderid INT,
  orderdate DATE,
  customerid INT,
  menuid INT,
  quantity REAL
);

-- Insert sample data
INSERT Into menus values
  (1, 'Black Pink', 999),
  (2, 'Alaska Crab', 599),
  (3, 'Truffle Master', 499);

INSERT Into customers values
  (1, 'Saka', 0812345678),
  (2, 'Son', 0823456789),
  (3, 'Silva', 0834567890);

INSERT Into orders values
  (1, '2023-10-21', 1, 2, 2),
  (2, '2023-10-21', 2, 1, 2),
  (3, '2023-10-24', 3, 2, 2),
  (4, '2023-10-28', 1, 1, 5),
  (5, '2023-10-28', 2, 1, 2),
  (6, '2023-10-28', 3, 3, 2),
  (7, '2023-11-05', 1, 3, 1);

.mode box
-- sum order of october
SELECT
    itemname,
    sum(quantity) AS n_order,
    sum(quantity * price) as total_price
from (
  SELECT * FROM menus
) as tme
join (
  SELECT * from orders
  WHERE STRFTIME('%Y%m', orderdate) = '202310' 
) as tor
ON tme.menuid = tor.menuid
GROUP by 1
order by 2 DESC;

-- top order month of october -- basic
SELECT
    itemname,
    name,    
    SUM(quantity) AS total_order
from orders AS tor
JOIN customers AS tcu ON tor.customerid = tcu.customerid 
JOIN menus AS tme ON tor.menuid = tme.menuid
WHERE itemname = 'Black Pink' AND STRFTIME('%Y%m', orderdate) = '202310'
GROUP by 2
limit 1;

-- top order month of october -- WITH
WITH menu_bp as (
  SELECT * FROM menus
  WHERE itemname = 'Black Pink'
), sale_oct AS (
  SELECT * from orders
  WHERE STRFTIME('%Y%m', orderdate) = '202310'
)

SELECT
    itemname,
    name,
    SUM(quantity) AS total_order
FROM menu_bp AS tme
JOIN sale_oct AS tor ON tme.menuid = tor.menuid
join customers as tcu on tor.customerid = tcu.customerid
group by 2
LIMIT 1;

-- Aggregate Function
SELECT
    tcu.name as name,
    MAX(tor.quantity) as maxorder,
    SUM(tor.quantity * tme.price) AS total_price,
    ROUND(AVG(tor.quantity * tme.price), 2) AS avg,
    COUNT(*) AS n_order
from orders AS tor
JOIN customers AS tcu ON tor.customerid = tcu.customerid 
JOIN menus AS tme ON tor.menuid = tme.menuid
GROUP by name;
