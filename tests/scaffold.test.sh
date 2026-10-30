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

# --- new ----------------------------------------------------------------
"$SCRIPT" new disk-cleaner --dir "$T" --author someone >/dev/null
N="$T/disk-cleaner"
export N
check "new creates the plugin dir" bash -c '[ -f "$N/plugin.toml" ]'
check "new rewrites the id" bash -c 'grep -qF "id = \"someone/disk-cleaner\"" "$N/plugin.toml"'
check "new title-cases the name" bash -c 'grep -qF "name = \"Disk Cleaner\"" "$N/plugin.toml"'
check "new rewrites the default label" bash -c 'grep -qF "default = \"disk-cleaner\"" "$N/plugin.toml"'
check "new rewrites the panel id" bash -c 'grep -qF "someone/disk-cleaner:panel" "$N/widget.luau"'
check "new leaves no scaffold id behind" bash -c '! grep -rqF "nandomoreirame/scaffold" "$N" --exclude-dir=.git'
check "new drops the script and template-only tests" bash -c '[ ! -e "$N/scaffold" ] && [ ! -e "$N/tests/scaffold.test.sh" ] && [ ! -e "$N/tests/docs.test.sh" ]'
check "new uses the README template" bash -c 'head -1 "$N/README.md" | grep -qF "Disk Cleaner"'
check "new removes the README template" bash -c '[ ! -e "$N/docs/README.template.md" ]'
check "new skips generated files" bash -c '[ ! -e "$N/tests/.generated" ]'
check "new starts a fresh git repo on main" bash -c '[ "$(git -C "$N" symbolic-ref --short HEAD)" = main ] && [ -z "$(git -C "$N" log --oneline 2>/dev/null)" ]'
check "new plugin passes its own tests" bash -c '(cd "$N" && ./run-tests >/dev/null 2>&1)'
check "new refuses an existing target" bash -c '! "$SCRIPT" new disk-cleaner --dir "$T" >/dev/null 2>&1'
check "new refuses a non-kebab name" bash -c '! "$SCRIPT" new Bad_Name --dir "$T" >/dev/null 2>&1'
"$SCRIPT" new plain --dir "$T" >/dev/null
check "new defaults the author" bash -c 'grep -qF "id = \"nandomoreirame/plain\"" "$T/plain/plugin.toml"'

# Safety and byte-for-byte preservation.
printf '# custom ignore block\nlocal-cache/' > "$R/.gitignore"
"$SCRIPT" sync "$R" >/dev/null
check "sync preserves an unterminated custom ignore block" bash -c 'printf "# custom ignore block\nlocal-cache/\ntests/.generated/\n" | cmp -s - "$R/.gitignore"'
cp "$R/.gitignore" "$T/ignore-before"
"$SCRIPT" sync "$R" >/dev/null
check "sync is byte-idempotent" cmp -s "$T/ignore-before" "$R/.gitignore"
mkdir "$T/self"
tar -C "$ROOT" --exclude=./.git --exclude=./tests/.generated -cf - . | tar -C "$T/self" -xf -
check "sync refuses the template itself" bash -c '! "$T/self/scaffold" sync "$T/self" >/dev/null 2>&1'
check "self sync preserves the source harness" cmp -s "$ROOT/tests/support/modules.luau" "$T/self/tests/support/modules.luau"
mkdir -p "$T/external" "$T/linked"
printf 'id = "x/linked"\n' > "$T/linked/plugin.toml"
ln -s "$T/external" "$T/linked/tests"
check "sync refuses symlinked harness paths" bash -c '! "$SCRIPT" sync "$T/linked" >/dev/null 2>&1'
check "sync never writes through symlinks" bash -c '[ -z "$(ls -A "$T/external")" ]'
check "new refuses a target nested inside the template" bash -c '! "$T/self/scaffold" new nested --dir "$T/self" >/dev/null 2>&1' 

echo "scaffold.test.sh: $passed passed, $failed failed"
[ "$failed" -eq 0 ]
