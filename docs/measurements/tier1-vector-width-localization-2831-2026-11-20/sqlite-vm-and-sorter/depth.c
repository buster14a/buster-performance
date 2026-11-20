#include <stdio.h>
#include <limits.h>
#include <stdint.h>
typedef int64_t i64;
#define SORTER_MAX_MERGE_COUNT 16
static int vdbeSorterTreeDepth(int nPMA){
  int nDepth = 0;
  i64 nDiv = SORTER_MAX_MERGE_COUNT;
  while( nDiv < (i64)nPMA ){
    nDiv = nDiv * SORTER_MAX_MERGE_COUNT;
    nDepth++;
  }
  return nDepth;
}
int main(void){
  unsigned values[]={0,1,15,16,17,255,256,257,4095,4096,4097,65535,65536,65537,1048575,1048576,1048577,16777215,16777216,16777217,268435455,268435456,268435457,INT_MAX};
  puts("nPMA\tdepth\tscalar_multiply_iterations");
  for(unsigned i=0;i<sizeof(values)/sizeof(*values);i++){int depth=vdbeSorterTreeDepth((int)values[i]);printf("%u\t%d\t%d\n",values[i],depth,depth>0?depth-1:0);if(depth>7)return 1;}
  return 0;
}
