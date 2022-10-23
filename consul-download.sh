#!/usr/bin/env sh
# This is consul-download.sh at https://github.com/wilsonmar/mac-setup/blob/master/consul-download.sh
# This is git commit -m"v1.15 update consul latest version"

# Copy and paste this:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/mac-setup/master/consul-download.sh)"

# This automates manual instructions at https://learn.hashicorp.com/tutorials/consul/deployment-guide?in=consul/production-deploy
# This downloads and installs "safely" - verifying that what is downloaded has NOT been altered.
# Works like https://github.com/jsiebens/hashi-up/tree/main/scripts
       # and https://github.com/shoenig/hc-install
       # and https://github.com/NicoHood/GPGit  # verifies source
#   1. The fingerprint used here matches what the author saved in Keybase.
#   2. The author's hash of the downloaded file matches the hash created by the author.
#   3. Download does not occur if the file already exists in the current folder.
#   4. Files downloaded are removed because the executable is what is used.
# Techniques for shell scripting used here are explained at https://wilsonmar.github.io/shell-scripts
# Explainer: https://serverfault.com/questions/896228/how-to-verify-a-file-using-an-asc-signature-file

    # TODO: Add processing on other OS/Platforms (Windows, Linux)
    # Kermit TODO: The expires: date above must be in the future ..."
    # Kermit? TODO: Change file name with time stamp instead of removing.
    # TODO: Add install of more utilities # instead of consul-download.sh
    # TODO: Add install of more HashiCorp programs: terraform, vault, consul-k8s, etc.

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
   echo "   -h          #  show this help menu"
   echo "   -cont       #  continue (NOT stop) on error"
   echo "   -v          # -verbose (list more details to console)"
   echo "   -vv         # -very verbose diagnostics (tracing)"
   echo "   -x          #  set -x to display every console command"
   echo "   -q          # -quiet headings for each step"
   echo "   -ni         # -no install of utilities brew, gpg2, jq, etc. (default is install)"
   echo " "
   echo "   -vers       #  list versions released, then stop"
   echo "   -oss        #  Install Open Source Sofware edition instead of default Enterprise edition"
   echo "   -consul \"1.13.1\"  # Specify version of Consul to install"
   echo "   -installdir \"/usr/local/bin\"   # target folder for program installation"
   echo "   -email \"johndoe@gmail.com\"     # to generate GPG keys for"
   echo " "
   echo "USAGE EXAMPLES:"
   echo "chmod +x consul-download.sh   # (one time) change permissions"
   echo "./consul-download.sh -vers -v   # list versions & release details, then stop"
   echo "./consul-download.sh -email johndoe@gmail.com   # assumes -ent (enterprise edition) and latest version available"
   echo "./consul-download.sh -v -oss -consul 1.13.1  # specific open source version - prompt for email"
}  # args_prompt()


### 04. Define variables (and default values) for use as "feature flags":
   CONTINUE_ON_ERR=false        # -cont
   RUN_VERBOSE=false            # -v
   LIST_VERSIONS=false          # -vers
   RUN_DEBUG=false              # -vv
   SET_TRACE=false              # -x
   RUN_QUIET=false              # -q
   INSTALL_UTILS=true        # -ni  # not install
   INSTALL_OPEN_SOURCE=false    # -oss turns to true
   CONSUL_VERSION_PARM=""       # -consul 1.13.1
   TARGET_FOLDER_PARM=""        # -installdir "/usr/local/bin"
   MY_EMAIL_ADDRESS=""          # johndoe@gmail.com

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
   exit
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
    -email*)
      shift
      MY_EMAIL_ADDRESS=$( echo "$1" | sed -e 's/^[^=]*=//g' )
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
    -vers)
      export LIST_VERSIONS=true
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
# else Windows, Linux...
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
 	
# Linux:
# Use yum on CentOS and older Red Hat based distributions.
# Use dnf on Fedora and other newer Red Hat distributions.
# Use zypper on OpenSUSE based distributions   
fi


### 07. Verify parameters vs. exports defined on Terminal before invoking this:

if [ "${LIST_VERSIONS}" = true ]; then
    # Just the version codes: 
    CONSUL_VER_LIST="https://releases.hashicorp.com/consul"
    open "${CONSUL_VER_LIST}"

    if [ "${RUN_VERBOSE}" = true ]; then  # -v
        # show website with description of each release:
        CONSUL_VER_LIST="https://github.com/hashicorp/consul/releases"
        open "${CONSUL_VER_LIST}"
    fi
    exit
fi


# Enable run specification of this variable within https://releases.hashicorp.com/consul
# Thanks to https://fabianlee.org/2021/02/16/bash-determining-latest-github-release-tag-and-version/
# Instead of obtaining manually: https://docs.github.com/en/repositories/releasing-projects-on-github/linking-to-releases
if [ -n "${CONSUL_VERSION_PARM}" ]; then  # specified by parameter
   # lastest spec wins (use parameter with run)
   success "Using CONSUL_VERSION_PARM defined specified in script parm: -consul \"$CONSUL_VERSION_PARM\" ..."
   export CONSUL_VERSION="${CONSUL_VERSION_PARM}"
else
   # Since parm is not specified, lookup variable:
   # This no longer works: curl -sL https://api.github.com/repos/hashicorp/consul/releases/latest" | jq -r ".tag_name" | cut -c2- )
    if [ "${INSTALL_OPEN_SOURCE}" = true ]; then  # -oss 
        CONSUL_LATEST_VERSION=$( curl -sS https://api.releases.hashicorp.com/v1/releases/consul/latest |jq -r .version )
           # Example: "1.13.2+ent" thanks to Ranjandas Athiyanathum Poyil for identifying this.
    else  # Enterprise:
        CONSUL_LATEST_VERSION=$( curl -sS https://api.releases.hashicorp.com/v1/releases/consul/latest\?license_class\=enterprise |jq -r .version )
    fi
    success "Using latest consul version \"${CONSUL_LATEST_VERSION}\" ..."
    export CONSUL_VERSION="${CONSUL_LATEST_VERSION}"
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
   fatal "TARGET_FOLDER=\"${TARGET_FOLDER}\" not in PATH to be found. Aborting."
fi

if [ -z "${MY_EMAIL_ADDRESS}" ]; then  # not found:
    read -e -p "Input email address: " MY_EMAIL_ADDRESS
    # check for @ in email address:
    if [[ ! "$MY_EMAIL_ADDRESS" == *"@"* ]]; then
       fatal "MY_EMAIL_ADDRESS \"$MY_EMAIL_ADDRESS\" does not contain @. Aborting."
    fi
fi
    # success "Using MY_EMAIL_ADDRESS=$MY_EMAIL_ADDRESS"


if [ "${INSTALL_UTILS}" = true ]; then  # -I

    # Homebrew now runs xcode-select --install for command line tools for gcc, clang, git ..."
    # On Apple Silicon machines, there's one more step. Homebrew files are installed into the /opt/homebrew folder. 
    # But the folder is not part of the default $PATH. So follow Homebrew's advice and create a ~/.zprofile
    # Add Homebrew to your PATH in ~/.zprofile:
    # echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    # eval "$(/opt/homebrew/bin/brew shellenv)"

    #if ! command -v clang ; then
        # Not in /Applications/Xcode.app/Contents/Developer/usr/bin/
        # sudo xcode-select -switch /Library/Developer/CommandLineTools
        # XCode version: https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/pkgutil.1.html
        # pkgutil --pkg-info=com.apple.pkg.CLTools_Executables | grep version
        # Tools_Executables | grep version
        # version: 9.2.0.0.1.1510905681
    
        # Error: You have not agreed to the Xcode license. Please resolve this by running:
        # sudo xcodebuild -license accept
        # TODO: Input password:
    #fi
    note "$( gcc --version )"  #  note "$(  cc --version )"
    note "$( xcode-select --version )"  # Example output: xcode-select version 2395 (as of 23APR2022).

    if ! command -v brew ; then
        h2 "Installing brew package manager on macOS using Ruby ..."
        mkdir homebrew && curl -L https://GitHub.com/Homebrew/brew/tarball/master \
            | tar xz --strip 1 -C homebrew
        # if PATH for brew available:
    fi
    
    if ! command -v jq ; then
        note "Installing jq ..."
        brew install jq
    fi

    if ! command -v curl ; then
        note "Installing curl ..."
        brew install curl
    fi
    if ! command -v wget ; then
        note "Installing wget ..."
        brew install wget
    fi

    note "Installing Linux equivalents for MacOS ..."
    brew install gnu-getopt coreutils xz gzip bzip2 lzip zstd

    if ! command -v tree ; then
        note "Installing tree ..."
        brew install tree
    fi

    if ! command -v gpg ; then
        # Install gpg if needed: see https://wilsonmar.github.io/git-signing
        note "brew install gnupg2 (gpg) for Terminal use ..."
        # brew install --cask gpg-suite   # GUI 
        brew install gnupg2
        # Above should create folder "${HOME}/.gnupg"
    fi

    # Test that the key was created and the permission the trust was set:
    RESPONSE=$( gpg2 --list-keys )
    if [[ "${RESPONSE}" == *"<${MY_EMAIL_ADDRESS}>"* ]]; then  # contains it:
        success "MY_EMAIL_ADDRESS $MY_EMAIL_ADDRESS found among GPG keys ..."
            # pub   rsa4096 2021-06-20 [SC] [expires: 2025-06-20]
            #    123456789E91004D4C5D88CAE21961814AC0EF1B
            # uid           [ultimate] John Doe <johndoe+github@gmail.com>
        if [ "${RUN_VERBOSE}" = true ]; then  # -v
            echo "$RESPONSE"
        fi
    else
        note "MY_EMAIL_ADDRESS $MY_EMAIL_ADDRESS NOT found among GPG keys ..."

        # ~/.gnupg should have been created by install of gpg2
        if [ ! -d "${HOME}/.gnupg" ]; then  # found per https://gnupg.org/documentation/manuals/gnupg-2.0/GPG-Configuration.html
            note "mkdir -m 0700 .gnupg"
            # mkdir -m 0700 .gnupg
            chmod 0700 "${HOME}/.gnupg"
        fi

        if [ -f "${HOME}/.gnupg/gpg.conf" ]; then  # found - remove for rebuilt:
            note "rm .gnupg/gpg.conf"
            rm "${HOME}/.gnupg/gpg.conf"
        fi
        note "Creating $HOME/.gnupg/gpg.conf"  # Linux /usr/share/gnupg2/ 
        touch "$HOME/.gnupg/gpg.conf"
        chmod 600 "$HOME/.gnupg/gpg.conf"

        # See https://wilsonmar.github.io/git-signing/#verify-gpg-install-version
        # and https://serverfault.com/questions/691120/how-to-generate-gpg-key-without-user-interaction
        # No response is expected if the permissions command is successful.

        h2 "Generate 4096-bit RSA GPG key for $MY_EMAIL_ADDRESS ..."
        # Create a keydetails file containing commands used by 
        cat >keydetails <<EOF
        %echo Generating a basic OpenPGP key for $MY_EMAIL_ADDRESS
        Key-Type: RSA
        Key-Length: 4096
        Subkey-Type: RSA
        Subkey-Length: 4096
        Name-Real: User 1
        Name-Comment: User 1
        Name-Email: $MY_EMAIL_ADDRESS
        Expire-Date: 0
        %no-ask-passphrase
        %no-protection
        %pubring pubring.kbx
        %secring trustdb.gpg
        # Do a commit here, so that we can later print "done" :-)
        %commit
        %echo done
EOF

        h2 "Generate key pair:"
        gpg2 --verbose --batch --gen-key keydetails
            # gpg --default-new-key-algo rsa4096 --gen-key

            # gpg: Generating a basic OpenPGP key
            # gpg: writing public key to 'pubring.kbx'
            # gpg: writing self signature
            # gpg: RSA/SHA256 signature from: "2807AFD6A08A9BD0 [?]"
            # gpg: writing key binding signature
            # gpg: RSA/SHA256 signature from: "2807AFD6A08A9BD0 [?]"
            # gpg: RSA/SHA256 signature from: "A205B8C17D16A303 [?]"
            # gpg: done
            # gpg (GnuPG/MacGPG2) 2.2.34; Copyright (C) 2022 g10 Code GmbH
            # This is free software: you are free to change and redistribute it.
            # There is NO WARRANTY, to the extent permitted by law.

            # gpg: key "johndoe@gmail.com" not found: No public key
echo "here"

        # So we can encrypt without prompt, set trust to 5 for "I trust ultimately" the key :
        echo -e "5\ny\n" |  gpg2 --command-fd 0 --expert --edit-key $MY_EMAIL_ADDRESS trust;

        # TODO: Test whether the key can encrypt and decrypt:
        # gpg2 -e -a -r $MY_EMAIL_ADDRESS keydetails
        # TODO: Check failure
            # gpg: error retrieving 'wilsonmar@gmail.com' via Local: Unusable public key
            # gpg: error retrieving 'wilsonmar@gmail.com' via WKD: Server indicated a failure
            # gpg: wilsonmar@gmail.com: skipped: Server indicated a failure
            # gpg: keydetails: encryption failed: Server indicated a failure
            # https://sites.lafayette.edu/newquisk/archives/504

        # Remove:
        rm keydetails
        gpg2 -d keydetails.asc
        rm keydetails.asc


        h2 "Create a public GPG (.asc) file between BEGIN PGP PUBLIC KEY BLOCK-----"
        gpg --armor --export $MY_EMAIL_ADDRESS > "$MY_EMAIL_ADDRESS.asc"
        ls -al "$MY_EMAIL_ADDRESS.asc"

        echo "Please switch to browser window opened to https://github.com/settings/keys, then "
        cat "$MY_EMAIL_ADDRESS.asc" | pbcopy
        open https://github.com/settings/keys
        echo "paste (command+V) the private GPG key from Clipboard, then switch back " 
        read -e -p "here to press Enter to continue: " RESPONSE

        # FIX: extract key fingerprint (123456789E91004D4C5D88CAE21961814AC0EF1B above) :
        RESPONSE=$( gpg --show-keys "$MY_EMAIL_ADDRESS.asc" )
        echo $RESPONSE

        h2 "Verifying fingerprint ..."
        # Extract 2nd line (containing fingerprint):
        RESPONSE2=$( echo "$RESPONSE" | sed -n 2p ) 
        # Remove spaces:
        FINGERPRINT=$( echo "${RESPONSE2}" | xargs )
        # Verify we want key ID 72D7468F and fingerprint C874 011F 0AB4 0511 0D02 1055 3436 5D94 72D7 468F. 
        gpg --fingerprint "${FINGERPRINT}"

    echo "DEBUGGING";exit

        # Update the gpgconf file dynamically
        # echo ‘default-key:0:”xxxxxxxxxxxxxxxxxxxx’ | gpgconf —change-options gpg
            # note there is only ONE double-quote to signify a text string is about to begin.
            # There is a pair of single-quote surrounding the entire echo statement.
        h2 "$HOME/.gnupg/gpg.conf now contains ..."
        cat "$HOME/.gnupg/gpg.conf"


    echo "DEBUGGING";exit

        gpg2 -d "$MY_EMAIL_ADDRESS.asc"
        rm "$MY_EMAIL_ADDRESS.asc"

        # TODO: Verify
        # default-key "${RESPONSE}"  # contents = 123456789E91004D4C5D88CAE21961814AC0EF1B
            # cat $HOME/.gnupg/gpg.conf should now contain:
            # auto-key-retrieve
            # no-emit-version
            # use-agent
            # default-key 123456789E91004D4C5D88CAE21961814AC0EF1B

    fi

    # TODO: Add install of more utilities: python, shellcheck, go, tfsec, awscli, vscode, 

fi  # INSTALL_UTILS


if ! command -v consul ; then  # executable not found:
    echo "*** consul executable not found. Installing ..."
else
    RESPONSE=$( consul --version )
    # Consul v1.12.2
    # Revision 19041f20
    # Protocol 2 spoken by default, understands 2 to 3 (agent will automatically use protocol >2 when speaking to compatible agents)
    if [[ "${CONSUL_LATEST_VERSION}" == *"${RESPONSE}"* ]]; then  # contains it:
        note "consul version installed: ${RESPONSE}"
        if [[ "${CONSUL_VERSION}" == *"${CONSUL_LATEST_VERSION}"* ]]; then  # contains it:
            info "consul binary is already at the latest version ${CONSUL_LATEST_VERSION}."
            which consul
            note "Exiting..."
            exit
        else
            warning "consul binary being replaced with version ${CONSUL_VERSION}."
        fi
    fi

    # NOTE: There are /usr/local/bin/consul and /usr/local/bin/consul-k8s  
    # There is /opt/homebrew/bin//consul-terraform-sync installed by homebrew
    # So /usr/local/bin should be at the front of $PATH in .bash_profile or .zshrc
    # echo "*** which consul (/usr/local/bin/consul)"
    which consul
fi


# See https://tinkerlog.dev/journal/verifying-gpg-signatures-history-terms-and-a-how-to-guide
# Alternately, see https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/terraform-debian.sh
# Automation of steps described at 
                     #  https://github.com/sethvargo/hashicorp-installer/blob/master/hashicorp.asc
# curl -o hashicorp.asc https://raw.githubusercontent.com/sethvargo/hashicorp-installer/master/hashicorp.asc
if [ ! -f "hashicorp.asc" ]; then  # not found:
    note "Downloading HashiCorp's public asc file (7177 bytes)"
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
    note "Using existing HashiCorp.asc file ..."
fi
if [ ! -f "hashicorp.asc" ]; then  # not found:
   fatal "Download of hashicorp.asc failed. Aborting."
else
   ls -alT hashicorp.asc
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
    # The "C874..." fingerprint is used for verification

h2 "Verifying hashicorp fingerprint ..."
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

# TODO: Add install of more HashiCorp programs: terraform, vault, consul-k8s, instruqt, etc.

# for each platform:
export PLATFORM1="$( echo $( uname ) | awk '{print tolower($0)}')"
export PLATFORM="${PLATFORM1}"_"$( uname -m )"
success "CONSUL_VERSION=$CONSUL_VERSION on PLATFORM=${PLATFORM}"
# For PLATFORM="darwin_arm64" amd64, freebsd_386/amd64, linux_386/amd64/arm64, solaris_amd64, windows_386/amd64
if [ ! -f "consul_${CONSUL_VERSION}_${PLATFORM}.zip" ]; then  # not found:
    wget "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_${PLATFORM}.zip"
        # https://releases.hashicorp.com/consul/
    # consul_1.12.2+ent_d 100%[===================>]  44.59M  4.14MB/s    in 13s     
else
    note "consul_${CONSUL_VERSION}_${PLATFORM}.zip already downloaded."
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
    success "${EXPECTED_TEXT} verified."
else
    fail "Signature FAILED verification: ${RESPONSE}"
    # If the file was manipulated, you'll see "gpg: BAD signature from ..."
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
    success "Download verified: ${EXPECTED_TEXT} "
else
    fatal "${EXPECTED_TEXT} FAILED verification: ${RESPONSE}"
fi


if ! command -v consul ; then  # NOT found:
    note "*** consul not installed."
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


h2 "Unzip ..."
if [ -f "consul_${CONSUL_VERSION}_${PLATFORM}.zip" ]; then  # found:
    yes | unzip "consul_${CONSUL_VERSION}_${PLATFORM}.zip" consul
        # yes | to avoid prompt: replace consul? [y]es, [n]o, [A]ll, [N]one, [r]ename: 
        # specifying just consul so EULA.txt and TermsOfEvaluation.txt are not downloaded.
fi

if [ ! -f "consul" ]; then  # not found:
    fatal "consul file not found. Aborting."
fi


h2 "Move consul executable binary to folder in PATH ..."
mv consul "${TARGET_FOLDER}"
if [ ! -f "${TARGET_FOLDER}/consul" ]; then  # not found:
   fatal "${TARGET_FOLDER}/consul not found after move. Aborting."
fi


# Cleanup:
h2 "Removing downloaded files no longer needed ..."
rm "hashicorp.asc"
rm "consul_${CONSUL_VERSION}_SHA256SUMS"
rm "consul_${CONSUL_VERSION}_SHA256SUMS.72D7468F.sig"
rm "consul_${CONSUL_VERSION}_SHA256SUMS.sig"
rm "consul_${CONSUL_VERSION}_${PLATFORM}.zip"

# Now you can do git push.

note "consul_${CONSUL_VERSION} date/time stamp and bytes:"
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
   fatal "Consul ${CONSUL_VERSION} is NOT the desired version! Aborting."
fi


h2 "END"
# END