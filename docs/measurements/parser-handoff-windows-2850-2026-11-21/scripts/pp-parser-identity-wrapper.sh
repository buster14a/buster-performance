#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window"
root=$PWD
until [[ -e results/identity/.built ]];do sleep 2;done
for tag in identityon identitypoison identityoff;do
 mkdir -p "results/$tag";ln -sfn "$root/trees/identity" "trees/$tag";ln -sfn "$root/results/identity/build.log" "results/$tag/build.log"
 cat >"results/$tag/compiler" <<SCRIPT
#!/bin/bash
unset BUSTER_TEST_PARSE_IDENTITY BUSTER_TEST_PARSE_SOURCE_POISON
SCRIPT
 if [[ $tag != identityoff ]];then echo 'export BUSTER_TEST_PARSE_IDENTITY=1' >>"results/$tag/compiler";fi
 if [[ $tag == identitypoison ]];then echo 'export BUSTER_TEST_PARSE_SOURCE_POISON=1' >>"results/$tag/compiler";fi
 echo "exec $root/results/identity/compiler \"\$@\"" >>"results/$tag/compiler";chmod +x "results/$tag/compiler";touch "results/$tag/.built"
done
exec bash pp-parser-tests.sh identitypoison
