int f(void); int t(int (*g)(void)) { return g == f; }
