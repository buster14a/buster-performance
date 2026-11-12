import sys,re
# Print the build statements (with their indented variables) whose outputs are objects, the link or the post-link/bake, for one configuration's impl file.
text=open(sys.argv[1]).read()
blocks=re.split(r'\n(?=build )', text)
out=[]
for b in blocks:
    if not b.startswith('build '): continue
    head=b.split('\n',1)[0]
    if re.search(r'\.c\.o:|compiler\.link:|/compiler: |codegen/main_unit_[a-z]+/(part[0-9]+\.o|native\.o|split\.stamp):', head):
        lines=[l for l in b.split('\n') if l.strip() and not l.startswith('#')]
        out.append('\n'.join(lines))
print('\n\n'.join(sorted(out)))
