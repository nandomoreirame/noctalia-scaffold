# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]


## [0.1.0] - 2026-10-30

### Added

- Add the `nandomoreirame/scaffold` Hello World plugin: a bar widget with a configurable `label` setting that toggles a dropdown panel with `Hello World!` centered.
- Add `./scaffold new <name>` to copy the template into a renamed plugin (id, name, default label, starter README, fresh git repo) whose tests pass out of the box; the author prefix defaults to `whoami`.
- Add `./scaffold sync <repo>` to refresh `tests/support/`, `run-tests` and the CI workflow of an existing plugin without touching its code or tests.
- Add a Luau test harness with a mocked Noctalia host, covering the manifest, `lib/` purity, presentation models, entry scripts and `en`/`pt-BR` translation key parity, run locally and in CI.
- Add `docs/STYLEGUIDE.md` with the plugin conventions (layout, pure `lib/`, thin entries, panels, colors, settings, i18n, tests) and a README template with Why, Usage and Security sections for generated plugins.

### Fixed

- Refuse to sync the template into itself or through symlinked harness paths, and keep custom `.gitignore` content intact.

---
