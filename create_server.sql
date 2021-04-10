CREATE SERVER data_node1 FOREIGN DATA WRAPPER mysql OPTIONS
    (USER 'root', PASSWORD 'root', HOST 'data_node1', PORT 3306);
CREATE SERVER data_node2 FOREIGN DATA WRAPPER mysql OPTIONS
    (USER 'root', PASSWORD 'root', HOST 'data_node2', PORT 3306);
