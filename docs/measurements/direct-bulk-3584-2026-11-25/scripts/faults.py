import subprocess, sys, os, shutil
src='/home/user/buster/src/buster/compiler/c_direct_lex.c'
orig=open(src).read()
mutants=[
 ('CONTROL (no change)', 'static bool fast_pp_frame_args(', 'static bool fast_pp_frame_args('),
 ('space flag dropped', '    const __m512i v_space = _mm512_set1_epi64((int64_t)BUSTER_FTOK_SPACE << 8);', '    const __m512i v_space = _mm512_setzero_si512();'),
 ('space from wrong lane', 'const uint32_t space = (uint32_t)_mm512_cmpneq_epi32_mask(starts, _mm512_alignr_epi32(ends, v_ends, 15));', 'const uint32_t space = (uint32_t)_mm512_cmpneq_epi32_mask(starts, _mm512_alignr_epi32(ends, v_ends, 14));'),
 ('carry end not kept', '        v_ends = _mm512_permutexvar_epi32(_mm512_set1_epi32((int32_t)(lanes - 1u)), ends);', '        v_ends = _mm512_permutexvar_epi32(_mm512_set1_epi32((int32_t)(0u)), ends);'),
 ('long strings taken', '(_mm512_cmpeq_epi8_mask(kinds, v_string) & _mm512_testn_epi8_mask(lens, lens))', '(_mm512_cmpeq_epi8_mask(kinds, v_string) & 0)'),
 ('numbers that go on taken', '            if (fast_number_goes_on(base + w->starts[t + k], w->lens[t + k]))', '            if (0 & fast_number_goes_on(base + w->starts[t + k], w->lens[t + k]))'),
 ('punct len for runs', 'const __m512i ends = _mm512_add_epi32(starts, _mm512_cvtepu8_epi32(_mm_mask_blend_epi8(sized, punct_len, lens)));', 'const __m512i ends = _mm512_add_epi32(starts, _mm512_cvtepu8_epi32(punct_len));'),
 ('flat check ignores depth', '    const bool flat = *io_depth == 1u && (opens & live & (first_close - 1u)) == 0;', '    const bool flat = (opens & live & (first_close - 1u)) == 0;'),
 ('flat check ignores opens', '    const bool flat = *io_depth == 1u && (opens & live & (first_close - 1u)) == 0;', '    const bool flat = *io_depth == 1u;'),
 ('separators include close', '    uint64_t separators = commas & at_one & live & (closing - 1u);', '    uint64_t separators = commas & at_one & live;'),
 ('variadic splits all commas', '    while (separators != 0 && taken && (m->is_variadic == 0 || arg_count < m->param_count))', '    while (separators != 0 && taken)'),
 ('first arg gap from the paren start', '        const uint8_t* end = f->base + w->starts[lparen] + 1u;', '        const uint8_t* end = f->base + w->starts[lparen];'),
 ('line synced to the paren start', '            fast_pp_sync_file(f, f->base + w->starts[close] + 1u);', '            fast_pp_sync_file(f, f->base + w->starts[close]);'),
 ('window not past the close', '            w->pos = close + 1u;', '            w->pos = close;'),
 ('frame not past the close', '        ef->pos = close + 1u;', '        ef->pos = close;'),
 ('read_line ends early', '            done = t1 == w->count && w->stop == BUSTER_FWIN_STOP_EOL;', '            done = t1 == w->count;'),
 ('plain walk ignores #', '        if ((bt.kind == FTOK_HASH && next_param) || (bt.kind == FTOK_HASHHASH && has_next))', '        if (bt.kind == FTOK_HASHHASH && has_next)'),
 ('plain walk ignores ## after', '            if (param && !(has_next && body[walk + 1u].kind == FTOK_HASHHASH) && ((named[pidx >> 6] >> (pidx & 63u)) & 1u) == 0)', '            if (param && ((named[pidx >> 6] >> (pidx & 63u)) & 1u) == 0)'),
 ('substitution first space from arg', "                out[0] = fast_tok_make(first.kind, (first.flags & ~BUSTER_FTOK_SPACE) | (body[at].flags & BUSTER_FTOK_SPACE), first.extra, first.data);", "                out[0] = first;"),
 ('substitution tail dropped', '        fast_tok_copy(out, body + i, m->body_count - i);\n        out += m->body_count - i;', '        out += 0;'),
 ('copy tail off by one', '    for (; k < n; k += 1u)\n    {\n        dst[k] = src[k];', '    for (; k + 1u < n; k += 1u)\n    {\n        dst[k] = src[k];'),
 ('define params not moved', '        memmove(body, body + at, (size_t)(line_count - at) * sizeof(FastTok));', '        (void)0;'),
 ('frame args from a caller frame', '    const bool framed = pp->expand_depth > cf->min_expand_depth;', '    const bool framed = pp->expand_depth > 0u;'),
 ('prescan list skips empty first', '                cf->exp_arg_in_argbuf[pidx] = 0;', '                (void)0;'),
]
flags='-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -w -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -O1 -static'.split()
os.chdir('/home/user/buster')
results=[]
try:
    for name, old, new in mutants:
        if orig.count(old)!=1 and name[0] != 'C':
            print(f'{name}: ANCHOR {orig.count(old)}', flush=True); continue
        open(src,'w').write(orig.replace(old,new))
        b1=subprocess.run(['clang-23',*flags,'src/buster/compiler/c_direct.c','/home/user/dp/test_main.c','-o','/home/user/dp/mut/t'],capture_output=True)
        b2=subprocess.run(['clang-23',*flags,'src/buster/compiler/c_direct.c','/home/user/dp/direct_main.c','-o','/home/user/dp/mut/h'],capture_output=True)
        if b1.returncode or b2.returncode:
            print(f'{name}: BUILD FAILED', flush=True); continue
        t=subprocess.run(['timeout','60','/home/user/dp/mut/t'],capture_output=True)
        test_killed = t.returncode!=0
        C='/home/user/corpus'
        o='/home/user/dp/mut/o.o'
        if os.path.exists(o): os.remove(o)
        h=subprocess.run(['timeout','60','/home/user/dp/mut/h','--predefines',f'{C}/provenance/gnu17-pinned-predefines.txt','-isystem',f'{C}/headers/usr/lib/clang/23/include','-isystem',f'{C}/headers/usr/local/include','-isystem',f'{C}/headers/usr/include','-DSQLITE_OMIT_LOAD_EXTENSION','-DSQLITE_THREADSAFE=0','-DSQLITE_ENABLE_MEMSYS5','-DSQLITE_ENABLE_RTREE',f'-I{C}/sqlite',f'{C}/sqlite/sqlite3.c','-o',o],capture_output=True)
        sha=subprocess.run(['sha256sum',o],capture_output=True,text=True).stdout[:16] if os.path.exists(o) else 'none'
        sq_killed = sha!='f558aaf503fcb186'
        print(f'{name}: test {"KILLED" if test_killed else "survived"}, sqlite {"KILLED" if sq_killed else "survived"} ({sha})', flush=True)
finally:
    open(src,'w').write(orig)
