from pathlib import Path
import sys
p=Path(sys.argv[1]);p.mkdir(exist_ok=True,parents=True)
bulk=''.join(f'dead_{i} + another_dead_{i};\n' for i in range(11000))
def sample(name,body): (p/(name+'.c')).write_text('#line 751 "rejected-arm.c"\n#ifdef NOT_DEFINED_BY_BUILD\n'+bulk+body)
sample('skipped-notes','#if 0\n#else\n#elifdef NEVER_DEFINED\n#else\n#endif\n#else\nint survivor;\n#endif\n')
sample('skipped-unfinished','#warning /* never closed\n#endif\nint masked;\n')
sample('skipped-raw','#warning R"(\n#endif\nint masked;\n')
sample('quoted-hidden','/* words\n# else\n*/\nR"tag(fake\n#else\n)tag"\n%:if 0\n%:endif\n#else\nint survivor=__LINE__;\n#endif\n')
(p/'locations.c').write_text('#include "choice1.h"\n#define VALUE(t) (t)\n#ifdef TAKE\n'+''.join(f'enum {{ item_{i}=VALUE(__LINE__) }};\n' for i in range(9800))+'#else\n#error unexpected fixture\n#endif\nint score = __INCLUDE_LEVEL__ + __COUNTER__;\n')
