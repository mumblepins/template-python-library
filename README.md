# Template Python Library

A [Copier](https://copier.readthedocs.io/) template for bootstrapping a Python library with modern tooling and CI/CD.

## What's included

| Area | Tooling |
| --- | --- |
| Packaging | [uv](https://docs.astral.sh/uv/) with [uv_build](https://docs.astral.sh/uv/) build backend |
| Linting & formatting | [ruff](https://docs.astral.sh/ruff/), [prettier](https://prettier.io/) via [prek](https://github.com/j178/prek) |
| Type checking | [mypy](https://mypy-lang.org/) + [pyright](https://microsoft.github.io/pyright/) |
| Testing | [pytest](https://docs.pytest.org/) with coverage, xdist, randomly |
| Docs | [MkDocs Material](https://squidfunk.github.io/mkdocs-material/) + [mkdocstrings](https://mkdocstrings.github.io/) |
| Releases | [python-semantic-release](https://python-semantic-release.readthedocs.io/) |
| CI/CD | GitHub Actions — CI (split jobs, SHA-pinned), Docs deploy, Semantic Release, PyPI publishing |
| Secret scanning | [gitleaks](https://github.com/gitleaks/gitleaks) |
| Dependency updates | [Dependabot](https://docs.github.com/en/code-security/dependabot) |
| Community files | CONTRIBUTING.md, CODE_OF_CONDUCT.md, SECURITY.md |

## Prerequisites

- [Copier](https://copier.readthedocs.io/) >= 9.0 (`pipx install copier` or `uv tool install copier`)
- [uv](https://docs.astral.sh/uv/getting-started/installation/)
- [prek](https://github.com/j178/prek) (`uv tool install prek`)

## Usage

### Create a new project

```bash
copier copy --trust gh:mumblepins/template-python-library my-new-project
```

Or from a local clone:

```bash
copier copy --trust /path/to/template-python-library my-new-project
```

The `--trust` flag is required because this template runs post-generation tasks (git init, dependency installation, pre-commit setup).

Copier will prompt for:

| Prompt | Description | Default |
| --- | --- | --- |
| `project_name` | Human-readable name | `My Python Library` |
| `project_slug` | Kebab-case identifier (URLs, package) | derived from name |
| `package_name` | Python import name (snake_case) | derived from slug |
| `description` | Short project description | _(empty)_ |
| `author_name` | Author name | _(empty)_ |
| `author_email` | Author email | _(empty)_ |
| `github_org` | GitHub org or username | `mumblepins` |
| `license` | MIT / Apache-2.0 / BSD-3-Clause / GPL-3.0 / AGPL-3.0 / None | `MIT` |
| `python_version` | Minimum Python (3.11–3.14) | `3.14` |

After prompting, Copier will:

1. Render all `.jinja` templates with your answers
2. Run `git init`
3. Remove the LICENSE file if you chose `None`
4. Run `uv sync --all-groups` to install dependencies
5. Install pre-commit hooks via `prek install`
6. Run `prek run --all-files` to lint and format everything

### Update an existing project

If you generated a project from this template and want to pull in template changes:

```bash
cd my-project
uv run poe update
# or directly:
copier update --trust
```

Copier will replay your original answers and prompt for any new or changed values, then merge the diff.

## Project structure (generated)

```
my-project/
├── src/
│   └── <package_name>/
│       ├── __init__.py        # __version__ lives here
│       ├── app.py             # starter module
│       └── py.typed           # PEP 561 marker
├── tests/
│   ├── __init__.py
│   ├── conftest.py
│   └── test_app.py
├── docs/
│   ├── index.md
│   └── api/
│       └── index.md
├── .github/
│   ├── workflows/
│   │   ├── ci.yml             # lint + type-check + test (matrix) + coverage + gate
│   │   ├── docs.yml           # build + deploy MkDocs to GitHub Pages
│   │   ├── release.yml        # semantic release + GitHub release assets
│   │   └── publish.yml        # PyPI publishing (disabled by default)
│   └── dependabot.yml
├── .copier-answers.yml        # stores your Copier answers for updates
├── .editorconfig
├── .gitignore
├── .pre-commit-config.yaml
├── .python-version
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE                    # omitted if license = None
├── mkdocs.yml
├── pyproject.toml
├── README.md
└── SECURITY.md
```

## Developer commands

Once inside a generated project, common tasks are available via [poethepoet](https://poethepoet.natn.io/):

| Command | What it does |
| --- | --- |
| `uv run poe sync` | Upgrade and install all dependency groups |
| `uv run poe test` | Run pytest with coverage (html, term, xml) |
| `uv run poe prek` | Run all pre-commit hooks on all files |
| `uv run poe build` | Build sdist + wheel via `uv build` |
| `uv run poe docs` | Build MkDocs site |
| `uv run poe docs-serve` | Serve docs locally with live reload |
| `uv run poe check` | Full pre-flight: sync → prek → test |
| `uv run poe update` | Pull template updates via `copier update` |

## CI/CD workflows

- **CI** — runs on push/PR to `main`: split into lint, type-check, test (Python matrix), coverage, and an all-checks-pass gate. All actions pinned by SHA.
- **Docs** — builds MkDocs and deploys to GitHub Pages via GitHub Pages Actions (separate build + deploy jobs).
- **Release** — uses python-semantic-release to create versioned GitHub releases from conventional commits.
- **Publish** — PyPI publishing with Trusted Publishers and Sigstore provenance attestation. Disabled by default (`workflow_dispatch` only); edit the workflow trigger to `push: tags: ["v*"]` to enable.

## Conventional commits

Semantic release depends on [conventional commit](https://www.conventionalcommits.org/) messages:

- `feat:` → minor bump
- `fix:` / `perf:` → patch bump
- `build:`, `chore:`, `ci:`, `docs:`, `refactor:`, `style:`, `test:` → no version bump
