
######### Git Signing:


if [[ "${GIT_TOOLS,,}" == *"signing"* ]]; then

   # About http://notes.jerzygangi.com/the-best-pgp-tutorial-for-mac-os-x-ever/
   # See http://blog.ghostinthemachines.com/2015/03/01/how-to-use-gpg-command-line/
      # from 2015 recommends gnupg instead
   # Cheat sheet of commands at http://irtfweb.ifa.hawaii.edu/~lockhart/gpg/

   # If GPG suite is used, add the GPG key to ~/.bash_profile:
   BASHFILE_EXPORT "GPG_TTY" "$(tty)"

   # NOTE: gpg is the command even though the package is gpg2:
   if ! command_exists gpg ; then
      # See https://www.gnupg.org/faq/whats-new-in-2.1.html
      fancy_echo "Installing GPG2 for commit signing..."
      brew install gpg2
         brew info gpg2 >>$LOGFILE
         brew list gpg2 >>$LOGFILE
   else
      if [[ "${RUNTYPE,,}" == *"upgrade"* ]]; then
         fancy_echo "GPG2 upgrading ..."
         gpg --version  # outputs many lines!
         # To avoid response "Error: git not installed" to brew upgrade git
         brew uninstall GPG2 
         # NOTE: This does not remove .gitconfig file.
         brew install GPG2 
      fi
   fi
   echo "$(gpg --version | grep gpg)" >>$LOGFILE
   #gpg --version | grep gpg
      # gpg (GnuPG) 2.2.5 and many lines!
   # NOTE: This creates folder ~/.gnupg

   # Mac users can store GPG key passphrase in the Mac OS Keychain using the GPG Suite:
   # https://gpgtools.org/
   # See https://spin.atomicobject.com/2013/11/24/secure-gpg-keys-guide/

   # Like https://gpgtools.tenderapp.com/kb/how-to/first-steps-where-do-i-start-where-do-i-begin-setup-gpgtools-create-a-new-key-your-first-encrypted-mail
   BREW_CASK_INSTALL "GIT_TOOLS" "gpg-suite" "GPG Keychain" "brew"
   # See http://macappstore.org/gpgtools/
      # Renamed from gpgtools https://github.com/caskroom/homebrew-cask/issues/39862
      # See https://gpgtools.org/

   # Per https://gist.github.com/danieleggert/b029d44d4a54b328c0bac65d46ba4c65
   # git config --global gpg.program /usr/local/MacGPG2/bin/gpg2

   fancy_echo "Looking in ${#str} byte key chain for GIT_ID=$GIT_ID ..."
   str="$(gpg --list-secret-keys --keyid-format LONG )"
   # RESPONSE FIRST TIME: gpg: /Users/wilsonmar/.gnupg/trustdb.gpg: trustdb created
   echo "$str"
   # Using regex per http://tldp.org/LDP/abs/html/bashver3.html#REGEXMATCHREF
   if [[ "$str" =~ "$GIT_ID" ]]; then 
      fancy_echo "A GPG key for $GIT_ID already generated." >>$LOGFILE
   else  # generate:
      # See https://help.github.com/articles/generating-a-new-gpg-key/
      fancy_echo "Generate a GPG2 pair for $GIT_ID in batch mode ..."
      # Instead of manual: gpg --gen-key  or --full-generate-key
      # See https://superuser.com/questions/1003403/how-to-use-gpg-gen-key-in-a-script
      # And https://gist.github.com/woods/8970150
      # And http://www.gnupg.org/documentation/manuals/gnupg-devel/Unattended-GPG-key-generation.html
      cat >foo <<EOF
      %echo Generating a default key
      Key-Type: default
      Subkey-Type: default
      Name-Real: $GIT_NAME
      Name-Comment: 2 long enough passphrase
      Name-Email: $GIT_ID
      Expire-Date: 0
      Passphrase: $GPG_PASSPHRASE
      # Do a commit here, so that we can later print "done" :-)
      %commit
      %echo done
EOF
    gpg --batch --gen-key foo
    rm foo  # temp intermediate work file.
    # Sample output from above command:
    #gpg: Generating a default key
   #gpg: key AC3D4CED03B81E02 marked as ultimately trusted
   #gpg: revocation certificate stored as '/Users/wilsonmar/.gnupg/openpgp-revocs.d/B66D9BD36CC672341E419283AC3D4CED03B81E02.rev'
   #gpg: done

   fancy_echo "List GPG2 pairs just generated ..."
   str="$(gpg --list-secret-keys --keyid-format LONG )"
   # IF BLANK: gpg: checking the trustdb & gpg: no ultimately trusted keys found
   echo "$str"
   # RESPONSE AFTER a key is created:
   # Sample output:
   #sec   rsa2048/7FA75CBDD0C5721D 2018-03-22 [SC]
   #      B66D9BD36CC672341E419283AC3D4CED03B81E02
   #uid                 [ultimate] Wilson Mar (2 long enough passphrase) <WilsonMar+GitHub@gmail.com>
   #ssb   rsa2048/31653F7418AEA6DD 2018-03-22 [E]

   # To delete a key pair:
   #gpg --delete-secret-key 7FA75CBDD0C5721D
       # Delete this key from the keyring? (y/N) y
       # This is a secret key! - really delete? (y/N) y
       # Click <delete key> in the GUI. Twice.
   #gpg --delete-key 7FA75CBDD0C5721D
       # Delete this key from the keyring? (y/N) y

   fi

   fancy_echo "Retrieve from response Key for $GIT_ID ..."
   # Thanks to Wisdom Hambolu (wisyhambolu@gmail.com) for this:
   KEY=$(GPG_MAP_MAIL2KEY "$GIT_ID")  # 16 chars. 

   # PROTIP: Store your GPG key passphrase so you don't have to enter it every time you 
   #       sign a commit by using https://gpgtools.org/

   # If key is not already set in .gitconfig, add it:
   if grep -q "$KEY" "$GITCONFIG" ; then    
      fancy_echo "Signing Key \"$KEY\" already in $GITCONFIG" >>$LOGFILE
   else
      fancy_echo "Adding SigningKey=$KEY in $GITCONFIG..."
      git config --global user.signingkey "$KEY"

      # Auto-type in "adduid":
      # gpg --edit-key "$KEY" <"adduid"
      # NOTE: By using git config command, repeated invocation would not duplicate lines.
   fi 

   # See https://help.github.com/articles/signing-commits-using-gpg/
   # Configure Git client to sign commits by default for a local repository,
   # in ANY/ALL repositories on your computer, run:
      # NOTE: This updates the "[commit]" section within ~/.gitconfig
   git config commit.gpgsign | grep 'true' &> /dev/null
   # if coding suggested by https://github.com/koalaman/shellcheck/wiki/SC2181
   if [ $? == 0 ]; then
      fancy_echo "git config commit.gpgsign already true (on)." >>$LOGFILE
   else # false or blank response:
      fancy_echo "Setting git config commit.gpgsign false (off)..."
      git config --global commit.gpgsign false
      fancy_echo "To activate: git config --global commit.gpgsign true"
   fi
else
   fancy_echo "GIT_TOOLS signing not specified." >>$LOGFILE
fi



https://coachtestprep.s3-us-west-2.amazonaws.com/uploads/sites/2368/download-file/9264d224-426b-4c02-924c-02fcac570011/Sublime%20settings%20-%20Mac.zip?response-content-disposition=attachment&X-Amz-Expires=3600&X-Amz-Date=20180505T232340Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJ3Y4DMBTHODUCY2Q/20180505/us-west-2/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=959c3263b8a6fdd0f2f377fd629ecd4c3c19e970cf44d603105a0f1e18d67f2c