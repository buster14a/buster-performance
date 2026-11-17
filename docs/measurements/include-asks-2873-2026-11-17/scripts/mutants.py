#!/usr/bin/env python3
# mutants.py: the faults of the include search's asks (buster#2873), one at a time, in a COPY of the tree
# (/home/user/mut4/tree): each is a text of the new code replaced by a faulty one, the Debug compiler built, and the
# tests of the asks run (test-preprocessor's parts 1 and 4 of 4, which have the directory asks and the component
# keys, and test-files). A fault
# neither fails is a survivor. Every text is checked to be unique before any build, and the file is restored after
# each fault.
#   mutants.py check        : every fault's texts are unique, applies and reverts
#   mutants.py run [NAME..] : the campaign (all the faults, or those named); results in /home/user/mut4/results.txt
import subprocess, sys, os, shutil, time

ROOT = '/home/user/mut4'
TREE = ROOT + '/tree'
SRC = TREE + '/src/buster/compiler/'
P = 'c_preprocessor.c'
I = 'c_preprocessor_impl.c'
W = 'c_files.c'

MUTANTS = [
    ('threshold-two', P, '#define BUSTER_FILE_CACHE_ASKING_MISSES 3u', '#define BUSTER_FILE_CACHE_ASKING_MISSES 2u'),
    ('threshold-four', P, '#define BUSTER_FILE_CACHE_ASKING_MISSES 3u', '#define BUSTER_FILE_CACHE_ASKING_MISSES 4u'),
    ('default-off', P, '    cache->asking_misses = BUSTER_FILE_CACHE_ASKING_MISSES;', '    cache->asking_misses = 0;'),
    # the key
    ('key-starts-at-the-slash', P, '    const uint32_t first = directory->length + 1;\n    const uint32_t rest = length - first;',
     '    const uint32_t first = directory->length;\n    const uint32_t rest = length - first;'),
    ('key-looks-at-eight-bytes', P, '    const __mmask16 looked = (__mmask16)_bzhi_u32(0xffffu, rest < 16 ? rest : 16);',
     '    const __mmask16 looked = (__mmask16)_bzhi_u32(0xffffu, rest < 8 ? rest : 8);'),
    ('key-looks-past-the-end', P, '    const __mmask16 looked = (__mmask16)_bzhi_u32(0xffffu, rest < 16 ? rest : 16);',
     '    const __mmask16 looked = (__mmask16)_bzhi_u32(0xffffu, rest < 16 ? 16 : 16);'),
    ('key-without-a-slash-is-fifteen', P, '    const uint32_t count = _tzcnt_u32(slashes | 0x10000u);', '    const uint32_t count = _tzcnt_u32(slashes | 0x8000u);'),
    ('key-holds-the-slash', P, '    const uint32_t name = _bzhi_u32(0xffffu, count);', '    const uint32_t name = _bzhi_u32(0xffffu, count + 1);'),
    ('two-dots-asked', P, '    const bool dots = count <= 2 && (dotted & name) == name;', '    const bool dots = count <= 1 && (dotted & name) == name;'),
    ('any-dot-is-dots', P, '    const bool dots = count <= 2 && (dotted & name) == name;', '    const bool dots = count <= 2 && (dotted & name) != 0;'),
    ('long-dots-are-dots', P, '    const bool dots = count <= 2 && (dotted & name) == name;', '    const bool dots = count <= 3 && (dotted & name) == name;'),
    ('dots-asked', P, '    const bool counted = count <= BUSTER_FILE_CACHE_COMPONENT_NAME && !dots;',
     '    const bool counted = count <= BUSTER_FILE_CACHE_COMPONENT_NAME && (!dots || count != 0);'),
    ('name-a-byte-short', P, '    const bool counted = count <= BUSTER_FILE_CACHE_COMPONENT_NAME && !dots;',
     '    const bool counted = count < BUSTER_FILE_CACHE_COMPONENT_NAME && !dots;'),
    ('key-keeps-what-follows', P, '    return _mm_maskz_mov_epi8((__mmask16)name, bytes);', '    return _mm_maskz_mov_epi8((__mmask16)(name | 0xff00u), bytes);'),
    # the slot
    ('find-by-the-first-half', P, '        found |= (halves & (halves >> 1) & 0x55u) << (8 * v);', '        found |= (halves & 0x55u) << (8 * v);'),
    ('find-by-the-second-half', P, '        found |= (halves & (halves >> 1) & 0x55u) << (8 * v);', '        found |= ((halves >> 1) & 0x55u) << (8 * v);'),
    ('find-in-the-first-vector', P, '        found |= (halves & (halves >> 1) & 0x55u) << (8 * v);', '        found |= (halves & (halves >> 1) & 0x55u) << (8 * 0);'),
    ('find-in-half-the-slots', P, '    for (uint32_t v = 0; v < BUSTER_FILE_CACHE_COMPONENTS / 4; v += 1)', '    for (uint32_t v = 0; v < BUSTER_FILE_CACHE_COMPONENTS / 8; v += 1)'),
    ('find-the-slot-after', P, '    return _tzcnt_u32(found) / 2;', '    return _tzcnt_u32(found) / 2 + (found != 0);'),
    # the answer
    ('answers-gate-closed', P, '    if (directory->component_absent != 0)\n    {\n        uint32_t component = 0;',
     '    if (directory->component_absent == 0)\n    {\n        uint32_t component = 0;'),
    ('no-component-is-the-first-slot', P,
     '        const uint32_t slot = component != 0 ? file_cache_find_component(directory, key) : BUSTER_FILE_CACHE_COMPONENTS;\n        result',
     '        const uint32_t slot = component != 0 ? file_cache_find_component(directory, key) : 0;\n        result'),
    ('a-later-slot-answers', P, '        result = ((directory->component_absent >> slot) & 1) != 0;', '        result = (directory->component_absent >> slot) != 0;'),
    # the count and the ask
    ('listed-directory-asked', P, '    if (directory->names == 0)\n    {\n        key = file_cache_component_key(directory, path, length, &component);',
     '    if (directory->names == 0 || length != 0)\n    {\n        key = file_cache_component_key(directory, path, length, &component);'),
    ('a-slot-short', P,
     '    if (component != 0 && slot == BUSTER_FILE_CACHE_COMPONENTS && directory->component_count < BUSTER_FILE_CACHE_COMPONENTS)',
     '    if (component != 0 && slot == BUSTER_FILE_CACHE_COMPONENTS && directory->component_count < BUSTER_FILE_CACHE_COMPONENTS - 1)'),
    ('takes-the-first-slot', P, '        slot = directory->component_count;', '        slot = 0;'),
    ('slot-without-its-key', P, '        _mm_storeu_si128((__m128i*)(void*)directory->component_names[slot], key);',
     '        _mm_storeu_si128((__m128i*)(void*)directory->component_names[slot], _mm_setzero_si128());'),
    ('slot-not-taken', P, '        directory->component_count += 1;', '        directory->component_count += 0;'),
    ('count-wraps', P, '        directory->component_misses[slot] += directory->component_misses[slot] < UINT8_MAX;', '        directory->component_misses[slot] += 1;'),
    ('misses-by-two', P, '        directory->component_misses[slot] += directory->component_misses[slot] < UINT8_MAX;',
     '        directory->component_misses[slot] += directory->component_misses[slot] < UINT8_MAX ? 2 : 0;'),
    ('asked-again', P, '        if (directory->component_misses[slot] == cache->asking_misses)', '        if (directory->component_misses[slot] >= cache->asking_misses)'),
    ('asks-the-directory', P, '            const uint32_t end = directory->length + 1 + component;', '            const uint32_t end = directory->length + 1;'),
    ('ask-keeps-no-path', P, '            if (asked != 0)\n            {\n                memcpy(asked, path, end);', '            if (asked == 0)\n            {\n                memcpy(asked, path, end);'),
    ('asks-its-own-directory', P, '                const int error = stat(asked, &status) == 0 ? 0 : errno;',
     '                const int error = stat(directory->path, &status) == 0 ? 0 : errno;'),
    ('absent-whatever-the-answer', P, '                const uint32_t absent = error == ENOENT;', '                const uint32_t absent = error == ENOENT || error == 0;'),
    ('absent-never', P, '                const uint32_t absent = error == ENOENT;', '                const uint32_t absent = error == ENOENT && end == 0;'),
    ('absent-on-any-error', P, '                const uint32_t absent = error == ENOENT;', '                const uint32_t absent = error != 0;'),
    ('absent-bit-of-the-first-slot', P, '                directory->component_absent |= absent << slot;', '                directory->component_absent |= absent;'),
    ('cache-count-lost', P, '                cache->absent_components += absent;', '                cache->absent_components += 0;'),
    ('asks-uncounted', P, '                counts->asks += 1;', '                counts->asks += 0;'),
    ('miss-not-counted', P, '        file_cache_miss_component(cache, directory, path, length, counts);',
     '        file_cache_miss_component(cache, directory, path, directory->length + 1, counts);'),
    ('lookup-ignores-the-answer', I,
     '        const bool absent = directory != 0 && (file_cache_listed_absent(directory, path, length) || file_cache_component_absent(directory, path, length));',
     '        const bool absent = directory != 0 && (file_cache_listed_absent(directory, path, length) || (file_cache_component_absent(directory, path, length) && length == 0));'),
    ('lookup-finds-no-directory', I, '        const bool answers = cache->listed_directories != 0 || cache->absent_components != 0;',
     '        const bool answers = cache->listed_directories != 0;'),
    ('walk-ignores-the-answer', W,
     '            const bool absent = place != 0 && (file_cache_listed_absent(place, path, path_length) || file_cache_component_absent(place, path, path_length));',
     '            const bool absent = place != 0 && (file_cache_listed_absent(place, path, path_length) || (file_cache_component_absent(place, path, path_length) && path_length == 0));'),
    ('walk-finds-no-directory', W,
     '            const bool listed = candidate == PP_CANDIDATE_PATH && entry == 0 && (cache->listed_directories != 0 || cache->absent_components != 0) &&',
     '            const bool listed = candidate == PP_CANDIDATE_PATH && entry == 0 && cache->listed_directories != 0 &&'),
]

def read(path):
    return open(path).read()

def check():
    ok = True
    names = set()
    for name, f, old, new in MUTANTS:
        s = read(SRC + f)
        if name in names:
            print('DUPLICATE NAME', name); ok = False
        names.add(name)
        if s.count(old) != 1:
            print(name, 'old text occurs', s.count(old)); ok = False
        if old == new or s.replace(old, new) == s:
            print(name, 'changes nothing'); ok = False
    print(len(MUTANTS), 'faults;', 'all unique' if ok else 'PROBLEMS')
    return ok

def run(only):
    if not check():
        sys.exit(1)
    results = open(ROOT + '/results-frozen.txt', 'a')
    for name, f, old, new in MUTANTS:
        if only and name not in only:
            continue
        path = SRC + f
        saved = ROOT + '/saved.c'
        shutil.copyfile(path, saved)
        s = read(path)
        open(path, 'w').write(s.replace(old, new))
        start = time.time()
        build = subprocess.run(['./build.sh', '--config', 'Debug'], cwd=TREE, capture_output=True, text=True)
        verdict = 'NOT BUILT'
        detail = ''
        if build.returncode == 0:
            caught = []
            for test in (['test-preprocessor', '--part', '1/4'], ['test-preprocessor', '--part', '4/4'], ['test-files']):
                try:
                    ran = subprocess.run(['./build/compiler'] + test, cwd=TREE, capture_output=True, text=True, timeout=600)
                    if ran.returncode != 0:
                        caught.append(' '.join(test))
                        lines = [l for l in (ran.stdout + ran.stderr).splitlines() if 'asks' in l or 'WRONG' in l or 'listings' in l or 'component keys' in l]
                        detail += ' | '.join(l[:140] for l in lines[:2]) + ' || '
                except subprocess.TimeoutExpired:
                    caught.append(test[0] + ' (timeout)')
            verdict = 'caught by ' + ' and '.join(caught) if caught else 'SURVIVED'
        else:
            detail = (build.stderr + build.stdout)[-300:].replace('\n', ' ')
        shutil.copyfile(saved, path)
        line = f'{name}: {verdict} ({time.time() - start:.0f} s) {detail}'
        print(line, flush=True)
        results.write(line + '\n'); results.flush()
    subprocess.run(['./build.sh', '--config', 'Debug'], cwd=TREE, capture_output=True, text=True)
    print('campaign done', flush=True)
    results.write('campaign done\n'); results.flush()

if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == 'check':
        sys.exit(0 if check() else 1)
    run(sys.argv[2:] if len(sys.argv) > 2 else [])
