Here is the quickest way to get started with a macOS laptop (new or old) to work as a developer of several popular stacks and in several clouds."

## TL;DR: Run!

This approach is faster and repeatable than manually clicking through everything.
It's less error-prone because we've worked out the dependency clashes for you.
We created the script to automatically take care of workarounds to known issues. 

1. All that you need to do is <a target="_blank" href="https://wilsonmar.github.io/mac-setup">explained in my step-by-step instructions</a>.

1. Open a Terminal by pressing command+spacebar, then type enough of <strong>Terminal.app</strong> to select it.

1. Drag the right-edge of the Terminal window to expand its width to accomodate longer lines displayed.

1. Do a dry run of the script with <strong>no parameters</strong> so it only displays a (long) list of parameters, use your mouse to triple-click the command below to highlight it, then press command+C to copy it to your Clipboard:

   <pre><strong>zsh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/mac-setup/main/mac-setup.zsh)"
   </strong></pre>

   (The script previously invoked bash, but it now invokes zsh because Apple switched to that as the default)

1. Click on this link to read the script code so you can be assured that it is not purposely injecting malware.

   <a target="_blank" href="https://github.com/wilsonmar/mac-setup/blob/master/mac-setup.zsh">https://github.com/wilsonmar/mac-setup/blob/master/mac-setup.zsh</a>

   Unlike all other "dotfiles" on the internet, the script in this repo is thousands of lines long so that you copy and paste <strong>one</strong> script that installs everything needed: from XCode to Brew to Python to cloud CLI.
   
   I've tried to use the easiest to understand shell scripting techniques rather than esoteric one that other "experts" use to prove how superior they are. But if you disagree with something, please let me know. I welcome your suggestions.

   You don't need to comment out the ones you don't want. Just don't provide the parameter.

   The exception to that are brew commands in the script.

1. If you want to run the script to configure your laptop the <strong>most popular and trusted</strong> components macOS developers use, use your mouse to triple-click the command below to highlight it, then press command+C to copy it to your Clipboard:

   <pre><strong>zsh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/mac-setup/main/mac-setup.zsh)" -v -I
   </strong></pre>

   <tt>-I</tt> specifies <strong>Install</strong> of utilities.
   
1. Press command+V to paste the command from your Clipboard. It starts running.

   The script creates a <tt>~/Projects/mac-setup</tt> folder on your machine and downloads files into it, such as the <tt>mac-setup.zsh</tt> script. 

   If a utility program is not installed, the script installs it.

1. If you and your team may want a different set of utilities and apps to install, edit the mac-setup.zsh script and put it in your own repo on GitHub. Then run the mac-setup.zsh command from your own repo. You'll miss out on frequent updates of my repo, though.

1. Alternately, you can edit the configuration file and run Ansible.


<a name="Why"></a>

## Why?

Most tutorials ask you to <strong>manually type</strong> or copy and paste strings from web pages (often with missing steps), which can take time, and be error-prone. And most webinar demos seem to brag rather than teach skills. To be more helpful, this repo <strong>talks with code</strong> by including manual documentation in the "configuration as code" movement for minimizing risk and ensuring consistency.

This repo gives you a way to install, configure, and start a large set of programs running sample code for several "stacks":

   * MEAN (MongoDB, Express, Angular, NodeJs) with the <a target="_blank" href="http://meanjs.org/">MeanJs sample app</a>
   * <a target="_blank" href="http://mern.io/">MERN</a> (MongoDB, Express, React/Redux, NodeJs) for "Universal" apps, including WebPack
   * PERN (PostgreSQL, Express, React, Node-postgres) with utilities <a target="_blank" href="https://www.pgadmin.org/">PGAdmin</a>, <a target="_blank" href="https://postgresapp.com/">Postgresapp</a>, <a target="_blank" href="https://react-bootstrap.github.io/">react-bootstrap</a>, <a target="_blank" href="https://www.npmjs.com/package/pg">nodemon</a>, (<a target="_blank" href="https://medium.com/bb-tutorials-and-thoughts/how-to-dockerize-pern-stack-afcd824a785f">Dockerized</a>)

   * JAM (Jekyll, APIs, Markup) with a sample Github.io website
   * MAMP (Macintosh, Apache/Nginx, MySQL, PHP) for WordPress websites
   * Elastic (ELK) stack (Elasticsearch, Logstash, Kibana, etc.)
   * Serverless on Amazon Lambda, Azure Functions, Google Actions, Iron.io, etc.
   * <a target="_blank" href="https://www.cncf.io/">CNCF (Cloud Native Computing Foundation)</a> stack of Kubernetes, Prometheus monitoring, OpenTracing, JeagerTracing, FluentD log collector, and other projects
   * DevSecOps "stack" of Git, Nexus/Artifactory, Jenkins, MVN, Vagrant, Docker, etc.
   * Cloud management tools Terraform, AWS Cloud Formation, etc.

This repo enables you to get the above up and running in a matter of minutes.
Being able to get started quickly means that you can get working with the application rather than the ceremonies of installation.

This repo brings to Mac users the "frequent, small, and reversible changes" for Agile.

In this course, well-known DevOps practitioners Ernest Mueller and James Wickett provide an overview of the DevOps movement, focusing on the core value of CAMS (culture, automation, measurement, and sharing)

<a name="LimitedMemory"></a>

### Limited Memory

If you're now thinking "a Mac can't run every one of these programs" you're correct.
A Mac has at most 16 GB of RAM.

This repo isn't designed to run every service, but to enable you to pick a few at a time,
even on a MacBook Air with 4GB RAM and 128 GB hard disk.

The advantage gained by this script is <strong>fast change</strong>.
For example, setup to try the Atom editor, then remove it, and install something else.
This script enables you to <strong>switch quickly</strong> among sets of programs to <strong>quickly evaluate</strong> the technical aspects of each stack actually running -- not just conceptually -- but really working together at the same time.

Scripts here are <strong>modular</strong>. Its default setting is to not install everything. It installs only what you tell it to by adding a keyword in the control file.

Keywords to trigger install are specified in category variables:

<a name="Categories"></a>

* MAC_TOOLS <a href="#Homebrew">Homebrew</a>, <a href="#mas">mas</a>, Ansible, 1Password, PowerShell, etc.
* DATA_TOOLS MongoDB, postgresql, mysql, mariadb, graphql?
* EDITORS Atom, Code, Eclipse, Emacs, IntelliJ, Macvim, STS, Sublime, Textmate, vim
* BROWSERS chrome, firefox, brave, phantomjs
* GIT_CLIENTS git, cola, github, gitkraken, smartgit, sourcetree, tower, magit, gitup
* GIT_TOOLS hooks, tig, lfs, diff-so-fancy, grip, p4merge, git-flow, signing, hub

* JAVA_TOOLS Maven, Ant, Gradle, TestNG, Cucumber, Junit4, Junit5, Yarn, dbunit, Mockito,
          JMeter, GCViewer, JProfiler, etc.
* PYTHON_TOOLS Virtualenv, jupyter, anaconda, ipython, numpy, scipy, matplotlib, pytest, robotframework, etc.
* NODE_TOOLS Bower, gulp, gulp-cli, npm-check, jscs, less, jshint, eslint, webpack, etc.

* LOCALHOSTS Apache (httpd, apachectl), iron
* TEST_TOOLS selenium, sikulix, golum, dbunit?
* CLOUD_TOOLS aws, gcp, azure, cf, heroku, docker, vagrant, terraform, serverless

* MON_TOOLS (for monitoring) WireShark, Prometheus, others
* VIZ_TOOLS (for visualization) Grafana, others (Prometheus, Kibana, Graphite)

* COLAB_TOOLS (for collaboration) google-hangouts, hipchat, joinme, keybase, microsoft-lync, skype, slack, teamviewer, whatsapp, sococo, zoom
* MEDIA_TOOLS Camtasia, Kindle (others: Snagit, etc.)
<br /><br />

Links for individual apps above take you to technical descriptions about that technology.

The categories are run in dependency sequence. MAC_TOOLS are installed to provide underlying utilities, then DATA_TOOLS provides databases, then servers are installed, etc.

### Run types

"Genius bars" providing support to laptop users make use of this to quickly ready a <strong>new</strong> laptop for developers joining their organization. This helps developers skip wasted days installing (and doing it differently than colleagues).

This repo brings DevSecOps-style <strong>"immutable architecture"</strong> to MacOS laptops. Immutability means replacing the whole machine instance instead of upgrading or repairing faulty components.

But you don't have to start from scratch.

This script also performs <strong>updates</strong> and <strong>uninstall</strong> too.
Although you may use Apple's Time Machine app to backup everything to a USB drive or AirPort Time Capsule, you may want a way to <strong>keep up with the latest changes</strong> in apps updated to the latest version. Remember the "openssl" update scare?

This script upgrades all programs it knows about if you run the script with the RUNTYPE set to "upgrade". Use this script to install and configure what you need at the moment.

Change the RUNTYPE to "remove" and it clears up disk space.
(But be careful that overuse can fragment your disk space)


### Servers to work offline

This bash script enables you to <strong>work offline</strong> because it installs several servers. You manage allocation of port numbers in <strong>one place</strong>:

   <pre>
   ELASTIC_PORT="9200"    # DATA_TOOLS from default 9200
   GRAFANA_PORT="8089"    # VIZ_TOOLS from default 8080
   JEKYLL_PORT="4000"     # LOCAOHOSTS from default 4000
   JENKINS_PORT="8088"    # LOCALHOSTS from default 8080
   KIBANA_PORT="5601"     # DATA_TOOLS default 5601
   MYSQL_PORT="3060"      # DATA_TOOLS default 3060
   MEANJS_PORT="3000"     # NODE_TOOLS from default 3000
   MINIKUBE_PORT="8083"   # LOCAOHOSTS from default 8080
   NEO4J_PORT="7474"      # DATA_TOOL default 7474 HTTPS: 7473
   NGINX_PORT="8086"      # LOCALHOSTS from default 8080
   PACT_PORT="6666"       # TEST_TOOLS from default 6666
   POSTGRESQL_PORT="5432" # DATA_TOOLS default 5432
   PROMETHEUS_PORT="9090" # MON_TOOLS default 9090
   REDIS_PORT="6379"      # DATA_TOOLS default 6379
   SONAR_PORT="9000"      # DATA_TOOLS default 9000
   TOMCAT_PORT="8087"     # LOCALHOSTS from default 8080
   </pre>

   Docker instances use the same ports.

The above list is from the <strong>secrets.sh</strong> file in your $HOME folder, which
you edit to specify which port numbers and <strong>keywords to specify apps</strong> you want installed.

   The file's name is suffixed with ".sh" because it is a runnable script that establishes memory variables for a <a href="#MainScript">Setup script</a> to reference.


<a name="Homebrew"></a>

### Homebrew

Most of the apps installed make use of installation code defined in the Homebrew repository online. There is a file (of Ruby code) for each brew install formula at:<br />

   <a target="_blank" href="
   https://github.com/Homebrew/homebrew-core/blob/master/Formula/httpd.rb">
   https://github.com/Homebrew/homebrew-core/blob/master/Formula/httpd.rb</a>

   PROTIP: Before downloads a brew formula, we recommend that you look at its Ruby code to verify what really occurs and especially where files come from.

   <pre><strong>brew edit wget</strong></pre>


   In fact, we recommend that you install a binary repository proxy that supply you vetted files from a trusted server instead of retrieving whatever is the latest on the public Homebrew server.

   Homebrew currently has over 4,500 formulas.

To install and configure programs which don't have brew installation formulas,
various commands such as curl, sed, cut, etc. are used in the script.

Yes, you can just run brew yourself, one at a time. But logic in the script goes beyond what Homebrew does, and <strong>configures</strong> the component just installed:

   * Undo a brew error (such as needing an unset)
   * Install dependent components where necessary
   * Display the version number installed (to a log)
   * Add alias and paths in <strong>.bash_profile</strong> (if needed)
   * Perform configuration (such as adding a missing file needed for mariadb to start)
   * Edit configuration settings (such as changing default port within Nginx within config.conf file)
   * Upgrade and uninstall if that is available
   * Run a demo using the component to ensure that what has been installed actually works.
   <br /><br />

## Make this work for you

The section below explains to someone relatively new to Mac machines the steps to automate installation of additional MacOS application programs. Along the way, we explore basic skills to use a command-line Terminal and common commands.

1. Get <a target="_blank" href="https://wilsonmar.github.io/apple-macbook-hardware/">Mac laptop hardware</a>, <a target="_blank" href="https://wilsonmar.github.io/macos-bootup/">boot-up</a>

1. Obtain the Mac's Launch bar by positioning your mouse at the bottom edge of the screen until it appears.

2. If you don't see an icon for the <a target="_blank" href="https://wilsonmar.github.io/mac-osx-terminal/">Terminal program</a>, click the magnifying glass icon always at the upper-right corner and type in Term until "Terminal app" is highlighted, then press Enter to accept it.

3. Click menu Shell then click New Window for a Terminal session.

   PROTIP: More experienced people hover the mouse over New Window and click on one of the options.

   The Terminal program is called a "Bash" shell, which is a contraction of the term "Bourne-agan shell", which is a play on words.


   <a name="VersionWithGap"></a>

   ### Version with Grep

1. Test if you have Bash v4 installed by typing this:

   <pre><strong>bash --version | grep 'bash'
   </strong></pre>

   Bash 4.0 was released in 2009, but Apple still ships version 3.x, which first released in 2007.

   You have a recent version of Bash if you see:

   <pre>GNU bash, version 4.4.19(1)-release (x86_64-apple-darwin17.3.0)
   </pre>

   PROTIP: The attribute to obtain the version can vary among different commands.
   "--version" or "-v" or "version" may be used.

   Hold the Shift key to press the | (called pipe) key at the upper-right of the keyboard.

   The <tt>grep 'bash'</tt> is needed to filter out lines that do not contain the word "bash" in the response such as:

   <pre>GNU bash, version 4.4.19(1)-release (x86_64-apple-darwin17.3.0)
   Copyright (C) 2016 Free Software Foundation, Inc.
   License GPLv3+: GNU GPL version 3 or later &LT;http://gnu.org/licenses/gpl.html>
   &nbsp;
   This is free software; you are free to change and redistribute it.
   There is NO WARRANTY, to the extent permitted by law.</pre>

   If you have bash v3 that comes with MacOS, <a target="_blank" href="https://www.admon.org/scripts/new-features-in-bash-4-0/">this blog describes what is improved by version 4</a>.

   ### mac-bash4.sh initialization

2. Switch to back to this web page by holding down the command key and pressing Tab repeatedly until it rests on the browser icon.

3. Triple-click on the script line below to highlight it for copying:

   <pre>sh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/mac-setup/master/mac-bash-up.sh)"</pre>

4. Press Command+C to copy it to your invisible Clipboard.
5. Switch to the Terminal by holding down command and pressing Tab repeatedly until it rests on the Termial icon.
6. At the Terminal, click on a Terminal window and paste in the command by holding down command then V. It doesn't matter what folder you're on at this point.
7. Press Enter to run the command, which upgrades Bash to version 4 and copies a file to your Home folder.

   The script first makes use of the Ruby program to install Homebrew which, in turn, installs Bash v4 using the brew command to download and configure packages.

8. After it runs, verify the version again <a href="#VersionWithGap">as described above</a> to ensure it's version 4.


   <a name="HomeFolder"></a>

   ### Home folder

9. The default location the Terminal command opens to by default is your "Home" folder, which you can reach anytime by:

   <pre><strong>cd
   </strong></pre>

9. The "~" (tilde character) prompt represents the $HOME folder, which is equivalent to a path that contains your user account, such as (if you were me):

   <pre>/Users/wilsonmar</pre>

1. You can also use this variable to reach your account's Home folder:

   <pre>cd $HOME</pre>

   In other words these commands all achieve the same result:

   <tt>cd = cd ~ = cd $HOME</tt>

   ### secrets.sh at Home

   It's wise to avoid storing secrets in GitHub or other public repository. Files stored in
   <strong>your user $HOME holder</strong> (outside a Git-managed folder) have no chance to be uploaded from the Git repository. The script references secrets there.

   And if the script doesn't see a secrets file in your $HOME folder,
   it copies one there from the repo's sample file.

   NOTE the secrets.sh is a clear-text file.

   ### Encrypting and Decrypting secrets

   Optionally, you may store secrets and configurations in an encrypted file
   after some initial configuration.

   Run script <tt>./secrets.edit.sh</tt> to decrypt the contents of <tt>secrets.sh</tt>
   for the mac-setup-all.sh script to use.

   Run script <tt>./secrets.lock.sh</tt> to encrypt the contents of <tt>secrets.sh</tt>.

   Utilities "blackbox" or "git-secret" can be used to handle


   ### Text edit secrets.sh

1. Use a text editor to edit the <tt>secrets.sh</tt> file using a text editor that comes pre-loaded on every Mac:

   <pre><strong>textedit ~/secrets.sh</strong></pre>

   The tilde character specifies that the file is in your Home folder.

   <a name="Shebang"></a>

   ### Top of file Shebang

   Looking in the file, consider the first line in the secrets.sh file:

   <pre>#!/bin/bash</pre>

   That is the "Bourne-compliant" path for the Bash v3.2 shell installed by default on MacOS up to High Sierra. BTW, other Linux flavors may alternately use this for portability:

   <pre>#!/usr/bin/env</pre>

   BTW, unlike Windows, which determines the program to open files based on the suffix (or extension) of the file name, Linux shell programs such as Bash reference the "shebang" on the first line inside the file.

1. Open another Terminal window.
1. View the above files to see that they are binary executable files, such as:

   <pre><strong>textedit /usr/bin/bash</strong></pre>

1. Exit the file.
1. Press the command key with the back-tick (`) at the upper-left of the keyboard to switch among textedit windows.

   ### Version 4 Shebang

   If you instead see this on the first line:

   <tt>#!/usr/local/bin/bash</tt>

   that is the Bash program associated with <a href="#Bash4">Bash v4</a>.

   Version 4 is needed for <a href="#BashArrays">"associative arrays"
   needed in the script</a>.

   This is why we needed to first upgrade Bash before running other scripts.


   ### App keywords

   The initial secrets.sh file does not have keywords which specify additional apps to install.

1. Scroll down or press command+F to type an app keyword to find its <a href="#Categories">category</a>.

   ### Edit port numbers

1. Scroll to the list of <a href="#Ports">ports (listed above)</a>.

1. May sure that none of the ports are the same (conflicts).

1. Save the file and exit the text editor.

   <a name="MainScript"></a>

   ### Setup all

1. Now copy, switch, click and paste in a Terminal window to run this command:

   <pre>sh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/mac-setup/master/mac-setup-all.sh)"</pre>

   The script referenced in the command obtains more files needed by cloning from a public GitHub repository (<a target="_blank" href="https://github.com/wilsonmar/mac-setup/">
   https://github.com/wilsonmar/mac-setup</a>) to a folder under your home folder named "mac-setup".

4. Wait for the script to finish.

   On a 4mbps network the run takes less than 5 minutes for a minimal install.
   PROTIP: A faster network or a proxy Nexus server providing installers within the firewall would speed things up and ensure that vetted installers are used.

   When the script ends it pops up a log file in the TextEdit program that comes with MacOS.

5. Switch to the TextEdit window by clicking it.
6. Scroll to review the log file. Press command+F to input text to search.
6. Close the log file by clicking the red button.
7. Switch to a Finder window to your account's Home folder and delete log files.

   <a name="MacSetupFiles"></a>

   ### mac-setup files #

   The folder contains these files and folders:

   * Files within folder "hooks" are used by Git (if marked for install.)
   * File "mac-bash-profile.txt" contains starter entries to insert in ~/.bash_profile that is executed before MacOS opens a Terminal session.
   <br /><br />

   ### Subsequent runs

   To update what is installed on your Mac, re-run the mac-setup.zsh bash script.

1. cd into your Home folder to find the <strong>secrets.sh</strong> file.
1. Edit the file, then run again locally:

   <pre><strong>chmod +x mac-setup-all.sh
   ./mac-setup-all.sh
   </strong></pre>

   The <tt>chmod</tt> (pronounced "che-mod") changes the permissions for executing the file.

   Now let's look at the Bash coding techniques used in the scripts mentioned above, at: <a target="_blank" href="
   https://wilsonmar.github.io/bash-coding/">
   https://wilsonmar.github.io/bash-coding</a>

<hr />

<a name="mas"></a>

## Mas Mac apps

The brew formula "mas" manages Apple Store apps, but it only manages apps that have already been paid for.  mas does not install apps new to your Apple Store account.

Apps on Apple's App Store for Mac need to be installed manually. <a target="_blank" href="https://www.reddit.com/r/osx/comments/4hmgeh/list_of_os_x_tools_everyone_needs_to_know_about/">
Popular apps</a> include:

   * Office for Mac 2016
   * BitDefender for OSX
   * CrashPlan (for backups)
   * Amazon Music
   * <a target="_blank" href="https://wilsonmar.github.io/rdp/#microsoft-hockeyapp-remote-desktop-for-mac">HockeyApp RDP</a> (Remote Desktop Protocol client for controlling Microsoft Windows servers)
   * Colloquy IRC client (at https://github.com/colloquy/colloquy)
   * etc.
   <br /><br />

### .pkg and .dmg

.pkg and .dmg files can be downloaded to install apps.



<a name="CloudSync"></a>

## Cloud Sync

Apps for syncing to cloud providers are installed mostly for manual use:

Dropbox, OneDrive, Google Drive, Amazon Drive


## Additional apps

* <a target="_blank" href="https://answers.splunk.com/answers/223311/how-to-install-splunk-622-on-a-mac-os-x.html">Splunk</a> log analysis SPLUNK_PORT="8000"
 http://docs.splunk.com/Documentation/SplunkLight

* Kafka streams


<a name="More"></a>

## Wait, there's more

Lists of Mac programs:

   * https://github.com/paulirish/dotfiles/blob/master/brew-cask.sh
   (one of the earliest ones by a legend at Google)

   * https://github.com/andrewconnell/osx-install described at http://www.andrewconnell.com/blog/rapid-complete-install-reinstall-os-x-like-a-champ-in-three-ish-hours separates coreinstall.sh from myinstall.sh for personal preferences.

   * https://www.reddit.com/r/osx/comments/3u6mob/what_are_the_top_10_osx_applications_you_use/
   * https://github.com/siyelo/laptop
   * https://github.com/evanchiu/dotfiles
   * https://github.com/jeffreyjackson/mac-apps
   * https://github.com/jaywcjlove/awesome-mac/blob/master/README.md
   * https://medium.com/@ankushagarwal/maximize-developer-productivity-on-a-mac-a9ae6fbaedab
   * https://dotfiles.github.io/

   * https://www.mugo.ca/Blog/Turbo-charge-your-Mac-development-environment describes use of Vagrant

## Others like this

Here are other scripts to install on Mac:

* https://github.com/wilsonmar/git-utilities/blob/master/README.md was an early example just the bare basics,
   such as https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
   and https://git-scm.com/docs/git-config
* https://github.com/monfresh/laptop
* https://github.com/18F/laptop
* https://dzone.com/articles/local-continuous-delivery-environment-with-docker
* https://medium.com/my-name-is-midori/how-to-prepare-your-fresh-mac-for-software-development-b841c05db18
* https://github.com/swoodford/osx/blob/master/setup-developer-environment.sh
* https://www.bonusbits.com/wiki/Reference:Mac_OS_DevOps_Workstation_Setup_Check_List
* More at https://github.com/thoughtbot/laptop/blob/master/mac
* https://github.com/ghaiklor/iterm-fish-fisherman-osx described at https://ghaiklor.github.io/iterm-fish-fisherman-osx/ and https://blog.ghaiklor.com/bootstrap-your-terminal-environment-in-macos-with-a-single-bash-script-ea1ca445f0a5
* https://github.com/why-jay/osx-init/blob/master/install.sh
