The tagline of this repo is "Automatically install and configure the <strong>most popular programs</strong> to work offline as a developer of several stacks on a Mac and in clouds."

Bash scripts in this repo install, configure, then start programs running to prove that installation was successful. The "stacks" installed include:

   * MEAN (MongoDB, Express, Angular, NodeJs) with the MeanJs sample app
   * JAM (Jekyll, APIs, Markup) with a sample Github.io website
   * MAMP (Macintosh, Apache/Nginx, MySQL, PHP) for WordPress websites
   * Elastic (ELK) stack (Elasticsearch, Logstash, Kibana, etc.)
   * Serverless on Amazon Lambda, Azure Functions, Google Actions, Iron.io
   * DevSecOps "stack" of Git, Jenkins, Nexus, Vagrant, Docker, Terraform, etc.

By enabling you to switch quickly among sets of programs, scripts in this repo <strong>you can quickly evaluate</strong> the technical aspects of each stack and individual program not just conceptually, but really working together at the same time. The script in this repo is thousands of lines long so that you can mix and match what you install. No hidden code here.

<a name="Homebrew"></a>

### Homebrew

Most of the apps installed make use of installation code defined in the Homebrew repository online. There is a file (of Ruby code) for each brew install formula at:<br />

   <a target="_blank" href="
   https://github.com/Homebrew/homebrew-core/blob/master/Formula/httpd.rb">
   https://github.com/Homebrew/homebrew-core/blob/master/Formula/httpd.rb</a>

   PROTIP: Before downloads a brew formula, we recommend that you look at Ruby code to verify what really occurs and especially where files come from. In fact, we recommend that you install a binary repository proxy that supply you vetted files from a trusted server instead of retrieving whatever is the latest on the public Homebrew server.

   Homebrew currently has over 4,500 formulas.

Various commands such as curl, sed, cut, etc. are used as well, especially to install and configure programs which don't have brew installation formulas.

Most tutorials ask you to <strong>manually type</strong> or copy and paste strings from web pages (often with missing steps), which can take time, and be error-prone. And don't get me started on webinars with demos that brags rather than teach.
This script cuts through all that by scripts running on your Mac and displaying on your screen.

You will benefit most from this if you configure a <strong>new</strong> laptop for yourself or for other developers joining your organization. You'll skip wasted days installing everything one at a time (and doing it differently than colleagues).
This repo brings DevSecOps-style <strong>"immutable architecture"</strong> to MacOS laptops. Immutability means replacing the whole machine instance instead of upgrading or repairing faulty components.

But this script helps with <strong>updates too</strong>. You can, but don't have to, start from scratch. 
Although you may use Apple's Time Machine app to backup everything to a USB drive or AirPort Time Capsule, you may want a way to <strong>keep up with the latest changes</strong> in apps updated to the latest version, by running a single "upgrade" command. Use this script to install and configure most programs most people use.

This bash script enables you to <strong>work offline</strong> by installing several servers. 
You manage allocation of port numbers in <strong>one place</strong>:

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

Docker instances use the same ports, such as:

   <pre>
   PROMETHEUS_PORT="9090" # MON_TOOLS default 9090
   </pre>

The above list is fron the <strong>secrets.sh</strong> file in your $HOME folder, which
you edit to specify which port numbers and <strong>keywords to specify apps</strong> you want installed.

   The file's name is suffixed with ".sh" because it is a runnable script that establishes memory variables for a <a href="#MainScript">Setup script</a> to reference.

Keywords to trigger install are organzied by categories:

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

The categories are run in dependency sequence. MAC_TOOLS to provide underlying utilities, then
DATA_TOOLS to provide databases, etc.

Yes, you can just run brew yourself, one at a time. But logic in the script goes beyond what Homebrew does, and <strong>configures</strong> the component just installed:

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

   PROTIP: The attribute to obtain the version can vary among different commands.
   "--version" or "-v" or "version" may be used.

   Hold the Shift key to press the | (called pipe) key at the upper-right of the keyboard.

   The <tt>grep 'bash'</tt> is needed to filter out lines that do not contain the word "bash" in the response such as:

   <pre>
GNU bash, version 4.4.19(1)-release (x86_64-apple-darwin17.3.0)
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
&nbsp;
This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
   </pre>

   If you have bash v3 that comes with MacOS, the next few steps will update it to version 4.

   <a target="_blank" href="https://www.admon.org/scripts/new-features-in-bash-4-0/">
   This blog describes what is improved by version 4</a>.
   Bash 4.0 was released in 2009, but Apple still ships version 3.x, which first released in 2007.

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


   ### secrets.sh at Home

   The first time the script runs, it also copies the <strong>secrets.sh</strong> file from the public on-line repository into your laptop so that you can add your secrets in the file but have no chance the file will be uploaded from the Git repository where it came from.

   The file is placed in your account Home folder.

   <a name="HomeFolder"></a>

   ### Home folder

9. The default location the Teminal command opens to by default is your "Home" folder, which you can reach anytime by:

   <pre><strong>cd
   </strong></pre>

9. The "~" (tilde character) prompt represents the $HOME folder, which is equivalent to a path that contains your user account, such as (if you were me):

   <pre>/Users/wilsonmar</pre>

1. You can also use this variable to reach your account's Home folder:

   <pre>cd $HOME</pre>

   In other words these commands all achieve the same result:

   <tt>cd = cd ~ = cd $HOME</tt>

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

   To update what is installed on your Mac, re-run the mac-setup.sh bash script.

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

## Mac apps

Apps on Apple's App Store for Mac need to be installed manually. <a target="_blank" href="https://www.reddit.com/r/osx/comments/4hmgeh/list_of_os_x_tools_everyone_needs_to_know_about/">
Popular apps</a> include:

   * Office for Mac 2016
   * BitDefender for OSX
   * CrashPlan (for backups)
   * Amazon Music
   * <a target="_blank" href="https://wilsonmar.github.io/rdp/#microsoft-hockeyapp-remote-desktop-for-mac">HockeyApp RDP</a> (Remote Desktop Protocol client for controlling Microsoft Windows servers)
   * Colloquy IRC client (at https://github.com/colloquy/colloquy)
   * etc.

The brew "mas" manages Apple Store apps, but it only manages apps that have already been paid for. But mas does not install apps new to your Apple Store account.


<a name="CloudSync"></a>

## Cloud Sync

Apps for syncing to cloud providers are installed mostly for manual use:

Dropbox, OneDrive, Google Drive, Amazon Drive



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