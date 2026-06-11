# Template Python Library

[![CI][ci-shield]][ci-url]
[![Docs][docs-shield]][docs-url]
[![Release][release-shield]][release-url]

[ci-shield]: https://img.shields.io/github/actions/workflow/status/mumblepins/template-python-library/ci.yml?style=flat-square&branch=main&label=CI
[ci-url]: https://github.com/mumblepins/template-python-library/actions/workflows/ci.yml
[docs-shield]: https://img.shields.io/github/actions/workflow/status/mumblepins/template-python-library/docs.yml?style=flat-square&branch=main&label=Docs
[docs-url]: https://mumblepins.github.io/template-python-library/
[release-shield]: https://img.shields.io/github/actions/workflow/status/mumblepins/template-python-library/release.yml?style=flat-square&branch=main&label=Release
[release-url]: https://github.com/mumblepins/template-python-library/actions/workflows/release.yml

Description

## Prerequisites

```bash
uv tool install prek ruff pyright
```

## Installation

```bash
uv add template-python-library
```

## Developer commands

| Purpose              | Command                                       |
| -------------------- | --------------------------------------------- |
| Install deps         | `uv sync --upgrade --all-groups`              |
| Poe shortcut         | `uv run sync`                                 |
| All tests + coverage | `uv run test`                                 |
| Single test          | `uv run pytest tests/path.py::test_name -q`   |
| Lint + format        | `prek run --all-files --show-diff-on-failure` |
| Type-check (mypy)    | `uv run mypy src tests`                       |
| Type-check (pyright) | `pyright`                                     |
| Build docs           | `uv run docs`                                 |
| Serve docs           | `uv run docs-serve`                           |
| Full pre-flight      | `uv run poe check`                            |
