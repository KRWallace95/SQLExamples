USE SNOWFLAKE_SAMPLE_DATA.TPCH_SF1;

SELECT DISTINCT COUNT(R_NAME)
FROM region;

SELECT COUNT(O_ORDERKEY)
FROM orders
WHERE O_ORDERPRIORITY = '1-URGENT';

SELECT COUNT(O_ORDERKEY)
FROM orders
WHERE O_ORDERPRIORITY <> '1-URGENT';

SELECT DISTINCT(O_ORDERPRIORITY)
FROM orders
ORDER BY O_ORDERPRIORITY;

SELECT COUNT(O_ORDERKEY)
FROM orders
WHERE O_ORDERDATE BETWEEN '1995-01-01' AND '1995-12-31' AND O_ORDERPRIORITY IN ('3-MEDIUM','4-NOT SPECIFIED','5-LOW');

SELECT COUNT(DISTINCT O_ORDERKEY) AS number_orders
FROM orders o
JOIN lineitem l
ON o.O_ORDERKEY = l_orderkey
JOIN part p
ON l_partkey = p_partkey
WHERE P_NAME = 'yellow pale blanched gainsboro moccasin';

SELECT COUNT(P_PARTKEY)
FROM part
JOIN lineitem
ON p_partkey = l_partkey
JOIN orders
ON l_orderkey = o_orderkey
WHERE P_NAME = 'yellow pale blanched gainsboro moccasin';

SELECT s_name
FROM partsupp
JOIN part p1
ON ps_partkey = p1.p_partkey
INNER JOIN (
            SELECT p_name, max(ps_availqty) as availqty
            FROM partsupp                        
            JOIN part
            ON partsupp.ps_partkey = part.p_partkey
            WHERE p_name = 'yellow pale blanched gainsboro moccasin'
            GROUP BY p_name) as p2
ON p1.p_name = p2.p_name and partsupp.ps_availqty = p2.availqty
JOIN supplier
ON ps_suppkey = s_suppkey;

SELECT r_name
FROM region
JOIN nation
ON r_regionkey = n_regionkey
JOIN supplier
ON n_nationkey = s_nationkey
JOIN partsupp
ON s_suppkey = ps_suppkey
JOIN part p1
ON ps_partkey = p1.p_partkey
JOIN (SELECT p_name, min(ps_availqty) as availqty
            FROM partsupp                        
            JOIN part
            ON partsupp.ps_partkey = part.p_partkey
            WHERE p_name = 'yellow pale blanched gainsboro moccasin'
            GROUP BY p_name) as p2
ON p1.p_name = p2.p_name AND ps_availqty = p2.availqty;

SELECT DISTINCT p_name as product_name
FROM part
JOIN partsupp
ON p_partkey = ps_partkey
JOIN supplier
ON ps_suppkey = s_suppkey
JOIN nation
ON s_nationkey = n_nationkey
JOIN region
ON n_regionkey = r_regionkey
WHERE P_NAME LIKE('%e%') AND r_name = 'AMERICA';

SELECT COUNT(DISTINCT o_orderkey)
FROM orders
JOIN lineitem
ON o_orderkey = l_orderkey
WHERE l_linenumber >= 3;

SELECT COUNT(o_orderkey)
FROM (SELECT o_orderkey, count(DISTINCT l_suppkey) as number_suppliers
    FROM orders
    JOIN lineitem
    ON o_orderkey = l_orderkey
    GROUP BY o_orderkey
    HAVING count(l_suppkey) > 3
    ORDER BY o_orderkey);
    
SELECT round(avg(number_suppliers),2) as avg_suppliers
FROM (SELECT o_orderkey, count(l_suppkey) as number_suppliers
        FROM orders
        JOIN lineitem
        ON o_orderkey = l_orderkey
        GROUP BY o_orderkey
        ORDER BY o_orderkey);
        
SELECT COUNT(o_orderkey) as number_orders
FROM orders
JOIN customer
ON o_custkey = c_custkey
WHERE (c_custkey BETWEEN 10000 AND 20000)
        AND (o_orderdate BETWEEN '1995-02-15' AND '1996-02-13')
        AND (o_totalprice < 50000 OR o_totalprice > 250000);
        
SELECT COUNT(s_suppkey) as number_suppliers
FROM supplier
WHERE (s_name LIKE('%e%'))
        AND 
      (s_address LIKE('%e%') OR s_comment LIKE('%e%'));
      
SELECT DISTINCT l_suppkey
FROM lineitem
JOIN orders
ON l_orderkey = o_orderkey
WHERE o_orderkey IN (SELECT o_orderkey
                    FROM orders
                    JOIN lineitem
                    ON o_orderkey = l_orderkey
                    JOIN supplier 
                    ON l_suppkey = s_suppkey
                    WHERE s_suppkey = 1) AND
l_suppkey <> 1;

SELECT round(sum(l_discount * o_totalprice),2) as discount_price
FROM lineitem
JOIN orders
ON l_orderkey = o_orderkey;

SELECT min(discount_price), max(discount_price)
FROM (SELECT l_suppkey, avg(l_discount * o_totalprice) as discount_price
    FROM lineitem
    JOIN orders
    ON l_orderkey = o_orderkey
    GROUP BY l_suppkey
    ORDER BY l_suppkey);
    
SELECT 
    ps_suppkey,
    SUM(ps_availqty * ps_supplycost) AS sum_total_avail_cost
FROM
    partsupp
GROUP BY ps_suppkey
ORDER BY SUM(ps_availqty * ps_supplycost) DESC
LIMIT 3;