#include "zstd.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
static void *read_all(const char *name, size_t *length)
{
    FILE *f=fopen(name,"rb");
    if(!f || fseek(f,0,SEEK_END)) return NULL;
    long bytes=ftell(f);
    if(bytes<0 || fseek(f,0,SEEK_SET)) return NULL;
    size_t n=(size_t)bytes;
    void *p=malloc(n?n:1);
    if(!p || (n && fread(p,1,n,f)!=n) || fclose(f)) return NULL;
    *length=n; return p;
}
int main(int argc,char **argv)
{
    if(argc!=6) return 2;
    int level=atoi(argv[4]); unsigned rounds=(unsigned)strtoul(argv[5],NULL,10);
    const int decompress=strcmp(argv[1],"decompress")==0;
    if(!decompress && strcmp(argv[1],"compress")) return 2;
    size_t size=0,frame_size=0;
    void *src=read_all(argv[2],&size),*frame=read_all(argv[3],&frame_size);
    size_t capacity=decompress?size:ZSTD_compressBound(size);
    unsigned char *out=malloc(capacity?capacity:1);
    ZSTD_CCtx *c=ZSTD_createCCtx(); ZSTD_DCtx *d=ZSTD_createDCtx();
    if(!src || !frame || !out || !c || !d || !rounds) return 3;
    size_t produced=0;
    for(unsigned i=0;i<rounds;i++) {
        produced=decompress?ZSTD_decompressDCtx(d,out,capacity,frame,frame_size):ZSTD_compressCCtx(c,out,capacity,src,size,level);
        if(ZSTD_isError(produced)) {fprintf(stderr,"%s\n",ZSTD_getErrorName(produced));return 4;}
    }
    if(produced!=(decompress?size:frame_size) || memcmp(out,decompress?src:frame,produced)) return 5;
    uint64_t h=UINT64_C(14695981039346656037);
    for(size_t i=0;i<produced;i++) h=(h^out[i])*UINT64_C(1099511628211);
    printf("%zu %zu %016" PRIx64 "\n",size,produced,h);
    ZSTD_freeDCtx(d);ZSTD_freeCCtx(c);free(src);free(frame);free(out);return 0;
}
