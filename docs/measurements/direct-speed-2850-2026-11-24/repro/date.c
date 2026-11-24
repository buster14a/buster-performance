int puts(const char *);
int main(void) { puts(__DATE__ " " __TIME__); return 0; }
/* padding so that the file is longer than the lexer's tail of 80 bytes ......................... */
