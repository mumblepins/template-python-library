# AGENTS.md — template-python-library

This is a [Copier](https://copier.readthedocs.io/) template that generates Python libraries. It is **not** a Python library itself.

## Architecture

- `copier.yml` — template config, prompts, and post-generation tasks
- `*.jinja` — Jinja2 templates rendered by Copier during `copier copy`. Source templates live in `src/{{ package_name }}/` and `tests/`.
- `pyproject.toml` (non-jinja) — only configures `python-semantic-release` for template version bumps. **No dev dependencies or test config** — do not run `uv sync --all-groups` or `uv run pytest` here.
- `pyproject.toml.jinja` — the template that becomes the generated project's `pyproject.toml`
- `.gitignore` excludes `uv.lock` (line 345) — intentional for this template repo only

## Generated project toolchain

When users run `copier copy --trust ...`, the output project uses:

| Area | Tool |
|------|------|
| Package mgr | `uv` |
| Lint/format | `ruff` (via `prek`) |
| Type check | `mypy` + `pyright` |
| Test | `pytest` with coverage, xdist, randomly |
| Task runner | `poethepoet` (commands via `uv run poe ...`) |
| Pre-commit | `prek` (not raw `pre-commit`) |
| Docs | MkDocs Material + mkdocstrings |
| Releases | `python-semantic-release` (conventional commits) |

## Generated project commands (not runnable in template root)

```sh
uv run poe test       # pytest with coverage
uv run poe prek       # prek run --all-files --show-diff-on-failure
uv run poe check      # sync → prek → test
uv run poe docs-serve # mkdocs serve with live reload
uv run poe update     # copier update --trust
uv run mypy src tests
uv run pyright
```

## Template development

- No tests exist for the template — do not attempt to run pytest
- Template version is bumped automatically via `.github/workflows/template-release.yml` (on push to `main`, using `python-semantic-release`)
- Pre-commit hooks are configured in `.pre-commit-config.yaml` and run via `prek`
- Run `prek run --all-files` to lint/format template files
- Edit `.jinja` files to change generated project output
- After changing `copier.yml` prompts, test with `copier copy --trust --vcs-ref=HEAD . /tmp/test-output` — without `--vcs-ref=HEAD`, Copier uses the latest tag instead of the working tree

## Style conventions

- 4-space indent for Python, 2-space for YAML (`.editorconfig`)
- Ruff config: line-length 100, double quotes, Google-style docstrings, isort with `combine-as-imports`
- Pytest in generated projects uses `--import-mode=importlib`
- Coverage `fail_under = 50` in generated projects
