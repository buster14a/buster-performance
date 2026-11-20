#include "zstd.h"
#include <stdio.h>
#include <stdlib.h>
int main(int argc,char **argv)
{
    if(argc!=4) return 2;
    FILE *f=fopen(argv[1],"rb"); if(!f || fseek(f,0,SEEK_END)) return 3;
    long bytes=ftell(f); if(bytes<0 || fseek(f,0,SEEK_SET)) return 3;
    size_t n=(size_t)bytes,capacity=ZSTD_compressBound(n); void *src=malloc(n?n:1),*dst=malloc(capacity);
    if(!src||!dst||fread(src,1,n,f)!=n||fclose(f)) return 3;
    size_t z=ZSTD_compress(dst,capacity,src,n,atoi(argv[3])); if(ZSTD_isError(z)) return 4;
    f=fopen(argv[2],"wb"); if(!f||fwrite(dst,1,z,f)!=z||fclose(f)) return 5;
    free(src);free(dst);return 0;
}
