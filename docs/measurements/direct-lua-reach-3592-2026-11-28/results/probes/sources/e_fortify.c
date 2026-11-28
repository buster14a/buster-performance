void *memcpy(void *, const void *, unsigned long); char buf[10]; void t(const char *s) { memcpy((__extension__ (char *)buf), s, 100); }
