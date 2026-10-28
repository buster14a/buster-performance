struct S{unsigned v:9;unsigned char pad[268435456];} a={.v=511,.v=0,.pad[268435455]=0};
unsigned char *get(void){return (unsigned char *)&a;}
unsigned long get_size(void){return sizeof a;}
