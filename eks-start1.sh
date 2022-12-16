#!/usr/bin/env sh
# This is eks-start1.sh at https://github.com/wilsonmar/mac-setup/blob/master/eks-start1.sh
# which automates manual steps at https://aws-ia.github.io/terraform-aws-eks-blueprints/main/getting-started/
# as described at https://wilsonmar.github.io/terraform/#example-eks-cluster-with-new-vpc

# Copy and paste this:
# curl -s "https://raw.githubusercontent.com/wilsonmar/mac-setup/master/eks-start1.sh" \
# --output eks-start1.sh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/mac-setup/master/eks-start1.sh)"

# shellcheck disable=SC3010,SC2155,SC2005,SC2046
   # SC3010 POSIX compatibility per http://mywiki.wooledge.org/BashFAQ/031 where [[ ]] is undefined.
   # SC2155 (warning): Declare and assign separately to avoid masking return values.
   # SC2005 (style): Useless echo? Instead of 'echo $(cmd)', just use 'cmd'.
   # SC2046 (warning): Quote this to prevent word splitting.

### STEP 01. Capture starting information for display later:
# See https://wilsonmar.github.io/mac-setup/#StartingTimes
THIS_PROGRAM="$0"
SCRIPT_VERSION="v0.24 # kubectl get pods --all-namespaces"
LOG_DATETIME=$( date +%Y-%m-%dT%H.%M.%S%z)
# clear  # Terminal screen (but not history)
echo "=========================== ${LOG_DATETIME} ${THIS_PROGRAM} ${SCRIPT_VERSION}"
EPOCH_START="$( date -u +%s )"  # such as Linux Epoch 1572634619

### STEP 02. Display a menu if no parameter is specified in the command line
# See https://wilsonmar.github.io/mac-setup/#Args
# See https://wilsonmar.github.io/mac-setup/#EchoFunctions
args_prompt() {
   echo "OPTIONS:"
   echo "   -h          #  show this help menu by running without any parameters"
   echo "   -cont       #  continue (NOT stop) on error"
   echo "   -v          # -verbose (list more details to console)"
   echo "   -vv         # -very verbose diagnostics (tracing)"
   echo "   -x          #  set -x to display every console command"
   echo "   -q          # -quiet headings for each step"
   echo " "
   echo "   -vers       #  list versions released"
   echo "   -I          # -Install utilities brew, etc. (default is install)"
   echo "   -tf \"1.3.6\"            # version of Terraform to install"
   echo "   -gpg        #  Install gpg2 utility and generate key if needed"
   echo "   -email \"johndoe@gmail.com\"     # to generate GPG keys for"
   echo " "
   echo "   -DGB        # Delete GitHub at Beginning (to download again)"
   echo "   -c          # -clone again from GitHub (default uses what exists)"
   echo "   -GFP \"$HOME/githubs\"   # Folder path to install repo from GitHub"
#   echo "   -G          # -GitHub is the basis for program to run"
   echo " "
   echo "   -aws        # -AWS cloud awscli"
   echo "   -region \"us-east-1\"    # region in the cloud awscli"
#   echo "   -consul \"1.13.1\"  # Specify version of Consul to install"
#   echo "   -oss        #  Install Open Source instead of default Enterprise ed."
   echo " "
   echo "   -KTD        # Kubernetes Terraform Deploy"
   echo "   -DTB        # Destroy Terraform-created resources at Beginning of run"
   echo "   -DTE        # Destroy Terraform-created resources at End of run"
   echo "   -DLE        # Destroy Terraform-created Logs at End of run"
   echo " "
   echo "USAGE EXAMPLES:"
   echo "# (one time) change permission to enable run:"
   echo "chmod +x eks-start1.sh"
   echo ""
   echo "./eks-start1.sh -vers -v   # list versions & release details, then stop"
   echo "./eks-start1.sh -v -I  # install"
   echo "time ./eks-start1.sh -v -KTD"
}  # args_prompt()

if [ $# -eq 0 ]; then
   args_prompt
   exit 1
fi
exit_abnormal() {            # Function: Exit with error.
  echo "exiting abnormally"
  #args_prompt
  exit 1
}

### STEP 03. Define variables (and default values) for use as "feature flags":
   CONTINUE_ON_ERR=false        # -cont
   RUN_VERBOSE=false            # -v
   LIST_VERSIONS=false          # -vers
   RUN_DEBUG=false              # -vv
   SET_TRACE=false              # -x
   RUN_QUIET=false              # -q
   TARGET_FOLDER_PARM=""        # -installdir "/usr/local/bin"
   INSTALL_UTILS=false          # -I
   INSTALL_GPG=false            # -gpg
   GET_ASC=false                # -asc
   CONSUL_VERSION_PARM=""       # -consul 1.13.1
   INSTALL_TERRAFORM=false      # -tf
   INSTALL_TF=false             # -tf
   TF_VERSION_PARM=""           # -tf "1.13.1"

   INSTALL_OPEN_SOURCE=false    # -oss turns to true
   MY_EMAIL_ADDRESS=""          # johndoe@gmail.com

   GITHUB_FOLDER_PATH=""        # -GFP (default "$HOME/githubs")
   DEL_GH_AT_BEG=false          # -DGB
   CLONE_GITHUB=false           # -c

   REMOVE_GITHUB_AFTER=false    # -R

   CLOUD_REGION=""              # -region us-west-2 default
   USE_AWS_CLOUD=false          # -aws
   # From AWS Management Console https://console.aws.amazon.com/iam/
   #   AWS_OUTPUT_FORMAT="json"  # asked by aws configure CLI.
   # EKS_CLUSTER_FILE=""   # cluster.yaml instead
   
   KUBE_TF_DEPLOY=false          # -KTD
   KUBE_NAMESPACE="kube-system"

# Post-processing:
   DEL_TF_RESC_AT_BEG=false     # -DTB
   DEL_TF_RESC_AT_END=false     # -DTE
   DEL_TF_LOGS_AT_END=false     # -DLE


### STEP 04. Custom functions to format echo text to screen
# See https://wilsonmar.github.io/mac-setup/#TextColors
# \e ANSI color variables are defined in https://wilsonmar.github.io/bash-scripts#TextColors
h2() { if [ "${RUN_QUIET}" = false ]; then    # heading
   printf "\n\e[1m\e[33m\u2665 %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
   fi
}
info() {   # output on every run to show values used in run:
   printf "\e[2m\n➜ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
# Display only if -v parameter is specified:
note() { if [ "${RUN_VERBOSE}" = true ]; then
   printf "\n\e[1m\e[36m \e[0m \e[36m%s\e[0m" "$(echo "$@" | sed '/./,$!d')"
   printf "\n"
   fi
}
success() {  # Green
   printf "\n\e[32m\e[1m✔ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
# To warn about defaults applied:
warning() {  # White bold &#9758; or &#9755;
   printf "\n\e[47m\e[1m☞ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
error() {    # Red &#9747;
   printf "\n\e[31m\e[1m✖ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
# Unrecoverable errors that require abort for developer to fix:
fatal() {   # Skull: &#9760;  # Star: &starf; &#9733; U+02606  # Toxic: &#9762;
   printf "\n\e[31m\e[1m☢  %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
   exit 9
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


h2 "STEP 05. Set variables dynamically based on each parameter flag:"
# See https://wilsonmar.github.io/mac-setup/#VariablesSet
while test $# -gt 0; do
  case "$1" in
    -aws)
      export USE_AWS_CLOUD=true
      shift
      ;;
    -cont)
      export CONTINUE_ON_ERR=true
      shift
      ;;
    -c)
      export CLONE_GITHUB=true
      shift
      ;;
    -consul*)
      shift
      CONSUL_VERSION_PARM=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      # GET_ASC=true
      shift
      ;;
    -DGB)
      export DEL_GH_AT_BEG=true
      shift
      ;;
    -DLE)
      export DEL_TF_LOGS_AT_END=true
      shift
      ;;
    -DTB)
      export DEL_TF_RESC_AT_BEG=true
      shift
      ;;
    -DTE)
      export DEL_TF_RESC_AT_END=true
      shift
      ;;
    -email*)
      shift
      MY_EMAIL_ADDRESS=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      shift
      ;;
    -gpg)
      export INSTALL_GPG=true
      shift
      ;;
    -h)
      args_prompt
      exit 1
      shift
      ;;
    -installdir*)
      shift
      TARGET_FOLDER_PARM=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      shift
      ;;
    -KTD)
      export KUBE_TF_DEPLOY=true
        GITHUB_REPO_FOLDER="terraform-aws-eks-blueprints"
        GITHUB_REPO_URL="https://github.com/aws-ia/terraform-aws-eks-blueprints"
        GITHUB_PROJ_PATH="examples"
        # From https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/main/examples
        GITHUB_PROJ_FOLDER="eks-cluster-with-new-vpc"
        K8S_CLUSTER_ID="${GITHUB_PROJ_FOLDER}"
      shift
      ;;
    -NI)
      export INSTALL_UTILS=true
      shift
      ;;
    -N*)
      shift
      GITHUB_FOLDER_PATH=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export GITHUB_FOLDER_PATH
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
    -region*)
      shift
      CLOUD_REGION=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      shift
      ;;
    -tf*)
      shift
      TF_VERSION_PARM=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      # There is no Enteprise Terraform version executable:
      INSTALL_TF=true
      # GET_ASC=true
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

# See https://docs.aws.amazon.com/general/latest/gr/rande.html
# https://docs.aws.amazon.com/general/latest/gr/rande-manage.html

h2 "STEP 06a. Obtain info about the OS and define which package manager to use:"
# See https://wilsonmar.github.io/mac-setup/#OSDetect
export OS_TYPE="$( uname )" 
export OS_DETAILS=""  # default blank.
export PACKAGE_MANAGER=""
if [ "${OS_TYPE}" = "Darwin" ]; then  # it's on a Mac:
    export OS_TYPE="macOS"
    export PACKAGE_MANAGER="brew"

#    h2 "STEP 06b. Set sleep off (sudo requires password):"
#    # See https://wilsonmar.github.io/mac-setup/#NeverSleep
#    RESPONSE=$( sudo systemsetup -getcomputersleep | awk '{print $3}' )
#        # "Never" from Computer Sleep: Never 
#    if [[ "${MACHINE_TYPE}" == *"Never"* ]]; then
#       info "Already at Never"
#    else
#       sudo systemsetup -setcomputersleep Never
#        # 2022-12-10 14:33:10.540 systemsetup[54166:30878895] ### Error:-99 File:/AppleInternal/Library/BuildRoots/a0876c02-1788-11ed-b9c4-96898e02b808/Library/Caches/com.apple.xbs/Sources/Admin/InternetServices.m Line:379
#    fi

# else Windows, Linux...
fi
# For HashiCorp downloading:
export PLATFORM1="$( echo $( uname ) | awk '{print tolower($0)}')"  # darwin
export PLATFORM="${PLATFORM1}"_"$( uname -m )"  # "darwin_arm64"
# For PLATFORM="darwin_arm64" amd64, freebsd_386/amd64, linux_386/amd64/arm64, solaris_amd64, windows_386/amd64


h2 "STEP 07. Set Continue on Error and Trace:"
# See https://wilsonmar.github.io/mac-setup/#StrictMode
if [ "${CONTINUE_ON_ERR}" = true ]; then  # -cont
   warning "Set to continue despite error ..."
else
   note "Set -e (error stops execution) ..."
   set -e  # uxo pipefail  # exits script when a command fails
   # ALTERNATE: set -eu pipefail  # pipefail counts as a parameter
fi
if [ "${SET_TRACE}" = true ]; then
   h2 "Set -x ..."
   set -x  # (-o xtrace) to show commands for specific issues.
fi
# set -o nounset


h2 "STEP 08. Print run Operating environment information:"
note "Running $0 in $PWD"  # $0 = script being run in Present Wording Directory.
note "Apple macOS sw_vers = $(sw_vers -productVersion) / uname -r = $(uname -r)"  # example: 10.15.1 / 21.4.0

# See https://wilsonmar.github.io/mac-setup/#BashTraps
note "OS_TYPE=$OS_TYPE using PACKAGE_MANAGER=$PACKAGE_MANAGER"
HOSTNAME="$( hostname )"
   note "on hostname=$HOSTNAME "
PUBLIC_IP=$( curl -s ifconfig.me )
INTERNAL_IP=$( ipconfig getifaddr en0 )
   note "at PUBLIC_IP=$PUBLIC_IP, internal $INTERNAL_IP"

if [ "$OS_TYPE" = "macOS" ]; then  # it's on a Mac:
   export MACHINE_TYPE="$(uname -m)"
   if [[ "${MACHINE_TYPE}" == *"arm64"* ]]; then
      # On Apple M1 Monterey: /opt/homebrew/bin is where Zsh looks (instead of /usr/local/bin):
      export BREW_PATH="/opt/homebrew/bin"
      # eval $( "${BREW_PATH}/bin/brew" shellenv)
      export BASHFILE="$HOME/.zshrc"
   elif [[ "${MACHINE_TYPE}" == *"x86_64"* ]]; then
      export BREW_PATH="/usr/local/bin"
      export BASHFILE="$HOME/.bash_profile"
      #note "BASHFILE=~/.bashrc ..."
      #BASHFILE="$HOME/.bashrc"  # on Linux
   fi  # MACHINE_TYPE
   note "OS_TYPE=$OS_TYPE MACHINE_TYPE=$MACHINE_TYPE BREW_PATH=$BREW_PATH"
else
   fatal "OS_TYPE=$OS_TYPE is all this can handle at the moment."
   exit -9
    # Linux:
    # Use yum on CentOS and older Red Hat based distributions.
    # Use dnf on Fedora and other newer Red Hat distributions.
    # Use zypper on OpenSUSE based distributions   
fi


h2 "STEP 09. Set executable target folder based on call parameter:"
if [ -n "${TARGET_FOLDER_PARM}" ]; then  # specified by parameter
   TARGET_FOLDER="${TARGET_FOLDER_PARM}"
   echo "*** Using TARGET_FOLDER specified by parm -=\"$TARGET_FOLDER_PARM\" ..."
elif [ -n "${TARGET_FOLDER_IN}" ]; then  # specified by parameter
   TARGET_FOLDER="${TARGET_FOLDER_IN}"
   echo "*** Using TARGET_FOLDER_IN specified before invoke: \"$TARGET_FOLDER_IN\" ..."
else
   TARGET_FOLDER="$BREW_PATH"  # from above.
   echo "*** Using default TARGET_FOLDER=\"$TARGET_FOLDER\" ..."
fi

if [[ ! ":$PATH:" == *":$TARGET_FOLDER:"* ]]; then
   fatal "TARGET_FOLDER=\"${TARGET_FOLDER}\" not in PATH to be found. Aborting."
fi


h2 "STEP 10. Install base utilities (if parameter allows):"
if [ "${INSTALL_UTILS}" = true ]; then  # -NI NOT specified

    # Homebrew now runs xcode-select --install for command line tools for gcc, clang, git ..."
    # On Apple Silicon machines, there's one more step. Homebrew files are installed into the /opt/homebrew folder. 
    # But the folder is not part of the default $PATH. So follow Homebrew's advice and create a ~/.zprofile
    # Add Homebrew to your PATH in ~/.zprofile:
    # echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    # eval "$(/opt/homebrew/bin/brew shellenv)"

    #h2 "STEP 10a. Install XCode Command Utilities"
    #if ! command -v clang >/dev/null; then
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


    if ! command -v brew >/dev/null; then
        h2 "STEP 10b. Installing brew package manager on macOS using Ruby ..."
        mkdir homebrew && curl -L https://GitHub.com/Homebrew/brew/tarball/master \
            | tar xz --strip 1 -C homebrew
        # brew upgrades itself later.
    fi
    brew install jq  curl  wget  tree  git
    # STEP 10d. Installing Linux equivalents for MacOS ..."
    brew install gnu-getopt coreutils xz gzip bzip2 lzip zstd
    # STEP 10e. Install Visual Studio Code editor (if parameter allows):"
    brew install --cask visual-studio-code
    # h2 "STEP 10f. Install kubectl, tfsec, and other scanners:"
    brew install kubectl
    brew install tfsec

    # TODO: STEP 10c. Add install of more utilities: python, shellcheck, go
    # TODO: Add install of more HashiCorp programs: vault, consul, consul-k8s, instruqt, etc.

    # See https://wilsonmar.github.io/mac-setup/#AWS
    if [ "${USE_AWS_CLOUD}" = true ]; then   # -aws

       h2 "STEP 11. Install awscli, eksctl:"
       # For aws-cli commands, see http://docs.aws.amazon.com/cli/latest/userguide/ 
       brew install awscli
       brew install eksctl

       # h2 "aws version ..."  
       note "$( aws --version )"  
          # aws-cli/2.9.4 Python/3.11.0 Darwin/21.6.0 source/arm64 prompt/off
          # aws-cli/2.6.1 Python/3.9.12 Darwin/21.4.0 source/arm64 prompt/off
          # aws-cli/2.0.9 Python/3.8.2 Darwin/19.5.0 botocore/2.0.0dev13
       note "which aws at $( which aws )"  
          # /opt/homebrew/bin//aws
          # /usr/local/bin/aws
    fi

    h2 "STEP 12. Install GPG2:"
    if ! command -v gpg >/dev/null; then
        # Install gpg if needed: see https://wilsonmar.github.io/git-signing
        note "brew install gnupg2 (gpg) for Terminal use ..."
    # brew install --cask gpg-suite   # GUI 
    brew install gnupg2
        # Above should create folder "${HOME}/.gnupg"
    fi

fi  #INSTALL_UTILS

# "STEP 13. Saved for future use"

h2 "STEP 14. Verify Region in ~/.aws/config :"
cat ~/.aws/config

if [ -z "${CLOUD_REGION}" ]; then  # not found:
   export AWS_REGION="us-west-2"
   warning "-region not specified in parameter, set to default \"$AWS_REGION\" "
else
   export AWS_REGION="${CLOUD_REGION}"
   info "AWS region \"$AWS_REGION\" set from parameter."
fi


h2 "STEP 25. List app versions if requested by \"-vers\" parameter:"
if [ "${LIST_VERSIONS}" = true ]; then  # -vers
    note "Look at browser for https://releases.hashicorp.com/terraform"
    TF_VER_LIST="https://releases.hashicorp.com/terraform"
    open "${TF_VER_LIST}"
    # FIXME: Wait until it appears?

    if [ "${RUN_VERBOSE}" = true ]; then  # -v
        note "Look at browser for https://github.com/hashicorp/terraform/releases"
        # show website with description of each release:
        TF_VER_LIST="https://github.com/hashicorp/terraform/releases"
        open "${TF_VER_LIST}"
    fi
    # note "Exiting because attention switched to browser page."
    # exit
fi


if [ "${INSTALL_TF}" = true ]; then  # -tf

    h2 "STEP 26. Lookup latest Terraform app version:"
    TF_LATEST_VERSION=$( curl -sS https://api.releases.hashicorp.com/v1/releases/terraform/latest |jq -r .version )
    # Example: "1.3.6"
    if [[ "${TF_LATEST_VERSION}" == *"null"* ]]; then
        fatal "null TF_VERSION_PARM"
        exit 9
    else
        info "Latest Terraform version is \"${TF_LATEST_VERSION}\" ..."
    fi

    h2 "STEP 27. Determine what version of Terraform to install:"
    if [ -z "${TF_VERSION_PARM}" ]; then  # is NOT specified
        note "-tf parameter not specified with a version."
        export TF_VERSION_PARM="${TF_LATEST_VERSION}"
        note "-tf ${TF_LATEST_VERSION} is assumed based on the latest version."
    fi  # parameter specified:

fi # INSTALL_TF


if [ "${GET_ASC}" = true ]; then  # -asc

    h2 "STEP 15. Ensure an email is provided for GPG (if parameter allows):"
    if [ -z "${MY_EMAIL_ADDRESS}" ]; then  # not found:
        read -e -p "Input email address: " MY_EMAIL_ADDRESS
        # check for @ in email address:
        if [[ ! "$MY_EMAIL_ADDRESS" == *"@"* ]]; then
            fatal "MY_EMAIL_ADDRESS \"$MY_EMAIL_ADDRESS\" does not contain @. Aborting."
        fi
    fi


    h2 "STEP 16. Ensure a key was created for $MY_EMAIL_ADDRESS:"
    RESPONSE=$( gpg2 --list-keys )
            # pub   rsa4096 2021-06-20 [SC] [expires: 2025-06-20]
            #    123456789E91004D4C5D88CAE21961814AC0EF1B
            # uid           [ultimate] John Doe <johndoe+github@gmail.com>
    if [[ "${RESPONSE}" == *"<${MY_EMAIL_ADDRESS}>"* ]]; then  # contains it:
        success "MY_EMAIL_ADDRESS $MY_EMAIL_ADDRESS found among GPG keys ..."
        if [ "${RUN_VERBOSE}" = true ]; then  # -v
            echo "$RESPONSE"
        fi
    else
        warning "MY_EMAIL_ADDRESS $MY_EMAIL_ADDRESS NOT found among GPG keys ..."
        # TODO: recover by creating key rather than  # exit 9

        h2 "STEP 17. Set permission for the folder and conf file:"
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

        h2 "STEP 18: Generate 4096-bit RSA GPG key for $MY_EMAIL_ADDRESS ..."
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

        h2 "STEP 19: Generate key pair:"
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

        h2 "STEP 20: Create a public GPG (.asc) file between BEGIN PGP PUBLIC KEY BLOCK-----"
        gpg --armor --export $MY_EMAIL_ADDRESS > "$MY_EMAIL_ADDRESS.asc"
        ls -alT "$MY_EMAIL_ADDRESS.asc"

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

    echo "DEBUGGING 1";exit

        # Update the gpgconf file dynamically
        # echo ‘default-key:0:”xxxxxxxxxxxxxxxxxxxx’ | gpgconf —change-options gpg
            # note there is only ONE double-quote to signify a text string is about to begin.
            # There is a pair of single-quote surrounding the entire echo statement.
        h2 "$HOME/.gnupg/gpg.conf now contains ..."
        cat "$HOME/.gnupg/gpg.conf"

    echo "DEBUGGING 2";exit

        h2 "STEP 21: "
        gpg2 -d "$MY_EMAIL_ADDRESS.asc"
        rm "$MY_EMAIL_ADDRESS.asc"

        # TODO: Verify
        # default-key "${RESPONSE}"  # contents = 123456789E91004D4C5D88CAE21961814AC0EF1B
            # cat $HOME/.gnupg/gpg.conf should now contain:
            # auto-key-retrieve
            # no-emit-version
            # use-agent
            # default-key 123456789E91004D4C5D88CAE21961814AC0EF1B

    fi  # MY_EMAIL_ADDRESS


    h2 "STEP 22. Get HashiCorp ASC key:"
    # See https://tinkerlog.dev/journal/verifying-gpg-signatures-history-terms-and-a-how-to-guide
    # Alternately, see https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/terraform-debian.sh
    # Automation of steps described at 
                        #  https://github.com/sethvargo/hashicorp-installer/blob/master/hashicorp.asc
    # curl -o hashicorp.asc https://raw.githubusercontent.com/sethvargo/hashicorp-installer/master/hashicorp.asc

    # From GUI: https://keybase.io/hashicorp says 64-bit: 3436 5D94 72D7 468F
    # 34365D9472D7468F Created 2021-04-19 (after the Codedev supply chain attack)
    # TODO: Manual extract and paste here:
    export ASC_SHA="72D7468F"
    note "ASC_SHA=${ASC_SHA}"

    if [ ! -f "hashicorp.asc:?" ]; then  # not found:
        note "STEP 22. Downloading HashiCorp ASC key to $PWD:"
        # Get PGP Signature from a commonly trusted 3rd-party (Keybase) - asc file applicable to all HashiCorp products.

        # This does not return a file anymore:
        wget --no-check-certificate -q hashicorp.asc https://keybase.io/hashicorp/pgp_keys.asc || 
        # Alternately: 
        sudo curl -s "https://keybase.io/_/api/1.0/key/fetch.json?pgp_key_ids=34365D9472D7468F" | jq -r '.keys | .[0] | .bundle' > "hashicorp.asc"
        # Get public key:
            # See https://discuss.hashicorp.com/t/hcsec-2021-12-codecov-security-event-and-hashicorp-gpg-key-exposure/23512
            # And https://www.securityweek.com/twilio-hashicorp-among-codecov-supply-chain-hack-victims
            # See https://circleci.com/developer/orbs/orb/jmingtan/hashicorp-vault
        if [ ! -f "hashicorp.asc" ]; then  # still not found:
            fatal "Download of hashicorp.asc failed. Aborting."
            exit 9
        else
            note "Using newly downloaded hashicorp.asc file ..."
            ls -alT hashicorp.asc
        fi
    else
        note "Using existing hashicorp.asc file  (7717 bytes?) ..."
        ls -alT hashicorp.asc
    fi

    h2 "STEP 23: gpg Verify hashicorp fingerprint:"
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

    # "Extract 2nd line (containing fingerprint):"
    RESPONSE2=$( echo "$RESPONSE" | sed -n 2p ) 
    # Remove spaces:
    FINGERPRINT=$( echo "${RESPONSE2}" | xargs )
    # Verify we want key ID 72D7468F and fingerprint C874 011F 0AB4 0511 0D02 1055 3436 5D94 72D7 468F. 
    VERIF=$( gpg --fingerprint "${FINGERPRINT}" )
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

fi # GET_ASC


Install_terraform(){  # function

    h2 "STEP 29. Download version ${TF_VERSION_PARM} of Terraform ${ASC_SHA}:"
    if [ ! -f "terraform_${TF_VERSION_PARM}_${PLATFORM}.zip" ]; then  # not found:
        wget "https://releases.hashicorp.com/terraform/${TF_VERSION_PARM}/terraform_${TF_VERSION_PARM}_${PLATFORM}.zip"
            # https://releases.hashicorp.com/terraform/
        # terraform_1.3.6_darwin_arm64.zip  18.39M  4.04MB/s    in 4.9s    
    else
        note "terraform_${TF_VERSION_PARM}_${PLATFORM}.zip already downloaded."
    fi

    if [ ! -f "terraform_${TF_VERSION_PARM}_SHA256SUMS" ]; then  # not found:
        wget "https://releases.hashicorp.com/terraform/${TF_VERSION_PARM}/terraform_${TF_VERSION_PARM}_SHA256SUMS"
        # terraform_1.3.6_SHA256SUMS   1.35K  --.-KB/s    in 0s
    fi

    if [ ! -f "terraform_${TF_VERSION_PARM}_SHA256SUMS.${ASC_SHA}.sig" ]; then  # not found:
        wget "https://releases.hashicorp.com/terraform/${TF_VERSION_PARM}/terraform_${TF_VERSION_PARM}_SHA256SUMS.${ASC_SHA}.sig"
        # terraform_1.3.6_SHA256SUMS.72D74   566  --.-KB/s    in 0s  
    fi

    if [ ! -f "terraform_${TF_VERSION_PARM}_SHA256SUMS.sig" ]; then  # not found:
        wget "https://releases.hashicorp.com/terraform/${TF_VERSION_PARM}/terraform_${TF_VERSION_PARM}_SHA256SUMS.sig"
        # terraform_1.3.6_SHA256SUMS.sig   566  --.-KB/s    in 0s
    fi

    h2 "STEP 30. gpg --verify terraform_${TF_VERSION_PARM}_SHA256SUMS.sig terraform_${TF_VERSION_PARM}_SHA256SUMS"
    RESPONSE=$( gpg --verify "terraform_${TF_VERSION_PARM}_SHA256SUMS.sig" \
        "terraform_${TF_VERSION_PARM}_SHA256SUMS" )
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
        fatal "Signature FAILED verification: ${RESPONSE}"
        # If the file was manipulated, you'll see "gpg: BAD signature from ..."
    fi

    h2 "STEP 31. Verify that SHASUM matches the archive ..."
    export EXPECTED_TEXT="terraform_${TF_VERSION_PARM}_${PLATFORM}.zip: OK"
        # terraform_1.12.2+ent_darwin_arm64.zip: OK
    RESPONSE=$( yes | shasum -a 256 -c "terraform_${TF_VERSION_PARM}_SHA256SUMS" 2>/dev/null | grep "${EXPECTED_TEXT}" )
        # yes | to avoid "replace EULA.txt? [y]es, [n]o, [A]ll, [N]one, [r]ename:"
        # shasum: terraform_1.12.2+ent_darwin_amd64.zip: No such file or directory
        # terraform_1.12.2+ent_darwin_amd64.zip: FAILED open or read
        # terraform_1.12.2+ent_darwin_arm64.zip: OK
    if [[ "${EXPECTED_TEXT}" == *"${RESPONSE}"* ]]; then  # contains it:
        success "Download verified: ${EXPECTED_TEXT} "
    else
        fatal "${EXPECTED_TEXT} FAILED verification: ${RESPONSE}"
    fi

    TF_INSTALLED_AT=$( command -v terraform )  # response: /opt/homebrew/bin/terraform
    if [ -z "${TF_INSTALLED_AT}" ]; then  # NOT found:
        fatal "Terraform ${TF_VERSION_PARM} not installed!"
        exit 9
    else
        h2 "STEP 32. Remove existing terraform from path \"${TARGET_FOLDER}\" "
        if [ -f "${TARGET_FOLDER}/terraform" ]; then  # specified by parameter
            echo "*** removing existing terraform binary file from \"$TARGET_FOLDER\" before unzip of new file:"
            ls -alT "${TARGET_FOLDER}/terraform"
            # -rwxr-xr-x@ 1 user  group  127929168 Jun  3 13:46 2022 /usr/local/bin/terraform
            
            # Kermit TODO: Change file name with time stamp instead of removing.
            rm "${TARGET_FOLDER}/terraform"
        fi
    fi

    h2 "STEP 33. Unzip ..."
    if [ -f "terraform_${TF_VERSION_PARM}_${PLATFORM}.zip" ]; then  # found:
        yes | unzip "terraform_${TF_VERSION_PARM}_${PLATFORM}.zip" terraform
            # yes | to avoid prompt: replace terraform? [y]es, [n]o, [A]ll, [N]one, [r]ename: 
            # specifying just terraform so EULA.txt and TermsOfEvaluation.txt are not downloaded.
    fi

    if [ ! -f "terraform" ]; then  # not found:
        fatal "terraform file not found. Aborting."
    fi

    h2 "STEP 34. Move terraform executable binary to folder in PATH $TARGET_FOLDER"
    mv terraform "${TARGET_FOLDER}"
    if [ ! -f "${TARGET_FOLDER}/terraform" ]; then  # not found:
       fatal "${TARGET_FOLDER}/terraform not found after move. Aborting."
    fi

    h2 "STEP 35. Confirm install $TF_VERSION_PARM:"
    TF_VERSION=$( terraform --version | head -1 | awk '{print $2}' )
    # Remove leading v character in v1.3.6
    TF_VERSION="${TF_VERSION:1}"
    if [[ "${TF_VERSION_PARM}" == "${TF_VERSION}" ]]; then  # contains it:
       info "TF_VERSION ${TF_VERSION} downloaded is as requested."
    else
       fatal "TF_VERSION ${TF_VERSION} downloaded not ${TF_VERSION_PARM} requested."
       exit 9
    fi

} ## Function Install_TF()

if [ "${INSTALL_TF}" = true ]; then  # -tf

    h2 "STEP 28. Determine what version of Terraform is already installed:"
    TF_INSTALLED_AT=$( command -v terraform )  # response: /opt/homebrew/bin//terraform
    if [ -n "${TF_INSTALLED_AT}" ]; then  # some version is installed
        RESPONSE=$( terraform --version | head -1 | awk '{print $2}' )
                # Terraform v1.2.5
                # on darwin_arm64
                # Your version of Terraform is out of date! The latest version
        RESPONSE="${RESPONSE:1}"
        if [[ "${TF_VERSION_PARM}" == *"${RESPONSE}"* ]]; then  # contains it:
            info "Current Terraform version $RESPONSE already at $TF_INSTALLED_AT"
            # No need to install.
        else  # Install:
            # DO NOT simply get latest per https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
            # brew tap hashicorp/tap
            # brew install terraform
        
            Install_terraform  # function
        fi
    else  # NO version is installed:
        Install_terraform  # function STEP 29-35
    fi

    h2 "STEP 36. Confirm install of Terraform ${TF_VERSION_PARM}:"
    TF_VERSION=$( terraform --version | head -1 | awk '{print $2}' )
    TF_VERSION="${TF_VERSION}"
    if [[ "${TF_VERSION_PARM}" != *"${TF_VERSION}"* ]]; then  # contains it:
       fatal "Terraform binary ${TF_VERSION} just installed is not the ${TF_LATEST_VERSION} requested."
       exit 9
    fi

    h2 "STEP 37. Removing downloaded files no longer needed:"
    FILE_TO_DELETE="hashicorp.asc"
    if [ -f "${FILE_TO_DELETE}" ]; then  # found - remove
        rm "${FILE_TO_DELETE}"
    fi
    FILE_TO_DELETE="terraform_${TF_VERSION}_SHA256SUMS"
    if [ -f "${FILE_TO_DELETE}" ]; then  # found - remove
        rm "${FILE_TO_DELETE}"
    fi
    FILE_TO_DELETE="terraform_${TF_VERSION}_SHA256SUMS.${ASC_SHA}.sig"
    if [ -f "${FILE_TO_DELETE}" ]; then  # found - remove
        rm "${FILE_TO_DELETE}"
    fi
    FILE_TO_DELETE="terraform_${TF_VERSION}_SHA256SUMS.sig"
    if [ -f "${FILE_TO_DELETE}" ]; then  # found - remove
        rm "${FILE_TO_DELETE}"
    fi
    FILE_TO_DELETE="terraform_${TF_VERSION}_${PLATFORM}.zip"
    if [ -f "${FILE_TO_DELETE}" ]; then  # found - remove
        rm "${FILE_TO_DELETE}"
    fi

fi  # INSTALL_TF


######################

note "Now at $PWD to start."

h2 "STEP 40a. Verify AWS connectivity:"
   # https://aws.amazon.com/blogs/security/an-easier-way-to-determine-the-presence-of-aws-account-access-keys/
   RESPONSE=$( { aws iam get-account-summary | sed s/Output/Useless/ > outfile; } 2>&1 )
      # An error occurred (ExpiredToken) when calling the GetAccountSummary operation: The security token included in the request is expired
   if [[ "${RESPONSE}" == *"expired"* ]]; then
      fatal "Keys in ~/.aws/credentials have expired! Aborting run."
      exit 9
   else
      h2 "STEP 40b. Identify if resources were already created:"
   fi

k8s_nodes_pods_list(){
    # See https://wilsonmar.github.io/terraform/#k8s_nodes_pods_list

    h2 "STEP 42a. list worker nodes and pods (function k8s_nodes_pods_list):"
    RESPONSE=$( { kubectl get nodes | sed s/Output/Useless/ > outfile; } 2>&1 )
       # See https://stackoverflow.com/questions/962255/how-to-store-standard-error-in-a-variable
    if [[ "${RESPONSE}" != *"NAME"* ]]; then
        # If AWS credentials are not valid:
        # E1216 06:46:28.873204   93669 memcache.go:238] couldn't get current server API group list: the server has asked for the client to provide credentials
        # If nodes are no longer available:
        # E1214 07:58:44.629220   46304 memcache.go:238] couldn't get current server API group list: Get "https://0E7188B181023B24E8C319BB2E31DACA.gr7.us-west-2.eks.amazonaws.com/api?timeout=32s": dial tcp: lookup 0E7188B181023B24E8C319BB2E31DACA.gr7.us-west-2.eks.amazonaws.com: no such host
       warning "Command \"kubectl get nodes\" found no nodes!"
       K8S_NODES_FOUND=false
       # No need to display the error.
    else
       # Run again because precious command is bonkers:
       K8S_NODES_FOUND=true
        if [ "${RUN_VERBOSE}" = true ]; then
           kubectl get nodes
        fi
    fi

    h2 "STEP 42b. list 18 pods (function k8s_nodes_pods_list):" 
                                 # -n ${KUBE_NAMESPACE}
    RESPONSE=$( { kubectl get pods --all-namespaces | sed s/Output/Useless/ > outfile; } 2>&1 )
    if [[ "${RESPONSE}" != *"NAMESPACE"* ]]; then
       warning "Command \"kubectl get pods -n ${KUBE_NAMESPACE}\" found no hosts!"
    else
       # Run again because precious command is bonkers:
        if [ "${RUN_VERBOSE}" = true ]; then
            kubectl get pods -n ${KUBE_NAMESPACE} 
        fi
        # NAME                                                         READY
        # aws-load-balancer-controller-854cb78798-p47sr                1/1
        # aws-load-balancer-controller-854cb78798-qthql                1/1
        # aws-node-nzvzq                                               1/1
        # aws-node-pfbl2                                               1/1
        # aws-node-qcv2m                                               1/1
        # cluster-autoscaler-aws-cluster-autoscaler-7ccbf68bc9-bgzg2   1/1
        # cluster-proportional-autoscaler-coredns-6fcfcd685f-lpkwl     1/1
        # coredns-57ff979f67-mpkzg                                     1/1
        # coredns-57ff979f67-nxn6v                                     1/1
        # ebs-csi-controller-79998cddcc-67c4c                          6/6
        # ebs-csi-controller-79998cddcc-vlfm4                          6/6
        # ebs-csi-node-l8gxl                                           3/3
        # ebs-csi-node-px26g                                           3/3
        # ebs-csi-node-tbhb8                                           3/3
        # kube-proxy-2bnb4                                             1/1
        # kube-proxy-ghpm2                                             1/1
        # kube-proxy-j5c9s                                             1/1
        # metrics-server-7d76b744cd-vchnk                              1/1
    fi

    # TODO: https://kubernetes.io/docs/reference/kubectl/cheatsheet/
}

Cleanup_k8s() {

    if [ "${DEL_TF_RESC_AT_BEG}" = true ]; then  # -DTB

        h2 "STEP 90. Destroy addons:"
        terraform destroy -target="module.eks_blueprints_kubernetes_addons" \
           -auto-approve >"${LOG_DATETIME}_90_destroy_addons.log"
        echo $?

        h2 "STEP 91. Destroy blueprints:"
        terraform destroy -target="module.eks_blueprints" \
           -auto-approve >"${LOG_DATETIME}_91_destroy_eks_blueprints.log"
        echo $?

        h2 "STEP 92. Destroy vpc:"
        terraform destroy -target="module.vpc" \
           -auto-approve >"${LOG_DATETIME}_92_destroy_vpc.log"
        echo $?

        h2 "STEP 93. Destroy additional:"
        terraform destroy \
           -auto-approve >"${LOG_DATETIME}_93_destroy_additional.log"
            # Destroy complete! Resources: 93 destroyed.
        echo $?

        info "K8s resources cleaned up by function Cleanup_k8s."
    else
       info "K8s nodes may be live and -DTB parameter not specified to recreate."
       exit
    fi

    # Manually check: https://aws.amazon.com/premiumsupport/knowledge-center/check-for-active-resources/
}

k8s_nodes_pods_list
if [ "${K8S_NODES_FOUND}" = true ]; then
    if [ "${DEL_TF_RESC_AT_BEG}" = true ]; then  # -DTB
       h2 "STEP 41. Destroy at beginning:"
       Cleanup_k8s || # function defined above. 90-93
       info "K8s resources cleaned up."
    else
       info "K8s nodes are live and -DTB parameter not specified to recreate."
       # https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/
       # if -vv
          # kubectl describe pod 

    fi
fi


if [ "${KUBE_TF_DEPLOY}" = true ]; then  # -KTD

    h2 "STEP 42. Obtain GitHub repo (depending on parameters):"
    # See https://wilsonmar.github.io/mac-setup/#ObtainRepo
    # To ensure that we have a project folder (from GitHub):
    if [ -z "${GITHUB_FOLDER_PATH}" ]; then   # value not specified in parm
        note "No -GFP (GITHUB_FOLDER_PATH) specified in run parameters"
        GITHUB_FOLDER_PATH="$HOME/githubs"
        warning "Default GFP \"$GITHUB_FOLDER_PATH\" being used."
    fi
    cd  # to root folder
    cd "${GITHUB_FOLDER_PATH}" || return # as suggested by SC2164
    info "Now at ${GITHUB_FOLDER_PATH}"

    # https://www.zshellcheck.net/wiki/SC2115 :
    # Use "${var:?}" to ensure this never expands to / .
    if [ -d "${GITHUB_FOLDER_PATH:?}" ]; then  # path already created.
        note "Using existing folder at \"${GITHUB_FOLDER_PATH:?}\" to clone github"
    else
        note "Creating folder path ${GITHUB_FOLDER_PATH:?} to clone github"
        sudo mkdir -p "${GITHUB_FOLDER_PATH:?}"
    fi
    cd "${GITHUB_FOLDER_PATH:?}" || return # as suggested by SC2164
    note "Now at $PWD"

    Clone_GitHub_repo(){   # function
        note "Obtaining repo \"${GITHUB_REPO_URL:?}\" at $PWD:"
        sudo git clone "${GITHUB_REPO_URL}" --depth 1
        ls -alT "${GITHUB_REPO_FOLDER}"
        cd "${GITHUB_REPO_FOLDER}" || return # as suggested by SC2164
        note "At path $PWD"
    }
    if [ -d "${GITHUB_REPO_FOLDER:?}" ]; then  # directory already exists:
        if [ "${DEL_GH_AT_BEG}" = true ]; then   # -DGB (Delete GitHub at Beginning)
            h2 "Removing project folder $GITHUB_REPO_FOLDER:? ..."
            ls -al "${GITHUB_REPO_FOLDER}"
            sudo rm -rf "${GITHUB_REPO_FOLDER}"
        fi
        
        if [ "${CLONE_GITHUB}" = true ]; then   # -c specified to clone again:
            Clone_GitHub_repo  # function
        else
            warning "Using GitHub repo contents from previous run:"
        fi
    else  # GITHUB_REPO_FOLDER does not exist
        Clone_GitHub_repo  # function
    fi
    cd "${GITHUB_REPO_FOLDER}" || return # as suggested by SC2164
    info "Now at $PWD"
    info "$( ls -alT .git/index )"
        # .git/index holds all git history, so is changed on every git operation.

    cd "${GITHUB_PROJ_PATH}/${GITHUB_PROJ_FOLDER}" || return # as suggested by SC2164
    info "Now at $PWD"


    # h2 "STEP 43. Provide password for sudo chown and chmod:"
    # change ownership to avoid errors:
    #sudo chown -R $(whoami) .
    #sudo chmod -R +rwX .

    # Invoke upon non-0 exit in error from subsequent commands:
    trap "Cleanup_k8s" ERR

    h2 "STEP 50. tfstate file before terraform commands:"
    ls -alT terraform.tfstate

    # Among Terraform commands: https://acloudguru.com/blog/engineering/the-ultimate-terraform-cheatsheet#h-the-10-most-common-terraform-commands
    # https://k21academy.com/terraform-iac/terraform-cheat-sheet/

    # No need to check if terraform init has already been done because it is safe to run terraform init many times even if nothing changed.

    # Install Terraform provider plugins and modules that convert HCL to API calls: 
    h2 "STEP 51. terraform init: ${LOG_DATETIME}_51_tf_init.log"
    terraform init >"${LOG_DATETIME}_51_tf_init.log"
    echo $?

    h2 "STEP 52. terraform validate: ${LOG_DATETIME}_52_tf_validate.log"
    echo $?
    terraform init >"${LOG_DATETIME}_52_tf_validate.log"

    h2 "STEP 53. ${LOG_DATETIME}_53_tfsec.log"
    # || true added to ignore error 1 returned if errors are found.
    tfsec >"${LOG_DATETIME}_53_tfsec.log" || true 
    echo $?
    # TODO: other scanners (Synk, Bridgecrew, etc.) integrated by TFC

    h2 "STEP 54. terraform apply: ${LOG_DATETIME}_54_tf_apply_vpc.log"
    terraform apply -target="module.vpc" -auto-approve \
       >"${LOG_DATETIME}_54_tf_apply_vpc.log"
    echo $?

    h2 "STEP 55. terraform apply: ${LOG_DATETIME}_55_tf_apply_eks_blueprints.log"
    terraform apply -target="module.eks_blueprints" -auto-approve \
       >"${LOG_DATETIME}_55_tf_apply_eks_blueprints.log"
    echo $?

    # eks_blueprints_kubernetes_addons

    h2 "STEP 56. terraform apply: ${LOG_DATETIME}_56_tf_apply.log"
    terraform apply -auto-approve >"${LOG_DATETIME}_56_tf_apply.log"
    echo $?

    # K8S_CLUSTER_ID="eks-cluster-with-new-vpc"
    h2 "STEP 57. kubeconfig ${AWS_REGION} ${K8S_CLUSTER_ID} to ${LOG_DATETIME}_57_tf_update_kubeconfig.log"
    aws eks --region "${AWS_REGION}" update-kubeconfig --name "${K8S_CLUSTER_ID}" \
    >"${LOG_DATETIME}_57_tf_update_kubeconfig.log"
       # FIXME: An error occurred (ResourceNotFoundException) when calling the DescribeCluster operation: No cluster found for name: eks-cluster-with-new-vpc.
    # OUTPUT: Updated context arn:aws:eks:us-west-2:670394095681:cluster/eks-cluster-with-new-vpc in /Users/wilsonmar/.kube/config
    echo $?

    h2 "STEP 58. Show Kubernetes status:"
    k8s_nodes_pods_list

    if [ "${DEL_TF_RESC_AT_END}" = true ]; then  # -DTE
        h2 "STEP 59. -DTE = Delete TF Resources at End "
        Cleanup_k8s  # function defined above. 90-93
    fi # DEL_TF_RESC_AT_END

    if [ "${DEL_TF_LOGS_AT_END}" = true ]; then  # -DLE
        h2 "STEP 60. -DLE Delete TF Logs at End for ${LOG_DATETIME} "
        ls -alT $LOG_DATETIME*
        rm $LOG_DATETIME*
           # Recover deleted files from your Mac Trash
    else
        h2 "STEP 61. -DLE Delete not specified for Logs at End for ${LOG_DATETIME} "
        ls -alT $LOG_DATETIME*
    fi # DEL_TF_LOGS_AT_END

    h2 "STEP 62. List date of tfstate file after terraform commands:"
    ls -alT terraform.tfstate.backup
    ls -alT terraform.tfstate

fi  # KUBE_TF_DEPLOY


#h2 "STEP 70. List resources actually allocated within AWS:"
   # For manual GUI, see https://bobbyhadz.com/blog/aws-list-all-resources
   # For CLI ??
   # TODO: See Terraform Cloud (TFC) vs. state (drift detection)

#h2 "STEP 71. Diagram resources: -graph"
   # See https://wilsonmar.github.io/terraform#DiagrammingTools

#h2 "STEP 72. Impose artificial load:"

#h2 "STEP 73. Security findings from AWS Config"

#h2 "STEP 74. Report metrics comparisons:"

#h2 "STEP 75. Get costs by tags:"
   # Kubecost?

####################


### STEP 99. End-of-run stats
# See https://wilsonmar.github.io/mac-setup/#ReportTimings
EPOCH_END="$( date -u +%s )"  # such as 1572634619

# END