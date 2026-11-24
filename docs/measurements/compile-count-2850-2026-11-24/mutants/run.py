import os, shutil, subprocess, sys, tempfile
root = '/home/user/buster'
files = ['tools/ci/compile-count.c', 'tools/ci/compile-count.sh', 'tools/ci/compile-count.txt', 'tests/ci/compile-count.sh']
C, SH = files[0], files[1]
mutants = [
    ('band 501', C, '#define BUSTER_COUNT_BAND 500', '#define BUSTER_COUNT_BAND 501'),
    ('band 499', C, '#define BUSTER_COUNT_BAND 500', '#define BUSTER_COUNT_BAND 499'),
    ('spread 51', C, '#define BUSTER_COUNT_SPREAD 50', '#define BUSTER_COUNT_SPREAD 51'),
    ('spread 49', C, '#define BUSTER_COUNT_SPREAD 50', '#define BUSTER_COUNT_SPREAD 49'),
    ('header 18', C, '#define BUSTER_COUNT_HEADER_WORDS 19u', '#define BUSTER_COUNT_HEADER_WORDS 18u'),
    ('header 20', C, '#define BUSTER_COUNT_HEADER_WORDS 19u', '#define BUSTER_COUNT_HEADER_WORDS 20u'),
    ('record 64', C, '#define BUSTER_COUNT_RECORD_BYTES 72u', '#define BUSTER_COUNT_RECORD_BYTES 64u'),
    ('record 80', C, '#define BUSTER_COUNT_RECORD_BYTES 72u', '#define BUSTER_COUNT_RECORD_BYTES 80u'),
    ('counters field 52', C, '#define BUSTER_COUNT_RECORD_COUNTERS 56u', '#define BUSTER_COUNT_RECORD_COUNTERS 52u'),
    ('counters field 60', C, '#define BUSTER_COUNT_RECORD_COUNTERS 56u', '#define BUSTER_COUNT_RECORD_COUNTERS 60u'),
    ('version 12', C, '#define BUSTER_COUNT_VERSION 11u', '#define BUSTER_COUNT_VERSION 12u'),
    ('magic', C, '0xff6c70726f667281ull', '0xff6c70726f667282ull'),
    ('judge strict', C, 'verdict.status = apart <= (int64_t)BUSTER_COUNT_BAND', 'verdict.status = apart < (int64_t)BUSTER_COUNT_BAND'),
    ('judge reads an unread statement', C, 'const int64_t claimed = states ? stated : 0;', 'const int64_t claimed = stated;'),
    ('judge adds the statement', C, 'difference * 100000 - claimed * (int64_t)base', 'difference * 100000 + claimed * (int64_t)base'),
    ('judge band of the head', C, 'apart <= (int64_t)BUSTER_COUNT_BAND * (int64_t)base', 'apart <= (int64_t)BUSTER_COUNT_BAND * (int64_t)head'),
    ('median upper', C, 'side->median = sorted[(runs - 1) / 2];', 'side->median = sorted[runs / 2];'),
    ('median first', C, 'side->median = sorted[(runs - 1) / 2];', 'side->median = sorted[0];'),
    ('steady strict', C, '(side->most - side->least) * 100000 <= (uint64_t)BUSTER_COUNT_SPREAD', '(side->most - side->least) * 100000 < (uint64_t)BUSTER_COUNT_SPREAD'),
    ('steady from median', C, '(side->most - side->least) * 100000', '(side->most - side->median) * 100000'),
    ('steady never', C, "if (!side_steady(&base) || !side_steady(&head))", "if (false)"),
    ('steady base only', C, "if (!side_steady(&base) || !side_steady(&head))", "if (!side_steady(&base))"),
    ('statement first line', C, "            if (end > start && text[start] != '#')", "            if (!found && end > start && text[start] != '#')"),
    ('statement comments', C, "            if (end > start && text[start] != '#')", "            if (end > start)"),
    ('statement sign', C, 'statement->stated = negative ? -stated : stated;', 'statement->stated = stated;'),
    ('statement four digits', C, 'fraction_digits <= 3 &&', 'fraction_digits <= 4 &&'),
    ('statement maximum', C, 'stated <= BUSTER_COUNT_STATED_MAXIMUM &&', 'stated < BUSTER_COUNT_STATED_MAXIMUM &&'),
    ('statement no whole', C, 'valid = whole_digits > 0 &&', 'valid = true &&'),
    ('statement point alone', C, '(!point || fraction_digits > 0) &&', ''),
    ('statement end', C, "const bool ended = at == found_length || line[at] == ' ' || line[at] == '\\t';", 'const bool ended = true;'),
    ('statement length', C, '&& found_length < BUSTER_COUNT_LINE_BYTES;', '&& found_length <= BUSTER_COUNT_LINE_BYTES + 8;'),
    ('statement percent', C, "if (at < found_length && line[at] == '%')", 'if (false)'),
    ('statement scale', C, '        for (size_t digit = fraction_digits; digit < 3; digit += 1)', '        for (size_t digit = fraction_digits; digit < 2; digit += 1)'),
    ('states by length', C, 'base_statement.length != head_statement.length || memcmp(base_statement.line, head_statement.line, head_statement.length) != 0', 'base_statement.length != head_statement.length'),
    ('states always', C, 'const bool states = base_statement.length != head_statement.length ||', 'const bool states = true ||'),
    ('states never', C, 'const bool states = base_statement.length != head_statement.length ||', 'const bool states = false &&'),
    ('records unchecked', C, 'if (declared != counters)', 'if (false)'),
    ('zero sum', C, 'else if (sum == 0)', 'else if (false)'),
    ('counters unbounded', C, 'fits = fits && counters <= (length - offset) / 8;', 'fits = fits && counters <= (length - offset);'),
    ('records unbounded', C, 'fits = fits && records <= (length - offset) / BUSTER_COUNT_RECORD_BYTES;', 'fits = fits && records <= (length - offset);'),
    ('padding unbounded', C, 'fits = fits && padding <= length - offset;', ''),
    ('identifiers unbounded', C, 'bool fits = identifiers <= room;', 'bool fits = true;'),
    ('identifiers skipped', C, 'uint64_t offset = 8 * BUSTER_COUNT_HEADER_WORDS + (fits ? identifiers : 0);', 'uint64_t offset = 8 * BUSTER_COUNT_HEADER_WORDS;'),
    ('padding skipped', C, 'offset += fits ? padding : 0;', ''),
    ('counter maximum', C, 'overflow = overflow || counter > BUSTER_COUNT_MAXIMUM || sum > BUSTER_COUNT_MAXIMUM;', 'overflow = overflow || sum > BUSTER_COUNT_MAXIMUM;'),
    ('sum maximum', C, 'if (overflow || sum > BUSTER_COUNT_MAXIMUM)', 'if (overflow)'),
    ('short header', C, 'if (length < 8 * BUSTER_COUNT_HEADER_WORDS)', 'if (length < 8)'),
    ('head statement optional', C, '!file_statement(head_statement_path, false, &head_statement)', '!file_statement(head_statement_path, true, &head_statement)'),
    ('base statement required', C, '!file_statement(base_statement_path, true, &base_statement)', '!file_statement(base_statement_path, false, &base_statement)'),
    ('empty head statement', C, '    if (status == COUNT_PASSED && head_statement.length == 0)\n    {\n        fprintf(stderr, "compile-count: %s has no statement line\\n", head_statement_path);\n        status = COUNT_UNUSABLE;', '    if (false)\n    {\n        status = COUNT_UNUSABLE;'),
    ('failed status', C, 'COUNT_FAILED = 1,', 'COUNT_FAILED = 3,'),
    ('always passes', C, '        status = verdict.status;', '        status = COUNT_PASSED;'),
    ('proposal rounding', C, '+ 5) / 10;', ') / 10;'),
    ('moved scale', C, 'verdict.moved = difference * 100000 / (int64_t)base;', 'verdict.moved = difference * 10000 / (int64_t)base;'),
    ('moved of head', C, 'verdict.moved = difference * 100000 / (int64_t)base;', 'verdict.moved = difference * 100000 / (int64_t)head;'),
    ('difference reversed', C, 'const int64_t difference = (int64_t)head - (int64_t)base;', 'const int64_t difference = (int64_t)base - (int64_t)head;'),
    ('sum skips first', C, 'for (uint64_t i = 0; i < counters; i += 1)\n                {\n                    const uint64_t counter', 'for (uint64_t i = 1; i < counters; i += 1)\n                {\n                    const uint64_t counter'),
    ('word 7 bytes', C, 'for (size_t i = 0; i < 8; i += 1)\n    {\n        word |=', 'for (size_t i = 0; i < 7; i += 1)\n    {\n        word |='),
    ('runs capacity', C, 'side != NULL && !takes_value && side->runs < BUSTER_COUNT_RUNS', 'side != NULL && !takes_value'),
    ('sh: no -O0', SH, '"${flags[@]}" -O0 -g0 -fprofile-instr-generate)', '"${flags[@]}" -g0 -fprofile-instr-generate)'),
    ('sh: no instrumentation', SH, '"${flags[@]}" -O0 -g0 -fprofile-instr-generate)', '"${flags[@]}" -O0 -g0)'),
    ('sh: status dropped', SH, '    return "$status"\n', '    return 0\n'),
    ('sh: sides swapped', SH, 'count "$work/base/compiler" "$corpus" "$work" base\n    count "$work/head/compiler" "$corpus" "$work" head', 'count "$work/head/compiler" "$corpus" "$work" base\n    count "$work/base/compiler" "$corpus" "$work" head'),
    ('sh: statements swapped', SH, '--base-statement "$base/tools/ci/compile-count.txt" --head-statement "$head/tools/ci/compile-count.txt"', '--base-statement "$head/tools/ci/compile-count.txt" --head-statement "$base/tools/ci/compile-count.txt"'),
    ('sh: one lane dropped', SH, 'local -a unit=(--lanes 1 --predefines', 'local -a unit=(--predefines'),
    ('sh: two runs', SH, '    for run in 1 2 3; do\n        rm -f', '    for run in 1 2; do\n        rm -f'),
    ('sh: stale profile kept', SH, '        rm -f -- "$directory/$name-$run.profraw"\n', ''),
    ('sh: static mode dropped', SH, "        *' -DBUSTER_HOST_STATIC=1 '*) mode+=(-static -Wl,--wrap=__register_frame_info,--wrap=__deregister_frame_info) ;;", "        *' -DBUSTER_HOST_STATIC=1 '*) ;;"),
    ('sh: always static', SH, "    local -a mode=(-no-pie)\n", "    local -a mode=(-no-pie -static -Wl,--wrap=__register_frame_info,--wrap=__deregister_frame_info)\n"),
    ('sh: unit failure ignored', SH, '        if [ ! -s "$object" ]; then', '        if false; then'),
    ('sh: compile failure ignored', SH, '''            die "count: $executable didn't compile sqlite3.c"''', '''            true'''),
    ('sh: annotation cut', SH, "cut -c 24-)", "cut -c 16-)"),
    ('sh: no summary', SH, '    if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then', '    if false; then'),
    ('sh: release flags dropped', SH, './build.sh print-compile-flags --config Release)', './build.sh print-compile-flags)'),
    ('sh: compile outside the tree', SH, '        (cd "$tree" && exec "$clang" -c', '        (exec "$clang" -c'),
    ('sh: one-function unit dropped from the report', SH, """printf 'compile-count: a one-function unit counts""", """: 'compile-count: a one-function unit counts"""),
    ('sh: objects kept', SH, '    rm -rf -- "$directory/objects"\n', ''),
]
only = sys.argv[1:]
survivors = []
for name, path, old, new in mutants:
    if only and name not in only:
        continue
    tmp = tempfile.mkdtemp(prefix='mutant-')
    for f in files:
        os.makedirs(os.path.dirname(os.path.join(tmp, f)), exist_ok=True)
        shutil.copy(os.path.join(root, f), os.path.join(tmp, f))
    text = open(os.path.join(tmp, path)).read()
    if text.count(old) != 1:
        print(f'{name}: PATTERN x{text.count(old)}', flush=True)
        survivors.append(name + ' (pattern)')
        shutil.rmtree(tmp)
        continue
    open(os.path.join(tmp, path), 'w').write(text.replace(old, new))
    r = subprocess.run(['bash', os.path.join(tmp, 'tests/ci/compile-count.sh')], capture_output=True, text=True, timeout=300)
    killed = r.returncode != 0
    last = (r.stderr.strip().splitlines() or r.stdout.strip().splitlines() or [''])[-1][:150]
    print(f"{name}: {'killed' if killed else 'SURVIVED'} | {last}", flush=True)
    if not killed:
        survivors.append(name)
    shutil.rmtree(tmp)
print('survivors:', survivors)
