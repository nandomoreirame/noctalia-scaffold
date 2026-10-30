# Noctalia Scaffold

Hello World, template and styleguide for Noctalia v5 plugins, with tests and a generator.

![Bar label "scaffold" with its Hello World panel open](screenshots/panel.png)

## Why

People writing their first Noctalia v5 plugin have two starting points today, and both cost time. The [official example](https://github.com/noctalia-dev/official-plugins/tree/main/example) shows every API but ships no tests, no generator and no conventions to follow. Copying a real plugin drags its business logic along, and you still rebuild a Luau test harness that can run without the shell. Scaffold is the smallest plugin that already follows the conventions, tests itself with a mocked host and renames itself into your new plugin with one command.

## Quick start

Requires Bash, Git, GNU tar, GNU sed and the `luau` CLI on `PATH`.

```bash
git clone https://github.com/nandomoreirame/noctalia-scaffold.git
cd noctalia-scaffold
./scaffold new my-plugin --dir ..
cd ../my-plugin && ./run-tests
```

The new plugin id is `$(whoami)/my-plugin`: the author prefix defaults to your machine user name (`whoami`). Pass `--author <github-user>` when your published id should differ. On GitHub you can also choose **Use this template**, clone the copy and run `./scaffold new` there; a template copy alone keeps the example identity.

## Usage

| Command | What it does |
| --- | --- |
| `./scaffold new <name> [--dir <parent>] [--author <id-prefix>]` | Copies this repo into `<parent>/<name>`, renames the id, name and default label, swaps in the starter README and runs `git init` |
| `./scaffold sync <plugin-repo>` | Refreshes `tests/support/`, `run-tests` and the CI workflow of an existing plugin; never touches `plugin.toml`, `lib/`, entry scripts or your tests |
| `./run-tests` | Runs the Luau suites, the shell tests and a self-check that a failing fixture is detected |

What you get in a new plugin:

| Path | Role |
| --- | --- |
| `plugin.toml` | Manifest: id, bar widget, panel, one `label` setting |
| `widget.luau`, `panel.luau` | Thin entry scripts: read host, call `lib/`, render |
| `lib/present.luau` | Pure presentation logic, testable without the shell |
| `translations/` | `en` and `pt-BR`, with a key-parity test |
| `tests/` | Manifest, purity, model, entry and translation tests on a mocked host |

Conventions behind each file are in the [styleguide](docs/STYLEGUIDE.md).

## Install locally

From a plugin created with `./scaffold new my-plugin`:

```bash
mkdir -p ~/.local/share/noctalia/plugins
ln -s "$PWD" ~/.local/share/noctalia/plugins/my-plugin
echo "$(whoami)/my-plugin"   # the id to use below
```

Add that id to `[plugins] enabled` in `plugins.toml`. In `bar.toml`, add `my-plugin` to a bar slot and define (replace `<whoami>` with the output above):

```toml
[widget.my-plugin]
type = "<whoami>/my-plugin:bar"
```

Restart Noctalia. GUI settings may override whole enabled and bar-slot lists; check the effective configuration with `noctalia config export`. If the panel looks see-through, your bar is translucent: attached panels inherit its opacity. Float it instead (see [Panels](docs/STYLEGUIDE.md#panels)).

## Development

```bash
./run-tests
shellcheck scaffold run-tests tests/*.test.sh
```

CI installs the pinned Luau CLI and runs the same suite. `CLAUDE.md` holds instructions for AI coding agents; humans start with this README and the styleguide.

## Security

The plugin makes no network calls, runs no commands and reads or writes no files; it only reads its `label` setting through the host API. `./scaffold new` writes only inside the directory it creates, and `./scaffold sync` replaces only the harness paths listed above (custom files under `tests/support/` are overwritten, so review the target first). `./run-tests` compiles local Luau source, so run it only on code you trust. CI downloads Luau from its upstream GitHub release.

## Contributing

Issues and pull requests are welcome. Keep `./run-tests` and `shellcheck` green and follow the [styleguide](docs/STYLEGUIDE.md).

## Acknowledgements

The [official example plugin](https://github.com/noctalia-dev/official-plugins/tree/main/example) is the API reference; [tanrendev/noctalia-plugin-template](https://github.com/tanrendev/noctalia-plugin-template) covers catalog and release tooling for publishing a plugin source.

## License

MIT, Fernando Moreira Costa. See [LICENSE](LICENSE).
