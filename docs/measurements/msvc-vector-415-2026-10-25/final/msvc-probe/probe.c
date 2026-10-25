#include "tree/src/buster/compiler/c_lexer.c"
int64_t lexer_probe(const uint8_t* source, uint64_t length, uint8_t* kinds, uint32_t* starts, uint32_t* ends, uint32_t flags)
{
    return c_tokenize(source, length, kinds, starts, ends, flags);
}
