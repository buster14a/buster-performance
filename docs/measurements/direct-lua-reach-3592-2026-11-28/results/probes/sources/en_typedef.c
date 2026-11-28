typedef enum {A,B} E; void g(E); void t(int c) { g(c < 0 ? A : B); }
