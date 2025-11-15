#!/usr/bin/env bash
set -euo pipefail

REPO_LIST_FILE=${1:-docker/repos.txt}
SRC_ROOT=${2:-/opt/nodeprof/sources}
BUILD_SCRIPT=${3:-scripts/build.sh}
ARTIFACT_DIR=${4:-/opt/nodeprof/bin}

if [[ ! -f "${REPO_LIST_FILE}" ]]; then
  echo "[build] repository list file '${REPO_LIST_FILE}' does not exist" >&2
  exit 1
fi

mkdir -p "${SRC_ROOT}" "${ARTIFACT_DIR}"

while IFS= read -r line; do
  repo=$(echo "${line}" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')
  [[ -z "${repo}" || "${repo}" == \#* ]] && continue

  read -r source_url dest_name _ <<< "${repo}"

  if [[ -z "${source_url}" ]]; then
    echo "[build] invalid repo line: ${line}" >&2
    exit 1
  fi

  if [[ -z "${dest_name}" ]]; then
    dest_name=$(basename "${source_url}" .git)
  fi

  target_dir="${SRC_ROOT}/${dest_name}"
  if [[ -d "${target_dir}" ]]; then
    echo "[build] Skipping ${source_url}, already cloned"
    continue
  fi

  echo "[build] Cloning ${source_url} -> ${target_dir}"
  git clone --depth=1 "${source_url}" "${target_dir}"

done < "${REPO_LIST_FILE}"

if [[ ! -x "${BUILD_SCRIPT}" ]]; then
  echo "[build] build script '${BUILD_SCRIPT}' missing or not executable" >&2
  exit 1
fi

"${BUILD_SCRIPT}" "${SRC_ROOT}" "${ARTIFACT_DIR}"
