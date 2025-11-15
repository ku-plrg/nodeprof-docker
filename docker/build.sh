#!/usr/bin/env bash
set -euo pipefail

mkdir -p /works
git clone https://github.com/graalvm/mx.git /works/mx
cd /works/mx
# https://github.com/Haiyang-Sun/nodeprof.js/issues/115#issue-2456364190
git switch -c build-7.7.1 7.7.1
export PATH="/works/mx:${PATH}"

export JAVA_HOME="$(printf "y\n" | mx fetch-jdk --java-distribution labsjdk-ce-17 | grep '^export JAVA_HOME=' | cut -d= -f2)"
echo "installed JAVA_HOME=${JAVA_HOME}"

cd /
git clone https://github.com/Haiyang-Sun/nodeprof.js.git /works/nodeprof.js
# pinned to 2025-11-15 for stablity, the commit it references is from 2023-09-12. Update as needed.
git switch -c build-5cccefc 5cccefc56dbd144f6a9ff303288dc1f4441f30d4
cd /works/nodeprof.js

mx sforceimport

cd /works/graal
# https://github.com/Haiyang-Sun/nodeprof.js/issues/115#issuecomment-2297091426
git switch -c build-15d7be6 15d7be6

cd /works/nodeprof.js
mx build

