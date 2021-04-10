# spider-playground

spider-playground launches Docker containers for playing with the Spider storage engine.

## Usage

```bash
# Run Spider cluster
docker-compose up -d

# Connect to Spider node
docker exec -it spider_node mysql -uroot -proot

# Connect to data nodes
docker exec -it data_node1 mysql -uroot -proot
docker exec -it data_node2 mysql -uroot -proot
```

## Example

```sql
# spider_node
CREATE TABLE test.spider_example (
   id INT PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(50)
) ENGINE=Spider
PARTITION BY HASH(id) (
  PARTITION p1 comment 'server "data_node1", table "spider_example"',
  PARTITION p2 comment 'server "data_node2", table "spider_example"'
);

# data_node1/2
CREATE TABLE test.spider_example (
   id INT PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(50)
) ENGINE = InnoDB;
```

```sql
# spider_node
INSERT INTO test.spider_example (name) VALUES ('Aris'), ('Bob'), ('Carole');
Query OK, 3 rows affected (0.010 sec)
Records: 3  Duplicates: 0  Warnings: 0

SELECT * FROM test.spider_example;
+----+--------+
| id | name   |
+----+--------+
|  2 | Bob    |
|  1 | Aris   |
|  3 | Carole |
+----+--------+
3 rows in set (0.003 sec)

# data_node1
SELECT * FROM test.spider_example;
+----+------+
| id | name |
+----+------+
|  2 | Bob  |
+----+------+
1 row in set (0.000 sec)

# data_node2
SELECT * FROM test.spider_example;
+----+--------+
| id | name   |
+----+--------+
|  1 | Aris   |
|  3 | Carole |
+----+--------+
2 rows in set (0.000 sec)
```
