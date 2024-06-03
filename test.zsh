#!/usr/bin/env zsh
SHOW_DEBUG=true

         # Extract Chrome browser bookmarks:
         FILE_TO_BACKUP="$HOME/Library/Application Support/Google/Chrome/Default/Bookmarks"
         MY_USB_PATH="/Volumes/${USE_DRIVE_NAME}/Bookmarks-${THIS_PROGRAM}-${LOG_DATETIME}"
         if [ ! -f "${PATH_TO_EXTRACT}" ]; then  # file not found:
            echo "-macos Bookmarks file not found. Not extracted. Continuing..."
         else
           if [ "${SHOW_DEBUG}" = true ]; then  # -vv
               bookmarks=$(jq '.roots.bookmark_bar.children[] | recurse(.children[]) | .url, .name' "$FILE_TO_EXTRACT" | sed 'N;s/\n/ /')
               # Print the formatted bookmarks
               printf "%s\n" "$bookmarks"
            fi
            echo "-macos copying to disk..."
            sudo cp -a "$HOME/${FILE_TO_BACKUP}" "${MY_USB_PATH}/${FOLDER_TO_BACKUP}"
            # Extract bookmark URLs and titles using jq:
         fi

exit 9

# See https://wilsonmar.github.io/mac-setup/#akeyless

AKEYLESS_API_GW_URL="???"
AKEYLESS_PREFIX="akeyless://${AKEYLESS_ACCT}/${AKEYLESS_KEY}"
if [ ! -z ${AKEYLESS_API_GW_URL} ] && [ -f ~/.akeyless/latest_token ]; then
  LATEST_PROFILE=$(cat ~/.akeyless/latest_token)
elif [ -d ~/.akeyless/profiles/ ]; then  # contains file default.toml
  LATEST_PROFILE=$(ls -1t ~/.akeyless/profiles/ 2>/dev/null | head -1)
else
  fatal "Akeyless default.toml not identified. Exiting..."
fi

if [ ! -z ${LATEST_PROFILE} ]; then
  ENV_RUNNING_FLAG="~/.akeyless/env_running"
  if [ ! -f ${ENV_RUNNING_FLAG} ]; then
    touch ${ENV_RUNNING_FLAG}
    LATEST_PROFILE=${LATEST_PROFILE%".toml"}
    for var in $(env | grep "=${AKEYLESS_PREFIX}" | sed 's/=.*//g')
    do
      if [[ "${!var}" = "${AKEYLESS_PREFIX}"* ]]; then
        SECRET_PATH=${!var#"$AKEYLESS_PREFIX"}
        SECRET_TYPE=$(akeyless describe-item --name "${SECRET_PATH}" --profile ${LATEST_PROFILE} 2>/dev/null | jq -r .item_type)
        [ -z ${SECRET_TYPE} ] && continue
        [[ "${SECRET_TYPE}" == "DYNAMIC_SECRET" ]] && IS_DYNAMIC="dynamic-" || IS_DYNAMIC=""
        [[ "${SECRET_TYPE}" == "ROTATED_SECRET" ]] && IS_ROTATED="rotated-" || IS_ROTATED=""
        NEW_VAL=$(akeyless get-${IS_DYNAMIC}${IS_ROTATED}secret-value --name "${SECRET_PATH}" --profile ${LATEST_PROFILE} 2>/dev/null)
        if [ ! -z "${NEW_VAL}" ]; then
          export $var="${NEW_VAL}"
        fi
      fi
    done
    rm -f ${ENV_RUNNING_FLAG}
  fi
fi

exit

if ! command -v code -v >/dev/null; then  # not installed, so:
   echo "ERROR: code command not available ..."
   exit
fi

# Instead of using https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/p/alertmanager.rb
# Recommended: https://prometheus.io/download/#alertmanager
# Download file: https://github.com/prometheus/alertmanager/releases/download/v0.27.0-rc.0/alertmanager-0.27.0-rc.0.darwin-amd64.tar.gz
# Notes at https://github.com/prometheus/alertmanager/releases

# https://github.com/prometheus/alertmanager/releases/tag/v2.49.1
# VER="0.27.0-rc.0"
# ARCH="darwin-amd64" # or "darwin-arm" 
# amd:
curl -0L "https://github.com/prometheus/alertmanager/releases/download/v${VER}/alertmanager-${VER}.${ARCH}.tar.gz"
tar -xvzf "alertmanager-${VER}.${ARCH}.tar.gz"
ls -al *
# Set symlink
sudo ln -s /usr/local/bin/alertmanager /usr/local/bin/palertmanager-${VER}.${ARCH}.tar.gz/alertmanager
cd alertmanager
ls -al *
# Start it in &background:
chmod +x alertmanager
./alertmanager --config.file=alertmanager.yml > alert.out 2>&1 &
sudo systemctl restart prometheus
sudo systemctl status prometheus

open "https://localhost:9090/alerts"

# Force an event: Stop node_exporter

sudo killall -HUP alertmanager

