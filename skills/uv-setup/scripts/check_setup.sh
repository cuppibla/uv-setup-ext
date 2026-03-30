#!/bin/bash
# check_setup.sh
# Run this to verify that uv and ADK are correctly set up.
# Usage: bash .gemini/skills/uv-setup/scripts/check_setup.sh

set -e

PASS="\033[0;32m✓\033[0m"
FAIL="\033[0;31m✗\033[0m"
WARN="\033[0;33m!\033[0m"
errors=0

echo ""
echo "=== ADK + uv Setup Check ==="
echo ""

# 1. Check uv
if command -v uv &>/dev/null; then
    UV_VER=$(uv --version 2>&1)
    echo -e "$PASS uv is installed: $UV_VER"
else
    echo -e "$FAIL uv is NOT installed."
    echo "   Fix: curl -LsSf https://astral.sh/uv/install.sh | sh"
    errors=$((errors + 1))
fi

# 2. Check pyproject.toml
if [ -f "pyproject.toml" ]; then
    echo -e "$PASS pyproject.toml found"
else
    echo -e "$FAIL pyproject.toml not found in current directory."
    echo "   Fix: run 'uv init --no-package' from the project root"
    errors=$((errors + 1))
fi

# 3. Check google-adk in dependencies
if [ -f "pyproject.toml" ] && grep -q "google-adk" pyproject.toml; then
    echo -e "$PASS google-adk is listed in pyproject.toml"
else
    echo -e "$FAIL google-adk not found in pyproject.toml"
    echo "   Fix: run 'uv add google-adk'"
    errors=$((errors + 1))
fi

# 4. Check .venv exists
if [ -d ".venv" ]; then
    echo -e "$PASS .venv directory exists"
else
    echo -e "$WARN .venv not found — will be created on first 'uv run'"
fi

# 5. Check adk available via uv run
if command -v uv &>/dev/null; then
    if uv run adk --version &>/dev/null 2>&1; then
        ADK_VER=$(uv run adk --version 2>&1)
        echo -e "$PASS adk is available via uv run: $ADK_VER"
    else
        echo -e "$FAIL 'uv run adk --version' failed."
        echo "   Fix: run 'uv add google-adk' then try again"
        errors=$((errors + 1))
    fi
fi

# 6. Check Python version
if command -v uv &>/dev/null; then
    PY_VER=$(uv run python --version 2>&1)
    MAJOR=$(uv run python -c "import sys; print(sys.version_info.major)")
    MINOR=$(uv run python -c "import sys; print(sys.version_info.minor)")
    if [ "$MAJOR" -ge 3 ] && [ "$MINOR" -ge 11 ]; then
        echo -e "$PASS Python version OK: $PY_VER"
    else
        echo -e "$FAIL Python $PY_VER is too old. ADK requires 3.11+."
        echo "   Fix: run 'uv python install 3.11' then 'uv sync'"
        errors=$((errors + 1))
    fi
fi

echo ""
if [ $errors -eq 0 ]; then
    echo -e "$PASS All checks passed! Run: uv run adk web"
else
    echo -e "$FAIL $errors issue(s) found. Fix the errors above and re-run this script."
fi
echo ""
