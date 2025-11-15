#!/usr/bin/env bash
set -euo pipefail

CLI_BIN="${CLI_BIN:-/opt/nodeprof/bin/nodeprof}"

if [[ ! -x "${CLI_BIN}" ]]; then
  echo "Entrypoint error: CLI binary '${CLI_BIN}' not found or not executable" >&2
  exit 1
fi

if [[ $# -eq 0 ]]; then
  exec "${CLI_BIN}"
fi

case "$1" in
  bash|sh)
    exec "$@"
    ;;
  nodeprof)
    shift
    exec "${CLI_BIN}" "$@"
    ;;
  -* )
    exec "${CLI_BIN}" "$@"
    ;;
  *)
    exec "$@"
    ;;
esac
