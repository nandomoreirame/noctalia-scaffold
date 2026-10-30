#!/usr/bin/env bash
# Docs exist and carry the sections the spec requires.
set -eo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failed=0
need() { grep -qF -- "$2" "$ROOT/$1" || { echo "FAIL: $1 lacks '$2'" >&2; failed=1; }; }

need README.md "## Why"
need README.md "## Usage"
need README.md "## Security"
need docs/README.template.md "## Why"
need docs/README.template.md "## Usage"
need README.md "./scaffold new"
need README.md "./run-tests"
need docs/STYLEGUIDE.md "## lib/ purity"
need docs/STYLEGUIDE.md "## Panels"
need docs/STYLEGUIDE.md "## i18n"
need docs/STYLEGUIDE.md "## Settings"
need docs/STYLEGUIDE.md "## Tests"
need docs/STYLEGUIDE.md "## No local state in the repo"
need CLAUDE.md "docs/STYLEGUIDE.md"
need docs/README.template.md "# Scaffold"
need docs/README.template.md "nandomoreirame/scaffold"
need docs/README.template.md "## Security"
need docs/README.template.md "./run-tests"

for doc in README.md docs/STYLEGUIDE.md; do
  if grep -n "nandomoreirame" "$ROOT/$doc" | grep -v "github.com/nandomoreirame/noctalia-scaffold"; then
    echo "FAIL: $doc hardcodes the template author; use \$(whoami)" >&2; failed=1
  fi
done
need README.md "whoami"
need docs/STYLEGUIDE.md "whoami"
if grep -rnE '/home/[a-z]+/' "$ROOT/README.md" "$ROOT/docs" "$ROOT/CLAUDE.md"; then
  echo "FAIL: absolute home path in docs" >&2; failed=1
fi
if grep -rnP '\x{2014}|\x{2013}' "$ROOT/README.md" "$ROOT/docs" "$ROOT/CLAUDE.md"; then
  echo "FAIL: em/en dash in docs" >&2; failed=1
fi
echo "docs.test.sh: $([ $failed -eq 0 ] && echo ok || echo failed)"
exit $failed
