import subprocess, shutil, os, sys
src='/home/user/buster/src/buster/compiler/c_direct_lex.c'
orig=open(src).read()
L='/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
flags='-march=native -I/home/user/buster/src -fwrapv -funsigned-char -fno-strict-aliasing -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -O1 -static -w'.split()
mutants=[
 ("run-carry-dropped", "        run_carry = (runs >> 63) & next_run;", "        run_carry = (runs >> 63) & next_run & 0;"),
 ("pair-at-last-byte-not-scalar", "                                  (pairs & ((candidates >> 1) | top_bit));", "                                  (pairs & ((candidates >> 1) | (top_bit & 0)));"),
 ("pair-before-candidate-not-scalar", "                                  (pairs & ((candidates >> 1) | top_bit));", "                                  (pairs & (((candidates >> 1) & 0) | top_bit));"),
 ("dot-before-digit-not-scalar", "        const __mmask64 scalars = (dots & with_next & ", "        const __mmask64 scalars = (dots & 0 & with_next & "),
 ("dot-at-last-byte-not-scalar", "((uint64_t)((fast_lex_class[next_byte & 127u] >> 5) & 1u) << 63))) |", "((uint64_t)((fast_lex_class[next_byte & 127u] >> 5) & 0u) << 63))) |"),
 ("number-never-goes-on", "    return after == '.' || ((after == '+' || after == '-') && (last == 'e' || last == 'p'));", "    return (after == '.' || ((after == '+' || after == '-') && (last == 'e' || last == 'p'))) & 0;"),
 ("exponent-sign-ignored", "    return after == '.' || ((after == '+' || after == '-') && (last == 'e' || last == 'p'));", "    return after == '.';"),
 ("long-run-never-scalar", "        wk[run_carry != 0 && carried_len > 255u ? open_idx : spare] = BUSTER_FWIN_SCALAR;", "        wk[spare] = BUSTER_FWIN_SCALAR;"),
 ("long-run-length-unpatched", "        wl[carried_idx] = (uint8_t)carried_len;", "        wl[spare] = (uint8_t)carried_len;"),
 ("open-start-stale", "        open_start = starts_run ? block_offset + 63u - (uint32_t)_lzcnt_u64(run_starts) : open_start;", "        open_start = starts_run ? block_offset + 62u - (uint32_t)_lzcnt_u64(run_starts) : open_start;"),
 ("open-idx-stale", "        open_idx = starts_run ? n + m_count - 1u : open_idx;", "        open_idx = starts_run ? n + m_count - 2u : open_idx;"),
 ("parity-odd", "        const __mmask64 pairs = (from_even & even_bits) | (candidates & ~from_even & ~even_bits);", "        const __mmask64 pairs = (from_even & ~even_bits) | (candidates & ~from_even & even_bits);"),
 ("pair-across-block-dropped", "        const __mmask64 with_next = punct & ((lmask >> 1) | top_bit);", "        const __mmask64 with_next = punct & (lmask >> 1);"),
 ("pair-into-special", "        const __mmask64 with_next = punct & ((lmask >> 1) | top_bit);", "        const __mmask64 with_next = punct;"),
 ("straddle-ignored", "        whole = starts[last] + length <= offset;", "        whole = true;"),
 ("paired-ends-keep-carried", "        const __mmask64 paired_ends = run_ends & ~(_blsi_u64(run_ends) & (0u - run_carry));", "        const __mmask64 paired_ends = run_ends;"),
 ("run-lanes-all", "        const __mmask64 run_lanes = _pext_u64(run_starts, tok_starts);", "        const __mmask64 run_lanes = _pext_u64(run_starts | punct, tok_starts);"),
 ("more-than-32-tokens", "        if (__builtin_expect(m_count > 32u, 0))", "        if (__builtin_expect(m_count > 64u, 0))"),
 ("bol-after-comment", "        bol = solid != 0 ? chunk_nl > solid : (bol || chunk_nl != 0);", "        bol = solid != 0 ? chunk_nl > solid : (chunk_nl != 0);"),
 ("skip-open-without-carry", "        const __mmask64 opens = (star | slash) & ((slash << 1) | slash_in);", "        const __mmask64 opens = (star | slash) & (slash << 1);"),
 ("skip-taint-none", "        const __mmask64 tainted = passes & ~taint_sum;", "        const __mmask64 tainted = passes & ~taint_sum & 0;"),
 ("skip-taint-carry-dropped", "            taint_in = taint_out;\n", "            taint_in = 0;\n"),
 ("skip-first-any-hash", "        const __mmask64 directives = hash & first;", "        const __mmask64 directives = hash;"),
 ("skip-bol-carry-dropped", "            bol_in = lead_out | (nl >> 63);", "            bol_in = nl >> 63;"),
 ("skip-backslash-newline-real", "        const __mmask64 passes = ~(nl & ~((backslash << 1) | backslash_in));", "        const __mmask64 passes = ~nl;"),
 ("skip-backslash-carry-dropped", "            backslash_in = backslash >> 63;", "            backslash_in = 0;"),
 ("skip-comment-bol-lost", "                next_bol = at_first ? 1u : 0u;", "                next_bol = 0u;"),
 ("skip-slash-first-carry", "            slash_first = first >> 63;", "            slash_first = 0;"),
 ("skip-slash-taint-carry", "            slash_tainted = tainted >> 63;", "            slash_tainted = 0;"),
 ("prefix-check-dropped", "            if (ch == '\\\\' || (ch == '\\'' && number) || ((ch == '\"' || ch == '\\'') && prefix))", "            if (ch == '\\\\' || (ch == '\\'' && number))"),
 ("tail-run-dropped", "        const bool after_run = limit != 0 ? ((runs >> (limit - 1u)) & 1u) != 0 : tail_run != 0;", "        const bool after_run = limit != 0 ? ((runs >> (limit - 1u)) & 1u) != 0 : false;"),
 ("tail-run-not-reset", "        tail_run = 0;\n        const uint8_t ch = p[0];", "        const uint8_t ch = p[0];"),
 ("scalar-extent-one", "                wl[idx] = (uint8_t)(1u + (uint32_t)((pairs >> bit) & 1u));", "                wl[idx] = 1u;"),
 ("straddle-string-like", "        else if (kind != FTOK_STR_LIT)\n        {\n            length = w->lens[last];", "        else if (kind == FTOK_IDENT || kind == FTOK_INT_LIT)\n        {\n            length = w->lens[last];"),
 ("splice-check-dropped", "            if (ch == '\\\\' || (ch == '\\'' && number) || ((ch == '\"' || ch == '\\'') && prefix))", "            if ((ch == '\\'' && number) || ((ch == '\"' || ch == '\\'') && prefix))"),
]
results=[]
try:
    for name, old, new in mutants:
        if orig.count(old)!=1:
            results.append((name, "ANCHOR-MISSING %d" % orig.count(old))); continue
        open(src,'w').write(orig.replace(old,new))
        b=subprocess.run([L]+flags+['/home/user/buster/src/buster/compiler/c_direct.c','main.c','-o','mutant'],capture_output=True,text=True)
        if b.returncode!=0:
            results.append((name,"BUILD-FAILED")); continue
        try:
            r=subprocess.run(['./mutant'],capture_output=True,timeout=120)
            results.append((name, "killed" if r.returncode!=0 else "SURVIVED"))
        except subprocess.TimeoutExpired:
            results.append((name,"killed (timeout)"))
finally:
    open(src,'w').write(orig)
for n,r in results: print("%-36s %s" % (n,r))
