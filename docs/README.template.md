# Scaffold

Noctalia v5 plugin that <does what, in one line, for whom>.

<!-- Screenshot: save one as screenshots/main.png and embed it here, with alt text describing what the reader sees. -->

## Why

<Who has the problem, in their words.> <What they do today and what it costs them.> <Why the obvious alternative is not enough.> <What this plugin does differently, in one line.>

## Install

Requires Noctalia v5 (plugin API 22 or later).

```bash
mkdir -p ~/.local/share/noctalia/plugins
ln -s "$PWD" ~/.local/share/noctalia/plugins/scaffold
```

Add `nandomoreirame/scaffold` to `[plugins] enabled` in `plugins.toml`, then add `[widget.scaffold] type = "nandomoreirame/scaffold:bar"` to a bar slot in `bar.toml` and restart Noctalia.

## Usage

<What appears in the bar, what a click opens, what each action does.>

| Setting | Type | Default | Effect |
| --- | --- | --- | --- |
| `label` | string | `scaffold` | Text next to the icon in the bar |

## Development

Needs the `luau` CLI on `PATH`.

```bash
./run-tests
```

## Security

<List every network call, command and file this plugin touches, from the code. If it touches none, say so in one line.>

## License

MIT, <Owner>. See [LICENSE](LICENSE).
