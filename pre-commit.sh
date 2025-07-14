#!/usr/bin/env bash

# gxp "v002 rm exit :pre-commit.sh"

# This is from https://github.com/wilsonmar/mac-setup/blob/main/pre-commit.sh
# to scan only files which have been git commit applied.

# At your repo's folder (where its .git is listed):
# Copy this file to your repo's .git/hooks/pre-commit  # file name without an extension
# cp pre-commit.sh .git/hooks/pre-commit
# chmod +x .git/hooks/pre-commit
# echo "\n#" >> temp1.py
# git add temp1.py;git commit -m"test temp1.py"

echo "Running pre-commit.sh from .git/hooks/pre-commit"

set -eo pipefail

# Install the latest: 
# if ! command -v flake8 >/dev/null; then  # command not found, so:
# brew install ggshield

brew install safety
safety check
if [ $? -ne 0 ]; then
    echo "Safety found vulnerabilities found. Commit aborted."
    exit 1
fi

# Find all staged Python files:
CHANGED_FILES=$(git diff --name-only --cached --diff-filter=ACMR)
PY_FILES=$(echo "$CHANGED_FILES" | grep '\.py$' || true)
if [[ -n "$PY_FILES" ]]; then
   # black --check $PY_FILES
   brew install ruff  # instead of flake8 & black
   ruff check $PY_FILES   # instead of . for all files
fi
if [ $? -ne 0 ]; then
   echo "Ruff found vulnerabilities. Commit aborted."
   exit 1
fi

brew install bandit
# instead of . for all files, including transitive dependencies:
bandit -r $PY_FILES
if [ $? -ne 0 ]; then
    echo "Bandit found vulnerabilities. Commit aborted."
    exit 1
fi

# brew install snyk-cli
