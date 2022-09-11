#!/usr/bin/env sh
# This is consul-download.sh at https://github.com/wilsonmar/mac-setup/blob/main/scripts/consul-download.sh
# This automates manual instructions at https://learn.hashicorp.com/tutorials/consul/deployment-guide?in=consul/production-deploy
# This downloads and installs "safely" - verifying that what is downloaded has NOT been altered.
#   1. The fingerprint used here matches what the author saved in Keybase.
#   2. The author's hash of the downloaded file matches the hash created by the author.
#   3. Download does not occur if the file already exists in the current folder.
#   4. Files downloaded are removed because the executable is what is used.
# Techniques for shell scripting used here are explained at https://wilsonmar.github.io/shell-scripts
# Explainer: https://serverfault.com/questions/896228/how-to-verify-a-file-using-an-asc-signature-file

# This is gas "v1.10 unzip just consul file"
    # Kermit TODO: The expires: date above must be in the future ..."
    # Kermit? TODO: Change file name with time stamp instead of removing.
    # TODO: Add install of more utilities # To be hashi-agents-install.sh
    # TODO: Add install of more HashiCorp programs: terraform, vault, consul-k8s, etc.
    # TODO: Add processing on other OS/Platforms.

# shellcheck disable=SC3010,SC2155,SC2005,SC2046
   # SC3010 POSIX compatibility per http://mywiki.wooledge.org/BashFAQ/031 where [[ ]] is undefined.
   # SC2155 (warning): Declare and assign separately to avoid masking return values.
   # SC2005 (style): Useless echo? Instead of 'echo $(cmd)', just use 'cmd'.
   # SC2046 (warning): Quote this to prevent word splitting.

# Break on error:
set -e # uxo pipefail

### 02. Display a menu if no parameter is specified in the command line
args_prompt() {
   echo "OPTIONS:"
   echo "   -h            show this help menu"
   echo "   -cont         continue (NOT stop) on error"
   echo "   -v            run -verbose (list space use and each image to console)"
   echo "   -vv           run -very verbose diagnostics"
   echo "   -x            set -x to trace command lines"
#  echo "   -x            set sudoers -e to stop on error"
   echo "   -q           -quiet headings for each step"
   echo "   -ni          -no install of utilities brew, gpg2, jq, etc. (default is install)"
   echo " "
   echo "   -oss          Install Open Source Sofware edition instead of default Enterprise edition"
   echo "   -consul \"1.13.1\"     Version of Consul"
   echo "   -installdir \"/usr/local/bin\"     target folder"
   echo " "
   echo "# USAGE EXAMPLES:"
   echo "chmod +x hashi-agents-install.sh   # (one time) change permissions"
   echo "./hashi-agents-install.sh # assumes -ent and lates version available"
   echo "./hashi-agents-install.sh -v -oss"
   echo "./hashi-agents-install.sh -v -consul 1.13.1  # specific version"
}  # args_prompt()
#if [ $# -eq 0 ]; then  # display if no parameters are provided:
#   args_prompt
#   exit 1
#fi

### 04. Define variables for use as "feature flags"
# Normal:
   CONTINUE_ON_ERR=false        # -cont
   RUN_VERBOSE=false            # -v
   RUN_DEBUG=false              # -vv
   SET_TRACE=false              # -x
   RUN_QUIET=false              # -q
   INSTALL_UTILS=true        # -ni  # not install
   INSTALL_OPEN_SOURCE=false    # -oss turns to true
   CONSUL_VERSION_PARM=""       # -consul 1.13.1
   TARGET_FOLDER_PARM=""        # -installdir "/usr/local/bin"

### 05. Custom functions to echo text to screen
# See https://wilsonmar.github.io/mac-setup/#TextColors
# \e ANSI color variables are defined in https://wilsonmar.github.io/bash-scripts#TextColors
h2() { if [ "${RUN_QUIET}" = false ]; then    # heading
   printf "\n\e[1m\e[33m\u2665 %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
   fi
}
info() {   # output on every run
   printf "\e[2m\n➜ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
note() { if [ "${RUN_VERBOSE}" = true ]; then
   printf "\n\e[1m\e[36m \e[0m \e[36m%s\e[0m" "$(echo "$@" | sed '/./,$!d')"
   printf "\n"
   fi
}
success() {
   printf "\n\e[32m\e[1m✔ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
error() {    # &#9747;
   printf "\n\e[31m\e[1m✖ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
warning() {  # &#9758; or &#9755;
   printf "\n\e[5m\e[36m\e[1m☞ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
fatal() {   # Skull: &#9760;  # Star: &starf; &#9733; U+02606  # Toxic: &#9762;
   printf "\n\e[31m\e[1m☢  %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}

if [ "${RUN_DEBUG}" = true ]; then  # -vv
   h2 "Header here"
   info "info"
   note "note"
   success "success!"
   error "error"
   warning "warning (warnNotice)"
   fatal "fatal (warnError)"
fi

### 06. Set variables dynamically based on each parameter flag
# See https://wilsonmar.github.io/mac-setup/#VariablesSet
while test $# -gt 0; do
  case "$1" in
    -cont)
      export CONTINUE_ON_ERR=true
      shift
      ;;
    -h)
      args_prompt  # show help menu
      exit 1
      shift
      ;;
    -consul*)
      shift
      CONSUL_VERSION_PARM=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      shift
      ;;
    -installdir*)
      shift
      TARGET_FOLDER_PARM=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      shift
      ;;
    -ni)
      export INSTALL_UTILS=false
      shift
      ;;
    -oss)
      export INSTALL_OPEN_SOURCE=true
      shift
      ;;
    -q)
      export RUN_QUIET=true
      shift
      ;;
    -vv)
      export RUN_DEBUG=true
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
    *)
      fatal "Parameter \"$1\" not recognized. Aborting."
      exit 0
      break
      ;;
  esac
done

### 08. Obtain and show information about the operating system in use to define which package manager to use
# See https://wilsonmar.github.io/mac-setup/#OSDetect
   export OS_TYPE="$( uname )"
   export OS_DETAILS=""  # default blank.
   export PACKAGE_MANAGER=""
if [ "${OS_TYPE}" = "Darwin" ]; then  # it's on a Mac:
      OS_TYPE="macOS"
      PACKAGE_MANAGER="brew"
fi


### 10. Set Continue on Error and Trace
# See https://wilsonmar.github.io/mac-setup/#StrictMode
if [ "${CONTINUE_ON_ERR}" = true ]; then  # -cont
   warning "Set to continue despite error ..."
else
   note "Set -e (error stops execution) ..."
   set -e  # exits script when a command fails
   # ALTERNATE: set -eu pipefail  # pipefail counts as a parameter
fi
if [ "${SET_TRACE}" = true ]; then
   h2 "Set -x ..."
   set -x  # (-o xtrace) to show commands for specific issues.
fi
# set -o nounset


### 11a. Print run Operating environment information 
note "Running $0 in $PWD"  # $0 = script being run in Present Wording Directory.
note "Apple macOS sw_vers = $(sw_vers -productVersion) / uname -r = $(uname -r)"  # example: 10.15.1 / 21.4.0

# See https://wilsonmar.github.io/mac-setup/#BashTraps
note "OS_TYPE=$OS_TYPE using $PACKAGE_MANAGER"
HOSTNAME="$( hostname )"
   note "on hostname=$HOSTNAME "
PUBLIC_IP=$( curl -s ifconfig.me )
INTERNAL_IP=$( ipconfig getifaddr en0 )
   note "at PUBLIC_IP=$PUBLIC_IP, internal $INTERNAL_IP"

if [ "$OS_TYPE" = "macOS" ]; then  # it's on a Mac:
   export MACHINE_TYPE="$(uname -m)"
   note "OS_TYPE=$OS_TYPE MACHINE_TYPE=$MACHINE_TYPE"
   if [[ "${MACHINE_TYPE}" == *"arm64"* ]]; then
      # On Apple M1 Monterey: /opt/homebrew/bin is where Zsh looks (instead of /usr/local/bin):
      export BREW_PATH="/opt/homebrew"
      # eval $( "${BREW_PATH}/bin/brew" shellenv)
   elif [[ "${MACHINE_TYPE}" == *"x86_64"* ]]; then
      export BREW_PATH="/usr/local/bin"
      export BASHFILE="$HOME/.bash_profile"  # on Macs
      #note "BASHFILE=~/.bashrc ..."
      #BASHFILE="$HOME/.bashrc"  # on Linux
   fi  # MACHINE_TYPE
fi


### 07. Verify parameters vs. exports defined on Terminal before invoking this:

# Instead of obtaining manually: https://docs.github.com/en/repositories/releasing-projects-on-github/linking-to-releases
CONSUL_LATEST_VERSION=$( curl -sL "https://api.github.com/repos/hashicorp/consul/releases/latest" | jq -r ".tag_name" | cut -c2- )

# Enable run specification of this variable within https://releases.hashicorp.com/consul
# Thanks to https://fabianlee.org/2021/02/16/bash-determining-latest-github-release-tag-and-version/

if [ -n "${CONSUL_VERSION_PARM}" ]; then  # specified by parameter
   # lastest spec wins (use parameter with run)
   echo "*** Using CONSUL_VERSION_PARM defined specified in script parm: -consul \"$CONSUL_VERSION_PARM\" ..."
   export CONSUL_VERSION="${CONSUL_VERSION_PARM}"
else
   # Since parm is not specified, try variable set before program invoke:
#   if [ -z "${CONSUL_VERSION_IN+x}" ]; then  # specified:
#      echo "*** Using \"$CONSUL_VERSION_IN\" defined before script invoke ..."
#      export CONSUL_VERSION="${CONSUL_VERSION_IN}"
#   else
      echo "*** Using latest version \"${CONSUL_LATEST_VERSION}\" ..."
      export CONSUL_VERSION="${CONSUL_LATEST_VERSION}"
#   fi
fi

if [ "${INSTALL_OPEN_SOURCE}" = false ]; then  # -oss not specified
    CONSUL_VERSION="${CONSUL_VERSION}+ent"  # for "1.12.2+ent"
    echo "*** Using consul version $CONSUL_VERSION ..."
fi


if [ -n "${TARGET_FOLDER_PARM}" ]; then  # specified by parameter
   TARGET_FOLDER="${TARGET_FOLDER_PARM}"
   echo "*** Using TARGET_FOLDER specified by parm -=\"$TARGET_FOLDER_PARM\" ..."
elif [ -n "${TARGET_FOLDER_IN}" ]; then  # specified by parameter
   TARGET_FOLDER="${TARGET_FOLDER_IN}"
   echo "*** Using TARGET_FOLDER_IN specified before invoke: \"$TARGET_FOLDER_IN\" ..."
else
   TARGET_FOLDER="/usr/local/bin"
   echo "*** Using default TARGET_FOLDER=\"$TARGET_FOLDER\" ..."
fi

if [[ ! ":$PATH:" == *":$TARGET_FOLDER:"* ]]; then
   fatal "*** TARGET_FOLDER=\"${TARGET_FOLDER}\" not in PATH to be found. Aborting."
   exit
fi


if [ "${INSTALL_UTILS}" = true ]; then  # -I

    if ! command -v gcc ; then
        # TODO: Install XCode command utilities: https://gist.github.com/tylergets/90f7e61314821864951e58d57dfc9acd
        fatal "*** gcc not found. Please install Xcode. Aborting."
        exit
    else
        note "$( gcc --version )"  #  note "$(  cc --version )"
        note "$( xcode-select --version )"  # Example output: xcode-select version 2395 (as of 23APR2022).
            # XCode version: https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/pkgutil.1.html
            # pkgutil --pkg-info=com.apple.pkg.CLTools_Executables | grep version
            # Tools_Executables | grep version
            # version: 9.2.0.0.1.1510905681
    fi

    if ! command -v brew ; then
        h2 "Installing brew package manager on macOS using Ruby ..."
        mkdir homebrew && curl -L https://GitHub.com/Homebrew/brew/tarball/master \
            | tar xz --strip 1 -C homebrew
        # if PATH for brew available:
    fi
    
    if ! command -v jq ; then
        echo "*** Installing jq ..."
        brew install jq
    fi

    if ! command -v curl ; then
        echo "*** Installing curl ..."
        brew install curl
    fi

    if ! command -v wget ; then
        echo "*** Installing wget ..."
        brew install wget
    fi

    # TODO: Add install of more utilities
    # shellcheck, tfsec,go, gpg2, awscli, vscode, python

fi  # INSTALL_UTILS

    # TODO: Add install of more HashiCorp programs: terraform, vault, consul-k8s, instruqt, etc.

if ! command -v consul ; then  # executable not found:
    echo "*** consul executable not found. Installing ..."
else
    RESPONSE=$( consul --version )
    # Consul v1.12.2
    # Revision 19041f20
    # Protocol 2 spoken by default, understands 2 to 3 (agent will automatically use protocol >2 when speaking to compatible agents)
    if [[ "${CONSUL_LATEST_VERSION}" == *"${RESPONSE}"* ]]; then  # contains it:
        echo "*** Currently installed:"
        echo "${RESPONSE}"
        if [[ "${CONSUL_VERSION}" == *"${CONSUL_LATEST_VERSION}"* ]]; then  # contains it:
            echo "*** consul binary is already at the latest version ${CONSUL_LATEST_VERSION}."
            which consul
            echo "*** Exiting..."
            exit
        else
            echo "*** consul binary being replaced with version ${CONSUL_VERSION}."
        fi
    fi

    # NOTE: There are /usr/local/bin/consul and /usr/local/bin/consul-k8s  
    # There is /opt/homebrew/bin//consul-terraform-sync installed by homebrew
    # So /usr/local/bin should be at the front of $PATH in .bash_profile or .zshrc
    echo "*** which consul (/usr/local/bin/consul)"
    which consul
fi

if ! command -v wget ; then
   echo "*** Installing wget ..."
   brew install wget
fi

# See https://tinkerlog.dev/journal/verifying-gpg-signatures-history-terms-and-a-how-to-guide
# Alternately, see https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/terraform-debian.sh
# Automation of steps described at 
                     #  https://github.com/sethvargo/hashicorp-installer/blob/master/hashicorp.asc
# curl -o hashicorp.asc https://raw.githubusercontent.com/sethvargo/hashicorp-installer/master/hashicorp.asc
if [ ! -f "hashicorp.asc" ]; then  # not found:
    echo "*** Downloading HashiCorp's public asc file (7177 bytes)"
    # Get PGP Signature from a commonly trusted 3rd-party (Keybase) - asc file applicable to all HashiCorp products.
    # This does not return a file:
    # wget --no-check-certificate -q hashicorp.asc https://keybase.io/hashicorp/pgp_keys.asc
    # SO ALTERNATELY since https://keybase.io/hashicorp says 34365D9472D7468F
    curl -s "https://keybase.io/_/api/1.0/key/fetch.json?pgp_key_ids=34365D9472D7468F" | jq -r '.keys | .[0] | .bundle' > hashicorp.asc
    # 34365D9472D7468F Created 2021-04-19 (after the Codedev supply chain attack)
       # See https://discuss.hashicorp.com/t/hcsec-2021-12-codecov-security-event-and-hashicorp-gpg-key-exposure/23512
       # And https://www.securityweek.com/twilio-hashicorp-among-codecov-supply-chain-hack-victims
    # See https://circleci.com/developer/orbs/orb/jmingtan/hashicorp-vault
else
    echo "*** Using existing HashiCorp.asc file ..."
fi
if [ ! -f "hashicorp.asc" ]; then  # not found:
   fatal "*** Download of hashicorp.asc failed. Aborting."
   exit
else
   ls -alT hashicorp.asc
fi

if ! command -v gpg ; then
    # Install gpg if needed: see https://wilsonmar.github.io/git-signing
    echo "*** brew install gnupg2 (gpg)..."
    brew install gnupg2
    chmod 700 ~/.gnupg
fi
h2 "gpg import hashicorp.asc ..."
# No Using gpg --list-keys @34365D9472D7468F to check if asc file is already been imported into keychain (a one-time process)
    # gpg --import hashicorp.asc
    # gpg: key 34365D9472D7468F: public key "HashiCorp Security (hashicorp.com/security) <security@hashicorp.com>" imported
    # gpg: Total number processed: 1
    # gpg:               imported: 1
    # see https://www.vaultproject.io/docs/concepts/pgp-gpg-keybase

RESPONSE=$( gpg --show-keys hashicorp.asc )
    # pub   rsa4096 2021-04-19 [SC] [expires: 2026-04-18]
    #       C874 011F 0AB4 0511 0D02  1055 3436 5D94 72D7 468F
    # uid           [ unknown] HashiCorp Security (hashicorp.com/security) <security@hashicorp.com>
    # sub   rsa4096 2021-04-19 [E] [expires: 2026-04-18]
    # sub   rsa4096 2021-04-21 [S] [expires: 2026-04-20]
    # The "C874..." fingerprint is used for verification:

h2 "Verifying fingerprint ..."
# Extract 2nd line (containing fingerprint):
RESPONSE2=$( echo "$RESPONSE" | sed -n 2p ) 
# Remove spaces:
FINGERPRINT=$( echo "${RESPONSE2}" | xargs )
# Verify we want key ID 72D7468F and fingerprint C874 011F 0AB4 0511 0D02 1055 3436 5D94 72D7 468F. 
gpg --fingerprint "${FINGERPRINT}"
    # pub   rsa4096 2021-04-19 [SC] [expires: 2026-04-18]
    #       C874 011F 0AB4 0511 0D02  1055 3436 5D94 72D7 468F
    # uid           [ unknown] HashiCorp Security (hashicorp.com/security) <security@hashicorp.com>
    # sub   rsa4096 2021-04-19 [E] [expires: 2026-04-18]
    # sub   rsa4096 2021-04-21 [S] [expires: 2026-04-20]
# QUESTION: What does "[ unknown]" mean?  trusted with [ultimate]
# The response we want is specified in https://www.hashicorp.com/security#pgp-public-keys

# TODO: The expires: date above must be in the future ..."
# for loop through pub and sub lines:
   # if [ ${val1} <= ${val2} ]
      # echo "*** The expires: 2026-04-20 date above must be in the future ..."


# for each platform:
export PLATFORM1="$( echo $( uname ) | awk '{print tolower($0)}')"
export PLATFORM="${PLATFORM1}"_"$( uname -m )"
echo "*** CONSUL_VERSION=$CONSUL_VERSION on PLATFORM=${PLATFORM}"
# For PLATFORM="darwin_arm64" amd64, freebsd_386/amd64, linux_386/amd64/arm64, solaris_amd64, windows_386/amd64
if [ ! -f "consul_${CONSUL_VERSION}_${PLATFORM}.zip" ]; then  # not found:
    wget "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_${PLATFORM}.zip"
        # https://releases.hashicorp.com/consul/
    # consul_1.12.2+ent_d 100%[===================>]  44.59M  4.14MB/s    in 13s     
else
    echo "*** consul_${CONSUL_VERSION}_${PLATFORM}.zip alread downloaded."
fi

if [ ! -f "consul_${CONSUL_VERSION}_SHA256SUMS" ]; then  # not found:
    wget "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS"
        # 1.08K  --.-KB/s    in 0s
fi
if [ ! -f "consul_${CONSUL_VERSION}_SHA256SUMS.72D7468F.sig" ]; then  # not found:
    wget "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS.72D7468F.sig"
        # 566  --.-KB/s    in 0s      
fi
if [ ! -f "consul_${CONSUL_VERSION}_SHA256SUMS.sig" ]; then  # not found:
    wget "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS.sig"
        # 566  --.-KB/s    in 0s      
fi

h2 "gpg --verify consul_${CONSUL_VERSION}_SHA256SUMS.sig consul_${CONSUL_VERSION}_SHA256SUMS"
RESPONSE=$( gpg --verify "consul_${CONSUL_VERSION}_SHA256SUMS.sig" \
    "consul_${CONSUL_VERSION}_SHA256SUMS" )
    # gpg: Signature made Fri Jun  3 13:58:17 2022 MDT
    # gpg:                using RSA key 374EC75B485913604A831CC7C820C6D5CD27AB87
    # gpg: Good signature from "HashiCorp Security (hashicorp.com/security) <security@hashicorp.com>" [unknown]
    # gpg: WARNING: This key is not certified with a trusted signature!
    # gpg:          There is no indication that the signature belongs to the owner.
    # Primary key fingerprint: C874 011F 0AB4 0511 0D02  1055 3436 5D94 72D7 468F
    #      Subkey fingerprint: 374E C75B 4859 1360 4A83  1CC7 C820 C6D5 CD27 AB87
EXPECTED_TEXT="Good signature"
if [[ "${EXPECTED_TEXT}" == *"${RESPONSE}"* ]]; then  # contains it:
    echo "*** ${EXPECTED_TEXT} verified."
else
    echo "*** Signature FAILED verification: ${RESPONSE}"
    # If the file was manipulated, you'll see "gpg: BAD signature from ..."
    exit
fi

h2 "Verify that SHASUM matches the archive ..."
export EXPECTED_TEXT="consul_${CONSUL_VERSION}_${PLATFORM}.zip: OK"
    # consul_1.12.2+ent_darwin_arm64.zip: OK
RESPONSE=$( yes | shasum -a 256 -c "consul_${CONSUL_VERSION}_SHA256SUMS" 2>/dev/null | grep "${EXPECTED_TEXT}" )
    # yes | to avoid "replace EULA.txt? [y]es, [n]o, [A]ll, [N]one, [r]ename:"
    # shasum: consul_1.12.2+ent_darwin_amd64.zip: No such file or directory
    # consul_1.12.2+ent_darwin_amd64.zip: FAILED open or read
    # consul_1.12.2+ent_darwin_arm64.zip: OK
if [[ "${EXPECTED_TEXT}" == *"${RESPONSE}"* ]]; then  # contains it:
    echo "*** Download verified: ${EXPECTED_TEXT} "
else
    echo "*** ${EXPECTED_TEXT} FAILED verification: ${RESPONSE}"
    exit
fi


if ! command -v consul ; then  # NOT found:
    echo "*** consul not installed."
else
   h2 "Remove existing consul from path \"${TARGET_FOLDER}\" "
   if [ -f "${TARGET_FOLDER}/consul" ]; then  # specified by parameter
      echo "*** removing existing consul binary file from \"$TARGET_FOLDER\" before unzip of new file:"
      ls -alT "${TARGET_FOLDER}/consul"
      # -rwxr-xr-x@ 1 user  group  127929168 Jun  3 13:46 2022 /usr/local/bin/consul
      
      # Kermit TODO: Change file name with time stamp instead of removing.
      rm "${TARGET_FOLDER}/consul"
    fi
fi

h2 "Unzip"
if [ -f "consul_${CONSUL_VERSION}_${PLATFORM}.zip" ]; then  # found:
   yes | unzip "consul_${CONSUL_VERSION}_${PLATFORM}.zip" consul
   # yes | to avoid replace consul? [y]es, [n]o, [A]ll, [N]one, [r]ename: 
   # specifying just consul so EULA.txt and TermsOfEvaluation.txt are not
fi

if [ ! -f "consul" ]; then  # not found:
    fatal "*** consul file not found. Aborting."
    exit
fi

h2 "Move consul executable binary to folder in $PATH "
mv consul "${TARGET_FOLDER}"
if [ ! -f "${TARGET_FOLDER}/consul" ]; then  # not found:
   fatal "*** ${TARGET_FOLDER}/consul not found after move. Aborting."
   exit
fi

# Cleanup:
h2 "*** Removing downloaded files no longer needed ..."
rm "hashicorp.asc"
rm "consul_${CONSUL_VERSION}_SHA256SUMS"
rm "consul_${CONSUL_VERSION}_SHA256SUMS.72D7468F.sig"
rm "consul_${CONSUL_VERSION}_SHA256SUMS.sig"
rm "consul_${CONSUL_VERSION}_${PLATFORM}.zip"

# Now you can do git push.

echo "*** consul_${CONSUL_VERSION} date/time stamp and bytes:"
ls -alT "${TARGET_FOLDER}/consul"
    # -rwxr-xr-x  1 user  group  117722304 Jun  3 13:44:36 2022 /usr/local/bin/consul # for consul_1.12.2 (open source)
    # -rwxr-xr-x@ 1 user  group  127929168 Jun  3 13:46 2022 /usr/local/bin/consul  # for consul_1.12.2+ent

RESPONSE=$( consul --version )
   # Consul v1.13.1+ent
   # Revision 5bd604e6
   # Build Date 2022-08-11T19:07:12Z
   # Protocol 2 spoken by default, understands 2 to 3 (agent will automatically use 
   # protocol >2 when speaking to compatible agents)
#OR:
   # Consul v1.12.2
   # Revision 19041f20
   # Protocol 2 spoken by default, understands 2 to 3 (agent will automatically use protocol >2 when speaking to compatible agents)
if [[ "${CONSUL_VERSION}" == *"${RESPONSE}"* ]]; then  # contains it:
   echo "${RESPONSE}"
   fatal "*** Consul is NOT the desired version ${CONSUL_VERSION} - Aborting."
   exit
fi

echo "*** END"
# END