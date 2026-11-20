#include "sqlite3.h"
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static uint64_t hash=UINT64_C(14695981039346656037);
static uint64_t classes[6];
static void byte(uint8_t b){hash=(hash^b)*UINT64_C(1099511628211);}
static void check(int rc,sqlite3 *db){if(rc!=SQLITE_OK){fprintf(stderr,"%s\n",sqlite3_errmsg(db));exit(2);}}
int main(int argc,char **argv)
{
    int reps=argc==2?atoi(argv[1]):0;
    if(reps<1 || reps>512)return 2;
    sqlite3 *db=0;sqlite3_stmt *st=0;check(sqlite3_open(":memory:",&db),db);
    const char *sql="SELECT date(?1,?2,?3),time(?1,?2,?3),datetime(?1,?2,?3),julianday(?1,?2,?3),unixepoch(?1,?2,?3),unixepoch(?1,?2,?3,'subsec'),strftime('%Y-%m-%dT%H:%M:%f',?1,?2,?3),timediff(datetime(?1,?2,?3),datetime(?1))";
    check(sqlite3_prepare_v2(db,sql,-1,&st,0),db);
    const char *dates[]={"0000-01-01 00:00:00","1969-12-31 23:59:59.999","1970-01-01","1900-02-28 23:59:59.5","2000-02-29 12:34:56.789","2024-01-31 00:00:01","2024-02-29","9999-12-31 23:59:59.999","2020-12-17T23:43:12.123+04:30","invalid"};
    const char *mods[]={"0 seconds","+0.125 seconds","-1.75 seconds","+10.125 minutes","-23.25 hours","+1.125 days","-31 days","+1 month","-0.5 months","+3 years","weekday 4","start of year","start of month","+0000-00-01 02:03:04.125","subsec"};
    const char *tails[]={"0 days","floor","ceiling","start of day"};
    for(int r=0;r<reps;r++)for(unsigned i=0;i<256;i++)for(unsigned j=0;j<15;j++) {
        switch(i%4){
        case 0:check(sqlite3_bind_text(st,1,dates[(i/4)%10],-1,SQLITE_STATIC),db);break;
        case 1:check(sqlite3_bind_double(st,1,2300000.+(double)((i*12161u+r*31u)%440000u)*0.5),db);break;
        case 2:check(sqlite3_bind_int64(st,1,2451545+(int)i-128),db);break;
        default:if(i%8==3)check(sqlite3_bind_null(st,1),db);else check(sqlite3_bind_text(st,1,dates[(i/4+3)%10],-1,SQLITE_STATIC),db);break;}
        check(sqlite3_bind_text(st,2,mods[j],-1,SQLITE_STATIC),db);check(sqlite3_bind_text(st,3,tails[(i+j+r)%4],-1,SQLITE_STATIC),db);
        if(sqlite3_step(st)!=SQLITE_ROW)return 3;
        for(int col=0;col<8;col++){
            int type=sqlite3_column_type(st,col);if(type<1||type>5)return 3;classes[type]++;byte((uint8_t)type);
            if(type==SQLITE_INTEGER || type==SQLITE_FLOAT){uint64_t word;if(type==SQLITE_INTEGER)word=(uint64_t)sqlite3_column_int64(st,col);else{double z=sqlite3_column_double(st,col);memcpy(&word,&z,8);}for(unsigned k=0;k<8;k++)byte((uint8_t)(word>>(8*k)));}
            else if(type==SQLITE_TEXT){int count=sqlite3_column_bytes(st,col);const unsigned char *s=sqlite3_column_text(st,col);for(int k=0;k<count;k++)byte(s[k]);byte(0xff);}
        }
        if(sqlite3_step(st)!=SQLITE_DONE)return 3;check(sqlite3_reset(st),db);
    }
    check(sqlite3_finalize(st),db);check(sqlite3_close(db),db);
    printf("queries=%u integer=%" PRIu64 " float=%" PRIu64 " text=%" PRIu64 " null=%" PRIu64 " hash=%016" PRIx64 "\n",(unsigned)reps*256u*15u,classes[SQLITE_INTEGER],classes[SQLITE_FLOAT],classes[SQLITE_TEXT],classes[SQLITE_NULL],hash);return 0;
}
