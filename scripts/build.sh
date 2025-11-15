#!/usr/bin/env bash
set -euo pipefail

SRC_ROOT=${1:-/opt/nodeprof/sources}
ARTIFACT_DIR=${2:-/opt/nodeprof/bin}

mkdir -p "${ARTIFACT_DIR}"

cat <<INFO
[build] Placeholder build script
        Replace scripts/build.sh with the steps needed to build your CLI.
        It receives the cloned repositories in: ${SRC_ROOT}
        and must write the executable(s) to: ${ARTIFACT_DIR}
INFO

# Example placeholder artifact so the Docker image still works
cat <<'EOF_SCRIPT' > "${ARTIFACT_DIR}/nodeprof"
#!/usr/bin/env bash
set -euo pipefail
INPUT=${1:-/workspace/input}
echo "NodeProf placeholder CLI"
if [[ -d "${INPUT}" ]]; then
  echo "Contents of ${INPUT}:"
  ls -al "${INPUT}"
else
  echo "Input directory ${INPUT} does not exist"
fi
EOF_SCRIPT

chmod +x "${ARTIFACT_DIR}/nodeprof"
