#include "sqlite3.h"
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static uint64_t counts[12];
void buster_sort_observe(int depth,int sequence)
{
    (void)sequence;
    if(depth>=0 && depth<12) counts[depth]++;
}
static void finish(sqlite3 *db,int rc)
{
    if(rc!=SQLITE_OK) {fprintf(stderr,"sqlite error %d %s\n",rc,sqlite3_errmsg(db));exit(3);}
}
static void sql(sqlite3 *db,const char *statement) {finish(db,sqlite3_exec(db,statement,0,0,0));}
static uint64_t next(uint64_t *s){*s^=*s<<13;*s^=*s>>7;*s^=*s<<17;return *s;}
int main(int argc,char **argv)
{
    if(argc!=4)return 2;
    const unsigned n=(unsigned)strtoul(argv[3],0,10); if(n==0)return 2;
    const int build=!strcmp(argv[1],"build"),memory=!strcmp(argv[1],"memory");
    sqlite3 *db=0;sqlite3_stmt *st=0;int rc=sqlite3_config(SQLITE_CONFIG_PMASZ,1u);if(rc!=SQLITE_OK)return 2;
    finish(db,sqlite3_open_v2(argv[2],&db,build?SQLITE_OPEN_READWRITE|SQLITE_OPEN_CREATE:SQLITE_OPEN_READONLY,NULL));
    if(build) {
        sql(db,"PRAGMA page_size=512; PRAGMA journal_mode=OFF; PRAGMA synchronous=OFF; BEGIN; CREATE TABLE entries(id INTEGER PRIMARY KEY,k INTEGER,v BLOB)");
        finish(db,sqlite3_prepare_v2(db,"INSERT INTO entries VALUES(?1,?2,?3)",-1,&st,NULL));uint64_t state=UINT64_C(0x1ae7329dee01c45d);
        for(unsigned i=1;i<=n;i++) {unsigned char blob[96];uint32_t key=(uint32_t)next(&state)%65521u;for(unsigned j=0;j<sizeof(blob);j+=8){uint64_t b=next(&state);memcpy(blob+j,&b,8);}sqlite3_bind_int(st,1,(int)i);sqlite3_bind_int(st,2,(int)key);sqlite3_bind_blob(st,3,blob,sizeof(blob),SQLITE_STATIC);if(sqlite3_step(st)!=SQLITE_DONE)return 4;finish(db,sqlite3_reset(st));}
        finish(db,sqlite3_finalize(st));sql(db,"COMMIT");finish(db,sqlite3_close(db));return 0;
    }
    sql(db,memory?"PRAGMA temp_store=MEMORY":"PRAGMA temp_store=FILE"); sql(db,"PRAGMA main.cache_size=4; PRAGMA temp.cache_size=4; PRAGMA threads=0");
    finish(db,sqlite3_prepare_v2(db,"SELECT id,k,v FROM entries WHERE id<=?1 ORDER BY k,id DESC",-1,&st,0));sqlite3_bind_int(st,1,(int)n);
    uint64_t h=UINT64_C(14695981039346656037);unsigned seen=0;int last_key=-1,last_id=-1;
    while((rc=sqlite3_step(st))==SQLITE_ROW){int id=sqlite3_column_int(st,0),key=sqlite3_column_int(st,1);const unsigned char *b=sqlite3_column_blob(st,2);if(!b||sqlite3_column_bytes(st,2)!=96||key<last_key||(key==last_key&&id>=last_id))return 5;
      h=(h^(uint64_t)id)*UINT64_C(1099511628211);h=(h^(uint64_t)key)*UINT64_C(1099511628211);for(unsigned j=0;j<96;j++)h=(h^b[j])*UINT64_C(1099511628211);last_key=key;last_id=id;seen++;}
    if(rc!=SQLITE_DONE || seen!=n)return 6;int sorts=sqlite3_stmt_status(st,SQLITE_STMTSTATUS_SORT,0);if(sorts!=1)return 7;
    printf("rows=%u sorted=%d hash=%016" PRIx64 "\n",seen,sorts,h);
    for(unsigned depth=0;depth<12;depth++) if(counts[depth]) fprintf(stderr,"depth=%u calls=%" PRIu64 " source_loop_iterations=%" PRIu64 "\n",depth,counts[depth],counts[depth]*(depth>1?depth-1:0));
    finish(db,sqlite3_finalize(st));finish(db,sqlite3_close(db));return 0;
}
