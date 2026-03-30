# uv-setup-ext

A Gemini CLI extension that sets up [uv](https://docs.astral.sh/uv/) for
your ADK project — so that `adk web` and all ADK commands work correctly
without "command not found" errors.

## The problem this solves

When you install `google-adk` with pip inside a virtual environment, the
`adk` command is only available inside that environment. If you run
`adk web` from a plain terminal it says "command not found".

`uv` solves this cleanly: it manages your virtual environment automatically
and `uv run adk web` always finds the right `adk`, no matter where you are.

## Install

```bash
gemini extensions install https://github.com/YOUR_USERNAME/uv-setup-ext
```

## Usage

Start Gemini CLI in your project folder and just describe the problem:

```
gemini> adk web says command not found, help me set up uv
gemini> I want to set up uv for my ADK project
gemini> help me install google-adk with uv
```

The skill will guide you through every step and run the right commands for you.

## What the skill does

- Checks whether `uv` is already installed
- Installs `uv` if missing (one command, no admin rights needed)
- Initialises a `uv` project in your agent folder (`pyproject.toml`)
- Adds `google-adk` as a dependency with `uv add`
- Replaces bare `adk` commands with `uv run adk` so they always work
- Verifies the setup is correct before handing off to you

## After setup, always use

```bash
uv run adk web          # instead of: adk web
uv run adk run <folder> # instead of: adk run <folder>
```

## Requirements

- [Gemini CLI](https://github.com/google-gemini/gemini-cli)
- macOS, Linux, or Windows (WSL)
- No Python pre-install required — uv handles everything
