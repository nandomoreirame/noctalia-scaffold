#!/usr/bin/env bash
set -eo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failed=0
need() { grep -qF -- "$2" "$ROOT/$1" || { echo "FAIL: $1 lacks $2" >&2; failed=1; }; }
need docs/README.template.md "# Scaffold"
need docs/README.template.md "nandomoreirame/scaffold"
need docs/README.template.md "## Security"
need docs/README.template.md "./run-tests"

exit "$failed"
