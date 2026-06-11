# AGENTS: How to work in this repository

## Prerequisites

Install required tools via uv:

```bash
uv tool install prek ruff pyright
```

## Architecture

- **Package**: `src/template_python_library/` — main package source
- **Tests**: `tests/` — pytest test suite
- **Docs**: `docs/` — mkdocs-material documentation

## Developer commands

Package manager is `uv`; Python >=3.14.

| Purpose              | Command                                       |
| -------------------- | --------------------------------------------- |
| Install deps         | `uv sync --upgrade --all-groups`              |
| Poe shortcut         | `uv run sync`                                 |
| All tests + coverage | `uv run test` (pytest with html/xml reports)  |
| Single test          | `uv run pytest tests/path.py::test_name -q`   |
| Lint + format        | `prek run --all-files --show-diff-on-failure` |
| Type-check (mypy)    | `uv run mypy src tests`                       |
| Type-check (pyright) | `pyright`                                     |
| Build docs           | `uv run docs`                                 |
| Serve docs           | `uv run docs-serve`                           |
| Full pre-flight      | `uv run poe check` (sync → prek → test)       |

Poe tasks (from `pyproject.toml [tool.poe.tasks]`): `sync`, `test`, `prek`, `build`, `docs`, `docs-serve`, `check`.

## Project conventions

- **Linting & formatting**: `ruff` (line-length 100, Google-style docstrings). Pre-commit runs: ruff (lint+format), prettier, gitleaks, uv-lock, pre-commit-hooks.
- **Build**: `uv_build`. Optional dependencies can be added via `[project.optional-dependencies]`.
- **Type checking**: Both `mypy` and `pyright` are configured. Pyright config is in `pyproject.toml` under `[tool.pyright]`.

## Tests

- Live in `tests/`. Run with `uv run test`.
- `pytest` config: `log_cli` at INFO level, `--import-mode=importlib`.
- Dev dependencies include `pytest-randomly` (random test order), `pytest-xdist` (parallel execution).

## Adding features

### Optional dependencies

Add to `[project.optional-dependencies]` in `pyproject.toml`:

```toml
[project.optional-dependencies]
extra_name = ["package>=1.0"]
```

### CLI scripts

Add to `[project.scripts]` in `pyproject.toml`:

```toml
[project.scripts]
my-cli = "template_python_library.cli:main"
```

Then run `uv sync` to install.
