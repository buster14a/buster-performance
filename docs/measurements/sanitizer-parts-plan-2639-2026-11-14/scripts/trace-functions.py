#!/usr/bin/env python3
# trace-functions.py TRACE.json...: each code-generation OptFunction event's function and duration in microseconds,
# "part<TAB>name<TAB>microseconds", from -ftime-trace files of `clang -x ir -Xclang -disable-llvm-passes` compiles
# (every OptFunction there is the code generator's).
import json, re, sys
for path in sys.argv[1:]:
    part = re.search(r'part(\d+)\.json$', path).group(1)
    with open(path) as f:
        events = json.load(f)['traceEvents']
    for e in events:
        if e.get('ph') == 'X' and e.get('name') == 'OptFunction':
            print(f"{part}\t{e['args']['detail']}\t{e['dur']}")
