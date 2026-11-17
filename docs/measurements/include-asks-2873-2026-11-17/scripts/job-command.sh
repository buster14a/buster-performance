#!/bin/bash
# job-command.sh: the units as one command: base2 against each variant (ab.sh, 9 rounds), and where the user cycles go
# by each compiler (perf record of the command's own process on CPU 2, user cycles, three runs a compiler, by symbol).
cd "$(dirname "$0")"
here=$PWD
: > job-command.done
log=command.log
: > "$log"
for other in scratch none off orderonly same; do
    tree=$other
    [ "$other" = same ] && tree=base2
    start=$(date +%s)
    ./lock.sh timeout -k 10 900 ./ab.sh "results/abc-command-$other" command 9 "base2=$PWD/base2/build/compiler" "$other=$PWD/$tree/build/compiler" > "results/abc-command-$other.log" 2>&1
    echo "$? $(( $(date +%s) - start ))s command-$other" >> "$log"
    tools/abstat "results/abc-command-$other" base2 "$other" > "results/abstatc-command-$other.txt" 2>&1
done
mkdir -p results/profile-command
cat > results/profile-command/run.sh <<'RUN'
#!/bin/bash
# run.sh HERE OUT NAME COMPILER: three recorded runs of the units as one command by COMPILER.
here=$1; out=$2; name=$3; compiler=$4
cd "$here"
source ../scripts/musl-common.sh
cp "$compiler" "$out/$name.compiler"
rm -rf /dev/shm/2873-profile-command && mkdir -p /dev/shm/2873-profile-command && cd /dev/shm/2873-profile-command || exit 1
taskset -c 2 "$here/$out/$name.compiler" "${options[@]}" --lanes 1 -c "${files[@]}" > /dev/null 2>&1
for run in 1 2 3; do
    taskset -c 2 perf record -q -e cycles:u -c 100003 -o "$here/$out/$name-$run.data" -- "$here/$out/$name.compiler" "${options[@]}" --lanes 1 -c "${files[@]}" > /dev/null 2> "$here/$out/$name-$run.err"
    perf report -i "$here/$out/$name-$run.data" --no-children --sort symbol --stdio -n 2> /dev/null | grep -v '^#' | grep -v '^$' > "$here/$out/$name-$run.symbols.txt"
    rm -f "$here/$out/$name-$run.data"
done
rm -rf /dev/shm/2873-profile-command "$here/$out/$name.compiler"
RUN
chmod +x results/profile-command/run.sh
for name in base2 scratch none; do
    ./lock.sh timeout -k 10 600 results/profile-command/run.sh "$here" results/profile-command "$name" "$here/$name/build/compiler" >> "$log" 2>&1
    echo "$? profile $name" >> "$log"
done
echo done >> "$log"
echo finished > job-command.done
