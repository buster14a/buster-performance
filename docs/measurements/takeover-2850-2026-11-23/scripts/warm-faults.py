import subprocess, sys, os, shutil
S=os.path.dirname(os.path.abspath(__file__))
R='/home/user/buster'
src=open(R+'/src/buster/compiler/lane.c').read()
M=[
('untouched-ignores-warm','arena->warm == 0 && arena->peak <= arena->length','arena->warm <= 255 && arena->peak <= arena->length'),
('discard-warm','!arena->unaccounted && arena->warm == 0)\n    {\n        const uintptr_t base = (uintptr_t)arena->base;','!arena->unaccounted && arena->warm <= 255)\n    {\n        const uintptr_t base = (uintptr_t)arena->base;'),
('clear-warm','!arena_warm_holds(bytes) && madvise','(arena_warm_holds(bytes) || true) && madvise'),
('holds-end','(uintptr_t)bytes - mapping < slot->bytes','(uintptr_t)bytes - mapping <= slot->bytes'),
('release-keeps-taken','__atomic_fetch_and(&arena_warm.taken, ~(1u << (arena->warm - 1)), __ATOMIC_RELEASE);','__atomic_fetch_and(&arena_warm.taken, ~0u, __ATOMIC_RELEASE);'),
('release-keeps-mapping','__atomic_store_n(&slot->mapping, 0, __ATOMIC_RELEASE);\n        __atomic_fetch_and','__atomic_store_n(&slot->mapping, slot->mapping, __ATOMIC_RELEASE);\n        __atomic_fetch_and'),
('begin-no-lock','flock(opened, LOCK_EX | LOCK_NB) == 0;','flock(opened, LOCK_SH | LOCK_NB) == 0;'),
('begin-mode','(status.st_mode & 077) == 0','(status.st_mode & 077) != 01000'),
('begin-tmpfs','(uint64_t)system.f_type == BUSTER_ARENA_WARM_TMPFS;\n            // Every','(uint64_t)system.f_type != 1;\n            // Every'),
('begin-blksize','(uint64_t)status.st_blksize >= block','(uint64_t)status.st_blksize >= block - block + 1'),
('begin-uid','status.st_uid == geteuid()','status.st_uid != 4000000000u'),
('begin-search-on','held = opened >= 0 && !locked && errno == EWOULDBLOCK;','held = opened >= -1;'),
('begin-state','file >= 0 || fill ? 2 : 3','file >= -1 || fill ? 2 : 3'),
('begin-later-call','(directory != 0 || fill) && __atomic_compare_exchange_n(&arena_warm.state, &state, 1, false, __ATOMIC_ACQ_REL, __ATOMIC_RELAXED)','(directory != 0 || fill) && (__atomic_compare_exchange_n(&arena_warm.state, &state, 1, false, __ATOMIC_ACQ_REL, __ATOMIC_RELAXED) || state < 9)'),
('reserve-slot-twice','(__atomic_fetch_or(&warm->taken, bit, __ATOMIC_ACQ_REL) & bit) == 0;','(__atomic_fetch_or(&warm->taken, bit, __ATOMIC_ACQ_REL) & bit) <= bit;'),
('reserve-small','capacity > BUSTER_ARENA_SMALL_BYTES && capacity <= arena_reservation_limit()','capacity > 0 && capacity <= arena_reservation_limit()'),
('reserve-slot-bound','slot < BUSTER_ARENA_WARM_SLOTS &&\n','slot <= BUSTER_ARENA_WARM_SLOTS &&\n'),
('reserve-place','const uint64_t place = (uint64_t)slot * BUSTER_ARENA_WARM_SLOT_BYTES;','const uint64_t place = (uint64_t)slot * 0;'),
('reserve-own-flag','                .own = own,\n','                .own = own && place > UINT64_MAX - 1,\n'),
('reserve-not-released-on-failure-bit','            __atomic_fetch_and(&warm->taken, ~bit, __ATOMIC_RELEASE);\n        }\n    }\n    if (result.base == 0)','            __atomic_fetch_and(&warm->taken, ~0u, __ATOMIC_RELEASE);\n        }\n    }\n    if (result.base == 0)'),
('commit-not-warm','    else if (arena->warm != 0 && needed > committed)\n    {\n        result = arena_warm_commit(arena, end);\n    }\n','    else if (arena->warm > 250 && needed > committed)\n    {\n        result = arena_warm_commit(arena, end);\n    }\n'),
('commit-allocated-kept','            slot->allocated = target;\n','            slot->allocated = target & 0;\n'),
('commit-growth','uint64_t grown = used + used / BUSTER_ARENA_WARM_GROWTH;','uint64_t grown = used * BUSTER_ARENA_WARM_GROWTH;'),
('commit-no-growth','uint64_t grown = used + used / BUSTER_ARENA_WARM_GROWTH;','uint64_t grown = used;'),
('commit-not-huge','uint64_t target = (offset + grown + BUSTER_ARENA_HUGE_PAGE_BYTES - 1) & ~(BUSTER_ARENA_HUGE_PAGE_BYTES - 1);','uint64_t target = (offset + grown + BUSTER_ARENA_PAGE_BYTES - 1) & ~(BUSTER_ARENA_PAGE_BYTES - 1);'),
('commit-own-from-start','uint8_t* own = mapping + slot->allocated;\n            const uint64_t own_bytes = slot->bytes - slot->allocated;','uint8_t* own = mapping + slot->allocated * 0;\n            const uint64_t own_bytes = slot->bytes - slot->allocated * 0;'),
('commit-own-not-set','            slot->own = true;\n            result = mmap(own','            slot->own = own == 0;\n            result = mmap(own'),
('commit-no-overlay','result = mmap(own, own_bytes, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE | MAP_FIXED, -1, 0) == own;','result = own != 0;'),
('commit-fill-from-committed','memset(mapping + slot->filled, BUSTER_ARENA_WARM_PATTERN, target - slot->filled);','memset(mapping + committed, BUSTER_ARENA_WARM_PATTERN, target - committed);'),
('commit-filled-kept','            slot->filled = target;\n','            slot->filled = target & 0;\n'),
('commit-fill-always','if (warm->fill && target > slot->filled)','if (target > slot->filled)'),
('commit-fill-never','if (warm->fill && target > slot->filled)','if (warm->fill && target > slot->filled + UINT32_MAX)'),
('unlock-keeps-lock','        flock(arena_warm.file, LOCK_UN);\n','        flock(arena_warm.file, LOCK_EX | LOCK_NB);\n'),
('reserve-fork','(warm->file < 0 || warm->pid == getpid())','(warm->file < 0 || warm->pid != 0)'),
('end-under-arena','(state == 2 || state == 3) && __atomic_load_n(&arena_warm.taken, __ATOMIC_ACQUIRE) == 0 &&','(state == 2 || state == 3) && __atomic_load_n(&arena_warm.taken, __ATOMIC_ACQUIRE) <= 255 &&'),
('end-keeps-file','            close(arena_warm.file);\n        }\n        arena_warm.file = -1;','            flock(arena_warm.file, LOCK_UN);\n        }\n        arena_warm.file = -1;'),
('end-keeps-state','        arena_warm.file = -1;\n        __atomic_store_n(&arena_warm.state, 0, __ATOMIC_RELEASE);','        arena_warm.file = -1;\n        __atomic_store_n(&arena_warm.state, 3, __ATOMIC_RELEASE);'),
('end-keeps-descriptor-number','        arena_warm.file = -1;\n        __atomic_store_n(&arena_warm.state, 0','        arena_warm.file = arena_warm.file;\n        __atomic_store_n(&arena_warm.state, 0'),
('end-not-refused-state','(state == 2 || state == 3) && __atomic_load_n(&arena_warm.taken','(state == 2) && __atomic_load_n(&arena_warm.taken'),
('begin-result-false','        result = true;\n    }\n    return result;\n}\n\nstatic void arena_warm_end','        result = state > 9;\n    }\n    return result;\n}\n\nstatic void arena_warm_end'),
('begin-pid-unset','        arena_warm.pid = getpid();\n','        arena_warm.pid = 1;\n'),
('reserve-not-aligned','mapping = (uint8_t*)(((uintptr_t)region + BUSTER_ARENA_HUGE_PAGE_BYTES - 1) & ~(uintptr_t)(BUSTER_ARENA_HUGE_PAGE_BYTES - 1));','mapping = (uint8_t*)(((uintptr_t)region + BUSTER_ARENA_PAGE_BYTES + BUSTER_ARENA_PAGE_BYTES - 1) & ~(uintptr_t)(BUSTER_ARENA_PAGE_BYTES - 1));'),
]
only=sys.argv[1:]
res=[]
for name,a,b in M:
    if only and name not in only: continue
    if src.count(a)!=1:
        res.append((name,'NO-MATCH %d'%src.count(a))); continue
    open(S+'/lane_mut.c','w').write(src.replace(a,b))
    c=subprocess.run(['clang','-O1','-march=native','-I'+R+'/src','-I'+R+'/src/buster/compiler','-fwrapv','-funsigned-char','-fno-strict-aliasing','-Wall','-Werror','-Wno-unused-function','-Wno-macro-redefined','-DLANE_C="%s/lane_mut.c"'%S,'-DLANE_TEST_C="buster/compiler/lane_test.c"','-o',S+'/harness_mut',S+'/harness.c','-lpthread'],capture_output=True,text=True)
    if c.returncode!=0:
        res.append((name,'not-built: '+c.stderr.strip().split('\n')[0][:160])); continue
    try:
        r=subprocess.run([S+'/harness_mut'],capture_output=True,text=True,timeout=120)
        out=(r.stdout+r.stderr).strip().split('\n')
        res.append((name,('killed' if r.returncode!=0 else 'SURVIVED')+' | '+' ; '.join(l.strip() for l in out if 'arenas:' in l)[:230]))
    except subprocess.TimeoutExpired:
        res.append((name,'killed (timeout)'))
    subprocess.run('rm -rf /dev/shm/buster-warm-* /tmp/buster-warm-*',shell=True)
for n,r in res: print(n.ljust(34),r)
