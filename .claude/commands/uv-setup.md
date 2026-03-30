# uv Setup

You are an expert in Python project setup with uv. Your job is to get the
user's project running correctly by ensuring uv is installed, the project is
initialised, and the required package(s) are added.

Always run commands directly using your shell tool. Never ask the user to
copy-paste commands manually unless there is no other option.

---

## What is uv?

uv is an extremely fast Python package manager made by Astral. It replaces
pip, pip-tools, virtualenv, and pyenv in a single tool. Key benefits:

- Creates and manages virtual environments automatically
- `uv run <command>` always uses the project's own environment — no
  "command not found" errors
- 10–100x faster than pip
- No admin rights required to install

---

## Step 1 — Check if uv is already installed

```bash
uv --version
```

- If it prints a version (e.g. `uv 0.5.x`) → skip to Step 3
- If it says "command not found" → proceed to Step 2

---

## Step 2 — Install uv

### macOS / Linux
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

After installing, reload the shell:
```bash
source $HOME/.local/bin/env
```

Verify:
```bash
uv --version
```

### Windows (PowerShell)
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### Alternative: install with pip (if curl is unavailable)
```bash
pip install uv
```

---

## Step 3 — Check if the project is already initialised

Run from the user's project directory:

```bash
ls pyproject.toml
```

- If `pyproject.toml` exists → the project is already a uv project, skip to Step 5
- If it does not exist → proceed to Step 4

---

## Step 4 — Initialise uv in the project directory

```bash
uv init --no-package
```

This creates:
- `pyproject.toml` — the project's dependency file
- `.python-version` — pins the Python version
- `.venv/` — the virtual environment (created on first `uv run`)

---

## Step 5 — Add the required dependency

Replace `<package-name>` with the package the user needs:

```bash
uv add <package-name>
```

This installs the package and all its dependencies into the local `.venv`
and records it in `pyproject.toml`.

To add multiple packages at once:
```bash
uv add <package-one> <package-two>
```

If you are unsure what package provides the command the user is trying to run,
check PyPI or ask the user to confirm the package name before proceeding.

---

## Step 6 — Verify the package is available

```bash
uv run python -c "import <module>; print('ok')"
```

Or, if the package provides a CLI command:
```bash
uv run <command> --version
```

If this succeeds, setup is complete.

---

## Step 7 — Remind the user of the new command pattern

After setup, remind the user to always prefix commands with `uv run`:

| Old command (broken)     | New command (correct)        |
|--------------------------|------------------------------|
| `<command>`              | `uv run <command>`           |
| `python script.py`       | `uv run python script.py`    |
| `python -m <module>`     | `uv run python -m <module>`  |

---

## Handling Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `<command>: command not found` | Running bare command outside uv | Use `uv run <command>` instead |
| `uv: command not found` after install | Shell not reloaded | Run `source $HOME/.local/bin/env` or open a new terminal |
| `No module named <x>` | Package not added to uv project | Run `uv add <package>` |
| `Python 3.x required` | Python version too old | Run `uv python install 3.11` then `uv sync` |
| `.venv not found` | uv not initialised | Run `uv init --no-package` then `uv add <package>` |
