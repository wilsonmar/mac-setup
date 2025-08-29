#!/usr/bin/env bash

# git commit -m"v001 + new :git-commit.sh"

# This is from https://github.com/wilsonmar/mac-setup/blob/main/git-commit.sh
# to scan only files which have been git commit applied.
# Copy this file to your repo's .git/hooks/git-commit  # file name without an extension
# or put in git-commit:
#     source ../../git-commit.sh

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
