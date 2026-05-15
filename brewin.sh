#!/usr/bin/env bash
# This is brewin.sh from https://github.com/wilsonmar/mac-setup/blob/main/brewin.sh
# It wraps `brew install` to capture and save Homebrew-downloaded bottle files locally.
# Techniques for shell scripting used here are explained at https://wilsonmar.github.io/shell-scripts
# This was created entirely by Warp.CLI Oz without human editing.
#
# HOW IT WORKS:
#   1. Snapshots $(brew --cache)/downloads/ before any download.
#   2. Runs `brew fetch <pkg>` to pull the bottle into Homebrew's cache.
#   3. Diffs the cache (before vs. after) to identify newly downloaded files.
#      Both the bottle tarball (*.bottle.tar.gz) and manifest JSON are captured.
#   4. Copies new files to SAVE_DIR (default: ~/brewin).
#   5. Runs `brew install` unless -fetch (download-only) is set.
#
# USAGE:
#   chmod +x brewin.sh                         # (one-time) make executable
#   ./brewin.sh                                # show help menu
#   ./brewin.sh -usage                         # show extended usage examples
#   ./brewin.sh wget                           # fetch + install wget, save bottle
#   ./brewin.sh -pkg wget -v                   # same, verbose
#   ./brewin.sh -pkg wget -fetch               # download only, do not install
#   ./brewin.sh -pkg wget -deps                # include dependency bottles
#   ./brewin.sh -savedir "/tmp/bottles" -pkg wget
#   ./brewin.sh -list                          # list previously saved bottles
#   ./brewin.sh -list -savedir ~/my-bottles    # list from a custom directory
#
# EXIT CODES:
#   0  success
#   1  fatal error (missing brew, bad args, fetch failure, mkdir failure, copy failure)
#
# shellcheck disable=SC2155  # Declare and assign separately to avoid masking return values.

SCRIPT_VERSION="v1.1 :brewin.sh"


### 01. Capture timestamps

EPOCH_START="$( date -u +%s )"
THIS_PROGRAM="${0##*/}"


### 02. Help / usage

args_prompt() {
   echo "OPTIONS: ${SCRIPT_VERSION}"
   echo "   -h              show this help menu"
   echo "   -usage          show extended usage examples"
   echo "   -cont           continue (NOT stop) on error"
   echo "   -v              verbose output"
   echo "   -vv             very verbose / debug"
   echo "   -x              set -x to trace every command"
   echo "   -q              quiet (suppress section headings)"
   echo " "
   echo "   -pkg \"wget\"     package name to fetch/install (or supply as positional arg)"
   echo "   -savedir \"path\" folder to save downloaded bottles (default: ~/brewin)"
   echo "   -fetch          download only — do NOT install"
   echo "   -deps           also fetch/save dependency bottles"
   echo "   -list           list bottles already saved in savedir, then exit"
   echo " "
   echo "USAGE EXAMPLES:"
   echo "  ./brewin.sh wget"
   echo "./brewin.sh -pkg wget -savedir ~/offline-bottles -v  # custom dir"
   echo "  ./brewin.sh -pkg wget -fetch          # download only"
   echo "  ./brewin.sh -pkg wget -deps -v        # include deps"
   echo "  ./brewin.sh -list                     # show saved bottles"
   echo "  ./brewin.sh -usage                    # show extended examples"
}

### 02b. Extended usage examples
# Pattern matches usage_examples() in mac-setup.sh

usage_examples() {
   echo "EXTENDED USAGE EXAMPLES: ${SCRIPT_VERSION}"
   echo " "
   echo "# --- Basic install & save ---"
   echo "./brewin.sh wget                          # fetch+install wget; save bottle to ~/brewin"
   echo "./brewin.sh -pkg wget -v                  # same with verbose output"
   echo "./brewin.sh -pkg wget -q                  # same, quiet (no section headings)"
   echo " "
   echo "# --- Custom save directory ---"
   echo "./brewin.sh -pkg wget -savedir ~/offline-bottles"
   echo "./brewin.sh -pkg wget -savedir /Volumes/USB-Drive/brew-cache   # save to USB for offline use"
   echo " "
   echo "# --- Download only (no install) ---"
   echo "./brewin.sh -pkg wget -fetch              # download bottle, skip install"
   echo "./brewin.sh -pkg wget -fetch -deps        # download wget + all dependencies"
   echo " "
   echo "# --- Multiple packages (run in a loop) ---"
   echo "for pkg in wget jq httpie; do"
   echo "  ./brewin.sh -pkg \"\$pkg\" -savedir ~/offline-bottles -v"
   echo "done"
   echo " "
   echo "# --- Inspect saved bottles ---"
   echo "./brewin.sh -list                         # list bottles in ~/brewin"
   echo "./brewin.sh -list -savedir ~/offline-bottles"
   echo " "
   echo "# --- Force re-download of an already-cached bottle ---"
   echo "brew fetch --force wget && ./brewin.sh -pkg wget -v"
   echo " "
   echo "# --- Trace / debug ---"
   echo "./brewin.sh -pkg wget -vv                 # verbose + debug output"
   echo "./brewin.sh -pkg wget -x                  # trace every shell command (set -x)"
   echo "./brewin.sh -pkg wget -cont -v            # continue even if a step fails"
}


### 03. Default feature-flag variables

CONTINUE_ON_ERR=false   # -cont
RUN_VERBOSE=false       # -v
RUN_DEBUG=false         # -vv
SET_TRACE=false         # -x
RUN_QUIET=false         # -q
FETCH_ONLY=false        # -fetch
INCLUDE_DEPS=false      # -deps
LIST_SAVED=false        # -list
PACKAGE_NAME=""         # -pkg or positional
SAVE_DIR="${HOME}/brewin"   # -savedir


### 04. Color-coded output helpers
# See https://wilsonmar.github.io/mac-setup/#TextColors

h2() {
   if [ "${RUN_QUIET}" = false ]; then
      printf "\n\e[1m\e[33m\u2665 %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
   fi
}
info() {
   printf "\e[2m\n➜ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
note() {
   if [ "${RUN_VERBOSE}" = true ]; then
      printf "\n\e[1m\e[36m \e[0m \e[36m%s\e[0m" "$(echo "$@" | sed '/./,$!d')"
      printf "\n"
   fi
}
success() {
   printf "\n\e[32m\e[1m✔ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
error() {
   printf "\n\e[31m\e[1m✖ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
warning() {
   printf "\n\e[5m\e[36m\e[1m☞ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
fatal() {
   printf "\n\e[31m\e[1m☢  %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
   exit 1
}


### 05. Parse CLI arguments

if [ $# -eq 0 ]; then
   args_prompt
   exit 0
fi

while test $# -gt 0; do
   case "$1" in
      -cont)
         export CONTINUE_ON_ERR=true
         shift
         ;;
      -deps)
         export INCLUDE_DEPS=true
         shift
         ;;
      -fetch)
         export FETCH_ONLY=true
         shift
         ;;
      -h)
         args_prompt
         exit 0
         ;;
      -usage)
         usage_examples
         exit 0
         ;;
      -list)
         export LIST_SAVED=true
         shift
         ;;
      -pkg)
         shift
         # Guard: value must be present and must not itself be a flag
         if [ -z "$1" ] || [[ "$1" == -* ]]; then
            fatal "-pkg requires a package name. Got: \"${1:-<empty>}\". Example: -pkg wget"
         fi
         PACKAGE_NAME="$( echo "$1" | sed -e 's/^[^=]*=//g' )"
         shift
         ;;
      -savedir)
         shift
         SAVE_DIR="$( echo "$1" | sed -e 's/^[^=]*=//g' )"
         shift
         ;;
      -q)
         export RUN_QUIET=true
         shift
         ;;
      -vv)
         export RUN_DEBUG=true
         export RUN_VERBOSE=true
         shift
         ;;
      -v)
         export RUN_VERBOSE=true
         shift
         ;;
      -x)
         export SET_TRACE=true
         shift
         ;;
      -*)
         fatal "Parameter \"$1\" not recognized. Run ${THIS_PROGRAM} -h for help."
         ;;
      *)
         # Accept package name as a plain positional argument
         if [ -z "${PACKAGE_NAME}" ]; then
            PACKAGE_NAME="$1"
         else
            fatal "Unexpected argument \"$1\". Package already set to \"${PACKAGE_NAME}\"."
         fi
         shift
         ;;
   esac
done


### 06. Strict-mode / trace

if [ "${CONTINUE_ON_ERR}" = true ]; then
   warning "Continuing despite errors ..."
else
   set -e
fi
if [ "${SET_TRACE}" = true ]; then
   set -x
fi


### 06b. Trap handler — fires on any unexpected exit
# Prints elapsed time and a hint so the user knows where to look.
# EXIT covers normal exit, ERR (when set -e fires), and manual kill signals.

_brewin_trap_exit() {
   local exit_code=$?
   local epoch_now
   epoch_now="$( date -u +%s )"
   local elapsed=$(( epoch_now - EPOCH_START ))
   if [ "${exit_code}" -ne 0 ]; then
      printf "\n\e[31m\e[1m☢  brewin.sh exited with code %s after %s seconds.\e[0m\n" \
         "${exit_code}" "${elapsed}" >&2
      printf "\e[2m   Re-run with -v or -x for more detail. Use -cont to keep going despite errors.\e[0m\n" >&2
   fi
}
trap '_brewin_trap_exit' EXIT
trap 'fatal "Interrupted (SIGINT). Partial downloads may remain in $(brew --cache)/downloads/"' INT
trap 'fatal "Terminated (SIGTERM)."' TERM


### 07. Handle -list mode early (no package required)

if [ "${LIST_SAVED}" = true ]; then
   if [ ! -d "${SAVE_DIR}" ]; then
      warning "Save directory does not exist yet: ${SAVE_DIR}"
      exit 0
   fi
   h2 "Bottles saved in ${SAVE_DIR}"
   # List with human-readable sizes; fall back gracefully if empty
   if [ -z "$( ls -A "${SAVE_DIR}" 2>/dev/null )" ]; then
      info "No bottles found in ${SAVE_DIR}"
   else
      ls -lh "${SAVE_DIR}"
   fi
   exit 0
fi


### 08. Validate required inputs

if [ -z "${PACKAGE_NAME}" ]; then
   error "No package name supplied."
   args_prompt
   exit 1
fi


### 09. Verify Homebrew is installed

if ! command -v brew >/dev/null 2>&1; then
   fatal "brew not found. Install Homebrew first: https://brew.sh"
fi
note "$( brew --version )"


### 10. Detect OS and cache directory

OS_TYPE="$( uname )"
if [ "${OS_TYPE}" = "Darwin" ]; then
   BREW_CACHE_DOWNLOADS="$( brew --cache )/downloads"
else
   # Linux (Homebrew / Linuxbrew)
   BREW_CACHE_DOWNLOADS="${HOME}/.cache/Homebrew/downloads"
fi
note "Homebrew download cache: ${BREW_CACHE_DOWNLOADS}"

if [ ! -d "${BREW_CACHE_DOWNLOADS}" ]; then
   # Cache dir may not exist yet on a fresh Homebrew install — that is fine.
   warning "Cache directory not found yet: ${BREW_CACHE_DOWNLOADS}"
fi


### 11. Create save directory

if [ ! -d "${SAVE_DIR}" ]; then
   h2 "Creating save directory: ${SAVE_DIR}"
   if ! mkdir -p "${SAVE_DIR}" 2>/dev/null; then
      fatal "Cannot create save directory: ${SAVE_DIR}  (check permissions)"
   fi
fi

# Verify the directory is writable before attempting any copy
if [ ! -w "${SAVE_DIR}" ]; then
   fatal "Save directory is not writable: ${SAVE_DIR}  (check permissions)"
fi
note "Bottles will be saved to: ${SAVE_DIR}"

# Pre-flight: warn if less than 500 MB free on the save-dir volume
# (bottles can be 30–300 MB each; dependencies can multiply that)
FREE_KB="$( df -k "${SAVE_DIR}" 2>/dev/null | awk 'NR==2 {print $4}' )"
if [ -n "${FREE_KB}" ] && [ "${FREE_KB}" -lt 512000 ]; then
   warning "Low disk space on ${SAVE_DIR}: only $(( FREE_KB / 1024 )) MB free."
   info    "Proceeding anyway — use -cont if you want to suppress this as a fatal error."
else
   note "Disk space available: $(( ${FREE_KB:-0} / 1024 )) MB"
fi


### 12. Snapshot cache contents before download

# Use sorted file listing so comm can compare correctly.
BEFORE_MANIFEST="$( ls -1 "${BREW_CACHE_DOWNLOADS}" 2>/dev/null | sort )"
note "Files in cache before fetch: $( echo "${BEFORE_MANIFEST}" | wc -l | tr -d ' ' )"


### 13. Fetch (download) the bottle(s) via brew fetch

FETCH_FLAGS=""
if [ "${INCLUDE_DEPS}" = true ]; then
   FETCH_FLAGS="--deps"
fi

h2 "Fetching bottle(s) for: ${PACKAGE_NAME} ..."
# brew fetch downloads the bottle to the cache without installing.
# shellcheck disable=SC2086  # FETCH_FLAGS intentionally unquoted for word-splitting
if ! brew fetch ${FETCH_FLAGS} "${PACKAGE_NAME}"; then
   fatal "brew fetch failed for package: ${PACKAGE_NAME}"
fi


### 14. Identify newly downloaded files

AFTER_MANIFEST="$( ls -1 "${BREW_CACHE_DOWNLOADS}" 2>/dev/null | sort )"
note "Files in cache after fetch: $( echo "${AFTER_MANIFEST}" | wc -l | tr -d ' ' )"

# comm -13 suppresses lines only in file1 (before) and lines common to both,
# yielding only files that appeared after the fetch.
# Filter out *.incomplete — these are partial downloads interrupted mid-stream
# and should not be copied (they would produce a corrupt saved file).
# grep -v exits 1 when no lines pass the filter (empty input = no new files).
# The '|| true' prevents set -e from treating that as a failure.
NEW_FILES="$( comm -13 <( echo "${BEFORE_MANIFEST}" ) <( echo "${AFTER_MANIFEST}" ) \
   | grep -v '\.incomplete$' || true )"

if [ -z "${NEW_FILES}" ]; then
   warning "No new files detected in the Homebrew cache."
   info    "The bottle for \"${PACKAGE_NAME}\" may have already been cached."
   info    "Previously cached bottles are not re-copied to avoid duplicates."
   info    "To force a re-copy, run:  brew fetch --force ${PACKAGE_NAME}"
else
   note "New files detected:"
   echo "${NEW_FILES}" | while IFS= read -r fname; do
      note "  ${fname}"
   done
fi


### 15. Copy new files to the save directory

COPY_COUNT=0
if [ -n "${NEW_FILES}" ]; then
   h2 "Copying downloaded bottle(s) to ${SAVE_DIR} ..."
   while IFS= read -r fname; do
      [ -z "${fname}" ] && continue
      src="${BREW_CACHE_DOWNLOADS}/${fname}"
      dst="${SAVE_DIR}/${fname}"
      if [ ! -f "${src}" ]; then
         warning "Source file not found, skipping: ${src}"
         continue
      fi
      if [ -f "${dst}" ]; then
         note "Already exists in save dir, skipping: ${fname}"
         continue
      fi
      if ! cp "${src}" "${dst}" 2>/dev/null; then
         error "Copy failed: ${src} → ${dst}"
         error "Check available disk space and write permissions on ${SAVE_DIR}"
         # Purge any partial destination file to avoid a corrupt saved bottle
         rm -f "${dst}" 2>/dev/null || true
         if [ "${CONTINUE_ON_ERR}" = true ]; then
            continue
         else
            fatal "Aborting due to copy failure. Re-run with -cont to skip failed files."
         fi
      fi
      # Verify the copy is not truncated: sizes must match
      src_size="$( wc -c < "${src}" 2>/dev/null | tr -d ' ' )"
      dst_size="$( wc -c < "${dst}" 2>/dev/null | tr -d ' ' )"
      if [ "${src_size}" != "${dst_size}" ]; then
         error "Size mismatch after copy (src=${src_size}B dst=${dst_size}B): ${fname}"
         rm -f "${dst}" 2>/dev/null || true
         if [ "${CONTINUE_ON_ERR}" = true ]; then
            continue
         else
            fatal "Aborting due to copy verification failure."
         fi
      fi
      FILE_SIZE="$( du -sh "${dst}" 2>/dev/null | cut -f1 )"
      success "Saved (${FILE_SIZE}): ${dst}"
      COPY_COUNT=$(( COPY_COUNT + 1 ))
   done <<< "${NEW_FILES}"
fi

if [ "${COPY_COUNT}" -eq 0 ] && [ -z "${NEW_FILES}" ]; then
   info "Nothing new to save."
elif [ "${COPY_COUNT}" -gt 0 ]; then
   success "${COPY_COUNT} file(s) saved to ${SAVE_DIR}"
fi


### 16. Install (unless -fetch only)

if [ "${FETCH_ONLY}" = true ]; then
   info "Skipping install (-fetch flag set). Package downloaded only."
else
   h2 "Installing ${PACKAGE_NAME} ..."
   brew install "${PACKAGE_NAME}"
   success "${PACKAGE_NAME} installed."
fi


### 17. Summary

EPOCH_END="$( date -u +%s )"
ELAPSED=$(( EPOCH_END - EPOCH_START ))
note "Elapsed time: ${ELAPSED} seconds"

h2 "Done. Saved bottles are in: ${SAVE_DIR}"
ls -lh "${SAVE_DIR}" 2>/dev/null || true
