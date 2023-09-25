#!/usr/bin/env zsh -f
# run-after-macos-update.sh
# Purpose: Run after each macOS update to re-enable Touch ID for 'sudo'
# from https://github.com/tjluoma/sudo-via-touch-id/blob/main/sudo-via-touch-id.sh
# A variant of https://gist.github.com/fraune/0831edc01fa89f46ce43b8bbc3761ac7
# Please reboot after running this.
# From:	Timothy J. Luoma
# Mail:	luomat at gmail dot com
# Date:	2020-01-28
# Switch to the root user with sudo su -
# See https://apple.stackexchange.com/questions/259093/can-touch-id-on-mac-authenticate-sudo-in-terminal/355880#355880

NAME="$0:t:r"

	# make sure your $PATH is set
if [[ -e "$HOME/.path" ]]
then
	source "$HOME/.path"
fi

	# this is what we are going to add
NEWTEXT='auth       sufficient     pam_tid.so'

	# this is the file we are going to add it to
FILE='/etc/pam.d/sudo'

	# this checks to see if the text is already in the file we want to modify
fgrep -q "$NEWTEXT" "$FILE"

	# here we save the exit code of the 'fgrep' command
EXIT="$?"

if [[ "$EXIT" == "0" ]]
then
		# if that code was zero, the file does not need to be modified
	echo "$NAME: '$FILE' already has correct entry."
else

		# if that code was not zero, we'll try to modify that file

		# this lets us use zsh's strftime
	zmodload zsh/datetime

		# get current timestamp
	TIME=$(strftime "%Y-%m-%d--%H.%M.%S" "$EPOCHSECONDS")

		# tell user what we are doing
	echo "$NAME: Need to add entry to '$FILE'"

		# get random tempfile name
	TEMPFILE="${TMPDIR-/tmp}/${NAME}.${TIME}.$$.$RANDOM.txt"

		# get comment line (this is usually the first line of the file)
	egrep '^#' "$FILE" >| "$TEMPFILE"

		# add our custom line
	echo "$NEWTEXT" >> "$TEMPFILE"

		# get the other lines
	egrep -v '^#' "$FILE" >> "$TEMPFILE"

		# tell the user what the filename is
		# useful for debugging, if needed
	# echo "$TEMPFILE"

		# set the proper permissions
		# and ownership
		# and move the file into place
	sudo chmod 444 "$TEMPFILE" \
	&& sudo chown root:wheel "$TEMPFILE" \
	&& sudo mv -vf "$TEMPFILE" "$FILE"

		# check the exit code of the above 3 commands
	EXIT="$?"

		# if the commands exited = 0
		# then we're good
	if [[ "$EXIT" == "0" ]]
	then
		echo "$NAME [SUCCESS]: 'sudo' was successfully added to '$FILE'."
	else
			# if we did not get a 'zero' result, tell the user
			# and give up
		echo "$NAME: 'sudo' failed (\$EXIT = $EXIT)"
		exit 1
	fi
fi

	# if iTerm is installed, check to see if one of its settings is set to work with this setting
	# and if not, tell the user what they need to change

if [ -d '/Applications/iTerm.app' -o -d "$HOME/Applications/iTerm.app" ]
then

	PREFERENCE=$(defaults read com.googlecode.iterm2 BootstrapDaemon 2>/dev/null)

	if [[ "$PREFERENCE" == "0" ]]
	then

		echo "$NAME: 'iTerm' preference is already set properly."

	else

		echo "$NAME [WARNING]: setting iTerm preferences via 'defaults write' may not work while iTerm is running."
		echo "$NAME [WARNING]: Be sure to turn OFF this setting in iTerm's Preferences:"
		echo "	Preferences » Advanced » 'Allow sessions to survive logging out and back in'"

	fi

fi

exit 0
#EOF
