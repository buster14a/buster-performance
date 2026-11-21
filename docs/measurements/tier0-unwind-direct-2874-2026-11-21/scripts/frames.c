// Every kind of Tier 0 frame, for piece 2's comparisons and fault round.
typedef __attribute__((vector_size(64))) int v16;
int g(char*);
int callee(int);
int leaf(int x) { return x + 1; }
int pushes(int x) { int a = g(0), b = g(0), c = g(0); return a + b + c + x; }
int reserve(int x) { char b[64]; b[x & 63] = 1; return g(b); }
int big(int x) { char b[70000]; b[x & 4095] = 1; return g(b); }
int vla(int n) { char b[n]; b[0] = 0; return g(b); }
int realigned(void) { _Alignas(64) char b[64]; b[0] = 0; return g(b); }
__attribute__((force_align_arg_pointer)) int forced(void) { char b[16]; b[0] = 0; return g(b); }
void eh(long offset, void* handler) { __builtin_eh_return(offset, handler); }
int tail(int x) { __attribute__((musttail)) return callee(x + 1); }
int tail_framed(int x) { char b[32]; b[x & 31] = 1; g(b); __attribute__((musttail)) return callee(x); }
struct interrupt_frame;
__attribute__((interrupt)) void isr(struct interrupt_frame* frame) { }
__attribute__((interrupt)) void isr_error(struct interrupt_frame* frame, unsigned long code) { g(0); }
__attribute__((no_caller_saved_registers)) void keep(int* p) { *p += g(0); }
__attribute__((no_caller_saved_registers)) void keep_vector(double* p) { *p = *p * 2.0; }
__attribute__((no_caller_saved_registers)) void keep_wide(v16* p) { *p = *p + *p; }
__attribute__((naked)) void naked(void) { __asm__("ret"); }
void leaves(void) { __asm__ volatile("addq $8, %%rsp\n\tret" ::: "memory"); }
void stack(char* p) { __asm__ volatile("movq %0, %%rsp" :: "r"(p) : "memory"); }
int many(int a, int b, int c, int d, int e, int f, int h, int i) { return g(0) + a + b + c + d + e + f + h + i; }
int loop(int n) { int s = 0; for (int i = 0; i < n; i += 1) { s += g(0); if (s > 100) break; } return s; }
__attribute__((no_caller_saved_registers)) void keep_general(int* p) { *p += 1; }
__attribute__((no_caller_saved_registers)) void keep_xmm(void) { __asm__ volatile("" ::: "xmm0"); }
__attribute__((no_caller_saved_registers, target("avx512f"))) void keep_mask(void) { __asm__ volatile("" ::: "k1"); }
__attribute__((no_caller_saved_registers)) void keep_rax(void) { __asm__ volatile("" ::: "rax"); }
