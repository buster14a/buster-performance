static int duplicate(void) { return 11; }
int remote(void) { return duplicate(); }
int strong_target(void) { return 17; }
int strong_alias(void) __attribute__((alias("strong_target")));
int (*published)(void) = strong_alias;
