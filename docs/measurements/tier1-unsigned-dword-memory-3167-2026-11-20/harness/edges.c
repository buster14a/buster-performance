#include <stdint.h>
typedef uint32_t Word;
extern void write_word(Word *, Word);
struct __attribute__((packed)) PackedWord { unsigned char prefix; Word value; };
#define CASES(T, S) \
T indexed_##S(Word *p, int i, Word k) { return (T)p[i - 3]; } \
T alias_##S(Word *p, int i, Word k) { Word v=p[i]; p[i]=k; return (T)v; } \
T call_##S(Word *p, int i, Word k) { Word v=p[i]; write_word(&p[i],k); return (T)v; } \
T volatile_##S(Word *p, int i, Word k) { Word v=((volatile Word*)p)[i]; p[i]=k; return (T)v; } \
T atomic_##S(Word *p, int i, Word k) { Word v=__atomic_load_n(&p[i],__ATOMIC_SEQ_CST); __atomic_store_n(&p[i],k,__ATOMIC_SEQ_CST); return (T)v; } \
T guarded_##S(Word *p,int ok,Word fallback) { if(ok) return (T)*p; return (T)fallback; } \
T packed_##S(struct PackedWord *p) { return (T)p->value; }
CASES(float, f)
CASES(double, d)
