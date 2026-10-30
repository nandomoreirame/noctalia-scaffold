#!/usr/bin/env bash
# ./scaffold new|sync against throwaway directories.
# shellcheck disable=SC2016
# Assertions expand fixture variables in the child shell.
set -eo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/scaffold"
passed=0
failed=0
T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT

ok() { passed=$((passed + 1)); }
ko() { failed=$((failed + 1)); echo "FAIL: $1" >&2; }
check() { local label="$1"; shift; if "$@"; then ok; else ko "$label"; fi; }

# --- sync ---------------------------------------------------------------
R="$T/plugin"
export ROOT SCRIPT T R
mkdir -p "$R/lib" "$R/tests/support"
printf 'id = "x/plugin"\n' > "$R/plugin.toml"
printf 'return 1\n' > "$R/lib/keep.luau"
printf 'mine\n' > "$R/tests/a.test.luau"
printf 'stale\n' > "$R/tests/support/old.luau"

"$SCRIPT" sync "$R" >/dev/null
check "sync copies the runner" bash -c '[ -x "$R/run-tests" ]'
check "sync copies ci.yml" bash -c 'cmp -s "$ROOT/.github/workflows/ci.yml" "$R/.github/workflows/ci.yml"'
check "sync mirrors tests/support" bash -c 'diff -rq "$ROOT/tests/support" "$R/tests/support" >/dev/null'
check "sync drops stale support files" bash -c '[ ! -e "$R/tests/support/old.luau" ]'
check "sync keeps lib/" bash -c '[ "$(cat "$R/lib/keep.luau")" = "return 1" ]'
check "sync keeps tests" bash -c '[ "$(cat "$R/tests/a.test.luau")" = "mine" ]'
check "sync keeps plugin.toml" bash -c '[ "$(cat "$R/plugin.toml")" = "id = \"x/plugin\"" ]'
"$SCRIPT" sync "$R" >/dev/null
check "sync appends the gitignore entry once" bash -c '[ "$(grep -cx "tests/.generated/" "$R/.gitignore")" = 1 ]'
check "sync refuses a dir without plugin.toml" bash -c '! "$SCRIPT" sync "$T" >/dev/null 2>&1'
check "unknown subcommand fails" bash -c '! "$SCRIPT" bogus >/dev/null 2>&1'

echo "scaffold.test.sh: $passed passed, $failed failed"
[ "$failed" -eq 0 ]
