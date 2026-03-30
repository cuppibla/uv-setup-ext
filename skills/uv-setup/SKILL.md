---
name: uv-setup
description: >
  Use this skill when the user gets a "command not found" error running adk,
  wants to set up uv for their ADK project, needs to install google-adk
  dependencies, or asks how to run adk web correctly. Also activate when the
  user is starting a new ADK project and needs a proper Python environment.
---

# uv Setup Skill

You are an expert in Python project setup with uv. Your job is to get the
user's ADK project running correctly — specifically so that `uv run adk web`
works without errors.

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

Run this command first:

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

After installing, reload the shell so the `uv` command is available:
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

## Step 3 — Check the project structure

The user should have an agent folder like:

```
my-agent/
├── .env
├── __init__.py
└── agent.py
```

Ask the user for their agent folder name if you do not already know it.
Run `ls` to confirm it exists before proceeding.

---

## Step 4 — Initialise uv in the project PARENT directory

uv should be set up in the **parent** directory of the agent folder
(the same directory from which you run `adk web`).

```bash
# Run from the parent directory, e.g. ~/adk-vibe-project/
uv init --no-package
```

This creates:
- `pyproject.toml` — the project's dependency file
- `.python-version` — pins the Python version
- `.venv/` — the virtual environment (created on first `uv run`)

If `pyproject.toml` already exists, skip this step.

---

## Step 5 — Add google-adk as a dependency

```bash
uv add google-adk
```

This installs `google-adk` and all its dependencies into the local `.venv`
and records it in `pyproject.toml`.

If the user also needs other packages (e.g. `requests`, `httpx`), add them:
```bash
uv add requests httpx
```

---

## Step 6 — Verify adk is available

```bash
uv run adk --version
```

If this prints the ADK version, the setup is complete.
If it fails, check that `uv add google-adk` completed without errors.

---

## Step 7 — Run the ADK dev UI

```bash
uv run adk web
```

This starts the ADK web interface at http://localhost:8000.

The user should open this URL in their browser and select their agent from
the dropdown.

---

## Step 8 — Tell the user the new command pattern

After setup, remind the user to always prefix ADK commands with `uv run`:

| Old command (broken) | New command (correct) |
|---------------------|----------------------|
| `adk web` | `uv run adk web` |
| `adk run my-agent` | `uv run adk run my-agent` |
| `adk --version` | `uv run adk --version` |

---

## Complete pyproject.toml reference

After `uv init` + `uv add google-adk`, the pyproject.toml should look like:

```toml
[project]
name = "adk-project"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = [
    "google-adk>=1.0.0",
]
```

If the user needs to add more packages later:
```bash
uv add <package-name>
```

To remove a package:
```bash
uv remove <package-name>
```

To sync after manually editing pyproject.toml:
```bash
uv sync
```

---

## Handling Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `adk: command not found` | Running bare `adk` outside uv | Use `uv run adk web` instead |
| `uv: command not found` after install | Shell not reloaded | Run `source $HOME/.local/bin/env` or open a new terminal |
| `No module named google.adk` | ADK not added to uv project | Run `uv add google-adk` |
| `Python 3.x required` | Python version too old | Run `uv python install 3.11` then `uv sync` |
| `Port 8000 already in use` | Another process using port | Run `uv run adk web --port 8001` |
| `.venv not found` | uv not initialised | Run `uv init --no-package` then `uv add google-adk` |
| `No agents found` | Running from wrong directory | Run `uv run adk web` from the PARENT of the agent folder |

---

## Folder layout reminder

```
adk-vibe-project/        ← run uv init and uv run adk web HERE
├── pyproject.toml       ← created by uv init
├── .python-version      ← created by uv init
├── .venv/               ← created automatically by uv
└── my-agent/            ← your ADK agent folder
    ├── .env
    ├── __init__.py
    └── agent.py
```

Never run `uv init` inside the agent folder itself.

---

## Reference Materials

See `references/uv-commands.md` for a full uv command cheat sheet.
See `scripts/check_setup.sh` to verify the setup is correct.
