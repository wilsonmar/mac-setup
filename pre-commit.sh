#!/usr/bin/env bash

# gxp "v006 + safety scan can't register :pre-commit.sh"

# This is from https://github.com/wilsonmar/mac-setup/blob/main/pre-commit.sh
# Explained at https://wilsonmar.github.io/python-scans
# to scan only files which have been git commit applied.

# At your repo's folder (where its .git is listed):
# Copy this file to your repo's .git/hooks/pre-commit  # file name without an extension
# git clone https://github.com/wilsonmar/known-bad
# cd known-bad
# # From https://github.com/wilsonmar/mac-setup/blob/main/pre-commit.sh
# cp ../mac-setup/pre-commit.sh .
# cp pre-commit.sh .git/hooks/pre-commit
# ls -al .git/hooks/pre-commit
# chmod +x .git/hooks/pre-commit
# # Create condition in error:
# echo "\n#" >> temp1.py
# git add temp1.py;git commit -m"test temp1.py"

echo "Running pre-commit.sh from .git/hooks/pre-commit"

START=$(date +%s)
#START=$(date +%s%3N)  # for millisecond precision
echo_run_stats() {
   #END=$(date +%s%3N)
   END=$(date +%s)
   DURATION=$((END - START))
   echo -e "\nElapsed Time: $DURATION seconds"
   exit 1
}
trap 'echo_run_stats' ERR
set -eo pipefail

# Install the latest: 
# if ! command -v flake8 >/dev/null; then  # command not found, so:
# brew install ggshield

#brew install safety
#safety scan
#if [ $? -ne 0 ]; then
#    echo "Safety scan found vulnerabilities found. Commit aborted."
#    exit 1
#fi

# Find all staged Python files:
CHANGED_FILES=$(git diff --name-only --cached --diff-filter=ACMR)
PY_FILES=$(echo "$CHANGED_FILES" | grep '\.py$' || true)
if [[ -n "$PY_FILES" ]]; then
   # black --check $PY_FILES
   brew install ruff  # instead of flake8 & black
   echo "ruff check $PY_FILES"
   ruff check $PY_FILES   # instead of . for all files
   if [ $? -ne 0 ]; then
      echo "Ruff found vulnerabilities. Commit aborted."
      exit 1
   fi

   #brew install bandit
   ## instead of . for all files, including transitive dependencies:
   #bandit -r $PY_FILES
   #if [ $? -ne 0 ]; then
   #   echo "Bandit found vulnerabilities. Commit aborted."
   #   exit 1
   #fi
fi

# brew install snyk-cli

echo_run_stats
