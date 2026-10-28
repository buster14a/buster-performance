struct S{unsigned v:9;unsigned char pad[4194304];} a={.v=511,.v=0,.pad[4194303]=0};
unsigned char *get(void){return (unsigned char *)&a;}
unsigned long get_size(void){return sizeof a;}
