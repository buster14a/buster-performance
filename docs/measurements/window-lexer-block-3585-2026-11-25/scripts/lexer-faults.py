# lexer-faults2.py: single-line faults in the window lexer, its readers and the inactive groups' skipper, each built
# into test-direct (c_direct.c's run_c_direct_tests) in a copy of the tree; every one must fail it. Four at a time.
import subprocess, shutil, os, sys, concurrent.futures
repo = '/home/user/buster'
lex = 'src/buster/compiler/c_direct_lex.c'
orig = open(os.path.join(repo, lex)).read()
L = '/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
flags = '-march=native -fwrapv -funsigned-char -fno-strict-aliasing -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -O1 -static -w'.split()
mutants = [
 ("run-carry-dropped", "        run_carry = run_goes_on >> 63;", "        run_carry = (run_goes_on >> 63) & 0;"),
 ("pair-at-last-byte-not-scalar", "            scalars = dots | (pairs & ((candidates >> 1) | top_bit));", "            scalars = dots | (pairs & ((candidates >> 1) | (top_bit & 0)));"),
 ("pair-before-candidate-not-scalar", "            scalars = dots | (pairs & ((candidates >> 1) | top_bit));", "            scalars = dots | (pairs & (((candidates >> 1) & 0) | top_bit));"),
 ("dot-not-scalar", "            scalars = dots | (pairs & ((candidates >> 1) | top_bit));", "            scalars = (dots & 0) | (pairs & ((candidates >> 1) | top_bit));"),
 ("rare-ignores-dots", "        if (__builtin_expect(((candidates & ((candidates >> 1) | top_bit)) | dots) != 0, 0))", "        if (__builtin_expect(((candidates & ((candidates >> 1) | top_bit)) | (dots & 0)) != 0, 0))"),
 ("rare-ignores-last-byte", "        if (__builtin_expect(((candidates & ((candidates >> 1) | top_bit)) | dots) != 0, 0))", "        if (__builtin_expect(((candidates & ((candidates >> 1) | (top_bit & 0))) | dots) != 0, 0))"),
 ("rare-ignores-touching", "        if (__builtin_expect(((candidates & ((candidates >> 1) | top_bit)) | dots) != 0, 0))", "        if (__builtin_expect(((candidates & (((candidates >> 1) & 0) | top_bit)) | dots) != 0, 0))"),
 ("number-never-goes-on", "    return after == '.' || ((after == '+' || after == '-') && (last == 'e' || last == 'p'));", "    return (after == '.' || ((after == '+' || after == '-') && (last == 'e' || last == 'p'))) & 0;"),
 ("exponent-sign-ignored", "    return after == '.' || ((after == '+' || after == '-') && (last == 'e' || last == 'p'));", "    return after == '.';"),
 ("long-run-never-scalar", "            wk[n - 1u] = BUSTER_FWIN_SCALAR;", "            wk[spare] = BUSTER_FWIN_SCALAR;"),
 ("long-run-length-unpatched", "        wl[run_carry != 0 ? n - 1u : spare] = (uint8_t)carried_len;", "        wl[spare] = (uint8_t)carried_len;"),
 ("long-run-check-ignores-carry", "        if (__builtin_expect((carried_len & (0u - run_carry)) > 255u, 0))", "        if (__builtin_expect(carried_len > 255u, 0))"),
 ("open-start-stale", "        open_start = run_starts != 0 ? off + 63u - _lzcnt_u64(run_starts) : open_start;", "        open_start = run_starts != 0 ? off + 62u - _lzcnt_u64(run_starts) : open_start;"),
 ("parity-odd", "            pairs = (from_even & even_bits) | (candidates & ~from_even & ~even_bits);", "            pairs = (from_even & ~even_bits) | (candidates & ~from_even & even_bits);"),
 ("own-ends-keep-carried", "        const uint64_t own_ends = tok_ends & (tok_ends - run_carry);", "        const uint64_t own_ends = tok_ends;"),
 ("ends-inside-runs", "        const uint64_t tok_ends = solid & ~(run_goes_on | pairs);", "        const uint64_t tok_ends = solid & ~pairs;"),
 ("ends-at-pair-first", "        const uint64_t tok_ends = solid & ~(run_goes_on | pairs);", "        const uint64_t tok_ends = solid & ~run_goes_on;"),
 ("starts-without-carry", "        const uint64_t tok_starts = solid & ~((runs & ((runs << 1) | run_carry)) | (pairs << 1));", "        const uint64_t tok_starts = solid & ~((runs & (runs << 1)) | (pairs << 1));"),
 ("starts-at-pair-second", "        const uint64_t tok_starts = solid & ~((runs & ((runs << 1) | run_carry)) | (pairs << 1));", "        const uint64_t tok_starts = solid & ~(runs & ((runs << 1) | run_carry));"),
 ("more-than-32-tokens", "        if (__builtin_expect(m_count > 32u, 0))", "        if (__builtin_expect(m_count > 64u, 0))"),
 ("bol-after-comment", "        bol = (newlines > solid) | (bol & (solid == 0));", "        bol = newlines > solid;"),
 ("prefix-check-dropped", "            if (ch == '\\\\' || (ch == '\\'' && number) || ((ch == '\"' || ch == '\\'') && prefix))", "            if (ch == '\\\\' || (ch == '\\'' && number))"),
 ("splice-check-dropped", "            if (ch == '\\\\' || (ch == '\\'' && number) || ((ch == '\"' || ch == '\\'') && prefix))", "            if ((ch == '\\'' && number) || ((ch == '\"' || ch == '\\'') && prefix))"),
 ("after-run-at-block-start-lost", "        const bool after_run = (limit != 0 || off != first_off) && (fast_char_class[p[-1]] & 1u) != 0;", "        const bool after_run = limit != 0 && (fast_char_class[p[-1]] & 1u) != 0;"),
 ("straddle-ignored", "        whole = starts[last] + length <= rel;", "        whole = true;"),
 ("straddle-string-like", "        else if (kind != FTOK_STR_LIT)\n        {\n            length = w->lens[last];", "        else if (kind == FTOK_IDENT || kind == FTOK_INT_LIT)\n        {\n            length = w->lens[last];"),
 ("scalar-extent-one", "                wl[idx] = (uint8_t)(1u + (uint32_t)((pairs >> bit) & 1u));", "                wl[idx] = 1u;"),
 ("next-class-sign-unmasked", "        const __m512i next_classes = _mm512_maskz_permutex2var_epi8(_mm512_testn_epi8_mask(v1, v_sign_bit), v_next_lo, v1, v_next_hi);", "        const __m512i next_classes = _mm512_permutex2var_epi8(v_next_lo, v1, v_next_hi);"),
 ("span-past-16-bits", "#define BUSTER_FWIN_SPAN           (65536u - 64u)", "#define BUSTER_FWIN_SPAN           (65536u + 4096u)"),
 ("origin-dropped-in-pass", "    const uint32_t rel = offset > w->origin ? offset - w->origin : 0u;", "    const uint32_t rel = offset;"),
 ("origin-dropped-in-tok", "    const uint8_t* const s = f->base + w->origin + w->starts[t];\n    const uint32_t kind = w->kinds[t];", "    const uint8_t* const s = f->base + w->starts[t];\n    const uint32_t kind = w->kinds[t];"),
 ("origin-dropped-in-emit", "            const uint8_t* const s = base + w->origin + w->starts[t];", "            const uint8_t* const s = base + w->starts[t];"),
 ("origin-dropped-in-macro", "    const uint8_t* const after_name = f->base + w->origin + w->starts[t] + w->lens[t];", "    const uint8_t* const after_name = f->base + w->starts[t] + w->lens[t];"),
 ("start-offset-from-file", "        const __m512i v_offset = _mm512_set1_epi16((short)(off - first_off));", "        const __m512i v_offset = _mm512_set1_epi16((short)off);"),
 ("comment-close-shares-star", "~_bzhi_u64(~UINT64_C(0), limit + 3u);", "~_bzhi_u64(~UINT64_C(0), limit + 2u);"),
 ("comment-close-not-opened", "            const uint64_t closes_here = closes & (UINT64_C(0) - ((stars >> limit >> 1) & 1u));", "            const uint64_t closes_here = closes;"),
 ("comment-close-before-open", "~_bzhi_u64(~UINT64_C(0), limit + 3u);", "~UINT64_C(0);"),
 ("comment-close-off-by-one", "                off = block_off + _tzcnt_u64(closes_here) + 1u;", "                off = block_off + _tzcnt_u64(closes_here);"),
 ("skip-open-without-carry", "        const __mmask64 opens = (star | slash) & ((slash << 1) | slash_in);", "        const __mmask64 opens = (star | slash) & (slash << 1);"),
 ("skip-taint-none", "        const __mmask64 tainted = passes & ~taint_sum;", "        const __mmask64 tainted = passes & ~taint_sum & 0;"),
 ("skip-first-any-hash", "        const __mmask64 directives = hash & first;", "        const __mmask64 directives = hash;"),
 ("skip-backslash-newline-real", "        const __mmask64 passes = ~(nl & ~((backslash << 1) | backslash_in));", "        const __mmask64 passes = ~nl;"),
]
def run(m):
    name, old, new = m
    if orig.count(old) != 1:
        return (name, "ANCHOR-MISSING %d" % orig.count(old))
    d = '/home/user/dp/faults/t-' + name
    shutil.rmtree(d, ignore_errors=True)
    shutil.copytree(os.path.join(repo, 'src'), os.path.join(d, 'src'))
    open(os.path.join(d, lex), 'w').write(orig.replace(old, new))
    b = subprocess.run([L] + flags + ['-I' + d + '/src', d + '/src/buster/compiler/c_direct.c', '/home/user/dp/faults/main.c', '-o', d + '/mutant'], capture_output=True, text=True)
    if b.returncode != 0:
        return (name, "BUILD-FAILED " + b.stderr[:200])
    try:
        r = subprocess.run([d + '/mutant'], capture_output=True, timeout=300, cwd=d)
        res = "killed" if r.returncode != 0 else "SURVIVED"
    except subprocess.TimeoutExpired:
        res = "killed (timeout)"
    shutil.rmtree(d, ignore_errors=True)
    return (name, res)
sel = [m for m in mutants if len(sys.argv) < 2 or m[0] in sys.argv[1:]]
with concurrent.futures.ThreadPoolExecutor(4) as ex:
    for name, res in ex.map(run, sel):
        print("%-36s %s" % (name, res), flush=True)
