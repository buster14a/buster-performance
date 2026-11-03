import re,sys,glob
# cold.py FUNCTION...: marks each static function's definition __attribute__((cold, noinline)).
for f in sys.argv[1:]:
    hits=0
    for path in glob.glob('*.c'):
        if path.endswith('_test.c'): continue
        s=open(path).read()
        pat=re.compile(r'^static ((?:const )?[A-Za-z_][A-Za-z0-9_]*\**) ('+re.escape(f)+r'\()(?=[^;]*?\)\n\{)', re.M|re.S)
        n=len(pat.findall(s))
        if n:
            s=pat.sub(r'static __attribute__((cold, noinline)) \1 \2', s)
            open(path,'w').write(s); hits+=n
            print(f'{f}: {path} ({n})')
    if hits!=1: print(f'!! {f}: {hits} definitions changed')
