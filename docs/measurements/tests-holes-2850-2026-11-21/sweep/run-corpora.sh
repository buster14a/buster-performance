#!/bin/bash
# run-corpora.sh TAG COMPILER: the four corpora through the shadow, with no option and with -Wall -Wextra.
S=/tmp/claude-0/-home-user/dee3f18a-a5e4-510a-ab70-2139693431f3/scratchpad
tag=$1; compiler=$2
export TREE=/home/user/buster-values
bash /home/user/keep/shadow-limited.sh $S/holes/$tag/shadow $compiler "sqlite lua musl" 3 "--passes 0 --window-rows --list 20" "--passes 0 --window-rows -Wall -Wextra --list 20"
bash /home/user/keep/shadow-limited.sh $S/holes/$tag/shadow $compiler "main" 1 "--passes 0 --window-rows --list 20" "--passes 0 --window-rows -Wall -Wextra --list 20"
echo "corpora exit 0"
