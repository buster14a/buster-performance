#!/usr/bin/env python3
# mutants.py: the faults of the include search's asks (buster#2873), one at a time, in a COPY of the tree
# (/home/user/mut4/tree): each is a text of the new code replaced by a faulty one, the Debug compiler built, and the
# tests of the asks run (test-preprocessor's part 4 of 4, which has the directory asks, and test-files). A fault
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
    ('component-starts-at-the-slash', P, '    const uint32_t first = directory->length + 1;', '    const uint32_t first = directory->length;'),
    ('dots-asked', P, '    return end < length && !dots ? component : 0;', '    return end < length && (!dots || component != 0) ? component : 0;'),
    ('two-dots-asked', P, "    const bool dots = component <= 2 && path[first] == '.' && path[end - 1] == '.';",
     "    const bool dots = component <= 1 && path[first] == '.' && path[end - 1] == '.';"),
    ('dot-first-is-dots', P, "    const bool dots = component <= 2 && path[first] == '.' && path[end - 1] == '.';",
     "    const bool dots = component <= 2 && path[first] == '.';"),
    ('dot-last-is-dots', P, "    const bool dots = component <= 2 && path[first] == '.' && path[end - 1] == '.';",
     "    const bool dots = component <= 2 && path[end - 1] == '.';"),
    ('find-by-length-alone', P, '    while (result != 0 && !(result->length == length && memcmp(result->name, name, length) == 0))',
     '    while (result != 0 && !(result->length == length))'),
    ('find-by-prefix', P, '    while (result != 0 && !(result->length == length && memcmp(result->name, name, length) == 0))',
     '    while (result != 0 && !(memcmp(result->name, name, length) == 0))'),
    ('any-record-answers', P, '    return record != 0 && record->absent;', '    return record != 0;'),
    ('answers-gate-closed', P,
     '    const uint32_t component = directory->absent_components != 0 ? file_cache_first_component(directory, path, length, &start) : 0;',
     '    const uint32_t component = directory->absent_components == 0 ? file_cache_first_component(directory, path, length, &start) : 0;'),
    ('listed-directory-asked', P,
     '    const uint32_t component = directory->names == 0 ? file_cache_first_component(directory, path, length, &start) : 0;',
     '    const uint32_t component = directory->names == 0 || length != 0 ? file_cache_first_component(directory, path, length, &start) : 0;'),
    ('record-without-its-name', P, '                memcpy(copy, path, (uint64_t)start + component);', '                memcpy(copy, path, (uint64_t)start);'),
    ('record-name-at-the-path', P, '                    .name = copy + start,', '                    .name = copy,'),
    ('record-length-short', P, '                    .length = component,', '                    .length = component - 1,'),
    ('record-forgets-the-others', P, '                    .next = directory->components,', '                    .next = 0,'),
    ('record-not-kept', P, '                directory->components = record;', '                directory->components = directory->components;'),
    ('misses-by-two', P, '            record->misses += 1;', '            record->misses += 2;'),
    ('asked-again', P, '            if (record->misses == cache->asking_misses)', '            if (record->misses >= cache->asking_misses)'),
    ('absent-whatever-the-answer', P, '                record->absent = error == ENOENT;', '                record->absent = error == ENOENT || error == 0;'),
    ('absent-never', P, '                record->absent = error == ENOENT;', '                record->absent = error == ENOENT && counts->asks == 0;'),
    ('absent-on-any-error', P, '                record->absent = error == ENOENT;', '                record->absent = error != 0;'),
    ('directory-count-lost', P, '                directory->absent_components += record->absent;', '                directory->absent_components += 0;'),
    ('cache-count-lost', P, '                cache->absent_components += record->absent;', '                cache->absent_components += 0;'),
    ('asks-uncounted', P, '                counts->asks += 1;', '                counts->asks += 0;'),
    ('asks-the-directory-itself', P, '                const int error = stat(record->path, &status) == 0 ? 0 : errno;',
     '                const int error = stat(directory->path, &status) == 0 ? 0 : errno;'),
    ('miss-not-counted', P, '        file_cache_miss_component(cache, directory, path, length, counts);', '        file_cache_miss_component(cache, directory, path, 0, counts);'),
    ('lookup-ignores-the-answer', I,
     '        const bool absent = directory != 0 && (file_cache_listed_absent(directory, path, length) || file_cache_component_absent(directory, path, length));',
     '        const bool absent = directory != 0 && (file_cache_listed_absent(directory, path, length) || (file_cache_component_absent(directory, path, length) && length == 0));'),
    ('lookup-finds-no-directory', I, '        const bool answers = cache->listed_directories != 0 || cache->absent_components != 0;',
     '        const bool answers = cache->listed_directories != 0;'),
    ('lookup-counts-the-directory', I, '            file_cache_count_miss(cache, directory, path, length, &probe, counts);',
     '            file_cache_count_miss(cache, directory, path, directory_length, &probe, counts);'),
    ('walk-ignores-the-answer', W,
     '            const bool absent = place != 0 && (file_cache_listed_absent(place, path, path_length) || file_cache_component_absent(place, path, path_length));',
     '            const bool absent = place != 0 && (file_cache_listed_absent(place, path, path_length) || (file_cache_component_absent(place, path, path_length) && path_length == 0));'),
    ('walk-finds-no-directory', W,
     '            const bool listed = candidate == PP_CANDIDATE_PATH && entry == 0 && (cache->listed_directories != 0 || cache->absent_components != 0) &&',
     '            const bool listed = candidate == PP_CANDIDATE_PATH && entry == 0 && cache->listed_directories != 0 &&'),
    ('walk-counts-the-directory', W, '        file_cache_count_miss(cache, directory, path->path, path->length, &run->found[p], counts);',
     '        file_cache_count_miss(cache, directory, path->path, path->directory_length, &run->found[p], counts);'),
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
    results = open(ROOT + '/results.txt', 'a')
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
            for test in (['test-preprocessor', '--part', '4/4'], ['test-files']):
                try:
                    ran = subprocess.run(['./build/compiler'] + test, cwd=TREE, capture_output=True, text=True, timeout=600)
                    if ran.returncode != 0:
                        caught.append(test[0])
                        lines = [l for l in (ran.stdout + ran.stderr).splitlines() if 'asks' in l or 'WRONG' in l or 'listings' in l]
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
