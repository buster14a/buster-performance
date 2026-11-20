/* Same library API workload for 8-, 16- and 32-bit PCRE2 builds. */
#include <pcre2.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

enum { ROWS=256, UNITS=188, PATTERNS=7 };
static PCRE2_UCHAR data[ROWS][UNITS];
static size_t lengths[ROWS];
static uint32_t next_value(uint32_t *s)
{
    *s ^= *s << 13;
    *s ^= *s >> 17;
    *s ^= *s << 5;
    return *s;
}
static void widen(PCRE2_UCHAR *dest, const char *src)
{
    do { *dest++=(unsigned char)*src; } while (*src++);
}
static uint64_t mix(uint64_t v,uint64_t value)
{
    return (v^value)*UINT64_C(1099511628211);
}
int main(int argc,char **argv)
{
    static const char *patterns[PATTERNS]={
        "^([A-Z]+) ([a-z]+):([0-9]+) \\[([^]]+)\\]",
        "(?i)\\b(?:error|warn)\\b.*?code=([0-9]{2,4})",
        "path=/(?:[a-z]+/){1,4}([a-z]+)\\.([a-z0-9]+)",
        "\\b([a-z]{3,7})=\\1\\b",
        "([0-9]{2}):([0-9]{2}):([0-9]{2})\\b",
        "(?<=id=)[a-f0-9]{8}(?![a-f0-9])",
        "(?>[A-Za-z]+|[0-9]+)(?:[-_:](?:[0-9]+|[A-Za-z]+)){2}",
    };
    static const char *levels[]={"INFO","WARN","ERROR","DEBUG"};
    static const char *modules[]={"parser","writer","storage","runtime","driver","thread","lexer","policy"};
    const unsigned rounds=argc==2 ? (unsigned)strtoul(argv[1],NULL,10):32u;
    if(!rounds) return 2;
    uint32_t random=0x9231475u;
    for(unsigned row=0;row<ROWS;row++){
        uint32_t a=next_value(&random),b=next_value(&random);
        char line[UNITS];
        int n=snprintf(line,sizeof(line),"%s %s:%u [%02u:%02u:%02u] id=%08x path=/%s/%s/%s.%s code=%u %s=%s",
            levels[a%4],modules[(a>>8)%8],b%2048,(b>>8)%24,(b>>13)%60,(b>>20)%60,a,
            modules[(b>>4)%8],modules[(b>>7)%8],modules[(b>>10)%8],a&32?"log":"txt",(a>>22)%1000,
            modules[(a>>11)%8],modules[(a&1?a>>11:b>>5)%8]);
        if(n<=0 || (size_t)n>=sizeof(line)) return 3;
        widen(data[row],line); lengths[row]=(size_t)n;
    }
    pcre2_code *compiled[PATTERNS];
    pcre2_match_data *results=pcre2_match_data_create(16,NULL);
    if(!results)return 4;
    for(unsigned i=0;i<PATTERNS;i++){
        PCRE2_UCHAR pat[128];widen(pat,patterns[i]);int err;PCRE2_SIZE offset;
        compiled[i]=pcre2_compile(pat,PCRE2_ZERO_TERMINATED,PCRE2_UTF|PCRE2_UCP,&err,&offset,NULL);
        if(!compiled[i]) {fprintf(stderr,"pattern %u failed at %zu (%d)\n",i,(size_t)offset,err);return 5;}
    }
    uint64_t digest=UINT64_C(1469598103934665603),matched=0;
    for(unsigned round=0;round<rounds;round++)
        for(unsigned k=0;k<ROWS;k++){
            unsigned row=(k+round*37u)&255u;
            for(unsigned i=0;i<PATTERNS;i++){
                int n=pcre2_match(compiled[i],data[row],lengths[row],0,0,results,NULL);
                if(n<0 && n!=PCRE2_ERROR_NOMATCH) return 6;
                digest=mix(digest,(uint32_t)n);
                if(n>0){
                    matched++;
                    PCRE2_SIZE *v=pcre2_get_ovector_pointer(results);
                    for(int j=0;j<2*n;j++)digest=mix(digest,v[j]);
                }
            }
        }
    for(unsigned i=0;i<PATTERNS;i++)pcre2_code_free(compiled[i]);
    pcre2_match_data_free(results);
    printf("%u %" PRIu64 " %016" PRIx64 "\n",rounds*ROWS*PATTERNS,matched,digest);
    return 0;
}
