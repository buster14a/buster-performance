.bail on
.mode list
BEGIN;
CREATE TABLE item(id INTEGER PRIMARY KEY, value INTEGER NOT NULL);
WITH RECURSIVE n(x) AS (VALUES(1) UNION ALL SELECT x+1 FROM n WHERE x<1000)
INSERT INTO item SELECT x, x%13 FROM n;
CREATE INDEX by_value ON item(value);
SAVEPOINT guard;
UPDATE item SET value=-555 WHERE id%17=0;
ROLLBACK TO guard;
RELEASE guard;
COMMIT;
SELECT count(*), sum(value), min(value), max(value) FROM item;
SELECT value, count(*) FROM item GROUP BY value ORDER BY value;
CREATE VIRTUAL TABLE rectangle USING rtree(id,minX,maxX,minY,maxY);
INSERT INTO rectangle VALUES(1,5,11,2,10),(2,6,12,11,15),(3,-3,1,9,12);
SELECT id FROM rectangle WHERE minX<8 AND maxX>4 AND minY<11 AND maxY>3 ORDER BY id;
PRAGMA integrity_check;
