#!/usr/bin/env bash
set -euo pipefail

function git-shallowify() {
    # keep the current checkout but trim history to the minimal depth we need
    local current_commit
    current_commit="$(git rev-parse --verify HEAD)"
    git fetch --depth=1 --force origin "${current_commit}"
    git reflog expire --expire=now --all
    git gc --prune=now --aggressive
}

mkdir -p /works
# https://github.com/Haiyang-Sun/nodeprof.js/issues/115#issue-2456364190
git clone --depth=1 --branch 7.7.1 https://github.com/graalvm/mx.git /works/mx
export PATH="/works/mx:${PATH}"
echo "PATH=${PATH}" >> /etc/environment
cd /works/mx
git-shallowify

export JAVA_HOME="$(printf "y\n" | mx fetch-jdk --java-distribution labsjdk-ce-17 | grep '^export JAVA_HOME=' | cut -d= -f2)"
echo "JAVA_HOME=${JAVA_HOME}" >> /etc/environment

cd /
git clone --depth=1 https://github.com/Haiyang-Sun/nodeprof.js.git /works/nodeprof.js
cd /works/nodeprof.js
# pinned to 2025-11-15 for stablity, the commit it references is from 2023-09-12. Update as needed.
git fetch --depth=1 origin 5cccefc56dbd144f6a9ff303288dc1f4441f30d4
git switch -c build-5cccefc 5cccefc56dbd144f6a9ff303288dc1f4441f30d4
git-shallowify

mx sforceimport

cd /works/graal
# https://github.com/Haiyang-Sun/nodeprof.js/issues/115#issuecomment-2297091426
git switch -c build-15d7be6 15d7be6
git-shallowify

cd /works/graaljs
git-shallowify

cd /works/nodeprof.js
mx build
