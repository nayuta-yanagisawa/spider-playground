# spider-playground

```
# Run Spider cluster
docker-compose up -d

# Connect to Spider node
docker exec -it spider_node mysql -uroot -proot

# Connect to data nodes
docker exec -it data_node1 mysql -uroot -proot
docker exec -it data_node2 mysql -uroot -proot
```
