.headers on
.mode column
CREATE TABLE t(a INTEGER PRIMARY KEY, b TEXT, c REAL);
INSERT INTO t(b, c) VALUES ('one', 1.5), ('two', -2.25), ('three', 3e10), (NULL, 0.0);
SELECT a, b, c, typeof(c) FROM t ORDER BY a;
.mode list
SELECT group_concat(b, '|') FROM t;
.schema
.tables
CREATE INDEX ti ON t(b);
.indexes
SELECT count(*), sum(c), avg(c), min(b), max(b) FROM t;
WITH RECURSIVE r(x) AS (SELECT 1 UNION ALL SELECT x + 1 FROM r WHERE x < 100) SELECT sum(x), total(x * 1.5) FROM r;
SELECT * FROM generate_series(1, 5);
.mode json
SELECT * FROM t WHERE a < 3;
.mode csv
SELECT printf('%5.2f|%d|%s', c, a, b) FROM t;
SELECT round(2.5), round(-2.5), round(1.23456, 3);
.dump
.show
SELECT value FROM generate_series(1.5, 7.25, 2);
SELECT value FROM generate_series(-3.75, 3) LIMIT 4;
SELECT value FROM generate_series(10, 1, -3);
.mode box
SELECT 1 AS x, 'é' AS y, NULL AS z;
.mode table
SELECT a, b FROM t;
.width 5 10
.mode column
SELECT a, b FROM t;
.timer off
.nullvalue NULL
SELECT NULL, b FROM t WHERE b IS NULL;
.echo on
SELECT 42;
.echo off
.print hello world
.databases
.stats off
.eqp on
SELECT * FROM t WHERE b = 'two';
.eqp off
.expert
.parameter set @p 5
SELECT @p * 2;
.parameter list
.limit length
.dbinfo
