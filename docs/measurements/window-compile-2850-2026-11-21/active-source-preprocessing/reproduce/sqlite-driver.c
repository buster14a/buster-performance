#include "sqlite3.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static int row(void *unused, int count, char **values, char **names)
{
    (void)unused;
    (void)names;
    for (int i = 0; i < count; ++i) printf("%s%s", i ? "|" : "", values[i] ? values[i] : "NULL");
    putchar('\n');
    return 0;
}
static void query(sqlite3 *db, const char *sql)
{
    char *error = NULL;
    int rc = sqlite3_exec(db, sql, row, NULL, &error);
    if (rc != SQLITE_OK) { fprintf(stderr, "%s: %d %s\n",sql,rc,error?error:""); sqlite3_free(error); exit(1); }
}
int main(void)
{
    sqlite3 *db = NULL;
    if (sqlite3_open(":memory:", &db) != SQLITE_OK) return 2;
    puts(sqlite3_libversion());
    query(db, "PRAGMA foreign_keys=ON; CREATE TABLE t(k INTEGER PRIMARY KEY, v TEXT UNIQUE, b BLOB); BEGIN;");
    sqlite3_stmt *ins = NULL;
    if (sqlite3_prepare_v2(db,"INSERT INTO t VALUES(?,?,?);",-1,&ins,NULL) != SQLITE_OK) return 3;
    const char *values[]={"café","alpha","beta","gamma"};
    const unsigned char bytes[]={0,255,23,42};
    for (int i=0;i<4;i++) {
        if (sqlite3_bind_int(ins,1,i+1)!=SQLITE_OK || sqlite3_bind_text(ins,2,values[i],-1,SQLITE_STATIC)!=SQLITE_OK ||
            sqlite3_bind_blob(ins,3,bytes+i,4-i,SQLITE_STATIC)!=SQLITE_OK || sqlite3_step(ins)!=SQLITE_DONE || sqlite3_reset(ins)!=SQLITE_OK) return 4;
    }
    if (sqlite3_finalize(ins)!=SQLITE_OK) return 5;
    query(db,"COMMIT; SELECT k,v,hex(b) FROM t ORDER BY v;");
    query(db,"WITH RECURSIVE seq(n) AS (VALUES(1) UNION ALL SELECT n+1 FROM seq WHERE n<50) SELECT count(*),sum(n),sum(n*n) FROM seq;");
    query(db,"CREATE VIRTUAL TABLE boxes USING rtree(id,x1,x2,y1,y2); INSERT INTO boxes VALUES(1,0,2,0,1),(2,7,9,6,8); SELECT id FROM boxes WHERE x1<=1.5 AND x2>=1.5;");
    query(db,"SELECT k,dense_rank() OVER (ORDER BY length(v)),v FROM t ORDER BY k;");
    int duplicate=sqlite3_exec(db,"INSERT INTO t(k,v) VALUES(10,'alpha');",NULL,NULL,NULL);
    printf("constraint=%d/%d\n",duplicate,sqlite3_extended_errcode(db));
    if (duplicate!=SQLITE_CONSTRAINT) return 6;
    query(db,"BEGIN; DELETE FROM t; ROLLBACK; SELECT count(*),sum(length(b)) FROM t; PRAGMA integrity_check;");
    return sqlite3_close(db)!=SQLITE_OK;
}
