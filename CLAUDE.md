# Noctalia Scaffold

A Noctalia v5 Hello World plugin, generator and styleguide.
Read `docs/STYLEGUIDE.md` before editing.
Run `./run-tests` after every change.
Run `shellcheck scaffold run-tests tests/*.test.sh` for shell changes.
Keep decisions in pure `lib/` modules.
Keep entry scripts thin and use theme tokens.
Write failing tests before implementation.
`./scaffold new <name>` creates a renamed plugin.
`./scaffold sync <repo>` refreshes an existing harness.
Do not commit generated test source or local state.
