# PostgreSQL Cheatsheet

> Production-grade reference for PostgreSQL administration, queries, and optimization.
> Last verified: May 2026 | Version: 16.x / 17.x

---

## Quick Reference

| Command / Query | Description |
|---|---|
| `psql -U username -d dbname` | Connect to PostgreSQL database |
| `\\l` | List all databases |
| `\c dbname` | Connect to a database |
| `\dt` | List all tables in current database |
| `\d+ tablename` | Show table schema and detail |
| `\df` | List functions |
| `\dx` | List installed extensions |
| `EXPLAIN ANALYZE <query>` | Show query execution plan and runtime |
| `SELECT pg_reload_conf();` | Reload configuration files without restart |

---

## Connection & Command Line

### Interactive Shell (psql)
```bash
# Connect as default user (postgres) to default database
psql -U postgres

# Connect to specific host, port, database and user
psql -h localhost -p 5432 -U myuser -d mydb

# Run a single query directly from the shell and exit
psql -U myuser -d mydb -c "SELECT * FROM users LIMIT 10;"

# Export query results directly to CSV file
psql -U myuser -d mydb -A -F "," -c "SELECT * FROM users" > output.csv
```

### Essential psql Meta-Commands
```bash
\conninfo      # Display connection details
\q             # Exit the shell
\?             # Show all psql meta-command help
\h             # Show SQL syntax help (e.g. \h SELECT)
\dt+           # List tables with size and description
\di            # List indexes
\dv            # List views
\dn            # List schemas
\du            # List users and their roles
```

---

## Database & Table Operations

### Schema Management
```sql
-- Create database with UTF-8 encoding
CREATE DATABASE prod_db WITH ENCODING 'UTF8';

-- Create schema
CREATE SCHEMA api;

-- Create table with common PostgreSQL constraints and data types
CREATE TABLE api.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) NOT NULL CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$'),
    age INT DEFAULT 18,
    profile JSONB,
    tags TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

### Array & JSONB Operations
```sql
-- Query row with JSONB containing specific key-value pair
SELECT * FROM api.users WHERE profile @> '{"status": "active"}';

-- Extract JSONB value as text
SELECT username, profile->>'theme' AS selected_theme FROM api.users;

-- Search inside arrays
SELECT username FROM api.users WHERE 'admin' = ANY(tags);

-- Append item to array
UPDATE api.users SET tags = array_append(tags, 'moderator') WHERE id = 'some-uuid';
```

---

## Administration & Troubleshooting

### Process Monitoring
```sql
-- Show active connections and their queries
SELECT pid, usename, pg_blocking_pids(pid) AS blocked_by, query, state, age(clock_timestamp(), query_start) AS duration 
FROM pg_stat_activity 
WHERE state != 'idle' 
ORDER BY duration DESC;

-- Terminate a slow query safely
SELECT pg_cancel_backend(PID);

-- Forcefully terminate a connection
SELECT pg_terminate_backend(PID);
```

### Size & Resource Analysis
```sql
-- Get size of database
SELECT pg_size_pretty(pg_database_size('prod_db'));

-- Get size of table including indexes
SELECT pg_size_pretty(pg_total_relation_size('api.users'));

-- Get size of index alone
SELECT pg_size_pretty(pg_relation_size('api.users_username_key'));
```

---

## Tips & Tricks

- **Use JSONB over JSON:** JSONB stores data in a decomposed binary format, which supports indexing and is much faster to query.
- **Indexes on foreign keys:** PostgreSQL does not automatically index foreign keys. Always add them to prevent slow JOIN queries.
- **Vacuum regularly:** Use `VACUUM ANALYZE;` to clean up dead tuples and update database statistics for the query planner.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
