#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
enum { count = 256, room = 168 };
static long double extended[count]; static double regular[count]; static uint64_t seed=UINT64_C(0x2149fab83a1e1107);
static uint64_t random_bits(void) {seed^=seed<<13;seed^=seed>>7;seed^=seed<<17;return seed;}
static long double make_ld(unsigned se,uint64_t lo) {long double v;unsigned char b[sizeof(v)]={0};memcpy(b,&lo,8);memcpy(b+8,&se,2);memcpy(&v,b,sizeof(v));return v;}
static void prepare(void) {
 for(unsigned i=0;i<count;i++) {uint64_t frac=random_bits()|(UINT64_C(1)<<63);unsigned neg=i&1?0x8000:0;
  unsigned e=16383+(int)(random_bits()%241)-120;
  if(i%31==0){e=0;frac=0;}else if(i%41==0){e=0;frac=1+(i&63);}else if(i%43==0){e=0x7fff;frac=UINT64_C(1)<<63;}
  else if(i%47==0){e=0x7fff;frac|=UINT64_C(3)<<62;}else if(i%7==0){e=16383+(int)(i%24)-12;frac=UINT64_C(1)<<63|((i&3u)*(UINT64_C(1)<<58));}
  extended[i]=make_ld(e|neg,frac);regular[i]=(double)extended[i];
 }
}
static void reset(unsigned r) {unsigned short cw=0x037f|(r<<10);unsigned mx=0x1f80|(r<<13);__asm__ volatile("fninit;fldcw %0;ldmxcsr %1"::"m"(cw),"m"(mx):"memory");}
static int render(unsigned group,unsigned i,char*buf,size_t n) {
 int prec=(int)(i%29),width=(i&1)?19:-23;
 switch(group) {
 case 0:return snprintf(buf,n,"%+#*.*La",width,prec,extended[i]);
 case 1:return snprintf(buf,n,"% 0*.*Lf",width,prec,extended[i]);
 case 2:return snprintf(buf,n,"%#-.*Le",prec,extended[i]);
 case 3:return snprintf(buf,n,"%+.*Lg",prec,extended[i]);
 case 4:return snprintf(buf,n,"[%#.19a|%+.9g]",regular[i],regular[i]);
 default:return snprintf(buf,n,"%3$*2$.*1$LG/%4$#.*1$La",prec,width,extended[i],extended[(i+11)%count]);}
}
static uint64_t mix(uint64_t h,const unsigned char *s,size_t n){for(size_t j=0;j<n;j++)h=(h^s[j])*UINT64_C(1099511628211);return h;}
int main(int ac,char **av) {
 if(ac!=4)return 2;unsigned g=(unsigned)strtoul(av[1],0,10),reps=(unsigned)strtoul(av[3],0,10);if(g>=6||!reps||reps>1000)return 2;
 int check=!strcmp(av[2],"check");reset(0);prepare();uint64_t sum=UINT64_C(1469598103934665603);
 unsigned char b[room];static const unsigned sizes[]={0,1,13,85,152};
 for(unsigned k=0;k<(check?4:reps);k++){
  reset(check?k:0);
  for(unsigned i=0;i<count;i++)for(unsigned z=0;z<(check?5u:1u);z++){
   unsigned n=check?sizes[z]:152u;memset(b,0xa5,sizeof(b));if(check)reset(k);errno=0;
   int rc=render(g,i,n?(char*)b+8:NULL,n);int e=errno;unsigned short sw,cw;unsigned mx;
   __asm__ volatile("fnstsw %0;fnstcw %1;stmxcsr %2":"=m"(sw),"=m"(cw),"=m"(mx)::"memory");
   if(rc<0||e)return 3;unsigned used=rc+1u<n?rc+1u:n;
   if((used&&b[7+used]!=0)||memchr(b,0xa5,8)==NULL)return 4;
   for(unsigned j=0;j<8;j++)if(b[j]!=0xa5)return 4;
   for(unsigned j=8+used;j<room;j++)if(b[j]!=0xa5)return 4;
   unsigned char status[12]={0};memcpy(status,&rc,4);memcpy(status+4,&e,4);status[8]=sw&63;status[9]=mx&63;status[10]=(sw>>11)&7;status[11]=(cw>>10)&3;
   if(check){if(fwrite(status,1,12,stdout)!=12||fwrite(b,1,room,stdout)!=room)return 5;}
   else{sum=mix(sum,status,12);sum=mix(sum,b+8,used);}
  }
 }
 if(!check)printf("%016llx\n",(unsigned long long)sum);return 0;
}
