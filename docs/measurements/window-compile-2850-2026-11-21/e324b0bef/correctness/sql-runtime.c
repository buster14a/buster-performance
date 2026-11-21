#include <sqlite3.h>
#include <stdio.h>
#include <string.h>

int main(void)
{
    sqlite3 *db = 0;
    sqlite3_stmt *stmt = 0;
    if (strcmp(sqlite3_libversion(), SQLITE_VERSION) || sqlite3_open(":memory:", &db))
        return 1;
    if (sqlite3_prepare_v2(db, "SELECT sqlite_version(), 19 + 23", -1, &stmt, 0))
        return 2;
    if (sqlite3_step(stmt) != SQLITE_ROW || strcmp((const char *)sqlite3_column_text(stmt, 0), SQLITE_VERSION) || sqlite3_column_int(stmt, 1) != 42)
        return 3;
    printf("%s %d\n", sqlite3_column_text(stmt, 0), sqlite3_column_int(stmt, 1));
    sqlite3_finalize(stmt);
    return sqlite3_close(db) != SQLITE_OK;
}
