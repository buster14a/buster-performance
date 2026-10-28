extern int target;union U{int *p;unsigned char pad[268435456];} a={.p=&target,.pad={0}};
unsigned char *get(void){return (unsigned char *)&a;}
unsigned long get_size(void){return sizeof a;}
