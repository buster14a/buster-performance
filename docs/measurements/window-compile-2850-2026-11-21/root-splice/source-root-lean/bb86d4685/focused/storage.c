extern int ac; int ac; extern int ac; static int bc; extern int renamed __asm__("actual_name"); static int localcopy;
int source(int x){ int a=x,b=2; a=b; ac=3; bc=7; localcopy=42; renamed=8; { int b=ac; a=b; } return a; }
int reads(void){return ac+bc;} int copies(void){ static int z; z=3; return z; }
