import subprocess, sys, os
S='/tmp/claude-0/-home-user/c5559a1a-e340-5109-8d23-d5a8ff5725f9/scratchpad'
src=open('/home/user/buster/src/buster/compiler/lane.c').read()
faults=[
 ('split-noop', 'madvise((void*)at, BUSTER_ARENA_PAGE_BYTES, MADV_NOHUGEPAGE);', '(void)at;'),
 ('split-two-pages', 'madvise((void*)at, BUSTER_ARENA_PAGE_BYTES, MADV_NOHUGEPAGE);', 'madvise((void*)at, 2 * BUSTER_ARENA_PAGE_BYTES, MADV_NOHUGEPAGE);'),
 ('split-stride-4mb', '        at += BUSTER_ARENA_HUGE_PAGE_BYTES;\n    }\n}\n\n// Maps [from, to)', '        at += 2 * BUSTER_ARENA_HUGE_PAGE_BYTES;\n    }\n}\n\n// Maps [from, to)'),
 ('split-round-down', 'uintptr_t at = ((uintptr_t)mapping + from + BUSTER_ARENA_HUGE_PAGE_BYTES - 1) & ~(uintptr_t)(BUSTER_ARENA_HUGE_PAGE_BYTES - 1);', 'uintptr_t at = ((uintptr_t)mapping + from) & ~(uintptr_t)(BUSTER_ARENA_HUGE_PAGE_BYTES - 1);'),
 ('split-end-inclusive', 'while (at < end && __atomic_load_n(&arena_medium_splits', 'while (at <= end && __atomic_load_n(&arena_medium_splits'),
 ('budget-ignored', '__atomic_load_n(&arena_medium_splits, __ATOMIC_RELAXED) < BUSTER_ARENA_MEDIUM_SPLITS)', '__atomic_load_n(&arena_medium_splits, __ATOMIC_RELAXED) < UINT32_MAX)'),
 ('budget-not-counted', '        __atomic_fetch_add(&arena_medium_splits, 1, __ATOMIC_RELAXED);\n', '        __atomic_fetch_add(&arena_medium_splits, 0, __ATOMIC_RELAXED);\n'),
 ('budget-off-by-one', '__atomic_load_n(&arena_medium_splits, __ATOMIC_RELAXED) < BUSTER_ARENA_MEDIUM_SPLITS)', '__atomic_load_n(&arena_medium_splits, __ATOMIC_RELAXED) <= BUSTER_ARENA_MEDIUM_SPLITS)'),
 ('commit-hook-off', 'if (arena_pages_medium && arena->capacity > arena->small && target > small_end)', 'if (arena_pages_medium && arena->capacity > arena->small && target > small_end && target == 1)'),
 ('commit-from-small-end', 'arena_medium_split(mapping, committed > small_end ? committed : small_end, target);', 'arena_medium_split(mapping, small_end, target);'),
 ('commit-from-committed', 'arena_medium_split(mapping, committed > small_end ? committed : small_end, target);', 'arena_medium_split(mapping, committed, target);'),
 ('extend-hook-off', '            if (arena_pages_medium)\n            {\n                arena_medium_split(mapping, begin, to);', '            if (arena_pages_medium && to == 1)\n            {\n                arena_medium_split(mapping, begin, to);'),
 ('extend-from-from', 'arena_medium_split(mapping, begin, to);', 'arena_medium_split(mapping, from, to);'),
 ('tables-huge', '!arena_pages_busy && !arena_pages_medium && i < count', '!arena_pages_busy && i < count'),
 ('knob-no-open', "result = text[i] == '[' && memcmp(text + i + 1, word, size) == 0 && text[i + 1 + size] == ']';", "result = memcmp(text + i + 1, word, size) == 0 && text[i + 1 + size] == ']';"),
 ('knob-no-close', "result = text[i] == '[' && memcmp(text + i + 1, word, size) == 0 && text[i + 1 + size] == ']';", "result = text[i] == '[' && memcmp(text + i + 1, word, size) == 0;"),
 ('knob-bound', 'for (uint64_t i = 0; !result && i + size + 2 <= length; i += 1)', 'for (uint64_t i = 0; !result && i + size + 2 < length; i += 1)'),
 ('knob-bound-past', 'for (uint64_t i = 0; !result && i + size + 2 <= length; i += 1)', 'for (uint64_t i = 0; !result && i + size + 1 <= length; i += 1)'),
 ('choose-busy-kept', 'arena_pages_busy = busy && !offered;', 'arena_pages_busy = busy;'),
 ('choose-medium-idle', 'arena_pages_medium = busy && offered;', 'arena_pages_medium = offered;'),
 ('choose-medium-never', 'arena_pages_medium = busy && offered;', 'arena_pages_medium = busy && offered && !busy;'),
]
survivors=[]
for name, old, new in faults:
    if src.count(old)!=1:
        print(name, 'PATTERN-COUNT', src.count(old)); continue
    path=f'{S}/harness/mut/{name}.c'
    open(path,'w').write(src.replace(old,new))
    r=subprocess.run([f'{S}/harness/run.sh', path], capture_output=True, text=True)
    state='killed' if r.returncode==1 else 'NOT-BUILT' if r.returncode==2 else 'SURVIVED' if r.returncode==0 else f'crashed({r.returncode})'
    print(f'{name}: {state}')
    if state=='SURVIVED': survivors.append(name)
print('survivors:', survivors)
