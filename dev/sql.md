# SQL Cheatsheet

> Structured Query Language for managing and querying relational databases.
> Last verified: May 2026 | Version: SQL:2023 standard

---

## Quick Reference

| Command | Description |
|---|---|
| `SELECT * FROM table` | Retrieve all rows |
| `SELECT col FROM t WHERE cond` | Filter rows |
| `INSERT INTO t (col) VALUES (val)` | Insert a row |
| `UPDATE t SET col=val WHERE cond` | Update rows |
| `DELETE FROM t WHERE cond` | Delete rows |
| `CREATE TABLE t (col type)` | Create table |
| `DROP TABLE t` | Delete table |
| `ALTER TABLE t ADD col type` | Add column |
| `JOIN ... ON ...` | Join tables |
| `GROUP BY col` | Aggregate rows |
| `ORDER BY col DESC` | Sort results |
| `LIMIT n` | Limit rows returned |
| `WITH cte AS (...)` | Common Table Expression |
| `CREATE INDEX idx ON t(col)` | Create index |
| `BEGIN; ... COMMIT;` | Transaction |

---

## Data Types

### Common Data Types (Standard SQL)

```sql
-- Numeric
INTEGER         -- 4-byte int (-2B to 2B)
BIGINT          -- 8-byte int
SMALLINT        -- 2-byte int
DECIMAL(p,s)    -- exact decimal, p=precision, s=scale
NUMERIC(p,s)    -- same as DECIMAL
FLOAT           -- approximate float
REAL            -- 4-byte float
DOUBLE PRECISION -- 8-byte float
SERIAL          -- auto-increment int (PostgreSQL)
AUTO_INCREMENT  -- auto-increment int (MySQL)

-- String
VARCHAR(n)      -- variable length string, max n chars
CHAR(n)         -- fixed length string
TEXT            -- unlimited length string
CLOB            -- character large object

-- Date/Time
DATE            -- YYYY-MM-DD
TIME            -- HH:MM:SS
TIMESTAMP       -- date + time
TIMESTAMPTZ     -- timestamp with timezone
INTERVAL        -- time interval

-- Boolean
BOOLEAN         -- TRUE / FALSE / NULL

-- Binary
BLOB            -- binary large object
BYTEA           -- PostgreSQL binary
VARBINARY(n)    -- variable binary
```

---

## CRUD Operations

### SELECT

```sql
-- All columns, all rows
SELECT * FROM users;

-- Specific columns
SELECT id, name, email FROM users;

-- With alias
SELECT id, name AS full_name, email FROM users;
SELECT u.id, u.name FROM users u;  -- table alias

-- Distinct values
SELECT DISTINCT country FROM customers;
SELECT DISTINCT ON (department) name, salary FROM employees
ORDER BY department, salary DESC;

-- Calculated columns
SELECT price, quantity, price * quantity AS total FROM order_items;

-- Limit rows
SELECT * FROM products LIMIT 10;
SELECT * FROM products LIMIT 10 OFFSET 20;  -- page 3

-- Order results
SELECT * FROM users ORDER BY name ASC;
SELECT * FROM users ORDER BY created_at DESC;
SELECT * FROM users ORDER BY last_name ASC, first_name ASC;

-- Conditional expressions
SELECT
    name,
    CASE
        WHEN age < 18 THEN 'minor'
        WHEN age < 65 THEN 'adult'
        ELSE 'senior'
    END AS age_group
FROM users;

SELECT
    price,
    CASE category
        WHEN 'electronics' THEN price * 0.9
        WHEN 'clothing' THEN price * 0.8
        ELSE price
    END AS discounted_price
FROM products;
```

### WHERE Clause

```sql
-- Basic comparisons
SELECT * FROM users WHERE age = 30;
SELECT * FROM users WHERE age > 18;
SELECT * FROM users WHERE age >= 18;
SELECT * FROM users WHERE age != 30;
SELECT * FROM users WHERE age <> 30;  -- same as !=

-- NULL checks
SELECT * FROM users WHERE email IS NULL;
SELECT * FROM users WHERE email IS NOT NULL;

-- Range
SELECT * FROM products WHERE price BETWEEN 10 AND 50;

-- IN list
SELECT * FROM users WHERE country IN ('US', 'UK', 'CA');
SELECT * FROM users WHERE id NOT IN (1, 2, 3);

-- Pattern matching (LIKE)
SELECT * FROM users WHERE name LIKE 'A%';      -- starts with A
SELECT * FROM users WHERE name LIKE '%son';    -- ends with son
SELECT * FROM users WHERE name LIKE '%ali%';  -- contains ali
SELECT * FROM users WHERE name ILIKE '%ali%'; -- case insensitive (PostgreSQL)
SELECT * FROM products WHERE name NOT LIKE '%sale%';

-- Regex (PostgreSQL)
SELECT * FROM users WHERE name ~ '^A';         -- regex match
SELECT * FROM users WHERE name !~ '^A';        -- no match
SELECT * FROM users WHERE name ~* '^a';        -- case-insensitive

-- Logical operators
SELECT * FROM users WHERE age > 18 AND country = 'US';
SELECT * FROM users WHERE age < 18 OR age > 65;
SELECT * FROM users WHERE NOT (age BETWEEN 18 AND 65);

-- Subquery in WHERE
SELECT * FROM orders WHERE user_id IN (
    SELECT id FROM users WHERE country = 'US'
);

SELECT * FROM products WHERE price > (
    SELECT AVG(price) FROM products
);
```

### INSERT

```sql
-- Single row
INSERT INTO users (name, email, age) VALUES ('Alice', 'alice@example.com', 30);

-- Multiple rows
INSERT INTO users (name, email) VALUES
    ('Alice', 'alice@example.com'),
    ('Bob', 'bob@example.com'),
    ('Carol', 'carol@example.com');

-- Insert from SELECT
INSERT INTO archive_users (id, name, email)
SELECT id, name, email FROM users WHERE active = FALSE;

-- Insert with returning (PostgreSQL)
INSERT INTO users (name, email) VALUES ('Dave', 'dave@example.com')
RETURNING id, created_at;

-- Upsert (PostgreSQL)
INSERT INTO users (email, name) VALUES ('alice@example.com', 'Alice')
ON CONFLICT (email) DO UPDATE SET name = EXCLUDED.name;

-- Upsert (MySQL)
INSERT INTO users (email, name) VALUES ('alice@example.com', 'Alice')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Ignore duplicates
INSERT IGNORE INTO users (email) VALUES ('alice@example.com');  -- MySQL
INSERT INTO users (email) VALUES ('a@b.com') ON CONFLICT DO NOTHING;  -- PostgreSQL
```

### UPDATE

```sql
-- Update all matching rows
UPDATE users SET active = TRUE WHERE age >= 18;

-- Update multiple columns
UPDATE products
SET price = price * 0.9, updated_at = NOW()
WHERE category = 'electronics';

-- Update with subquery
UPDATE orders
SET status = 'complete'
WHERE user_id IN (SELECT id FROM premium_users);

-- Update with JOIN (PostgreSQL)
UPDATE orders o
SET shipping_cost = s.cost
FROM shipping_rates s
WHERE o.zone = s.zone;

-- Update with JOIN (MySQL)
UPDATE orders o
JOIN shipping_rates s ON o.zone = s.zone
SET o.shipping_cost = s.cost;

-- Update returning (PostgreSQL)
UPDATE users SET name = 'Alice Smith' WHERE id = 1
RETURNING id, name, updated_at;
```

### DELETE

```sql
-- Delete matching rows
DELETE FROM users WHERE active = FALSE;

-- Delete all rows (but keep table)
DELETE FROM users;
TRUNCATE TABLE users;          -- faster, non-transactional in some DBs
TRUNCATE TABLE users RESTART IDENTITY;  -- also reset sequences (PostgreSQL)

-- Delete with subquery
DELETE FROM orders
WHERE user_id IN (SELECT id FROM users WHERE deleted_at IS NOT NULL);

-- Delete with JOIN (MySQL)
DELETE o FROM orders o
JOIN users u ON o.user_id = u.id
WHERE u.banned = TRUE;

-- Delete returning (PostgreSQL)
DELETE FROM users WHERE id = 1 RETURNING *;
```

---

## Joins

```sql
-- INNER JOIN — only matching rows in both tables
SELECT u.name, o.total
FROM users u
INNER JOIN orders o ON u.id = o.user_id;

-- LEFT JOIN (LEFT OUTER JOIN) — all left rows, nulls for non-matches
SELECT u.name, o.total
FROM users u
LEFT JOIN orders o ON u.id = o.user_id;

-- RIGHT JOIN — all right rows, nulls for non-matches
SELECT u.name, o.total
FROM users u
RIGHT JOIN orders o ON u.id = o.user_id;

-- FULL OUTER JOIN — all rows from both, nulls where no match
SELECT u.name, o.total
FROM users u
FULL OUTER JOIN orders o ON u.id = o.user_id;

-- CROSS JOIN — cartesian product (every combo)
SELECT colors.name, sizes.name
FROM colors CROSS JOIN sizes;

-- SELF JOIN — table joined to itself
SELECT e.name AS employee, m.name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;

-- Multiple joins
SELECT u.name, p.title, c.content
FROM users u
JOIN posts p ON p.user_id = u.id
JOIN comments c ON c.post_id = p.id
WHERE u.active = TRUE;

-- Join with aggregation
SELECT u.name, COUNT(o.id) AS order_count, SUM(o.total) AS total_spent
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
GROUP BY u.id, u.name
ORDER BY total_spent DESC;
```

---

## Aggregation

### GROUP BY & HAVING

```sql
-- Count
SELECT country, COUNT(*) AS user_count
FROM users
GROUP BY country
ORDER BY user_count DESC;

-- Multiple aggregations
SELECT
    department,
    COUNT(*) AS headcount,
    AVG(salary) AS avg_salary,
    MAX(salary) AS max_salary,
    MIN(salary) AS min_salary,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department;

-- HAVING (filter after aggregation)
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 60000;

-- WHERE + GROUP BY + HAVING
SELECT category, COUNT(*) AS cnt, AVG(price) AS avg_price
FROM products
WHERE active = TRUE
GROUP BY category
HAVING COUNT(*) >= 5
ORDER BY avg_price DESC;

-- GROUP BY with ROLLUP (adds subtotals)
SELECT region, department, SUM(sales)
FROM data
GROUP BY ROLLUP(region, department);
```

### Aggregate Functions

```sql
COUNT(*)             -- count all rows
COUNT(col)           -- count non-null values
COUNT(DISTINCT col)  -- count unique non-null values
SUM(col)             -- sum
AVG(col)             -- average
MIN(col)             -- minimum
MAX(col)             -- maximum
STRING_AGG(col, ',') -- concatenate strings (PostgreSQL)
GROUP_CONCAT(col)    -- concatenate strings (MySQL)
ARRAY_AGG(col)       -- collect into array (PostgreSQL)
JSON_AGG(col)        -- collect into JSON array (PostgreSQL)
BOOL_AND(col)        -- true if all values are true (PostgreSQL)
BOOL_OR(col)         -- true if any value is true (PostgreSQL)
```

---

## Subqueries

```sql
-- Scalar subquery (single value)
SELECT name, salary,
    (SELECT AVG(salary) FROM employees) AS company_avg
FROM employees;

-- Row subquery
SELECT * FROM users
WHERE (country, city) = (SELECT country, city FROM offices WHERE name = 'HQ');

-- Table subquery (derived table)
SELECT dept, avg_sal
FROM (
    SELECT department AS dept, AVG(salary) AS avg_sal
    FROM employees
    GROUP BY department
) AS dept_stats
WHERE avg_sal > 50000;

-- EXISTS / NOT EXISTS
SELECT * FROM users u
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.user_id = u.id
);

SELECT * FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.user_id = u.id
);

-- Correlated subquery (references outer query)
SELECT name, salary
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department = e1.department
);
```

---

## Common Table Expressions (CTEs)

```sql
-- Basic CTE
WITH recent_orders AS (
    SELECT user_id, COUNT(*) AS cnt, SUM(total) AS total
    FROM orders
    WHERE created_at >= NOW() - INTERVAL '30 days'
    GROUP BY user_id
)
SELECT u.name, ro.cnt, ro.total
FROM users u
JOIN recent_orders ro ON u.id = ro.user_id
ORDER BY ro.total DESC;

-- Multiple CTEs
WITH
    active_users AS (
        SELECT * FROM users WHERE active = TRUE
    ),
    high_spenders AS (
        SELECT user_id, SUM(total) AS spent
        FROM orders
        GROUP BY user_id
        HAVING SUM(total) > 1000
    )
SELECT u.name, hs.spent
FROM active_users u
JOIN high_spenders hs ON u.id = hs.user_id;

-- Recursive CTE (hierarchy traversal)
WITH RECURSIVE org_chart AS (
    -- Base case: top-level employees
    SELECT id, name, manager_id, 0 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive case: employees under each manager
    SELECT e.id, e.name, e.manager_id, oc.level + 1
    FROM employees e
    JOIN org_chart oc ON e.manager_id = oc.id
)
SELECT REPEAT('  ', level) || name AS hierarchy
FROM org_chart
ORDER BY level, name;
```

---

## Window Functions

```sql
-- ROW_NUMBER — unique number per row in partition
SELECT name, department, salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
FROM employees;

-- RANK — tied rows get same rank, gaps after ties
SELECT name, salary,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

-- DENSE_RANK — tied rows get same rank, no gaps
SELECT name, salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

-- NTILE — divide rows into n buckets
SELECT name, salary,
    NTILE(4) OVER (ORDER BY salary DESC) AS quartile
FROM employees;

-- LAG / LEAD — access previous/next row
SELECT date, revenue,
    LAG(revenue, 1) OVER (ORDER BY date) AS prev_revenue,
    revenue - LAG(revenue, 1) OVER (ORDER BY date) AS change
FROM monthly_revenue;

-- FIRST_VALUE / LAST_VALUE
SELECT name, department, salary,
    FIRST_VALUE(name) OVER (PARTITION BY department ORDER BY salary DESC) AS top_earner
FROM employees;

-- Running total (cumulative sum)
SELECT date, amount,
    SUM(amount) OVER (ORDER BY date ROWS UNBOUNDED PRECEDING) AS running_total
FROM transactions;

-- Moving average
SELECT date, revenue,
    AVG(revenue) OVER (ORDER BY date ROWS 6 PRECEDING) AS rolling_7day_avg
FROM daily_revenue;
```

---

## Table & Schema Management

### CREATE TABLE

```sql
CREATE TABLE users (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(255) UNIQUE NOT NULL,
    age         INTEGER CHECK (age >= 0 AND age <= 150),
    country     CHAR(2) DEFAULT 'US',
    bio         TEXT,
    salary      DECIMAL(10, 2),
    active      BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- With constraints
CREATE TABLE orders (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    total       DECIMAL(10,2) NOT NULL CHECK (total > 0),
    status      VARCHAR(20) DEFAULT 'pending'
        CHECK (status IN ('pending', 'paid', 'shipped', 'complete')),
    created_at  TIMESTAMP DEFAULT NOW()
);

-- Composite primary key
CREATE TABLE user_roles (
    user_id     INTEGER REFERENCES users(id),
    role_id     INTEGER REFERENCES roles(id),
    PRIMARY KEY (user_id, role_id)
);
```

### ALTER TABLE

```sql
-- Add column
ALTER TABLE users ADD COLUMN phone VARCHAR(20);

-- Drop column
ALTER TABLE users DROP COLUMN phone;

-- Rename column
ALTER TABLE users RENAME COLUMN old_name TO new_name;

-- Change column type
ALTER TABLE users ALTER COLUMN age TYPE BIGINT;  -- PostgreSQL
ALTER TABLE users MODIFY COLUMN age BIGINT;       -- MySQL

-- Set default
ALTER TABLE users ALTER COLUMN active SET DEFAULT TRUE;

-- Add constraint
ALTER TABLE users ADD CONSTRAINT uq_email UNIQUE (email);
ALTER TABLE orders ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE users ADD CONSTRAINT chk_age CHECK (age >= 0);

-- Drop constraint
ALTER TABLE users DROP CONSTRAINT uq_email;

-- Rename table
ALTER TABLE old_name RENAME TO new_name;
```

### Indexes

```sql
-- Create index
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_created ON orders(created_at DESC);

-- Unique index
CREATE UNIQUE INDEX idx_email ON users(email);

-- Composite index
CREATE INDEX idx_name_country ON users(name, country);

-- Partial index (PostgreSQL)
CREATE INDEX idx_active_users ON users(email) WHERE active = TRUE;

-- Expression index (PostgreSQL)
CREATE INDEX idx_lower_email ON users(LOWER(email));

-- Full-text index (PostgreSQL)
CREATE INDEX idx_search ON products USING gin(to_tsvector('english', name || ' ' || description));

-- Drop index
DROP INDEX idx_users_email;

-- Show indexes (MySQL)
SHOW INDEX FROM users;

-- Show indexes (PostgreSQL)
SELECT indexname, indexdef FROM pg_indexes WHERE tablename = 'users';
```

---

## Transactions

```sql
-- Basic transaction
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;

-- Rollback on error
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
-- Something went wrong...
ROLLBACK;

-- Savepoints
BEGIN;
INSERT INTO orders (user_id, total) VALUES (1, 100);
SAVEPOINT sp1;
INSERT INTO order_items (order_id, product_id) VALUES (LASTVAL(), 5);
-- If this fails, rollback to savepoint only
ROLLBACK TO SAVEPOINT sp1;
COMMIT;

-- Isolation levels
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

---

## Common SQL Functions

```sql
-- String functions
UPPER(str)              -- uppercase
LOWER(str)              -- lowercase
LENGTH(str)             -- character count
CHAR_LENGTH(str)        -- same as LENGTH in most DBs
TRIM(str)               -- remove whitespace from both ends
LTRIM(str)              -- left trim
RTRIM(str)              -- right trim
SUBSTRING(str, start, len)  -- extract substring
LEFT(str, n)            -- first n characters
RIGHT(str, n)           -- last n characters
REPLACE(str, from, to)  -- replace all occurrences
CONCAT(s1, s2)          -- concatenate strings
CONCAT_WS(',', s1, s2)  -- concatenate with separator
POSITION(sub IN str)    -- position of substring
LIKE, ILIKE             -- pattern matching

-- Numeric functions
ROUND(n, decimal_places)
CEIL(n) / CEILING(n)
FLOOR(n)
ABS(n)
MOD(n, divisor)
POWER(base, exp)
SQRT(n)
RANDOM()                -- 0.0 to 1.0 (PostgreSQL)
RAND()                  -- 0.0 to 1.0 (MySQL)

-- Date/Time functions
NOW()                   -- current timestamp with timezone
CURRENT_TIMESTAMP       -- current timestamp
CURRENT_DATE            -- today's date
CURRENT_TIME            -- current time
DATE_TRUNC('month', ts) -- truncate to month (PostgreSQL)
EXTRACT(year FROM ts)   -- extract year
DATE_PART('hour', ts)   -- extract part (PostgreSQL)
AGE(ts)                 -- interval from ts to now (PostgreSQL)
DATE_ADD(date, INTERVAL) -- MySQL
date + INTERVAL '1 day'  -- PostgreSQL interval math
DATEDIFF(end, start)    -- days between dates (MySQL)
TO_CHAR(ts, 'YYYY-MM-DD') -- format date (PostgreSQL)
DATE_FORMAT(ts, '%Y-%m-%d') -- format date (MySQL)

-- NULL functions
COALESCE(a, b, c)       -- first non-null value
NULLIF(a, b)            -- null if a = b, else a
ISNULL(val, default)    -- replace null (SQL Server/MySQL)
NVL(val, default)       -- replace null (Oracle)
```

---

## Tips & Tricks

- Use `EXPLAIN` (or `EXPLAIN ANALYZE` in PostgreSQL) to understand query performance.
- Indexes speed up reads but slow down writes — index columns used in WHERE and JOIN.
- CTEs can make complex queries readable, but sometimes a subquery is faster.
- `SELECT 1` in EXISTS subqueries is conventional and equivalent to `SELECT *`.
- Avoid `SELECT *` in production — list columns explicitly for clarity and performance.
- Use parameterized queries (prepared statements) to prevent SQL injection.
- `TRUNCATE` is much faster than `DELETE FROM table` but cannot be rolled back in some DBs.
- Window functions run after WHERE and GROUP BY but before ORDER BY and LIMIT.
- Composite indexes should list the highest-cardinality column first for best performance.
- `RETURNING` in PostgreSQL lets you get inserted/updated rows without a second query.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
