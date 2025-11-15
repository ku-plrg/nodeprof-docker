#!/usr/bin/env bash
set -euo pipefail

mkdir -p /works
git clone https://github.com/graalvm/mx.git /works/mx
cd /works/mx
git switch -c build-7.7.1 7.7.1
export PATH="/works/mx:${PATH}"

export JAVA_HOME="$(printf "y\n" | mx fetch-jdk --java-distribution labsjdk-ce-17 | grep '^export JAVA_HOME=' | cut -d= -f2)"
echo "installed JAVA_HOME=${JAVA_HOME}"

cd /
git clone https://github.com/Haiyang-Sun/nodeprof.js.git /works/nodeprof.js
cd /works/nodeprof.js

mx sforceimport

cd /works/graal
git switch -c build-15d7be6 15d7be6

cd /works/nodeprof.js
mx build

