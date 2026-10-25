#ifndef BUSTER_MSVC_PROBE_STRING_H
#define BUSTER_MSVC_PROBE_STRING_H
#include <stddef.h>
void* memcpy(void*, const void*, size_t);
void* memchr(const void*, int, size_t);
int memcmp(const void*, const void*, size_t);
size_t strlen(const char*);
#endif
