# uv-setup-ext

A Gemini CLI extension that sets up [uv](https://docs.astral.sh/uv/) for
any Python project — so that Python commands and tools always work correctly
without "command not found" errors.

## The problem this solves

When you install a Python package with pip inside a virtual environment, its
CLI commands are only available inside that environment. Running them from a
plain terminal gives "command not found".

`uv` solves this cleanly: it manages your virtual environment automatically
and `uv run <command>` always finds the right tool, no matter where you are.

## Install

```bash
gemini extensions install https://github.com/YOUR_USERNAME/uv-setup-ext
```

## Usage

Start Gemini CLI in your project folder and just describe the problem:

```
gemini> adk web says command not found, help me set up uv
gemini> I want to add requests to my project with uv
gemini> help me install httpx using uv
gemini> set up uv for my Python project
```

The skill will guide you through every step and run the right commands for you.

## What the skill does

1. Checks whether `uv` is already installed, installs it if missing
2. Checks whether the project already has a `pyproject.toml`
3. Runs `uv init --no-package` if the project is not yet initialised
4. Adds the required package with `uv add <package>`
5. Verifies the setup is correct before handing off to you

## After setup, always use

```bash
uv run <command>          # instead of: <command>
uv run python script.py   # instead of: python script.py
uv add <package>          # to add new dependencies
```

## Requirements

- [Gemini CLI](https://github.com/google-gemini/gemini-cli)
- macOS, Linux, or Windows (WSL)
- No Python pre-install required — uv handles everything
