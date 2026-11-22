#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "sqlite3.h"

static uint64_t digest = UINT64_C(14695981039346656037);
static unsigned rows;

static int consume(void *state, int columns, char **values, char **names) {
    (void)state;
    (void)names;
    for (int i=0; i<columns; ++i) {
        if (values[i] == NULL) {
            digest = (digest ^ 0xff) * UINT64_C(1099511628211);
        } else {
            const unsigned char *v = (const unsigned char *)values[i];
            while (*v) digest = (digest ^ *v++) * UINT64_C(1099511628211);
            digest *= UINT64_C(1099511628211);
        }
    }
    rows++;
    return 0;
}

int main(void) {
    sqlite3* db;
    if (sqlite3_open(":memory:",&db) != SQLITE_OK) return 1;
    const char* sql =
        "CREATE TABLE t(i INTEGER PRIMARY KEY,k TEXT,val);"
        "WITH RECURSIVE n(x) AS (VALUES(1) UNION ALL SELECT x+1 FROM n WHERE x<2400)"
        " INSERT INTO t SELECT x,printf('%07d',(x*97)%317),(x*x+71)%1959 FROM n;"
        "CREATE INDEX ix ON t(k,val);"
        "CREATE VIRTUAL TABLE box USING rtree(i,x0,x1,y0,y1);"
        "INSERT INTO box SELECT i,i%51,i%51+1,(i*71)%151,(i*71)%151+2 FROM t;"
        "BEGIN; UPDATE t SET val=val+7 WHERE i%4=1; SAVEPOINT s; DELETE FROM t WHERE i%7=0;"
        "ROLLBACK TO s; RELEASE s; COMMIT;"
        "SELECT i,k,val,rank() OVER (PARTITION BY k ORDER BY val) FROM t ORDER BY k,val,i;"
        "SELECT t.i,t.val,b.y0 FROM box b JOIN t ON t.i=b.i "
        "WHERE b.x1>=17 AND b.x0<=23 AND b.y0<90 ORDER BY t.val,t.i;"
        "SELECT k,sum(val),count(*),max(i) FROM t GROUP BY k ORDER BY k;"
        "PRAGMA integrity_check;";
    char* error=0;
    const int rc=sqlite3_exec(db,sql,consume,0,&error);
    if (rc != SQLITE_OK) fprintf(stderr,"%d %s\n",rc,error?error:"");
    sqlite3_free(error);
    if (sqlite3_close(db)!=SQLITE_OK || rc!=SQLITE_OK) return 1;
    printf("%u %llu\n",rows,(unsigned long long)digest);
    return 0;
}
