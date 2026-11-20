#include "opus.h"
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Setting {int rate,channels,application,bitrate,ms,as_float,vbr,dtx,fec;};
static const struct Setting profiles[]={
 {48000,2,OPUS_APPLICATION_AUDIO,128000,20,0,0,0,0},
 {48000,1,OPUS_APPLICATION_VOIP,24000,20,0,1,0,1},
 {16000,1,OPUS_APPLICATION_VOIP,12000,20,0,1,1,1},
 {48000,2,OPUS_APPLICATION_RESTRICTED_LOWDELAY,96000,5,1,0,0,0},
 {8000,1,OPUS_APPLICATION_VOIP,9000,40,0,1,1,0},
 {24000,2,OPUS_APPLICATION_AUDIO,48000,10,1,1,0,0},
 {48000,2,OPUS_APPLICATION_AUDIO,56000,60,0,1,0,0},
};
enum { FRAMES=64, MAX=5760*2, PKT=4000 };
static opus_int16 pcm[MAX];static float fp[MAX];static unsigned char packets[FRAMES][PKT];static uint16_t lengths[FRAMES];
static void require(int ok){if(!ok)exit(2);}
static uint64_t state;
static uint32_t rng(void){state^=state<<13;state^=state>>7;state^=state<<17;return (uint32_t)state;}
static void fill(unsigned frame,int n,const struct Setting *s){
 for(int i=0;i<n;i++)for(int c=0;c<s->channels;c++){
  unsigned time=frame*(unsigned)n+(unsigned)i;uint32_t t=(time*(31u+7u*c)*8192u)/(unsigned)s->rate;
  int tri=(int)(t&1023);tri=(tri<512?tri:1023-tri)-255;int noise=(int)(rng()>>17)-16384;
  int v=frame<12 || (frame>=28&&frame<36)?0:frame<24?tri*80:frame<48?noise/2+tri*45:time%293<3?25000:tri*12;
  pcm[i*s->channels+c]=(opus_int16)v;fp[i*s->channels+c]=(float)pcm[i*s->channels+c]*(1.0f/32768.0f);
 }
}
static FILE *openfile(const char *path,const char *mode){FILE *f=fopen(path,mode);require(f!=NULL);return f;}
int main(int argc,char **argv){
 if(argc!=5)return 2;int which=atoi(argv[2]);require(which>=0&&which<(int)(sizeof(profiles)/sizeof(*profiles)));
 const struct Setting *s=profiles+which;int n=s->ms*s->rate/1000,err;state=UINT64_C(0x655ac7123100d52b);int encode=strcmp(argv[1],"encode")==0;
 if(encode){
  OpusEncoder *e=opus_encoder_create(s->rate,s->channels,s->application,&err);require(e&&err==OPUS_OK);
  require(opus_encoder_ctl(e,OPUS_SET_BITRATE(s->bitrate))==OPUS_OK);require(opus_encoder_ctl(e,OPUS_SET_COMPLEXITY(8))==OPUS_OK);
  require(opus_encoder_ctl(e,OPUS_SET_VBR(s->vbr))==OPUS_OK);require(opus_encoder_ctl(e,OPUS_SET_DTX(s->dtx))==OPUS_OK);
  require(opus_encoder_ctl(e,OPUS_SET_INBAND_FEC(s->fec))==OPUS_OK);require(opus_encoder_ctl(e,OPUS_SET_PACKET_LOSS_PERC(s->fec?15:0))==OPUS_OK);
  FILE *out=openfile(argv[3],"wb");for(unsigned j=0;j<FRAMES;j++){
   fill(j,n,s);int count=s->as_float?opus_encode_float(e,fp,n,packets[j],PKT):opus_encode(e,pcm,n,packets[j],PKT);require(count>0&&count<=PKT&&opus_packet_get_nb_samples(packets[j],count,s->rate)==n);
   unsigned char prefix[2]={(unsigned char)count,(unsigned char)(count>>8)};require(fwrite(prefix,1,2,out)==2&&fwrite(packets[j],1,(unsigned)count,out)==(unsigned)count);
  }require(!fclose(out));opus_encoder_destroy(e);
 }else{
  int lose=strcmp(argv[1],"loss")==0;require(lose||!strcmp(argv[1],"decode"));FILE *in=openfile(argv[3],"rb");
  for(unsigned j=0;j<FRAMES;j++){int a=fgetc(in),b=fgetc(in);require(a>=0&&b>=0);lengths[j]=(uint16_t)((unsigned)b*256u+(unsigned)a);require(lengths[j]&&lengths[j]<=PKT&&fread(packets[j],1,lengths[j],in)==lengths[j]);}
  require(fgetc(in)==EOF&&!fclose(in));FILE *out=openfile(argv[4],"wb");OpusDecoder *d=opus_decoder_create(s->rate,s->channels,&err);require(d&&err==OPUS_OK);
  for(unsigned j=0;j<FRAMES;j++){
   const unsigned char *packet=packets[j];int len=lengths[j],fec=0;
   if(lose&&j%13==5){packet=NULL;len=0;if(s->fec&&j+1<FRAMES){packet=packets[j+1];len=lengths[j+1];fec=1;}}
   int got=opus_decode(d,packet,len,pcm,n,fec);require(got==n);require(fwrite(pcm,sizeof(*pcm),n*s->channels,out)==(unsigned)(n*s->channels));
  }require(!fclose(out));opus_decoder_destroy(d);
 }
 return 0;
}
