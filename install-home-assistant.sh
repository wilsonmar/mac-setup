#!/bin/bash
# install-home-assistant.sh within https://github.com/wilsonmar/mac-setup
# lastchange: "v002 + auto-install xcode, brew, python, uv @install-home-assistant.sh"
# Based on https://www.perplexity.ai/search/645b66bd-53ba-45b6-b055-d5674b19c5cb

# 2. This is a Bash script for running on Apple Silicon Mac.
# Your Mac running macOS
# └── UTM — manages the virtual machine (https://github.com/utmapp/UTM)
#     └── Home Assistant OS — runs inside the VM
#         └── Home Assistant — manages your smart-home devices
        
# This downloads UTM and opens UTM. see https://docs.getutm.app/scripting/reference/
# This use UTM to create a Home Assistant OS VM (https://www.home-assistant.io/installation/macos/)
# This installs a background watchdog to keep the VM running continously while you’re logged in. 

# Continuous here means while your macOS account is logged in. 
# It restarts the VM after login or if the VM stops, but it 
# cannot run through shutdown, logout, or the FileVault unlock screen after a reboot.
# A user LaunchAgent runs within your login session.
# See https://github.com/aaronfagan/macos-launchd for cron & misc.plist
# The script uses UTM’s documented disk-import, bridged-interface, VM-status, and start/resume capabilities. 
# It reuses an existing VM named Home Assistant rather than replacing it.
# TO RUN this:
#    chmod +x install-home-assistant.sh
#    ./install-home-assistant.sh

#### SECTION 01 - Preflight

set -euo pipefail
umask 077

VM_NAME="Home Assistant"
RAM_MB=4096
CPU_COUNT=2

LABEL="local.homeassistant.utm"
STATE="$HOME/Library/Application Support/HomeAssistantUTM"
AGENT="$HOME/Library/LaunchAgents/$LABEL.plist"
LOG_DIR="$HOME/Library/Logs/HomeAssistantUTM"

fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
log()  { printf '\n==> %s\n' "$*"; }

# POLICY: Stop running if being run on Linux or any os not macOS Silicon ARM.
[[ "$(uname -s)" == Darwin ]] || fail "This script requires macOS."
[[ "$(uname -m)" == arm64 ]] || fail "This script targets Apple Silicon."
[[ "$EUID" -ne 0 ]] || fail "Run as your normal user, not with sudo."

#### SECTION 02 - Toolchain bootstrap

if ! xcode-select -p >/dev/null 2>&1; then
    log "Installing Xcode Command Line Tools; accept the macOS dialog"
    xcode-select --install || true
    until xcode-select -p >/dev/null 2>&1; do
        sleep 10
    done
fi

# POLICY: Before using brew, ensure the utility is installed and install it if needed.
ensure_brew() {
    command -v brew >/dev/null && return
    log "Installing Homebrew"
    /bin/bash -c "$(/usr/bin/curl --fail --silent --show-error --location \
        https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
}

# POLICY: brew install if command -v does not find the module installed
PYTHON="$(command -v python3 || true)"
if [[ -z "$PYTHON" ]]; then
    ensure_brew
    log "Installing Python 3 with Homebrew"
    brew install python
    PYTHON="$(command -v python3 || true)"
    [[ -n "$PYTHON" ]] || fail "python3 still not found after brew install."
fi
# POLICY: After install, check and fail if module is not found.

if ! command -v uv >/dev/null; then
    ensure_brew
    log "Installing uv with Homebrew"
    brew install uv
    command -v uv >/dev/null || fail "uv still not found after brew install."
fi

#### SECTION 03 - Find default-route Network interface

# use BRIDGE_IF if you set it. Don't continue if there’s no interface or if the route goes through a VPN (utun*, tun*, tap*). 
# The VM uses a bridged network so it gets its own LAN address.

# Override when needed: BRIDGE_IF=en0 bash install-home-assistant.sh
BRIDGE_IF="${BRIDGE_IF:-$(/sbin/route -n get default 2>/dev/null |
    /usr/bin/awk '/interface:/ {print $2; exit}')}"

[[ -n "$BRIDGE_IF" ]] || fail "Cannot find an active network interface."
/sbin/ifconfig "$BRIDGE_IF" >/dev/null 2>&1 ||
    fail "Network interface does not exist: $BRIDGE_IF"

case "$BRIDGE_IF" in
    utun*|tun*|tap*)
        fail "Default route uses a VPN. Set BRIDGE_IF to your LAN interface."
        ;;
esac

#### SECTION 04 - Temp workspace and cleanup

# Create a temp directory and an exit trap that unmounts any disk image and deletes the directory. 
# The download helper is curl with retries and a timeout.

mkdir -p "$STATE" "$LOG_DIR" "$(dirname "$AGENT")"
WORK="$(mktemp -d)"
MOUNT=""

cleanup() {
    if [[ -n "$MOUNT" ]]; then
        /usr/bin/hdiutil detach "$MOUNT" >/dev/null 2>&1 || true
    fi
    rm -rf "$WORK"
}
trap cleanup EXIT

download() {
    /usr/bin/curl --fail --location --retry 3 \
        --connect-timeout 30 --output "$2" "$1"
}

#### SECTION 05 - Install UTM without Homebrew or disabling Gatekeeper.

# If GUI /Applications/UTM.app is missing, downloads the latest UTM.dmg from GitHub.
if [[ ! -d /Applications/UTM.app ]]; then
    log "Downloading UTM"
    download \
        "https://github.com/utmapp/UTM/releases/latest/download/UTM.dmg" \
        "$WORK/UTM.dmg"

    MOUNT="$WORK/utm-mount"
    mkdir -p "$MOUNT"
    /usr/bin/hdiutil attach "$WORK/UTM.dmg" \
        -nobrowse -readonly -mountpoint "$MOUNT" >/dev/null

    [[ -d "$MOUNT/UTM.app" ]] || fail "UTM.app not found in disk image."

    log "Checking UTM signature and Gatekeeper assessment"
    /usr/bin/codesign --verify --deep --strict "$MOUNT/UTM.app"
    /usr/sbin/spctl --assess --type execute "$MOUNT/UTM.app"

    log "Installing UTM in /Applications"
    if [[ -w /Applications ]]; then
        /usr/bin/ditto "$MOUNT/UTM.app" /Applications/UTM.app
    else
        sudo /usr/bin/ditto "$MOUNT/UTM.app" /Applications/UTM.app
    fi

    /usr/bin/hdiutil detach "$MOUNT" >/dev/null
    MOUNT=""
fi

#### SECTION 06 - Open UTM.app using AppleScript

log "Opening UTM; approve macOS automation/network prompts if requested"
# POLICY: Explicitly specify location of utility open to avoid fakes. 
/usr/bin/open /Applications/UTM.app

#### SECTION 07 - Reuse the existing VM with this name rather than overwrite its disk.

VM_ID="$(/usr/bin/osascript - "$VM_NAME" <<'APPLESCRIPT'
on run argv
    tell application "UTM"
        set matches to every virtual machine whose name is (item 1 of argv)
        if (count of matches) > 1 then
            error "Multiple VMs have this name. Rename duplicates first."
        end if
        if (count of matches) = 1 then
            return id of item 1 of matches
        end if
        return ""
    end tell
end run
APPLESCRIPT
)"

#### SECTION 08 - If none is running, fetch the latest Home Assistant OS release metadata from GitHub 

# Pick the generic ARM64 .qcow2.xz image and download it.
# Check the image file's SHA-256 digest when one is published, and unpacks it with Python.
if [[ -z "$VM_ID" ]]; then
    log "Finding the latest stable Home Assistant OS ARM64 image"
    download \
        "https://api.github.com/repos/home-assistant/operating-system/releases/latest" \
        "$WORK/release.json"

    "$PYTHON" - "$WORK/release.json" "$WORK/asset.txt" <<'PY'
import json, sys
from pathlib import Path

release = json.loads(Path(sys.argv[1]).read_text())
assets = [
    a for a in release["assets"]
    if a["name"].startswith("haos_generic-aarch64-")
    and a["name"].endswith(".qcow2.xz")
]
if len(assets) != 1:
    raise SystemExit("Expected exactly one generic ARM64 QCOW2 image.")
asset = assets[0]
Path(sys.argv[2]).write_text(
    asset["browser_download_url"] + "\n" +
    (asset.get("digest") or "") + "\n"
)
PY

    IMAGE_URL="$(sed -n '1p' "$WORK/asset.txt")"
    DIGEST="$(sed -n '2p' "$WORK/asset.txt")"

    log "Downloading Home Assistant OS"
    download "$IMAGE_URL" "$WORK/haos.qcow2.xz"

    if [[ "$DIGEST" == sha256:* ]]; then
        ACTUAL="$(/usr/bin/shasum -a 256 "$WORK/haos.qcow2.xz" |
            /usr/bin/awk '{print $1}')"
        [[ "$ACTUAL" == "${DIGEST#sha256:}" ]] ||
            fail "Home Assistant image checksum mismatch."
    else
        printf 'Warning: release metadata supplied no SHA-256 digest.\n' >&2
    fi

    log "Extracting the disk image"
    "$PYTHON" - "$WORK/haos.qcow2.xz" "$WORK/haos.qcow2" <<'PY'
import lzma, shutil, sys
with lzma.open(sys.argv[1], "rb") as src, open(sys.argv[2], "wb") as dst:
    shutil.copyfileobj(src, dst)
PY

    log "Creating VM using bridged interface: $BRIDGE_IF"
    VM_ID="$(/usr/bin/osascript - \
        "$VM_NAME" "$WORK/haos.qcow2" "$BRIDGE_IF" \
        "$RAM_MB" "$CPU_COUNT" <<'APPLESCRIPT'
on run argv
    set vmName to item 1 of argv
    set diskFile to POSIX file (item 2 of argv)
    set bridgeName to item 3 of argv
    set ramSize to (item 4 of argv) as integer
    set cores to (item 5 of argv) as integer

    with timeout of 1800 seconds
        tell application "UTM"
            set vmConfig to {name:vmName, architecture:"aarch64", ¬
                machine:"virt", memory:ramSize, cpu cores:cores, ¬
                hypervisor:true, uefi:true, ¬
                drives:{{removable:false, interface:VirtIO, source:diskFile}}, ¬
                network interfaces:{{hardware:"virtio-net-pci", ¬
                    mode:bridged, host interface:bridgeName}}, ¬
                displays:{{hardware:"virtio-gpu-pci"}}}
            set newVM to make new virtual machine with properties ¬
                {backend:qemu, configuration:vmConfig}
            return id of newVM
        end tell
    end timeout
end run
APPLESCRIPT
)"
else
    log "Reusing existing VM: $VM_ID (configuration unchanged)"
fi

printf '%s\n' "$VM_ID" > "$STATE/vm-id"

# Check only the VM state; do not reboot a VM merely because HTTP is slow.
cat > "$STATE/ensure-running.applescript" <<'APPLESCRIPT'
on run argv
    with timeout of 120 seconds
        tell application "UTM"
            set auto terminate to false
            set vm to virtual machine id (item 1 of argv)
            if status of vm is stopped or status of vm is paused then
                start vm
            end if
        end tell
    end timeout
end run
APPLESCRIPT

#### SECTION 09 - Define watchdog.sh AppleScript to caffeinate every 30 seconds so the Mac stays awake.

# NOTE: /usr/bin/caffeinate is a built-in macOS tool shipped with every macOS install, so it needs no Homebrew or Xcode step.
cat > "$STATE/watchdog.sh" <<'BASH'
#!/bin/bash
set -u
STATE="$(cd "$(dirname "$0")" && pwd)"
VM_ID="$(cat "$STATE/vm-id")"

/usr/bin/caffeinate -is -w "$$" &
CAFFEINATE_PID=$!
trap 'kill "$CAFFEINATE_PID" 2>/dev/null || true' EXIT
trap 'exit 0' TERM INT

while true; do
    /usr/bin/osascript "$STATE/ensure-running.applescript" "$VM_ID" ||
        printf '%s: UTM check failed; retrying in 30 seconds.\n' \
            "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" >&2
    sleep 30 &
    wait "$!" || true
done
BASH
chmod 700 "$STATE/watchdog.sh"

# Generate a plist safely, including paths containing spaces.
"$PYTHON" - "$AGENT" "$LABEL" "$STATE" "$LOG_DIR" <<'PY'
import plistlib, sys
from pathlib import Path

agent, label, state, logs = sys.argv[1:]
config = {
    "Label": label,
    "ProgramArguments": ["/bin/bash", state + "/watchdog.sh"],
    "RunAtLoad": True,
    "KeepAlive": True,
    "ThrottleInterval": 15,
    "LimitLoadToSessionType": "Aqua",
    "StandardOutPath": logs + "/watchdog.log",
    "StandardErrorPath": logs + "/watchdog-error.log",
}
Path(agent).write_bytes(plistlib.dumps(config))
PY

#### SECTION 10 - Start the VM and load LaunchAgent to the URL it lists

log "Starting VM; approve automation access if prompted"
/usr/bin/osascript "$STATE/ensure-running.applescript" "$VM_ID"

log "Enabling the login watchdog"
DOMAIN="gui/$(id -u)"
/bin/launchctl bootout "$DOMAIN" "$AGENT" 2>/dev/null || true
/bin/launchctl enable "$DOMAIN/$LABEL"
/bin/launchctl bootstrap "$DOMAIN" "$AGENT"

printf '\nSetup complete.\n'
printf 'VM: %s\nNetwork interface: %s\n' "$VM_NAME" "$BRIDGE_IF"
printf 'Wait for Home Assistant to finish its first boot, then open:\n'
printf '  http://homeassistant.local:8123\n'
printf 'If that does not resolve, use the VM IP displayed in UTM.\n'
printf 'Watchdog logs: %s\n' "$LOG_DIR"

# WARNING: The watchdog only works while you’re logged in. It won’t survive shutdown, logout, or the FileVault unlock screen after a reboot.