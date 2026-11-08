#!/usr/bin/env bash
# "v001 new @macos-ios-mvt.sh"
# Based on https://share.gemini.google/SekgDd2QXgIu 26-11-07

set -euo pipefail

# --- Configuration & Defaults ---
OS_TYPE="$(uname -s)"
OUTPUT_DIR="./mvt_results_$(date +%Y%m%d_%H%M%S)"
DECRYPTED_DIR="./mvt_decrypted_backup"
IOC_FILE="$HOME/indicators.stix2"

echo "=== Amnesty MVT Automated Runner ==="

# --- Step 1: Verify / Install Prerequisites ---
echo "[*] Checking environment..."

if ! command -v python3 &>/dev/null; then
    echo "[-] Error: python3 is required. Please install Python 3.10+ first."
    exit 1
fi

if ! command -v pipx &>/dev/null; then
    echo "[!] pipx not detected. Attempting installation..."
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        if ! command -v brew &>/dev/null; then
            echo "[-] Error: Homebrew is required on macOS to install dependencies automatically."
            exit 1
        fi
        brew install pipx libusb sqlite3
    elif [[ "$OS_TYPE" == "Linux" ]]; then
        sudo apt-get update && sudo apt-get install -y pipx python3-dev libusb-1.0-0-dev sqlite3
    else
        echo "[-] Unsupported operating system: $OS_TYPE"
        exit 1
    fi
    pipx ensurepath
    export PATH="$PATH:$HOME/.local/bin"
fi

# --- Step 2: Install or Upgrade MVT ---
if ! command -v mvt-ios &>/dev/null; then
    echo "[*] Installing MVT via pipx..."
    pipx install mvt
    export PATH="$PATH:$HOME/.local/bin"
else
    echo "[*] MVT is already installed. Ensuring it is up to date..."
    pipx upgrade mvt || true
fi

# --- Step 3: Fetch Indicators of Compromise (IOCs) ---
echo "[*] Downloading latest IOCs (STIX2 signatures)..."
mvt-ios download-iocs

# Locate the downloaded STIX2 file if not in home root
if [[ ! -f "$IOC_FILE" ]]; then
    IOC_FILE=$(find "$HOME" -maxdepth 2 -name "*.stix2" 2>/dev/null | head -n 1 || echo "")
fi

# --- Step 4: Locate iOS Backup ---
BACKUP_PATH=""
if [[ "$OS_TYPE" == "Darwin" ]]; then
    DEFAULT_MAC_BACKUP_ROOT="$HOME/Library/Application Support/MobileSync/Backup"
    if [[ -d "$DEFAULT_MAC_BACKUP_ROOT" ]]; then
        # Pick the most recently modified backup folder
        LATEST_BACKUP=$(ls -td "$DEFAULT_MAC_BACKUP_ROOT"/*/ 2>/dev/null | head -n 1 || true)
        if [[ -n "$LATEST_BACKUP" ]]; then
            read -r -p "[?] Found backup at: $LATEST_BACKUP. Use this? (Y/n): " CONFIRM
            if [[ "$CONFIRM" =~ ^[Nn] ]]; then
                read -r -p "[?] Enter full path to encrypted iOS backup folder: " BACKUP_PATH
            else
                BACKUP_PATH="$LATEST_BACKUP"
            fi
        fi
    fi
fi

if [[ -z "$BACKUP_PATH" ]]; then
    read -r -p "[?] Enter full path to encrypted iOS backup folder: " BACKUP_PATH
fi

if [[ ! -d "$BACKUP_PATH" ]]; then
    echo "[-] Error: Directory does not exist: $BACKUP_PATH"
    exit 1
fi

# --- Step 5: Decrypt Backup ---
read -r -s -p "[?] Enter your iOS backup password: " BACKUP_PASS
echo ""

mkdir -p "$DECRYPTED_DIR"
echo "[*] Decrypting backup to $DECRYPTED_DIR..."
mvt-ios decrypt-backup -p "$BACKUP_PASS" -d "$DECRYPTED_DIR" "$BACKUP_PATH"

# Clear sensitive password from environment
unset BACKUP_PASS

# --- Step 6: Scan Backup ---
mkdir -p "$OUTPUT_DIR"
echo "[*] Running MVT analysis against IOCs..."

IOC_FLAG=""
if [[ -n "$IOC_FILE" && -f "$IOC_FILE" ]]; then
    IOC_FLAG="--iocs $IOC_FILE"
fi

mvt-ios check-backup $IOC_FLAG --output "$OUTPUT_DIR" "$DECRYPTED_DIR"

echo "=== Analysis Complete ==="
echo "[+] Reports saved to: $OUTPUT_DIR"
echo "[+] Detected items (if any):"
find "$OUTPUT_DIR" -type f -name "*_detected.json" -exec ls -lh {} +

read -r -p "[?] Do you want to securely remove the unencrypted decrypted backup folder now? (Y/n): " CLEANUP
if [[ ! "$CLEANUP" =~ ^[Nn] ]]; then
    rm -rf "$DECRYPTED_DIR"
    echo "[+] Cleaned up decrypted cache."
fi