M = [
 ("carry-dropped", "            carried |= live && bit == 63 ? 1 : 0;", "            carried |= live && bit == 99 ? 1 : 0;"),
 ("escaped-escapes", "            const bool live = ((escaped >> bit) & 1) == 0;", "            const bool live = ((escaped >> bit) & 1) == 0 || bit == 99 || true;"),
 ("string-newline-ignored", "_mm512_mask_cmpeq_epi8_mask(valid, bytes, _mm512_set1_epi8('\"')) | _mm512_mask_cmpeq_epi8_mask(valid, bytes, _mm512_set1_epi8('\\n'));", "_mm512_mask_cmpeq_epi8_mask(valid, bytes, _mm512_set1_epi8('\"'));"),
 ("string-closed-wrong", "    *closed = result < length && source[result] == '\"';", "    *closed = result < length;"),
 ("block-lines-after-close", "        lines &= close != 0 ? _bzhi_u64(~0ull, (uint32_t)__builtin_ctzll(close)) : ~0ull;", "        lines &= close != 0 ? ~0ull : ~0ull;"),
 ("block-start-early", "    uint32_t offset = at + 2;\n    *closed = false;", "    uint32_t offset = at + 1;\n    *closed = false;"),
 ("block-lines-dropped", "            parser->tokens[parser->token_count++] = (AsmToken){.start = line, .end = line + 1, .kind = '\\n'};", "            parser->tokens[parser->token_count] = (AsmToken){.start = line, .end = line + 1, .kind = '\\n'};"),
 ("scan-last-block", "        result = found != 0 ? at + (uint32_t)__builtin_ctzll(found) : result;", "        result = found != 0 && n == 64 ? at + (uint32_t)__builtin_ctzll(found) : result;"),
 ("slash-kind", "(AsmToken){.start = at, .end = end, .kind = '/'};", "(AsmToken){.start = at, .end = end, .kind = '*'};"),
 ("bad-byte-token", "        parser->tokens[parser->token_count++] = (AsmToken){.start = at, .end = end, .kind = byte};", "        parser->tokens[parser->token_count] = (AsmToken){.start = at, .end = end, .kind = byte};"),
 ("string-skip-start", "    uint32_t offset = at + 1;\n    uint64_t carried = 0;", "    uint32_t offset = at + 2;\n    uint64_t carried = 0;"),
]
import sys, json
if sys.argv[1] == "list":
    print(" ".join(n for n, a, b in M))
else:
    p = sys.argv[2]; s = open(p).read()
    for n, a, b in M:
        if n == sys.argv[1]:
            assert s.count(a) == 1, (n, s.count(a)); open(p, "w").write(s.replace(a, b))
