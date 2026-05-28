# MySQL Cheatsheet

> Production reference for MySQL administration, developer queries, and maintenance.
> Last verified: May 2026 | Version: 8.x

---

## Quick Reference

| Command / Query | Description |
|---|---|
| `mysql -u root -p` | Connect to MySQL shell |
| `SHOW DATABASES;` | List all databases |
| `USE dbname;` | Switch to database |
| `SHOW TABLES;` | List tables in database |
| `DESCRIBE tablename;` | Show table schema |
| `SHOW PROCESSLIST;` | Show active database queries |
| `EXPLAIN <query>;` | Analyze query plan |
| `mysqldump -u user -p db > backup.sql` | Backup a database |

---

## Connection & Command Line

### Command Line Shell
```bash
# Connect to local MySQL server
mysql -u root -p

# Connect to remote server on specific port
mysql -h 192.168.1.50 -P 3306 -u dbuser -p

# Connect and execute query immediately
mysql -u dbuser -p -e "SELECT VERSION();"

# Output results in XML or HTML format
mysql -u dbuser -p -X -e "SELECT * FROM mydb.users LIMIT 5;"
```

---

## Common SQL & Schema Operations

### Tables with Engines
```sql
-- Create table with InnoDB engine and UTF8mb4 character set
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL,
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Index Management
```sql
-- Add composite index
ALTER TABLE users ADD INDEX idx_email_status (email, status);

-- Drop index
ALTER TABLE users DROP INDEX idx_email_status;

-- View all indexes on a table
SHOW INDEX FROM users;
```

---

## Troubleshooting & Administration

### Query Performance & Connections
```sql
-- Show running threads and queries
SHOW FULL PROCESSLIST;

-- Kill a long-running thread
KILL 45;

-- Get storage engine status (extremely detailed stats on memory/disk)
SHOW ENGINE INNODB STATUS;
```

---

## Tips & Tricks

- **UTF8mb4:** Always use `utf8mb4` instead of `utf8`. Standard `utf8` in MySQL only supports 3 bytes per character, meaning it cannot store emojis, whereas `utf8mb4` fully supports 4 bytes.
- **Auto-increment optimization:** Avoid using large offsets in `LIMIT` (e.g. `LIMIT 100000, 10`). Use keyset pagination instead (e.g., `WHERE id > 100000 LIMIT 10`).

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
