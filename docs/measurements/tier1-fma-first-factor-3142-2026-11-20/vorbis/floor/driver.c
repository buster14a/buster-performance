#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ogg/ogg.h>
#include "vorbis/codec.h"
#include "codec_internal.h"
#include "registry.h"
typedef struct { int x0,x1,xa,ya,x2a,y2a,xya,an,xb,yb,x2b,y2b,xyb,bn; } Fit;
extern int accumulate_fit(const float*,const float*,int,int,Fit*,int,vorbis_info_floor1*);
static float floor_db[512],spectrum[512];
static uint64_t word=UINT64_C(0x97c74a7c3ade981b);
static unsigned rand32(void) {word^=word<<13;word^=word>>7;word^=word<<17;return (unsigned)word;}
static int expected(const float *floor,const float *spec,int start,int stop,Fit *a,int len,float atten) {
 *a=(Fit){.x0=start,.x1=stop};
 for(int i=start;i<len&&i<=stop;i++){
  int q=(int)fmaf(floor[i],7.3142857f,1023.5f); if(q>1023)q=1023;if(q<=0)continue;
  if(spec[i]+atten>=floor[i]){a->xa+=i;a->ya+=q;a->x2a+=i*i;a->y2a+=q*q;a->xya+=i*q;a->an++;}
  else{a->xb+=i;a->yb+=q;a->x2b+=i*i;a->y2b+=q*q;a->xyb+=i*q;a->bn++;}
 } return a->an;
}
static uint64_t digest(uint64_t h,const Fit *a){const unsigned char *bytes=(const unsigned char*)a;for(unsigned i=0;i<sizeof(*a);i++)h=(h^bytes[i])*UINT64_C(1099511628211);return h;}
int main(int argc,char **argv){
 if(argc!=3)return 2;int group=atoi(argv[1]),time=atoi(argv[2]);if(group<0||group>3)return 2;
 vorbis_info_floor1 info={0};unsigned n=0;uint64_t actual=UINT64_C(1469598103934665603);
 for(int t=0;t<(time?1:64);t++){
  for(int i=0;i<512;i++){floor_db[i]=(int)(rand32()%32101)*.005f-151.0f;spectrum[i]=floor_db[i]+((int)(rand32()%181)-90)*.125f;
    if(group==1)spectrum[i]=floor_db[i]+4.0f;if(group==2)spectrum[i]=floor_db[i]-4.0f;if(group==3)floor_db[i]=-160.0f;}
  info.twofitatten=time?0.75f:((int)(rand32()%65)-32)*.125f;
  for(int j=0;j<(time?12000:128);j++){
   int len=time?256:1+(rand32()%511);int lo=time?((j*3)&63):(rand32()%(len+1));int hi=time?lo+127:lo+(rand32()%(len+2));
   Fit value;int ret=accumulate_fit(floor_db,spectrum,lo,hi,&value,len,&info);
   if(!time){Fit ref;int desired=expected(floor_db,spectrum,lo,hi,&ref,len,info.twofitatten);if(ret!=desired||memcmp(&value,&ref,sizeof(ref)))return 3;}
   actual=digest(actual,&value);n++;
  }
 }
 printf("%u %016llx\n",n,(unsigned long long)actual);return 0;
}
