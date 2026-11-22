"""Run both modes of the same compiler on the given input and verify every declaration partition."""
import argparse
import os
from pathlib import Path
import subprocess
import sys

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('compiler',type=Path)
parser.add_argument('directory',type=Path)
parser.add_argument('name')
parser.add_argument('flags',nargs=argparse.REMAINDER)
args = parser.parse_args()
args.directory.mkdir(parents=True,exist_ok=True)
compiler = args.compiler.resolve()
prefix = args.directory/args.name
flags = args.flags[1:] if args.flags[:1]==['--'] else args.flags
env = {k:v for k,v in os.environ.items() if not k.startswith(('BUSTER_CHECK_BODY_', 'BUSTER_BODY_', 'BUSTER_STATIC_ROW_WINDOWS'))}
for mode, marker in [('source',{'BUSTER_CHECK_BODY_SOURCE_ONLY':'1','BUSTER_CHECK_BODY_ADMIT_ALL':'1'}),('whole',{'BUSTER_CHECK_BODY_WHOLE_FINGERPRINT':'1'})]:
    with Path(str(prefix)+'.'+mode+'.log').open('wb') as log:
        subprocess.run([compiler,'--lanes','1','-c',*flags,'-o',str(prefix)+'.'+mode+'.o'],env=env|{'BUSTER_CHECK_SOURCE_DECLARATIONS':'1','BUSTER_STATIC_ROW_WINDOWS':'1'}|marker,stderr=log,stdout=log,check=True)
script=Path(__file__).with_name('verify.py')
subprocess.run([sys.executable,script,args.name],env=env|{'BUSTER_RECEIPT_DIRECTORY':str(args.directory.resolve())},check=True)
