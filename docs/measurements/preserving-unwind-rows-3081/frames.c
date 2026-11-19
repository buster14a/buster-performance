long ordinary(long x) { return x + 1; }
__attribute__((preserve_most)) long most(long x) { return x + 1; }
__attribute__((preserve_all)) long all(long x) { return x + 1; }
__attribute__((no_caller_saved_registers)) void keep(volatile long *p) { *p += 1; }
struct irq_frame { unsigned long ip, cs, flags, sp, ss; };
__attribute__((interrupt)) void irq(struct irq_frame *frame) { (void)frame; }
__attribute__((interrupt)) void fault(struct irq_frame *frame, unsigned long error) { (void)frame; (void)error; }
