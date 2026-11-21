#define STOP() __builtin_trap()
int before(void) { return 123; }
void stop(void) { STOP(); }
int after(void) { return 456; }
