// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original runtime consumer for foreign-linker corpus qualification.
#include "sqlite3.h"
#include <stdint.h>
#include <stdio.h>
#include <string.h>

static int check_rows(sqlite3* database, const char* sql, int64_t count, int64_t ids, int64_t values)
{
    sqlite3_stmt* statement = 0;
    int good = sqlite3_prepare_v2(database, sql, -1, &statement, 0) == SQLITE_OK;
    good = good && sqlite3_step(statement) == SQLITE_ROW;
    good = good && sqlite3_column_int64(statement, 0) == count;
    good = good && sqlite3_column_int64(statement, 1) == ids;
    good = good && sqlite3_column_int64(statement, 2) == values;
    good = good && sqlite3_step(statement) == SQLITE_DONE;
    const int finalized = sqlite3_finalize(statement);
    return good && finalized == SQLITE_OK;
}

int main(void)
{
    sqlite3* database = 0;
    sqlite3_stmt* insert = 0;
    sqlite3_stmt* read = 0;
    int good = sqlite3_open(":memory:", &database) == SQLITE_OK;
    int64_t ids = 0;
    int64_t values = 0;
    int64_t even_ids = 0;
    int64_t even_values = 0;
    static const char setup[] =
        "PRAGMA temp_store=MEMORY;"
        "CREATE TABLE records(id INTEGER PRIMARY KEY,value INTEGER NOT NULL,payload BLOB NOT NULL);"
        "BEGIN;";
    if (good)
    {
        good = sqlite3_exec(database, setup, 0, 0, 0) == SQLITE_OK;
    }
    if (good)
    {
        good = sqlite3_prepare_v2(database, "INSERT INTO records VALUES(?1,?2,?3)", -1, &insert, 0) == SQLITE_OK;
    }
    for (int64_t id = 1; good && id <= 10000; id += 1)
    {
        const int64_t value = (id * 17) % 1009;
        uint8_t payload[16];
        for (unsigned i = 0; i < sizeof(payload); i += 1)
        {
            payload[i] = (uint8_t)(id * 13 + i * 29);
        }
        good = sqlite3_bind_int64(insert, 1, id) == SQLITE_OK && sqlite3_bind_int64(insert, 2, value) == SQLITE_OK &&
               sqlite3_bind_blob(insert, 3, payload, sizeof(payload), SQLITE_TRANSIENT) == SQLITE_OK && sqlite3_step(insert) == SQLITE_DONE &&
               sqlite3_reset(insert) == SQLITE_OK && sqlite3_clear_bindings(insert) == SQLITE_OK;
        ids += id;
        values += value;
        even_ids += (id & 1) == 0 ? id : 0;
        even_values += (id & 1) == 0 ? value : 0;
    }
    const int insert_finalized = sqlite3_finalize(insert);
    good = good && insert_finalized == SQLITE_OK;
    if (good)
    {
        good = sqlite3_exec(database, "COMMIT;CREATE INDEX value_index ON records(value);", 0, 0, 0) == SQLITE_OK &&
               check_rows(database, "SELECT count(*),sum(id),sum(value) FROM records", 10000, ids, values) &&
               check_rows(database, "SELECT count(*),sum(id),sum(value) FROM records WHERE id%2=0", 5000, even_ids, even_values);
    }
    if (good)
    {
        good = sqlite3_exec(database, "BEGIN;UPDATE records SET value=value+1;DELETE FROM records WHERE id%3=0;ROLLBACK;", 0, 0, 0) == SQLITE_OK &&
               check_rows(database, "SELECT count(*),sum(id),sum(value) FROM records", 10000, ids, values);
    }
    if (good)
    {
        good = sqlite3_prepare_v2(database, "SELECT id,payload FROM records ORDER BY id DESC", -1, &read, 0) == SQLITE_OK;
    }
    for (int64_t id = 10000; good && id != 0; id -= 1)
    {
        good = sqlite3_step(read) == SQLITE_ROW && sqlite3_column_int64(read, 0) == id && sqlite3_column_bytes(read, 1) == 16;
        const uint8_t* payload = good ? sqlite3_column_blob(read, 1) : 0;
        good = good && payload != 0;
        for (unsigned i = 0; good && i < 16; i += 1)
        {
            good = payload[i] == (uint8_t)(id * 13 + i * 29);
        }
    }
    good = good && sqlite3_step(read) == SQLITE_DONE;
    const int read_finalized = sqlite3_finalize(read);
    const int closed = sqlite3_close(database);
    good = good && read_finalized == SQLITE_OK && closed == SQLITE_OK;
    printf("SQLite foreign-link corpus: %s count=10000 id-sum=%lld value-sum=%lld\n", good ? "pass" : "fail",
           (long long)ids, (long long)values);
    return good ? 42 : 101;
}
