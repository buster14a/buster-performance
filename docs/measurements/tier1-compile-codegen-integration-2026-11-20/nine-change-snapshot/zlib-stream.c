#include "zlib.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int exercise(const unsigned char *source, unsigned length, int level, int strategy, unsigned chunk, FILE *out)
{
    z_stream encoder = {0};
    z_stream decoder = {0};
    if (deflateInit2(&encoder, level, Z_DEFLATED, 15, 8, strategy) != Z_OK) return 2;
    const uLong capacity = deflateBound(&encoder, length) + 16;
    unsigned char *compressed = malloc(capacity);
    unsigned char *restored = malloc(length + 1);
    if (!compressed || !restored) return 3;
    unsigned consumed = 0;
    int status;
    do {
        if (!encoder.avail_in && consumed < length) {
            const unsigned left = length - consumed;
            encoder.avail_in = left < chunk ? left : chunk;
            encoder.next_in = (Bytef *)source + consumed;
            consumed += encoder.avail_in;
        }
        encoder.next_out = compressed + encoder.total_out;
        const uLong room = capacity - encoder.total_out;
        encoder.avail_out = room < 97 ? (uInt)room : 97;
        if (!encoder.avail_out) return 4;
        status = deflate(&encoder, consumed == length ? Z_FINISH : Z_NO_FLUSH);
        if (status != Z_OK && status != Z_STREAM_END) return 5;
    } while (status != Z_STREAM_END);
    const unsigned size = (unsigned)encoder.total_out;
    if (deflateEnd(&encoder) != Z_OK || inflateInit(&decoder) != Z_OK) return 6;
    unsigned supplied = 0;
    do {
        if (!decoder.avail_in && supplied < size) {
            const unsigned left = size - supplied;
            decoder.avail_in = left < 53 ? left : 53;
            decoder.next_in = compressed + supplied;
            supplied += decoder.avail_in;
        }
        decoder.next_out = restored + decoder.total_out;
        const unsigned room = length + 1 - (unsigned)decoder.total_out;
        decoder.avail_out = room < 4093 ? room : 4093;
        status = inflate(&decoder, Z_NO_FLUSH);
        if (status != Z_OK && status != Z_STREAM_END) return 7;
    } while (status != Z_STREAM_END);
    if (decoder.total_out != length || decoder.total_in != size || memcmp(source,restored,length) || inflateEnd(&decoder)!=Z_OK) return 8;
    const uint32_t record[] = {(uint32_t)level,(uint32_t)strategy,chunk,size,crc32(0,source,length),adler32(1,source,length)};
    if (fwrite(record,sizeof(record),1,out)!=1 || fwrite(compressed,1,size,out)!=size) return 9;
    free(compressed);
    free(restored);
    return 0;
}

int main(int argc, char **argv)
{
    if (argc != 3) return 1;
    FILE *input = fopen(argv[1],"rb"), *output = fopen(argv[2],"wb");
    if (!input || !output || fseek(input,0,SEEK_END)) return 1;
    const long n = ftell(input);
    if (n < 0 || n > 4000000L || fseek(input,0,SEEK_SET)) return 1;
    unsigned char *data = malloc((size_t)n+1);
    if (!data || fread(data,1,(size_t)n,input)!=(size_t)n || fclose(input)) return 1;
    const int levels[]={0,1,3,6,9};
    const int strategies[]={Z_DEFAULT_STRATEGY,Z_FILTERED,Z_HUFFMAN_ONLY,Z_RLE,Z_FIXED};
    const unsigned chunks[]={1,31,4096};
    for (unsigned l=0;l<5;l++) for (unsigned k=0;k<5;k++) for (unsigned c=0;c<3;c++) {
        const int rc=exercise(data,(unsigned)n,levels[l],strategies[k],chunks[c],output);
        if (rc) {fprintf(stderr,"level %d strategy %d chunk %u error %d\n",levels[l],strategies[k],chunks[c],rc);return rc;}
    }
    free(data);
    return fclose(output)!=0;
}
