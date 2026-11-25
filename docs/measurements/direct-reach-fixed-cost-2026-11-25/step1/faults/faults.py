import subprocess, sys, os
B='/home/user/buster'
F={'lex':B+'/src/buster/compiler/c_direct_lex.c','main':B+'/src/buster/compiler/c_direct.c'}
O={'lex':open('c_direct_lex.c.orig').read(),'main':open('c_direct.c.orig').read()}
M=[
 ('shift-off-by-one','lex','    t->cache_shift = 64u - bits;','    t->cache_shift = 63u - bits;'),
 ('grow-at-one-late','lex','BUSTER_FIDENT_CACHE_GROW_LOAD << bits : UINT32_MAX;','(BUSTER_FIDENT_CACHE_GROW_LOAD << bits) + 1u : UINT32_MAX;'),
 ('never-asked-to-grow','lex','    t->cache_grow_at = bits < BUSTER_FIDENT_CACHE_BITS ?','    t->cache_grow_at = bits > BUSTER_FIDENT_CACHE_BITS ?'),
 ('migration-skipped','lex','            if (old_cache[i].id != 0)\n','            if (old_cache[i].id != 0 && i == 0)\n'),
 ('migration-wrong-shift','lex','>> new_shift] = old_cache[i];','>> (new_shift + 1u)] = old_cache[i];'),
 ('migration-hash-swapped','lex','fast_ident_cache_hash(old_cache[i].w0, old_cache[i].w1, old_cache[i].len)','fast_ident_cache_hash(old_cache[i].w1, old_cache[i].w0, old_cache[i].len)'),
 ('grows-by-one-bit','lex','BUSTER_FIDENT_CACHE_BITS ? old_bits + BUSTER_FIDENT_CACHE_GROW_BITS : BUSTER_FIDENT_CACHE_BITS;','BUSTER_FIDENT_CACHE_BITS ? old_bits + 1u : BUSTER_FIDENT_CACHE_BITS;'),
 ('no-room-asks-again','lex','    else\n    {\n        t->cache_grow_at = UINT32_MAX;\n    }\n    return grown;','    return grown;'),
 ('short-keeps-stale-slot','lex','            if (__builtin_expect(t->count >= t->cache_grow_at, 0) && fast_ident_cache_grow(t))\n            {\n                slot = t->cache + (h >> t->cache_shift);','            if (__builtin_expect(t->count >= t->cache_grow_at, 0) && fast_ident_cache_grow(t))\n            {\n                slot = slot + 0;'),
 ('long-keeps-stale-slot','lex','                if (__builtin_expect(t->count >= t->cache_grow_at, 0) && fast_ident_cache_grow(t))\n                {\n                    slot = t->cache + (h >> t->cache_shift);','                if (__builtin_expect(t->count >= t->cache_grow_at, 0) && fast_ident_cache_grow(t))\n                {\n                    slot = slot + 0;'),
 ('short-never-grows','lex','            if (__builtin_expect(t->count >= t->cache_grow_at, 0) && fast_ident_cache_grow(t))\n            {\n                slot','            if (__builtin_expect(t->count >= t->cache_grow_at, 0) && (t->count & 0) != 0 && fast_ident_cache_grow(t))\n            {\n                slot'),
 ('long-never-grows','lex','                if (__builtin_expect(t->count >= t->cache_grow_at, 0) && fast_ident_cache_grow(t))\n                {\n                    slot','                if (__builtin_expect(t->count >= t->cache_grow_at, 0) && (t->count & 0) != 0 && fast_ident_cache_grow(t))\n                {\n                    slot'),
 ('groups-swapped','lex','small ? BUSTER_FIDENT_SMALL_GROUPS : BUSTER_FIDENT_INIT_GROUPS','small ? BUSTER_FIDENT_INIT_GROUPS : BUSTER_FIDENT_SMALL_GROUPS'),
 ('cache-bits-swapped','lex','small ? BUSTER_FIDENT_SMALL_CACHE_BITS : BUSTER_FIDENT_CACHE_BITS','small ? BUSTER_FIDENT_CACHE_BITS : BUSTER_FIDENT_SMALL_CACHE_BITS'),
 ('pp-init-full-tables','lex','    bool ok = fast_ident_init(&pp->idents, arena, small);','    bool ok = fast_ident_init(&pp->idents, arena, small && arena == NULL);'),
 ('compile-full-tables','main','fast_pp_init(pp, &arena, &scratch, small);','fast_pp_init(pp, &arena, &scratch, small && pp == NULL);'),
 ('arena-not-advised','main','request->avoid_huge_pages || small) ||','request->avoid_huge_pages || (small && pp_never())) ||'),
 ('scratch-not-advised','main','UINT64_C(6) * 1024u * 1024u, request->avoid_huge_pages || small))','UINT64_C(6) * 1024u * 1024u, request->avoid_huge_pages || (small && pp_never())))'),
 ('small-inverted','main','(uint64_t)st.st_size < BUSTER_FDIRECT_LARGE_UNIT_BYTES;\n}','(uint64_t)st.st_size >= BUSTER_FDIRECT_LARGE_UNIT_BYTES;\n}'),
 ('every-unit-small','main','    return stat(input_path, &st) != 0 ||','    return stat(input_path, &st) == 0 ||'),
 ('short-slot-halved','lex','    FastIdentCacheSlot* slot = t->cache + (h >> t->cache_shift);\n    uint32_t id;','    FastIdentCacheSlot* slot = t->cache + ((h >> t->cache_shift) / 2u);\n    uint32_t id;'),
 ('long-slot-halved','lex','        h = fast_ident_cache_hash(w0, w1, len);\n        slot = t->cache + (h >> t->cache_shift);','        h = fast_ident_cache_hash(w0, w1, len);\n        slot = t->cache + ((h >> t->cache_shift) / 2u);'),
]
def restore():
    for k in F: open(F[k],'w').write(O[k])
only=sys.argv[1:]
for name,which,old,new in M:
    if only and name not in only: continue
    src=O[which]
    if src.count(old)!=1:
        print(f'{name}: PATTERN {src.count(old)}',flush=True); continue
    restore()
    text=src.replace(old,new)
    if 'pp_never()' in new: text=text.replace('static bool c_direct_unit_is_small(','static bool pp_never(void) { return getenv("BUSTER_NEVER_SET_XYZ") != NULL; }\n\nstatic bool c_direct_unit_is_small(')
    open(F[which],'w').write(text)
    b=subprocess.run(['./build.sh','--config','Release'],cwd=B,capture_output=True,text=True)
    if b.returncode!=0:
        print(f'{name}: BUILD FAILED {b.returncode}: {(b.stdout+b.stderr)[-300:]}',flush=True); continue
    try:
        t=subprocess.run(['./build/compiler','test-direct'],cwd=B,capture_output=True,text=True,timeout=300)
        out=(t.stdout+t.stderr).strip().splitlines()
        print(f"{name}: {'KILLED' if t.returncode!=0 else 'SURVIVED'} (status {t.returncode}) {' | '.join(out[-3:])[:200]}",flush=True)
    except subprocess.TimeoutExpired:
        print(f'{name}: KILLED (timeout)',flush=True)
restore()
b=subprocess.run(['./build.sh','--config','Release'],cwd=B,capture_output=True,text=True)
t=subprocess.run(['./build/compiler','test-direct'],cwd=B,capture_output=True,text=True)
print('restored:',b.returncode,t.stdout.strip())
