# Noctalia v5 plugin styleguide

## Layout

Keep `plugin.toml`, `widget.luau`, `panel.luau`, `lib/`, `translations/`, `tests/support/` and `run-tests` at the root. The generator is maintained here, not copied into generated plugins.

## lib/ purity

Put decisions in `lib/present.luau`. Pure modules must never access `noctalia`, `barWidget`, `panel` or `ui`. The manifest suite enforces this boundary. For example, `present.label(raw)` trims a string and supplies the default without calling the host.

## Entry scripts

Read settings, call a pure model and render its result. Keep click handlers as thin host calls. `widget.luau` calls `present.bar`; `panel.luau` calls `present.panel`. Re-render on update and panel open.

## Manifest

Use `<author>/<directory>` as the id, API 22, a version, license and a description of at most 120 characters. Declare every widget, panel and setting. Tests check these fields so metadata cannot silently drift.

## Panels

Declare `placement = "attached"` and `open_near_click = true`. Use a column with centered alignment, justification and available-height growth for the headline and subtitle. Verify layout in the real host because mocks cannot prove centering. `ui.box` does not host children.

Users can override placement in `plugins.toml`:

```toml
[plugin_settings."author/plugin"]
panel_placement = "floating"
```

Placement and border changes require a shell restart.

## Colors

Use theme tokens such as `on_surface` and `on_surface_variant`. Alpha suffixes belong to roles, for example `surface/0.5`. Avoid hardcoded hex colors except fully transparent values. Emit explicit visual properties on every render because omitted properties may retain their prior values.

## Settings

Declare `[[setting]]` with its type, default, `label_key` and `description_key`. Read it using `noctalia.getConfig("label")`. The mock rejects undeclared configuration keys unless supplied through its `config` option. Normalize missing and blank values in the pure module.

## i18n

Use nested JSON in `translations/en.json` and `translations/pt-BR.json`. Read strings with `noctalia.tr("bar.tooltip")`. The parity test flattens and compares both key sets. `Hello World!` stays literal; the subtitle and tooltip demonstrate translations.

## Tests

Run `./run-tests` with Luau on PATH. For pure modules use `modules.load("lib/present.luau")`. For entry scripts use `entry.load("widget.luau", { config = { label = "hello" }, vertical = true })` and inspect `mock.calls(loaded.env, "barWidget.render")`.

The host mock also supports `now`, `fs` and `async` options. Script command results explicitly: `async = { [cmd] = AsyncResult }`; an unscripted `runAsync` is an error. `modules.luau` injects relative `.luau` imports. The runner wraps source files into ignored `tests/.generated/` modules and runs `tests/*.test.sh` for shell behavior. Write a failing test before changing production behavior. Test generated plugins by running their own suite.

## No local state in the repo

Never commit workstation home paths, IP addresses, private hostnames or credentials. Read environment-specific values through settings or environment variables. Generated sources belong in the ignored test directory.

## Commits

Use Conventional Commits with an English imperative subject and keep implementation and its tests together. Do not add signatures, credentials or unrelated work.
