#!/usr/bin/env python3
# bystage.py RESULTS_DIR STAGE...: top functions inside given stages (user cycles a run, stall shares).
import sys, gzip, glob, re, collections
d = sys.argv[1]; want = set(sys.argv[2:])
exec(open(sys.argv[0].replace('bystage.py', 'common_reduce.py')).read())
