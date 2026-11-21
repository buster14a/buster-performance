#pragma clang diagnostic push
#pragma clang diagnostic warning "-Wunused-variable"
int first(void){int unused; return 1;}
#pragma clang diagnostic pop
int quiet(void){int unused; return 1;}
#pragma clang diagnostic error "-Wunused-parameter"
int final(int unused_parameter){return 2;}
