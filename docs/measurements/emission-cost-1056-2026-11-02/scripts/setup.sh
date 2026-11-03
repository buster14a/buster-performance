set -e
cd ~/buster-fast-bench/1056-claude
git clone -q https://github.com/buster14a/buster repo
cd repo
git fetch -q origin claude/zen-babbage-w50smj
git worktree add -q ../base c10aa68e0ff3d56f7eed9ec739bae6ba5c5a3fa9
git worktree add -q ../head 5052211a16f62873fef01c38e6a189652b0f32f3
git -C ../base log --oneline -1
git -C ../head log --oneline -1
echo SETUP-DONE
