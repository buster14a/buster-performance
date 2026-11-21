extern int dynamic_address(int);
extern int fixed_address(int);
extern int pointer_address(int);
int consume(char *bytes,int count) {return bytes[count - 1];}
int main(void) {return dynamic_address(8)!=41 || fixed_address(8)!=41 || pointer_address(8)!=41;}
