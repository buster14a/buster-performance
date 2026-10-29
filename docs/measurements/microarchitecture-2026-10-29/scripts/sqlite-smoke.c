// Adapted from microarchitecture-9700x-2026-10-27/method/sqlite-smoke.c.
// RTree statements are omitted because this campaign uses default SQLite features.
#include "sqlite3.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

static uint64_t digest = UINT64_C(1469598103934665603);
static unsigned long rows;

static int row(void *unused, int columns, char **values, char **names)
{
    (void)unused; (void)names;
    ++rows;
    for (int c = 0; c < columns; ++c)
    {
        const unsigned char *s = (const unsigned char *)(values[c] ? values[c] : "<NULL>");
        do { digest = (digest ^ *s) * UINT64_C(1099511628211); } while (*s++);
    }
    return 0;
}

static void sql(sqlite3 *db, const char *text)
{
    char *error = NULL;
    int code = sqlite3_exec(db, text, row, NULL, &error);
    if (code != SQLITE_OK)
    {
        fprintf(stderr, "SQLite error %d: %s\nSQL: %s\n", code, error ? error : "unknown", text);
        sqlite3_free(error);
        exit(1);
    }
}

int main(void)
{
    sqlite3 *db = NULL;
    if (sqlite3_open(":memory:", &db) != SQLITE_OK) return 1;
    sql(db, "PRAGMA foreign_keys=ON; CREATE TABLE t(id INTEGER PRIMARY KEY,v INTEGER,s TEXT,b BLOB); BEGIN;"
            "WITH RECURSIVE n(x) AS (VALUES(1) UNION ALL SELECT x+1 FROM n WHERE x<10000) "
            "INSERT INTO t SELECT x,(x*7919)%100003,printf('row-%05d',x),zeroblob(x%97) FROM n; COMMIT;"
            "CREATE INDEX ti ON t(v); SELECT count(*),sum(v),min(v),max(v),sum(length(b)) FROM t;"
            "SELECT a.id,b.id,a.v+b.v FROM t a JOIN t b ON b.id=a.id+7 WHERE a.v BETWEEN 200 AND 400 ORDER BY a.id;"
            "SELECT id,sum(v) OVER(ORDER BY id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) FROM t WHERE id<40;"
            "BEGIN; UPDATE t SET v=v+1 WHERE id%3=0; SAVEPOINT a; DELETE FROM t WHERE id%5=0; ROLLBACK TO a; RELEASE a; COMMIT;"
            "SELECT count(*),sum(v),hex(substr(b,1,4)),upper(s) FROM t WHERE id IN(1,2,3,29,8192,9999) GROUP BY id ORDER BY id;"
            "SELECT json_extract('{\"a\":[1,2,3]}','$.a[1]'),hex(char(0x3bb)),round(81.0/7.0,3);"
            "PRAGMA integrity_check;");
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db, "INSERT INTO t VALUES(?1,?2,?3,?4)", -1, &stmt, NULL) != SQLITE_OK) return 1;
    const unsigned char bytes[] = {0,1,255,128,42};
    for (int i = 0; i < 100; ++i)
    {
        sqlite3_bind_int64(stmt,1,10001+i);
        sqlite3_bind_int64(stmt,2,INT64_C(0x1234567800000000)+i);
        sqlite3_bind_text(stmt,3,"unicode-\xce\xbb-\xc3\xa9",-1,SQLITE_STATIC);
        sqlite3_bind_blob(stmt,4,bytes,sizeof(bytes),SQLITE_STATIC);
        if (sqlite3_step(stmt) != SQLITE_DONE) return 1;
        sqlite3_reset(stmt); sqlite3_clear_bindings(stmt);
    }
    sqlite3_finalize(stmt);
    sql(db,"SELECT id,v,s,hex(b) FROM t WHERE id>10000 ORDER BY id; PRAGMA integrity_check;");
    sqlite3 *copy = NULL;
    if (sqlite3_open(":memory:",&copy) != SQLITE_OK) return 1;
    sqlite3_backup *backup = sqlite3_backup_init(copy,"main",db,"main");
    if (backup == NULL || sqlite3_backup_step(backup,-1) != SQLITE_DONE || sqlite3_backup_finish(backup) != SQLITE_OK) return 1;
    sql(copy,"SELECT count(*),min(id),max(id),total(v),sum(length(s)) FROM t; PRAGMA integrity_check;");
    sqlite3_close(copy); sqlite3_close(db);
    printf("rows=%lu digest=%016llx\n",rows,(unsigned long long)digest);
    return 0;
}
