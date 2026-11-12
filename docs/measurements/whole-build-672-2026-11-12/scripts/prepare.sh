#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# prepare.sh PART: what the measurements need before them; run each PART inside its own hold of the 9700X's lock
# (lock.sh ./prepare.sh PART).
#   rebuild  the record's tools alone, built again
#   tools    the record's tools, the outputs' directories on tmpfs, and the unit lists
#   objects  the shell's objects by this compiler and by clang -O0, with and without -g, which the links take, with
#            each executable's check; the linkers' lines as clang's driver gives them
#   musl     musl's library as its Makefile selects its sources, by this compiler, with the two sources it refuses
#            replaced, and the program its link is checked with
#   synth    test-check-units --generate's program of synth's shape
set -u
cd "$(dirname "$0")"
. ./common.sh
part=${1:?a part}
out=$here/results/prepare
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner > "$out/$part.holder.txt"
status=0
note()
{
    echo "$1 status $2" >> "$out/$part.status.txt"
    if [[ $2 != 0 ]]; then status=1; fi
}
: > "$out/$part.status.txt"
case $part in
    rebuild)
        for tool in procbench medians phasemedians stagebuckets spin; do
            clang -O2 -Wall -Wextra -Werror -o "tools/$tool" "tools/$tool.c"; note "tool $tool" $?
        done
        ;;
    tools)
        for tool in procbench medians phasemedians stagebuckets; do
            clang -O2 -Wall -Wextra -Werror -o "tools/$tool" "tools/$tool.c"; note "tool $tool" $?
        done
        rm -rf $t
        mkdir -p $t/o $t/x $t/x8 $t/xk $t/f $t/lists $t/cache $t/y $t/m/c $t/m/cg $t/m/cx $t/m/tc $t/m/tcg $t/m/tcc $t/m/tccg $t/m/tccd $t/m/c8 $t/m/cg8 $t/m/kc $t/m/kcg $t/m/scratch
        cp inputs/hello.c inputs/empty.c $t/f/
        # The one-core record's musl units: the first source of each base name, so that one directory holds an object
        # a unit.
        files=()
        declare -A seen
        for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
            b=${f##*/}
            if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
        done
        printf '%s\n' "${files[@]}" > $t/lists/units1336.txt
        # Those of them that tcc compiles, with and without each of its debug formats: what it is timed on.
        : > $t/lists/units-tcc.txt
        : > "$out/tcc-refused.txt"
        for f in "${files[@]}"; do
            if tcc $mo -c "$f" -o $t/m/scratch/x.o > /dev/null 2>&1 && tcc $mo -g -c "$f" -o $t/m/scratch/x.o > /dev/null 2>&1 &&
               tcc $mo -gdwarf -c "$f" -o $t/m/scratch/x.o > /dev/null 2>&1; then
                echo "$f" >> $t/lists/units-tcc.txt
            else
                echo "${f#"$musl"/}" >> "$out/tcc-refused.txt"
            fi
        done
        # The library's sources as musl's Makefile selects them: src/*/*.c and the malloc directory's, each replaced by
        # its x86_64 source where there is one, but the one assembly source the driver's assembler refuses. Two sources
        # of one base name can't share a directory of objects: the second goes to list b.
        refused="$musl/src/string/x86_64/memset.s"
        : > $t/lists/lib-a.txt
        : > $t/lists/lib-b.txt
        unset seen
        declare -A seen
        for f in "$musl"/src/*/*.c "$musl"/src/malloc/mallocng/*.c; do
            d=${f%/*}
            b=${f##*/}
            b=${b%.c}
            for e in c s S; do
                if [[ -f $d/x86_64/$b.$e && $d/x86_64/$b.$e != "$refused" ]]; then f=$d/x86_64/$b.$e; fi
            done
            if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; echo "$f" >> $t/lists/lib-a.txt; else echo "$f" >> $t/lists/lib-b.txt; fi
        done
        wc -l $t/lists/units1336.txt $t/lists/units-tcc.txt $t/lists/lib-a.txt $t/lists/lib-b.txt "$out/tcc-refused.txt" > "$out/units.txt"
        echo "assembly sources in the library's lists: $(cat $t/lists/lib-a.txt $t/lists/lib-b.txt | grep -c '\.[sS]$')" >> "$out/units.txt"
        sed "s|^$corpus/||" $t/lists/units1336.txt > "$out/units1336.txt"
        sed "s|^$corpus/||" $t/lists/units-tcc.txt > "$out/units-tcc.txt"
        sed "s|^$corpus/||" $t/lists/lib-a.txt > "$out/lib-a.txt"
        sed "s|^$corpus/||" $t/lists/lib-b.txt > "$out/lib-b.txt"
        ;;
    objects)
        cd $t/x || exit 1
        for g in "" -g; do
            taskset -c 2 "$c" -c $g $sh "$sqlite/shell.c" -o shell$g.o > /dev/null 2>> "$out/objects.log"; note "buster shell$g.o" $?
            taskset -c 2 "$c" -c $g $sh "$sqlite/sqlite3.c" -o sq$g.o > /dev/null 2>> "$out/objects.log"; note "buster sq$g.o" $?
            taskset -c 2 clang -O0 -c $g $sh "$sqlite/shell.c" -o k-shell$g.o > /dev/null 2>> "$out/objects.log"; note "clang k-shell$g.o" $?
            taskset -c 2 clang -O0 -c $g $sh "$sqlite/sqlite3.c" -o k-sq$g.o > /dev/null 2>> "$out/objects.log"; note "clang k-sq$g.o" $?
        done
        cp shell.o sq.o shell-g.o sq-g.o $t/x8/
        "$c" -c $t/f/hello.c -o $t/f/hello.o >> "$out/objects.log" 2>&1; note "hello.o" $?
        # The linkers' lines, as clang's driver gives them to GNU ld.
        clang -v -o clang-line-dyn shell.o sq.o -lm > "$out/clang-dyn.txt" 2>&1; note "clang's dynamic line" $?
        clang -v -static -o clang-line-static shell.o sq.o -lm > "$out/clang-static.txt" 2>&1; note "clang's static line" $?
        # Every route's executable must run SQLite's shell: each of the four object sets, linked each way by each linker.
        check()
        {
            local name=$1 answer
            answer=$(./"$name" :memory: "select 6*7, sqlite_version(), sqrt(2.0);" 2>&1)
            echo "$name: $answer" >> "$out/objects-runs.txt"
            [[ $answer == "42|3.53.2|1.4142135623730951" || $answer == "42|3.53.2|1.4142135623730952" ]]; note "run $name" $?
        }
        : > "$out/objects-runs.txt"
        for set in b bg k kg; do
            case $set in
                b) objects="shell.o sq.o"; g="" ;;
                bg) objects="shell-g.o sq-g.o"; g=-g ;;
                k) objects="k-shell.o k-sq.o"; g="" ;;
                kg) objects="k-shell-g.o k-sq-g.o"; g=-g ;;
            esac
            "$c" link-foreign --lanes 1 $dyn -o chk-lf-dyn-$set $objects $dynend >> "$out/objects.log" 2>&1; note "link-foreign dyn $set" $?; check chk-lf-dyn-$set
            "$c" link-foreign --lanes 1 $static -o chk-lf-static-$set $objects $staticend >> "$out/objects.log" 2>&1; note "link-foreign static $set" $?; check chk-lf-static-$set
            "$c" $g $objects -lm -o chk-drv-dyn-$set >> "$out/objects.log" 2>&1; note "driver dyn $set" $?; check chk-drv-dyn-$set
            "$c" -static $g $objects -lm -o chk-drv-static-$set >> "$out/objects.log" 2>&1; note "driver static $set" $?; check chk-drv-static-$set
            for linker in ld.lld mold ld.bfd; do
                /usr/bin/$linker $dyn -o chk-$linker-dyn-$set $objects $dynend >> "$out/objects.log" 2>&1; note "$linker dyn $set" $?; check chk-$linker-dyn-$set
                /usr/bin/$linker $static -o chk-$linker-static-$set $objects $staticend >> "$out/objects.log" 2>&1; note "$linker static $set" $?; check chk-$linker-static-$set
            done
        done
        # The one-command builds, and the references'.
        for g in "" -g; do
            "$c" $g $sh -o chk-s-dyn$g "$sqlite/shell.c" "$sqlite/sqlite3.c" -lm > /dev/null 2>> "$out/objects.log"; note "one command dyn$g" $?; check chk-s-dyn$g
            "$c" -static $g $sh -o chk-s-static$g "$sqlite/shell.c" "$sqlite/sqlite3.c" /usr/lib/libm.a > /dev/null 2>> "$out/objects.log"; note "one command static$g" $?; check chk-s-static$g
            tcc -c $g $sh "$sqlite/shell.c" -o tcc-shell$g.o > /dev/null 2>> "$out/objects.log"; note "tcc shell$g.o" $?
            tcc -c $g $sh "$sqlite/sqlite3.c" -o tcc-sq$g.o > /dev/null 2>> "$out/objects.log"; note "tcc sq$g.o" $?
        done
        # tcc's own link of the shell, which this system's C library stops (kept as it fails: no status noted).
        tcc $sh -o chk-tcc-dyn "$sqlite/shell.c" "$sqlite/sqlite3.c" -lm > "$out/tcc-link.txt" 2>&1; echo "status $?" >> "$out/tcc-link.txt"
        # What the direct path says of -static with -lm, which the builds above give as a file instead.
        "$c" -static $sh -o chk-s-static-lm "$sqlite/shell.c" "$sqlite/sqlite3.c" -lm > "$out/static-lm.txt" 2>&1; echo "status $?" >> "$out/static-lm.txt"
        rm -f chk-* clang-line-*
        ;;
    musl)
        for g in "" g; do
            rm -rf $t/ml$g
            mkdir -p $t/ml$g/a $t/ml$g/b
            flag=${g:+-g}
            (cd $t/ml$g/a && taskset -c 2 "$c" $mo --lanes 1 -c $flag @$t/lists/lib-a.txt > /dev/null 2> "$out/musl-a$g.err"); note "library a $flag" $?
            (cd $t/ml$g/b && taskset -c 2 "$c" $mo --lanes 1 -c $flag @$t/lists/lib-b.txt > /dev/null 2> "$out/musl-b$g.err"); note "library b $flag" $?
            taskset -c 2 "$c" $mh -c $flag "$here/inputs/musl_hello.c" -o $t/ml$g/hello.o > "$out/musl-hello$g.txt" 2>&1; note "hello $flag" $?
            taskset -c 2 "$c" $mh -ffreestanding -c $flag "$here/inputs/musl_missing.c" -o $t/ml$g/missing.o > "$out/musl-missing$g.txt" 2>&1; note "missing $flag" $?
            # The start file's file-scope assembly is refused too (below): clang compiles it.
            taskset -c 2 clang -O0 $flag $mo -DCRT -c "$musl/crt/crt1.c" -o $t/ml$g/crt1.o > "$out/musl-crt1$g.txt" 2>&1; note "crt1 by clang $flag" $?
            # The link's objects: the library's, but the two that link-foreign refuses the link for (below).
            (cd $t/ml$g && ls a/*.o b/*.o | tr '\n' ' ' > objects-all.txt &&
                ls a/*.o b/*.o | grep -v -e '^a/dl_iterate_phdr\.o$' -e '^a/__tls_get_addr\.o$' | tr '\n' ' ' > objects.txt &&
                echo "library objects $flag: $(wc -w < objects-all.txt), linked: $(wc -w < objects.txt)" >> "$out/units.txt")
        done
        # The two refusals, as the driver words them.
        "$c" $mo -c "$musl/src/string/x86_64/memset.s" -o $t/m/scratch/memset.o > "$out/musl-refused.txt" 2>&1; echo "status $?" >> "$out/musl-refused.txt"
        "$c" $mo -DCRT -c "$musl/crt/crt1.c" -o $t/m/scratch/crt1.o >> "$out/musl-refused.txt" 2>&1; echo "status $?" >> "$out/musl-refused.txt"
        # link-foreign's link of every object of the library, which it refuses: the library defines __tls_get_addr
        # itself, and dl_iterate_phdr.c calls it as a function. Without dl_iterate_phdr.o it links the objects without
        # -g and still refuses those with -g; without __tls_get_addr.o too it links both. The links below leave the two
        # objects out, for every linker alike (the program needs neither).
        for g in "" g; do
            (cd $t/ml$g && "$c" link-foreign --lanes 1 -static -o hello-all crt1.o hello.o missing.o $(cat objects-all.txt) $G/libgcc.a > "$out/musl-link-lf-all$g.txt" 2>&1; echo "status $?" >> "$out/musl-link-lf-all$g.txt"
             "$c" link-foreign --lanes 1 -static -o hello-all crt1.o hello.o missing.o $(sed 's|a/dl_iterate_phdr\.o ||' objects-all.txt) $G/libgcc.a > "$out/musl-link-lf-one$g.txt" 2>&1; echo "status $?" >> "$out/musl-link-lf-one$g.txt"; rm -f hello-all)
        done
        # The link, by each linker, checked by the program's output; and a shared library of the same objects, which
        # aren't position-independent (the driver refuses -fPIC).
        : > "$out/musl-runs.txt"
        for g in "" g; do
            cd $t/ml$g || exit 1
            line="-static -o hello crt1.o hello.o missing.o $(cat objects.txt) $G/libgcc.a"
            "$c" link-foreign --lanes 1 ${line/-o hello/-o hello-lf} > "$out/musl-link-lf$g.txt" 2>&1; note "link-foreign musl $g" $?
            /usr/bin/ld.lld ${line/-o hello/-o hello-lld} > "$out/musl-link-lld$g.txt" 2>&1; note "ld.lld musl $g" $?
            /usr/bin/mold ${line/-o hello/-o hello-mold} > "$out/musl-link-mold$g.txt" 2>&1; note "mold musl $g" $?
            /usr/bin/ld.bfd ${line/-o hello/-o hello-bfd} > "$out/musl-link-bfd$g.txt" 2>&1; note "ld.bfd musl $g" $?
            for l in lf lld mold bfd; do
                answer=$(./hello-$l 2>&1)
                echo "hello-$l$g: $answer" >> "$out/musl-runs.txt"
                [[ $answer == "hello from musl: 0 7 0.333 42" ]]; note "run hello-$l $g" $?
            done
            ls -l hello-* >> "$out/musl-runs.txt"
        done
        (cd $t/ml && "$c" link-foreign --lanes 1 -shared -o libc.so $(cat objects.txt) > "$out/musl-shared.txt" 2>&1; echo "status $?" >> "$out/musl-shared.txt")
        # clang on the record's units, once: whether it takes them all.
        (cd $t/m/kc && taskset -c 2 clang -O0 $mo -c @$t/lists/units1336.txt > /dev/null 2> "$out/musl-clang.err"; note "clang's units" $?; ls | wc -l >> "$out/units.txt")
        ;;
    synth)
        rm -rf $t/y
        mkdir -p $t/y/src $t/y/o1 $t/y/o1g $t/y/o8 $t/y/o8g $t/y/c1 $t/y/c1g
        "$c" test-check-units --generate $t/y/src > "$out/synth.txt" 2>&1; note "generate" $?
        ls $t/y/src | head -5 >> "$out/synth.txt"
        ls $t/y/src | wc -l >> "$out/synth.txt"
        du -sb $t/y/src >> "$out/synth.txt"
        ls $t/y/src/*.c > $t/lists/synth.txt
        (cd $t/y/o1 && taskset -c 0-7 "$c" --lanes 8 -o program @$t/lists/synth.txt > /dev/null 2> "$out/synth-build.err"; note "build" $?; ./program > "$out/synth-run.txt" 2>&1; echo "status $?" >> "$out/synth-run.txt"; ls -l program >> "$out/synth.txt")
        ;;
    *) echo "unknown part $part" >&2; status=1 ;;
esac
if ((status == 0)); then date -u +%FT%TZ > "$out/$part.done"; fi
exit $status
