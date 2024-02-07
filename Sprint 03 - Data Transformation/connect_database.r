## Create Data
menus <- tribble(
  ~menu_id, ~menu_name, ~menu_price,
  1, 'Black Pink', 999,
  2, 'Alaska Crab', 599,
  3, 'Truffle Master', 499
)

customers <- tribble(
  ~customer_id, ~name, ~phone,
  1, 'Saka', '0812345678',
  2, 'Son', '0823456789',
  3, 'Silva', '0834567890'
)

orders <- tribble(
  ~order_id, ~order_date, ~customer_id, ~menu_id, ~quantity,
  1, '2023-10-21', 1, 2, 2,
  2, '2023-10-21', 2, 1, 2,
  3, '2023-10-24', 3, 2, 2,
  4, '2023-10-28', 1, 1, 5,
  5, '2023-10-28', 2, 1, 2,
  6, '2023-10-28', 3, 3, 2,
  7, '2023-11-05', 1, 3, 1
)

## connect to PostgreSQL server
## create connection
con <- dbConnect(
  PostgreSQL(),
  host = "arjuna.db.elephantsql.com",
  dbname = "gnksigjf",
  user = "gnksigjf",
  password = "q8DpMeQrWfVmdj7Mvr4dpSj33yFNVGGY",
  port = 5432
)

## db List Tables
dbListTables(con)

## write table to database
dbWriteTable(con, "menus", menus, row.names = FALSE)
dbWriteTable(con, "customers", customers, row.names = FALSE)
dbWriteTable(con, "orders", orders, row.names = FALSE)

## view table in database
dbGetQuery(con, "SELECT * from menus")
dbGetQuery(con, "SELECT * from customers")
dbGetQuery(con, "SELECT * from orders")

## Top Menu
df1 <- dbGetQuery(con, "SELECT
    menu_name,
    sum(quantity) AS total_order,
    sum(quantity * menu_price) AS total_price
FROM menus AS tme
JOIN orders AS tor
ON tme.menu_id = tor.menu_id
GROUP by 1
ORDER by 2 DESC")

## Top Customer
df2 <- dbGetQuery(con, "SELECT
    name,
    sum(quantity) AS total_order,
    sum(quantity * menu_price) AS total_price
FROM orders AS tor
JOIN customers AS tcu
ON tcu.customer_id = tor.customer_id
JOIN menus AS tme
ON tme.menu_id = tor.menu_id
GROUP by 1
ORDER by 3 DESC")

## close connection
dbDisconnect(con)
