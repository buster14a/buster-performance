#define _GNU_SOURCE
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
typedef struct String8 String8;
struct String8 { char* pointer; uint64_t length; };
#include SRC
int main(void){ char buf[64]; unsigned bad=0; for(unsigned len=0; len<=64; len++) for(unsigned b=0;b<256;b++){ memset(buf,(int)b,len); for(unsigned p=0;p<len;p++){ buf[p]=(char)((b+p*37)&255);} if(dependency_special(buf,len,false)!=dependency_special_scalar(buf,len)) bad++; } printf("%s bad=%u\n", SRC, bad); return bad!=0; }
