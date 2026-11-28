__attribute__((weak)) int f(void); int t(void) { return f != (void*)0; }
