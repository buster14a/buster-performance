from pathlib import Path as P
import re,subprocess as sp,tempfile,shutil,sys
tmp=P('/tmp/b2053');repo=P.cwd();binary=P(sys.argv[1]).resolve()
def selected(part,n=64):
 source=(repo/'src/buster/compiler/c_preprocessor_test.c').read_text().split('static bool pp_test_sections(')[1].split('    if (fuzz->count != 0)')[0]
 weights=[]
 for w,name in re.findall(r'PP_TEST_SECTION\(deal, (\d+), ([\w]+)\(',source):
  weights.extend([(int(w),name)]*(4 if name=='predefines_test_options' else 1))
 loads=[0]*n;deals={}
 for i in sorted(range(len(weights)),key=lambda i:-weights[i][0]):
  j=min(range(n),key=loads.__getitem__);loads[j]+=weights[i][0];deals[weights[i][1]]=j+1
 return f'{deals[part]}/{n}'
with tempfile.TemporaryDirectory() as td:
 t=P(td);root=t/'tests'
 shutil.copytree(repo/'tests/preprocessor',root/'preprocessor');shutil.copytree(repo/'tests/preprocessor-kernels',root/'preprocessor-kernels')
 suite=root/'preprocessor'/'structure';catalog=suite/'catalog.tsv';id='header-golden'
 for ext in ['.c','.h']:shutil.copy(suite/('0036'+ext),suite/(id+ext))
 with tempfile.TemporaryDirectory() as oracle:
  out=P(oracle)
  for ext in ['.c','.h']:shutil.copy(suite/(id+ext),out/('structure'+ext))
  r=sp.run(['clang','-E','-std=gnu17','-fno-caret-diagnostics','-fno-color-diagnostics','-o','/dev/null',str(out/'structure.c')],capture_output=True);assert r.returncode==1
  expected=b''.join(line for line in r.stderr.splitlines(True) if not line.endswith(b' generated.\n')).replace(str(out).encode(),b'%d');assert b'%d/structure.h' in expected and expected.count(b'%d/')>1
  (suite/(id+'.expected')).write_bytes(expected);(tmp/'pp-header-transcript.expected').write_bytes(expected)
 with catalog.open('a') as f:f.write(f'{id}\t-\theader,expected\tfull staged header transcript\n')
 guards=root/'preprocessor/guards';guard_row=next(x.split('\t') for x in (guards/'catalog.tsv').read_text().splitlines()[1:] if x and x[0]!='#')
 label='runtime guard case';shutil.copy(guards/(guard_row[0]+'.c'),guards/'added.c')
 with (guards/'catalog.tsv').open('a') as f:f.write('\t'.join(['added',*guard_row[1:4],label])+'\n')
 digests=root/'preprocessor-kernels/digests.tsv';old=next(x.split('\t')[-1] for x in digests.read_text().splitlines() if x.startswith('guards/'+guard_row[-1]+'\t'))
 with digests.open('a') as f:f.write('guards/'+label+'\t'+old+'\n')
 def run(name,phase,ok):
  part=selected(phase);r=sp.run([binary,'test-preprocessor','--clang','--jobs','1','--fuzz','0','--part',part,'--fixtures',root],cwd=t,stdout=sp.PIPE,stderr=sp.STDOUT)
  (tmp/('pp-review-'+name+'.log')).write_bytes(r.stdout);print(name,part,r.returncode,[s.decode() for s in r.stdout.splitlines() if b'directive structure:' in s or b'include guards:' in s or b'option sets: 0 of' in s],flush=True);assert (r.returncode==0)==ok
 run('header-and-guard','pp_test_directives',True)
 (suite/(id+'.expected')).write_text('wrong header location\n');run('bad-header','pp_test_directives',False)
 options=root/'preprocessor/option-refusals/catalog.tsv'
 with options.open('a') as f:f.write('late-standard\t-fmacro-prefix-map=\t-fmacro-prefix-map=/never-matches=/new -std=c89\n')
 run('late-option','pp_test_option_refusals',False)
 assert b"clang's -E doesn't change with" in (tmp/'pp-review-late-option.log').read_bytes()
