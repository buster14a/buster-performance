#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <xmmintrin.h>
#include "sqlite3.h"
enum {N=2048};
static uint64_t words[N], digest;static unsigned char minus[N];
unsigned long long conversion_calls;
static uint64_t mix(uint64_t x){x^=x>>30;x*=UINT64_C(0xbf58476d1ce4e5b9);x^=x>>27;x*=UINT64_C(0x94d049bb133111eb);return x^(x>>31);}
static uint64_t ref(uint64_t u,unsigned mode,int neg){
 unsigned e=63u-(unsigned)__builtin_clzll(u),shift=e>52?e-52:0;
 uint64_t bits=shift?u>>shift:u<<(52-e),rest=u&((UINT64_C(1)<<shift)-1);
 if(rest&&(mode==2||(mode==0&&(rest>(UINT64_C(1)<<(shift-1))||(rest==(UINT64_C(1)<<(shift-1))&&(bits&1)))))){
  if(++bits==(UINT64_C(1)<<53)){bits>>=1;e++;}
 }
 return ((uint64_t)neg<<63)|((uint64_t)(e+1023)<<52)|(bits&((UINT64_C(1)<<52)-1));
}
int main(int argc,char**argv){
 if(argc!=4)return 1;
 int blob=atoi(argv[1]),small=atoi(argv[2]),reps=atoi(argv[3]);if(reps<1||reps>1000)return 1;
 char *json=malloc(64*N);char *at=json;*at++='[';
 for(unsigned i=0;i<N;i++){
   uint64_t w=mix(i+229);
   if((i&7)==0)w=UINT64_MAX-(i&15);
   if((i&7)==1)w=(UINT64_C(1)<<63)+(uint64_t)(i%8)*2048+1024+(i%3)-1;
   words[i]=small?(w&0x7fffffffULL):(w|UINT64_C(1)<<63);minus[i]=(i>>1)&1;
   at+=sprintf(at,"%s%s0x%" PRIx64,i?",":"",minus[i]?"-":"",words[i]);
 }
 *at++=']';*at=0;sqlite3 *db=0;sqlite3_stmt *st=0,*build=0;
 if(sqlite3_open(":memory:",&db)||sqlite3_prepare_v2(db,"select value from json_each(?1)",-1,&st,0))return 2;
 void *b=0;
 if(blob){if(sqlite3_prepare_v2(db,"select jsonb(?1)",-1,&build,0)||sqlite3_bind_text(build,1,json,-1,SQLITE_STATIC)||sqlite3_step(build)!=SQLITE_ROW)return 3;
  int n=sqlite3_column_bytes(build,0);b=malloc((size_t)n);memcpy(b,sqlite3_column_blob(build,0),(size_t)n);sqlite3_finalize(build);if(sqlite3_bind_blob(st,1,b,n,SQLITE_STATIC))return 3;
 }else if(sqlite3_bind_text(st,1,json,-1,SQLITE_STATIC))return 3;
 unsigned original=_mm_getcsr();uint64_t count=0;
 for(int r=0;r<reps;r++){
   unsigned mode=(unsigned)r%4;_mm_setcsr(0x1f80|(mode<<13));
   unsigned i=0;int rc;
   while((rc=sqlite3_step(st))==SQLITE_ROW){
    if(i>=N)return 4;uint64_t bits=0;
    if(small){if(sqlite3_column_type(st,0)!=SQLITE_INTEGER)return 5;sqlite3_int64 v=sqlite3_column_int64(st,0);if(v!=(minus[i]?-(sqlite3_int64)words[i]:(sqlite3_int64)words[i]))return 5;bits=(uint64_t)v;}
    else {if(sqlite3_column_type(st,0)!=SQLITE_FLOAT)return 5;double v=sqlite3_column_double(st,0);memcpy(&bits,&v,8);uint64_t expected=ref(words[i],mode,minus[i]);if(bits!=expected){fprintf(stderr,"i=%u mode=%u got=%016" PRIx64 " expected=%016" PRIx64 "\n",i,mode,bits,expected);return 6;}}
    digest=(digest^bits)*1099511628211ULL;i++;count++;
   }
   if(rc!=SQLITE_DONE||i!=N||sqlite3_reset(st))return 7;
 }
 _mm_setcsr(original);sqlite3_finalize(st);sqlite3_close(db);free(b);free(json);printf("%" PRIu64 " %016" PRIx64 " %llu\n",count,digest,conversion_calls);return 0;
}
