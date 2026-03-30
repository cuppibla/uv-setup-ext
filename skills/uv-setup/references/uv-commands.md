# uv Commands — Quick Reference

## Install uv

```bash
# macOS / Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows (PowerShell)
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

# Via pip (fallback)
pip install uv

# Reload shell after install (macOS/Linux)
source $HOME/.local/bin/env

# Verify
uv --version
```

---

## Project Initialisation

```bash
# Create a new uv-managed project (no src layout)
uv init --no-package

# Create with a specific Python version
uv init --no-package --python 3.11

# Sync dependencies (after editing pyproject.toml manually)
uv sync
```

---

## Managing Dependencies

```bash
# Add a package
uv add google-adk

# Add multiple packages
uv add google-adk requests httpx

# Add a package with version constraint
uv add "google-adk>=1.0.0"

# Remove a package
uv remove requests

# Upgrade a package
uv add --upgrade google-adk

# List installed packages
uv pip list

# Show dependency tree
uv tree
```

---

## Running Commands in the uv Environment

```bash
# Always prefix with "uv run" to use the project environment
uv run adk web
uv run adk run my-agent
uv run adk --version
uv run python my_script.py
uv run pytest
```

You never need to activate the virtual environment manually.
`uv run` always uses `.venv` in the current project.

---

## Python Version Management

```bash
# Install a specific Python version
uv python install 3.11
uv python install 3.12

# List available Python versions
uv python list

# Pin the project to a Python version
uv python pin 3.11
```

---

## ADK-Specific Commands (always via uv run)

```bash
# Start the ADK web dev UI at http://localhost:8000
uv run adk web

# Use a different port
uv run adk web --port 8001

# Run agent in terminal chat mode
uv run adk run <agent-folder>

# Check ADK version
uv run adk --version
```

---

## Typical ADK Project Setup (from scratch)

```bash
# 1. Install uv (if not already installed)
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env

# 2. Create project folder and initialise uv
mkdir adk-vibe-project
cd adk-vibe-project
uv init --no-package

# 3. Add google-adk
uv add google-adk

# 4. Create your agent folder (Gemini CLI + adk-builder skill does this for you)
mkdir my-agent
# ... add __init__.py, agent.py, .env

# 5. Run
uv run adk web
```

---

## pyproject.toml Reference

```toml
[project]
name = "adk-project"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = [
    "google-adk>=1.0.0",
    "requests>=2.31.0",   # add other packages here
]
```

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `uv: command not found` | Run install script, then `source $HOME/.local/bin/env` |
| `adk: command not found` | Use `uv run adk web` instead of bare `adk web` |
| `No module named 'google.adk'` | Run `uv add google-adk` |
| `Python 3.x required` | Run `uv python install 3.11` then `uv sync` |
| `.venv conflicts` | Delete `.venv/` folder and run `uv sync` |
| `Port 8000 in use` | Run `uv run adk web --port 8001` |
| `No agents found in adk web` | Make sure you run from the PARENT of your agent folder |
