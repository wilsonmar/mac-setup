#!/bin/sh
# pre-commit file
# An example hook script to verify what is about to be committed.
# Called by "git commit" with no arguments.  The hook should
# To stop the commit, exit with non-zero status after issuing an appropriate message.

if [ -z "$GIT_AUTHOR_DATE" ]; then  # it's blank (testing standalone):
   GIT_AUTHOR_DATE="@1522308872 -0600" # provide sample input
   GIT_AUTHOR_NAME="Wilson Mar"
   GIT_AUTHOR_EMAIL="WilsonMar@gmail.com"
fi
   #echo "GIT_AUTHOR_DATE=$GIT_AUTHOR_DATE"
GIT_AUTHOR_YMD=${GIT_AUTHOR_DATE#"@"}  # # refers to the beginning char to strip.
GIT_AUTHOR_YMD=${GIT_AUTHOR_YMD%' '*} # strips chars from end of string after the space.
GIT_AUTHOR_YMD=$(date -r "$GIT_AUTHOR_YMD" '+%Y-%m-%dT%H:%M:%S')  # ISO 8601 format 
time=${GIT_AUTHOR_DATE:(-5)} # extracts last 5 chars from end of string.
GIT_AUTHOR_TZ=${time:0:3}:${time:3:2}
echo "pre-commit $GIT_AUTHOR_YMD$GIT_AUTHOR_TZ for $GIT_AUTHOR_NAME of $GIT_AUTHOR_EMAIL"
exit 0  # 1 is error.
