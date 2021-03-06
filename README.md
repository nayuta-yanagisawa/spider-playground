# spider-playground

spider-playground launches Docker containers for playing with the Spider storage engine.

## Usage

```bash
# Run Spider cluster using latest image
docker-compose up -d --build
```

```bash
# Run Spider cluster of specific version
IMAGE_TAG=10.3 docker-compose up -d --build

# TODO: Make it possible to specify a minor version.
# Under the current setting, specifying a minor version doesn't make sense because
# the mariadb-pluin-spider package determines the version of the Spider node.

# TODO: Make it possible to run 10.5 and 10.6
# MariaDB 10.5 and 10.6 fail to start after the mariadb-plugin-spider is installed.
# The issue is possibly related to https://jira.mariadb.org/browse/MDEV-22979.
```

```bash
# Connect to Spider node
docker exec -it spider_node mysql -uroot -proot

# Connect to data nodes
docker exec -it data_node1 mysql -uroot -proot
docker exec -it data_node2 mysql -uroot -proot
```

## Example

```sql
# spider_node
SELECT ENGINE, SUPPORT FROM information_schema.ENGINES WHERE ENGINE = 'SPIDER';
```

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
