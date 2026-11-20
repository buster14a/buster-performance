extern volatile int marker;
long double x87_positive_zero(void) { marker = 9; return 0.0L; }
long double x87_positive_one(void) { marker = 9; return 1.0L; }
long double x87_negative_zero(void) { marker = 9; return -0.0L; }
long double x87_negative_one(void) { marker = 9; return -1.0L; }
