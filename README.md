# Noctalia Scaffold

Starting a Noctalia v5 plugin means rebuilding a Luau test harness and finding conventions scattered across other plugins. Copying a working plugin also brings its unrelated business logic. This repository gives plugin authors a small, tested starting point: a Hello World plugin, a generator and a styleguide.

## Try the example

The bar shows a glyph and the configurable `scaffold` label. Clicking opens an attached panel with `Hello World!` and a translated subtitle. Vertical bars show only the glyph. A blank label falls back to the default.

## Start a plugin

Requires Bash, Git, GNU tar, GNU sed and the `luau` CLI on PATH.

```bash
./scaffold new my-plugin --dir .. --author you
cd ../my-plugin
./run-tests
```

On GitHub, choose **Use this template**, clone the result, then run `./scaffold new` to apply a new identity. A GitHub template copy alone keeps the example identity.

To refresh an existing plugin's harness:

```bash
./scaffold sync ../my-plugin
```

This replaces `tests/support/`, `run-tests` and the CI workflow while preserving plugin code and test suites.

## Install locally

```bash
mkdir -p ~/.local/share/noctalia/plugins
ln -s "$PWD" ~/.local/share/noctalia/plugins/scaffold
```

Add `nandomoreirame/scaffold` to `[plugins] enabled` in `plugins.toml`. In `bar.toml`, add `scaffold` to a bar slot and define:

```toml
[widget.scaffold]
type = "nandomoreirame/scaffold:bar"
```

Restart Noctalia. GUI settings may override entire enabled and bar-slot lists; check the effective configuration with `noctalia config export`.

## Tests

```bash
./run-tests
shellcheck scaffold run-tests tests/*.test.sh
```

The runner checks the manifest, pure presentation models, entries, locale key parity, generator and docs. It also verifies that a deliberately failing fixture is detected. CI installs the pinned Luau CLI and runs the same suite.

## Repository scope

The plugin and generator share the same harness, manifest and entry scripts so generated plugins start with the tested example. Read [the styleguide](docs/STYLEGUIDE.md) for conventions. `CLAUDE.md` provides instructions for AI coding agents; humans start with this README and the styleguide.

## Security

The plugin makes no network calls, executes no commands and reads or writes no files. It reads its label through the host settings API. The generator writes inside its selected target directory: `new` creates a fresh repository; `sync` replaces only harness paths and adds the generated-files ignore entry. Review the target before syncing because custom support files are replaced. The test harness compiles local Luau source; run tests only for code you trust. CI downloads Luau from its upstream GitHub release.

## License

MIT, Fernando Moreira Costa.
