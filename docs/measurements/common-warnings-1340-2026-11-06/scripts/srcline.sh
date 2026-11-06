cd ~/buster-fast-bench/1340-droid/root || exit 2
EXCLUSIVE_OWNER=droid-1340 EXCLUSIVE_TITLE="droid #1340 common warnings cost" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340 \
    ~/buster-fast-bench/exclusive.sh bash -c '
        head -1 /var/lib/buster-9700x/owner >> ../prof2/holds.txt
        LC_ALL=C perf report -i ../prof2/znver5.data --no-children --symbols check_driver_common_warnings --sort srcline --stdio -F sample,srcline 2>/dev/null | grep -v "^#" | grep -v "^$" > ../prof2/common-srcline.txt'
echo status $?
head -60 ../prof2/common-srcline.txt
