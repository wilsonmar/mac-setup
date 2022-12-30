#!/usr/bin/env bash

# USAGE:
# ./aws-info.sh  # with no parameters displays.
# From https://github.com/wilsonmar/DevSecOps/blob/main/aws/aws-info.sh
# Based on https://medium.com/circuitpeople/aws-cli-with-jq-and-bash-9d54e2eabaf1
#          https://theagileadmin.com/2017/05/26/aws-cli-queries-and-jq/
#    TODO: https://github.com/bash-my-aws/bash-my-aws documented at https://bash-my-aws.org/

# After you obtain a Terminal (console) in your environment,
# cd to folder, copy this line (without the # first character) and paste in the Terminal:
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/DevSecOps/master/aws/aws-info.sh)"

# SETUP STEP 01 - Capture starting timestamp and display no matter how it ends:
THIS_PROGRAM="$0"
SCRIPT_VERSION="v0.1.9"
# clear  # screen (but not history)

EPOCH_START="$( date -u +%s )"  # such as 1572634619
LOG_DATETIME=$( date +%Y-%m-%dT%H:%M:%S%z)-$((1 + RANDOM % 1000))
echo "  $THIS_PROGRAM $SCRIPT_VERSION ============== $LOG_DATETIME "

# SETUP STEP 02 - Ensure run variables are based on arguments or defaults ..."
args_prompt() {
   echo "OPTIONS:"
   echo "   -E           to set -e to NOT stop on error"
   echo "   -x           to set -x to trace command lines"
   echo "   -v           to run -verbose (list space use and each image to console)"
   echo "   -vv          to run -very verbose for debugging"
   echo "   -q           -quiet headings for each step"
   echo " "
   echo "   -I           -Install software"
   echo "   -U           -Upgrade packages"
   echo "   -p \"xxx-aws-##\" to use [Default] within ~/.aws/credentials"
   echo " "
   echo "   -allinfo     to show all sections of info."
   echo "   -userinfo    to show User info."
   echo "   -netinfo     to show Network info."
   echo "   -svcinfo     to show Services info with cost history."
   echo " "
   echo "   -lambdainfo  to show Lambda info."
   echo "   -amiinfo     to show AMI info."
   echo "   -ec2info     to show EC2 info."
   echo " "
   echo "   -s3info      to show S3 info."
   echo "   -diskinfo    to show Disk info."
   echo "   -dbinfo      to show Database info."
   echo "   -certinfo    to show Certificates info."
   echo "   -loginfo     to show Logging info."
   echo " "
#  echo "   -R \"us-east-1\"  to aws configure set region "
   echo "USAGE EXAMPLE:"
   echo "./aws-info.sh -v -svcinfo "
 }
if [ $# -eq 0 ]; then  # display if no parameters are provided:
   args_prompt
   exit 1
fi
exit_abnormal() {            # Function: Exit with error.
  echo "exiting abnormally"
  #args_prompt
  exit 1
}

# SETUP STEP 03 - Set Defaults (default true so flag turns it true):
   SET_EXIT=true                # -E
   RUN_QUIET=false              # -q
   SET_TRACE=false              # -x
   RUN_VERBOSE=false            # -v
   RUN_DEBUG=false              # -vv
   UPDATE_PKGS=false            # -U
   DOWNLOAD_INSTALL=false       # -I
   AWS_PROFILE="default"        # -p
  #AWS_REGION_IN=""             # -R region

   ALL_INFO=false               # -all
   USER_INFO=false              # -userinfo
   NET_INFO=false               # -netinfo
   LAMBDA_INFO=false            # -lambdainfo
   AMI_INFO=false               # -amiinfo
   EC2_INFO=false               # -ec2info
   S3_INFO=false                # -s3info
   DISK_INFO=false              # -diskinfo
   DB_INFO=false                # -dbinfo
   CERT_INFO=false              # -diskinfo
   LOG_INFO=false               # -loginfo

   MY_AMI_TYPE="Amazon Linux 2"
   MY_AMI_CONTAINS=".NET Core 2.1"

# SETUP STEP 04 - Read parameters specified:
while test $# -gt 0; do
  case "$1" in
    -allinfo)
      export ALL_INFO=true
      shift
      ;;
    -amiinfo)
      export AMI_INFO=true
      shift
      ;;
    -certinfo)
      export CERT_INFO=true
      shift
      ;;
    -diskinfo)
      export DISK_INFO=true
      shift
      ;;
    -dbinfo)
      export DB_INFO=true
      shift
      ;;
    -ec2info)
      export EC2_INFO=true
      shift
      ;;
    -E)
      export SET_EXIT=false
      shift
      ;;
    -q)
      export RUN_QUIET=true
      shift
      ;;
    -I)
      export DOWNLOAD_INSTALL=true
      shift
      ;;
    -lambdainfo)
      export LAMBDA_INFO=true
      shift
      ;;
    -loginfo)
      export LOG_INFO=true
      shift
      ;;
    -netinfo)
      export NET_INFO=true
      shift
      ;;
    -R*)
      shift
             AWS_REGION_IN=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export AWS_REGION_IN
      shift
      ;;
    -s3info)
      export S3_INFO=true
      shift
      ;;
    -svcinfo)
      export SVC_INFO=true
      shift
      ;;
    -userinfo)
      export USER_INFO=true
      shift
      ;;
    -U)
      export UPDATE_PKGS=true
      shift
      ;;
    -v)
      export RUN_VERBOSE=true
      shift
      ;;
    -vv)
      export RUN_DEBUG=true
      shift
      ;;
    -p*)
      shift
             AWS_PROFILE=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export AWS_PROFILE
      shift
      ;;
    -x)
      export SET_TRACE=true
      shift
      ;;
    *)
      error "Parameter \"$1\" not recognized. Aborting."
      exit 0
      break
      ;;
  esac
done


# SETUP STEP 04 - Set ANSI color variables (based on aws_code_deploy.sh): 
bold="\e[1m"
dim="\e[2m"
# shellcheck disable=SC2034 # ... appears unused. Verify use (or export if used externally).
underline="\e[4m"
# shellcheck disable=SC2034 # ... appears unused. Verify use (or export if used externally).
blink="\e[5m"
reset="\e[0m"
red="\e[31m"
green="\e[32m"
# shellcheck disable=SC2034 # ... appears unused. Verify use (or export if used externally).
blue="\e[34m"
cyan="\e[36m"

# SETUP STEP 05 - Specify alternate echo commands:
h2() { if [ "${RUN_QUIET}" = false ]; then    # heading
   printf "\n${bold}\e[33m\u2665 %s${reset}\n" "$(echo "$@" | sed '/./,$!d')"
   fi
}
info() {   # output on every run
   printf "${dim}\n➜ %s${reset}\n" "$(echo "$@" | sed '/./,$!d')"
}
note() { if [ "${RUN_VERBOSE}" = true ]; then
   printf "\n${bold}${cyan} ${reset} ${cyan}%s${reset}" "$(echo "$@" | sed '/./,$!d')"
   printf "\n"
   fi
}
debug_echo() { if [ "${RUN_DEBUG}" = true ]; then
   printf "\n${bold}${cyan} ${reset} ${cyan}%s${reset}" "$(echo "$@" | sed '/./,$!d')"
   printf "\n"
   fi
}
success() {
   printf "\n${green}✔ %s${reset}\n" "$(echo "$@" | sed '/./,$!d')"
}
error() {    # &#9747;
   printf "\n${red}${bold}✖ %s${reset}\n" "$(echo "$@" | sed '/./,$!d')"
}
warning() {  # &#9758; or &#9755;
   printf "\n${cyan}☞ %s${reset}\n" "$(echo "$@" | sed '/./,$!d')"
}
fatal() {   # Skull: &#9760;  # Star: &starf; &#9733; U+02606  # Toxic: &#9762;
   printf "\n${red}☢  %s${reset}\n" "$(echo "$@" | sed '/./,$!d')"
}
divider() {
  printf "\r\033[0;1m========================================================================\033[0m\n"
}

pause_for_confirmation() {
  read -rsp $'Press any key to continue (ctrl-c to quit):\n' -n1 key
}

# SETUP STEP 06 - Check what operating system is in use:
   OS_TYPE="$( uname )"
   OS_DETAILS=""  # default blank.
if [ "$(uname)" == "Darwin" ]; then  # it's on a Mac:
      OS_TYPE="macOS"
      PACKAGE_MANAGER="brew"
elif [ "$(uname)" == "Linux" ]; then  # it's on a Mac:
   if command -v lsb_release ; then
      lsb_release -a
      OS_TYPE="Ubuntu"
      # TODO: OS_TYPE="WSL" ???
      PACKAGE_MANAGER="apt-get"

      # TODO: sudo dnf install pipenv  # for Fedora 28

      silent-apt-get-install(){  # see https://wilsonmar.github.io/bash-scripts/#silent-apt-get-install
         if [ "${RUN_VERBOSE}" = true ]; then
            info "apt-get install $1 ... "
            sudo apt-get install "$1"
         else
            sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq "$1" < /dev/null > /dev/null
         fi
      }
   elif [ -f "/etc/os-release" ]; then
      OS_DETAILS=$( cat "/etc/os-release" )  # ID_LIKE="rhel fedora"
      OS_TYPE="Fedora"
      PACKAGE_MANAGER="yum"
   elif [ -f "/etc/redhat-release" ]; then
      OS_DETAILS=$( cat "/etc/redhat-release" )
      OS_TYPE="RedHat"
      PACKAGE_MANAGER="yum"
   elif [ -f "/etc/centos-release" ]; then
      OS_TYPE="CentOS"
      PACKAGE_MANAGER="yum"
   else
      error "Linux distribution not anticipated. Please update script. Aborting."
      exit 0
   fi
else 
   error "Operating system not anticipated. Please update script. Aborting."
   exit 0
fi
# note "OS_DETAILS=$OS_DETAILS"

# SETUP STEP 07 - Define utility functions, such as bash function to kill process by name:
ps_kill(){  # $1=process name
      PSID=$(ps aux | grep $1 | awk '{print $2}')
      if [ -z "$PSID" ]; then
         h2 "Kill $1 PSID= $PSID ..."
         kill 2 "$PSID"
         sleep 2
      fi
}

# SETUP STEP 08 - Adjust Bash version:
BASH_VERSION=$( bash --version | grep bash | cut -d' ' -f4 | head -c 1 )
   if [ "${BASH_VERSION}" -ge "4" ]; then  # use array feature in BASH v4+ :
      DISK_PCT_FREE=$(read -d '' -ra df_arr < <(LC_ALL=C df -P /); echo "${df_arr[11]}" )
      FREE_DISKBLOCKS_START=$(read -d '' -ra df_arr < <(LC_ALL=C df -P /); echo "${df_arr[10]}" )
   else
      if [ "${UPDATE_PKGS}" = true ]; then
         info "Bash version ${BASH_VERSION} too old. Upgrading to latest ..."
         if [ "${PACKAGE_MANAGER}" == "brew" ]; then
            brew install bash
         elif [ "${PACKAGE_MANAGER}" == "apt-get" ]; then
            silent-apt-get-install "bash"
         elif [ "${PACKAGE_MANAGER}" == "yum" ]; then    # For Redhat distro:
            sudo yum install bash      # please test
         elif [ "${PACKAGE_MANAGER}" == "zypper" ]; then   # for [open]SuSE:
            sudo zypper install bash   # please test
         fi
         info "Now at $( bash --version  | grep 'bash' )"
         fatal "Now please run this script again now that Bash is up to date. Exiting ..."
         exit 0
      else   # carry on with old bash:
         DISK_PCT_FREE="0"
         FREE_DISKBLOCKS_START="0"
      fi
   fi

# SETUP STEP 09 - Handle run endings:"

# In case of interrupt control+C confirm to exit gracefully:
#interrupt_count=0
#interrupt_handler() {
#  ((interrupt_count += 1))
#  echo ""
#  if [[ $interrupt_count -eq 1 ]]; then
#    fail "Really quit? Hit ctrl-c again to confirm."
#  else
#    echo "Goodbye!"
#    exit
#  fi
#}

trap interrupt_handler SIGINT SIGTERM
trap this_ending EXIT
trap this_ending INT QUIT TERM
this_ending() {
   EPOCH_END=$(date -u +%s);
   EPOCH_DIFF=$((EPOCH_END-EPOCH_START))
   # Using BASH_VERSION identified above:
   if [ "${BASH_VERSION}" -lt "4" ]; then
      FREE_DISKBLOCKS_END="0"
   else
      FREE_DISKBLOCKS_END=$(read -d '' -ra df_arr < <(LC_ALL=C df -P /); echo "${df_arr[10]}" )
   fi
   FREE_DIFF=$(((FREE_DISKBLOCKS_END-FREE_DISKBLOCKS_START)))
   MSG="End of script $SCRIPT_VERSION after $((EPOCH_DIFF/360)) seconds and $((FREE_DIFF*512)) bytes on disk."
   # echo 'Elapsed HH:MM:SS: ' $( awk -v t=$beg-seconds 'BEGIN{t=int(t*1000); printf "%d:%02d:%02d\n", t/3600000, t/60000%60, t/1000%60}' )
   success "$MSG"
   # note "Disk $FREE_DISKBLOCKS_START to $FREE_DISKBLOCKS_END"
}
sig_cleanup() {
    trap '' EXIT  # some shells call EXIT after the INT handler.
    false # sets $?
    this_ending
}

#################### Print run heading:

# SETUP STEP 09 - Operating environment information:
HOSTNAME=$( hostname )
PUBLIC_IP=$( curl -s ifconfig.me )

if [ "$OS_TYPE" == "macOS" ]; then  # it's on a Mac:
   debug_echo "BASHFILE=~/.bash_profile ..."
   BASHFILE="$HOME/.bash_profile"  # on Macs
else
   debug_echo "BASHFILE=~/.bashrc ..."
   BASHFILE="$HOME/.bashrc"  # on Linux
fi
   debug_echo "Running $0 in $PWD"  # $0 = script being run in Present Wording Directory.
   debug_echo "OS_TYPE=$OS_TYPE using $PACKAGE_MANAGER from $DISK_PCT_FREE disk free"
   debug_echo "on hostname=$HOSTNAME at PUBLIC_IP=$PUBLIC_IP."
   debug_echo " "

# print all command arguments submitted:
#while (( "$#" )); do 
#  echo $1 
#  shift 
#done 

# SETUP STEP 10 - Define run error handling:
EXIT_CODE=0
if [ "${SET_EXIT}" = true ]; then  # don't
   debug_echo "Set -e (no -E parameter  )..."
   set -e  # exits script when a command fails
   # set -eu pipefail  # pipefail counts as a parameter
else
   warning "Don't set -e (-E parameter)..."
fi
if [ "${SET_XTRACE}" = true ]; then
   debug_echo "Set -x ..."
   set -x  # (-o xtrace) to show commands for specific issues.
fi
# set -o nounset


# brew install awscli

##############################################################################
divider

if [ "${USER_INFO}" = true ] || [ "${ALL_INFO}" = true ]; then   # -userinfo
h2 "============= AWS User "

# See https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html
# and https://docs.aws.amazon.com/cli/latest/topic/config-vars.html
# note "Edit ~/.aws/credentials"
note "Setup credentials to AWS_PROFILE=$AWS_PROFILE  AWS_DEFAULT_OUTPUT=$AWS_DEFAULT_OUTPUT "

# See https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
note "aws configure list-profiles"
aws configure list-profiles

note "aws config list:"
aws configure list


note "aws whoami: UserId, Account, ARN, Account Alias:"
# See https://medium.com/circuitpeople/aws-cli-with-jq-and-bash-9d54e2eabaf1
# and https://docs.aws.amazon.com/cli/latest/reference/sts/get-caller-identity.html
{ aws sts get-caller-identity & aws iam list-account-aliases; } | jq -s ".|add"
   # "UserId": "ABCDEFGHIJKLMNOPQRSTU",
   # "Account": "123456789012",
   # "Arn": "arn:aws:iam::987654321234:user/Wilson_Mar",
   # "AccountAliases": [ "cloud-data-bridge-dev" ]
retVal=$?
if [ $retVal -ne 0 ]; then
   exit -1 
fi


# AWS_REGION=$( aws configure get region )
AWS_REGION=$( aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]' )
note "aws region: $AWS_REGION, AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION "
   # us-west-2



USER_LIST=$( aws iam list-users --query Users[*].UserName )
note "Count and list of users:"
echo "$USER_LIST" | wc -l
echo "$USER_LIST"


# note "When was AWS user account created?"
# See https://docs.aws.amazon.com/cli/latest/reference/iam/get-user.html
# ERROR: aws iam get-user --user-name "$AWS_PROFILE" --cli-input-json "json" | jq -r ".User.CreateDate[:4]" 

note "Trusted Advisor"
CHECK_ID=$(aws --region us-east-1 support describe-trusted-advisor-checks --language en --query 'checks[?name==`Service Limits`].{id:id}[0].id' --output text)
echo $CHECK_ID

fi   # if [ USER_INFO=true


if [ "${NET_INFO}" = true ] || [ "${ALL_INFO}" = true ]; then   # -netinfo
h2 "============= Networks "

note "What CIDRs have Ingress Access to which EC2 Ports?"
aws ec2 describe-security-groups | jq '[ .SecurityGroups[].IpPermissions[] as $a | { "ports": [($a.FromPort|tostring),($a.ToPort|tostring)]|unique, "cidr": $a.IpRanges[].CidrIp } ] | [group_by(.cidr)[] | { (.[0].cidr): [.[].ports|join("-")]|unique }] | add'

# note "Public ports:"
# aws public-ports
   # See https://docs.aws.amazon.com/workspaces/latest/adminguide/workspaces-port-requirements.html
   # "GroupName": "Amazon ECS-Optimized Amazon Linux 2 AMI-2-0-20210331-AutogenByAWSMP-1", "GroupId": "sg-043c2583c8fa2fb7b",
      #  "PortRanges": [ "tcp:22-22"

fi  #


if [ "${SVC_INFO}" = true ] || [ "${ALL_INFO}" = true ]; then   # -svcinfo
h2 "============= AWS Services Costs "

note "How many AWS services available?"
curl -s https://raw.githubusercontent.com/boto/botocore/develop/botocore/data/endpoints.json \
   | jq -r '.partitions[0].services | keys[]' | wc -l


# While it *can* be answered in the Config console UI (given enough clicks), 
# or using Cost Explorer (fewer clicks), 
local_cost_report() {
   # See https://docs.aws.amazon.com/cli/latest/reference/ce/get-cost-and-usage.html
#   aws ce get-cost-and-usage --time-period Start="$MONTH_FIRST_DAY",End="$MONTH_LAST_DAY" \
#      --granularity MONTHLY --metrics UsageQuantity \
#      --group-by Type=DIMENSION,Key=SERVICE | jq '.ResultsByTime[].Groups[] | select(.Metrics.UsageQuantity.Amount > 0) | .Keys[0]'
      # date "+%Y-%m-01" yields 2021-09-01, see https://www.cyberciti.biz/faq/linux-unix-formatting-dates-for-display/
      # See https://stackoverflow.com/questions/27920201/how-can-i-get-the-1st-and-last-date-of-the-previous-month-in-a-bash-script/46897063
   note "Cost of each service for $MONTH_RANGE month $MONTH_FIRST_DAY to $MONTH_LAST_DAY ($OS_TYPE)"
   aws ce get-cost-and-usage --time-period Start="$MONTH_FIRST_DAY",End="$MONTH_LAST_DAY" \
      --granularity MONTHLY --metrics USAGE_QUANTITY BLENDED_COST  \
      --group-by Type=DIMENSION,Key=SERVICE | jq '[ .ResultsByTime[].Groups[] | select(.Metrics.BlendedCost.Amount > "0") | { (.Keys[0]): .Metrics.BlendedCost } ] | sort_by(.Amount) | add'
}

   MONTH_RANGE="previous"
if [ "$OS_TYPE" == "macOS" ]; then  # it's on a Mac:
   # For MacOS: https://stackoverflow.com/questions/63559669/get-first-date-of-current-month-in-macos-terminal
   # And https://www.freebsd.org/cgi/man.cgi?date
   MONTH_FIRST_DAY=$( date -v1d -v-1m '+%Y-%m-%d' )  # yields 2021-08-01 previous month start
   # MONTH_FIRST_DAY=$( date -v1d -v"$(date '+%m')"m '+%Y-%m-%d' )  # yields 2021-09-01
      # The -v1d is a time adjust flag to move to the first day of the month
      # In -v"$(date '+%m')"m, we get the current month number using date '+%m' and use it to populate the month adjust field. So e.g. for Aug 2020, its set to -v8m
      # The '+%F' prints the date in YYYY-MM-DD format. If not supported in your date version, use +%Y-%m-%d explicitly.
      # To print all 12 months: for mon in {1..12}; do; date -v1d -v"$mon"m '+%F'; done
   # MONTH_LAST_DAY=$( date -v1d -v-1d -v+1m +%Y-%m-%d )  # for 2021-09-30
   MONTH_LAST_DAY=$( date -v1d -v-1d -v+0m +%Y-%m-%d )  # for 2021-09-30
else
   # This uses GNU date on Linus: not portable (notably Mac / *BSD date is different)
   # https://unix.stackexchange.com/questions/223543/get-the-date-of-last-months-last-day-in-a-shell-script
   MONTH_FIRST_DAY=$( date "+%Y-%m-01" -d "-1 Month" )
   MONTH_LAST_DAY=$( date --date="$(date +'%Y-%m-01') - 1 second" -I )  # for 2021-09-30
fi
local_cost_report


   MONTH_RANGE="current"
if [ "$OS_TYPE" == "macOS" ]; then  # it's on a Mac:
   # For MacOS: https://stackoverflow.com/questions/63559669/get-first-date-of-current-month-in-macos-terminal
   # And https://www.freebsd.org/cgi/man.cgi?date
   MONTH_FIRST_DAY=$( date -v1d '+%Y-%m-%d' )  # yields 2021-08-01 previous month start
   # MONTH_FIRST_DAY=$( date -v1d -v"$(date '+%m')"m '+%Y-%m-%d' )  # yields 2021-09-01
      # The -v1d is a time adjust flag to move to the first day of the month
      # In -v"$(date '+%m')"m, we get the current month number using date '+%m' and use it to populate the month adjust field. So e.g. for Aug 2020, its set to -v8m
      # The '+%F' prints the date in YYYY-MM-DD format. If not supported in your date version, use +%Y-%m-%d explicitly.
      # To print all 12 months: for mon in {1..12}; do; date -v1d -v"$mon"m '+%F'; done
   # MONTH_LAST_DAY=$( date -v1d -v-1d -v+1m +%Y-%m-%d )  # for 2021-09-30
   MONTH_LAST_DAY=$( date -v1d -v-1d -v+1m +%Y-%m-%d )  # for 2021-09-30
else
   # This uses GNU date on Linus: not portable (notably Mac / *BSD date is different)
   # https://unix.stackexchange.com/questions/223543/get-the-date-of-last-months-last-day-in-a-shell-script
   MONTH_FIRST_DAY=$( date "+%Y-%m-01" )
   MONTH_LAST_DAY=$( date --date="$(date +'%Y-%m-01') - 1 second" -I )  # for 2021-09-30
fi
local_cost_report

fi # 


if [ "${LAMBDA_INFO}" = true ] || [ "${ALL_INFO}" = true ]; then   # -lambdainfo
h2 "============= Lambda "

note "Which Lambda Functions Runtimes am I Using?"
aws lambda list-functions | jq ".Functions | group_by(.Runtime)|[.[]|{ runtime:.[0].Runtime, functions:[.[]|.FunctionName] }
]"

# note "Is everyone taking the time to set memory size and the time out appropriately?"
# aws lambda list-functions | jq ".Functions | group_by(.Runtime)|[.[]|{ (.[0].Runtime): [.[]|{ name: .FunctionName, timeout: .Timeout, memory: .MemorySize }] }]"
   # [{ "python3.6": [ { "name": "aws-controltower-NotificationForwarder", "timeout": 60, "memory": 128 }]

note "Lambda Function Environment Variables: exposing secrets in variables? Have a typo in a key?"
aws lambda list-functions | jq -r '[.Functions[]|{name: .FunctionName, env: .Environment.Variables}]|.[]|select(.env|length > 0)'

fi #

if [ "${AMI_INFO}" = true ] || [ "${ALL_INFO}" = true ]; then   # -amiinfo

h2 "============= \"$MY_AMI_TYPE\" AMIs containing \"$MY_AMI_CONTAINS\" "

note "List AMIs in an environment variable (this is slow, ’cause there are a *lot* of AMIs):"
#note "Step 1: List AMIs in an environment variable (this is slow, ’cause there are a *lot* of AMIs):"
export AMI_IDS=$(aws ec2 describe-images --owners amazon | jq -r ".Images[] | { id: .ImageId, desc: .Description } \
  | select(.desc?) | select(.desc | contains(\"$MY_AMI_TYPE\")) | select(.desc | contains(\"$MY_AMI_CONTAINS\")) | .id")
echo "AMI_ID=$AMI_IDS "

fi #



if [ "${EC2_INFO}" = true ] || [ "${ALL_INFO}" = true ]; then   # -ec2info
h2 "============= EC2 "

note "Which of my EC2 Security Groups are being used?"
MY_SEC_GROUPS="$( aws ec2 describe-network-interfaces \
      | jq '[.NetworkInterfaces[].Groups[]|.]|map({ (.GroupId|tostring): true }) | add'; aws ec2 describe-security-groups | jq '[.SecurityGroups[].GroupId]|map({ (.|tostring): false })|add'; )"
# echo "MY_SEC_GROUPS=$MY_SEC_GROUPS"
echo "$MY_SEC_GROUPS" | jq -s '[.[1], .[0]]|add|to_entries|[group_by(.value)[]|{ (.[0].value|if . then "in-use" else "unused" end): [.[].key] }]|add' 


note "How many EC2 instances of each type running/stopped?"
aws ec2 describe-instances | jq -r "[[.Reservations[].Instances[]|{ state: .State.Name, type: .InstanceType }]|group_by(.state)|.[]|{state: .[0].state, types: [.[].type]|[group_by(.)|.[]|{type: .[0], count: ([.[]]|length)}] }]"
   # [ { "state": "running", "types": [ { "type": "t3.medium", "count": 1    } ] } ]

# See https://www.slideshare.net/AmazonWebServices/deep-dive-advanced-usage-of-the-aws-cli
# for ec2-instances-running and waiting given an image-id.


note "EC2 parentage: Which EC2 Instances were created by Stacks?"
for stack in $(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE \
   | jq -r '.StackSummaries[].StackName'); do aws cloudformation describe-stack-resources --stack-name $stack \
   | jq -r '.StackResources[] | select (.ResourceType=="AWS::EC2::Instance")|.PhysicalResourceId'; done;


# note "Loop through the groups and streams and get the last 10 messages since midnight:"
# for group in $logs; do for stream in $(aws logs describe-log-streams --log-group-name $group --order-by LastEventTime --descending --max-items 1 | jq -r '[ .logStreams[0].logStreamName + " "] | add'); do h2 ""; echo GROUP: $group; echo STREAM: $stream; aws logs get-log-events --limit 10 --log-group-name $group --log-stream-name $stream --start-time $(date -d 'today 00:00:00' '+%s%N' | cut -b1-13) | jq -r ".events[].message"; done; done

#note "Bucket cost dollars per month (based on the standard tier price of $0.023 per GB per month):"
#   | echo $bucket: $(jq -r "(.Datapoints[0].Maximum // 0) * .023 / (1024*1024*1024) * 100.0 | floor / 100.0"); done;

note "How many Snapshot volumes do I have?"
aws ec2 describe-snapshots --owner-ids self | jq '.Snapshots | length'
   # 4

note "how large are EC2 Snapshots in total?"
aws ec2 describe-snapshots --owner-ids self | jq '[.Snapshots[].VolumeSize] | add'

note "How do Snapshots breakdown by the volume used to create them?"
aws ec2 describe-snapshots --owner-ids self \
   | jq '.Snapshots | [ group_by(.VolumeId)[] | { (.[0].VolumeId): { "count": (.[] | length), "size": ([.[].VolumeSize] | add) } } ] | add'


fi #


if [ "${S3_INFO}" = true ] || [ "${ALL_INFO}" = true ]; then   # -s3info
h2 "============= S3 usage "

S3_BUCKET_COUNT=$( aws s3api list-buckets --query "Buckets[].Name" | wc -l )
note "How much Data is in Each of my $S3_BUCKET_COUNT S3 Buckets?"
   # CloudWatch contains the data, but if your account has more than a few buckets it’s very tedious to use.
   # This little command gives your the total size of the objects in each bucket, one per line, with human-friendly numbers:
   # date +%Y-%m-%d = date --iso-8601 = 2021-12-30
for bucket in $( aws s3api list-buckets --query "Buckets[].Name" --output text ); \
   do aws cloudwatch get-metric-statistics --namespace AWS/S3 --metric-name BucketSizeBytes \
      --dimensions Name=BucketName,Value=$bucket Name=StorageType,Value=StandardStorage \
      --start-time $(date +%Y-%m-%d)T00:00 --end-time $(date +%Y-%m-%d)T23:59 --period 86400 --statistic Maximum \
   | echo $bucket: $(numfmt --to si $(jq -r ".Datapoints[0].Maximum // 0")); done;
retVal=$?
if [ $retVal -ne 0 ]; then
   exit -1 
fi

fi #

if [ "${DISK_INFO}" = true ] || [ "${ALL_INFO}" = true ]; then   # -diskinfo
h2 "============= Disk usage "

note "How many Gigabytes of Volumes do I have, by Status?"
aws ec2 describe-volumes | jq -r '.Volumes | [ group_by(.State)[] | { (.[0].State): ([.[].Size] | add) } ] | add'

fi #



if [ "${DB_INFO}" = true ] || [ "${ALL_INFO}" = true ]; then   # -dbinfo
h2 "============= DB_INFO "

note "RDS (Relational Data Service) Instance Endpoints:"
aws rds describe-db-instances | jq -r '.DBInstances[] | { (.DBInstanceIdentifier):(.Endpoint.Address + ":" + (.Endpoint.Port|tostring))}'

fi  #



if [ "${CERT_INFO}" = true ] || [ "${ALL_INFO}" = true ]; then   # -certinfo
h2 "============= Certificates "

# https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_server-certs.html
note "aws iam list-server-certificates"
aws iam list-server-certificates

fi #


if [ "${LOG_INFO}" = true ] || [ "${ALL_INFO}" = true ]; then   # -loginfo
h2 "============= Logs "

note "Log group names (space delimited):"
logs=$(aws logs describe-log-groups | jq -r '.logGroups[].logGroupName')
echo "$logs"


note "first log stream for each:"
for group in $logs; do echo $(aws logs describe-log-streams --log-group-name $group \
   --order-by LastEventTime --descending --max-items 1 | jq -r '.logStreams[0].logStreamName + " "'); done


# https://okigiveup.net/tutorials/discovering-aws-with-cli-part-1-basics/
# https://github.com/afroisalreadyinu/aws-containers
# note "Create VPC based on CIDR"  # see https://docs.amazonaws.cn/en_us/vpc/latest/userguide/vpc-subnets-commands-example.html
# aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query Vpc.VpcId --output text
   # An error occurred (VpcLimitExceeded) when calling the CreateVpc operation: The maximum number of VPCs has been reached.

fi #

# END
