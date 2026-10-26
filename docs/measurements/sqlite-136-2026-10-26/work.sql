PRAGMA journal_mode=OFF;
PRAGMA synchronous=OFF;
CREATE TABLE t(a INTEGER PRIMARY KEY, b INTEGER, c TEXT, d REAL);
WITH RECURSIVE n(x) AS (SELECT 1 UNION ALL SELECT x + 1 FROM n WHERE x < 300000)
INSERT INTO t SELECT x, (x * 7919) % 100003, printf('row %08d', x), x * 0.5 FROM n;
CREATE INDEX t_b ON t(b);
SELECT count(*), sum(b), avg(d), max(c) FROM t;
SELECT b % 97, count(*), sum(d) FROM t GROUP BY 1 ORDER BY 3 DESC LIMIT 5;
SELECT sum(t1.a) FROM t AS t1 JOIN t AS t2 ON t1.b = t2.a WHERE t1.a < 150000;
UPDATE t SET d = d * 1.5, c = upper(c) WHERE b % 3 = 0;
DELETE FROM t WHERE a % 5 = 0;
SELECT count(*), total(d), group_concat(substr(c, 5, 2), '') FROM (SELECT c, d FROM t ORDER BY c DESC LIMIT 2000);
SELECT printf('%.6f', avg(length(c) * d)) FROM t WHERE c LIKE '%9%';
