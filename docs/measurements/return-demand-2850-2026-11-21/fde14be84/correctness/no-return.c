_Noreturn void die(void);
_Noreturn void stops(void) { die(); }
_Noreturn void falls(int n) { if (n) die(); }
