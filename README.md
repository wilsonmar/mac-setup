The tagline of this repo is "Automatically install and configure the <strong>most popular programs</strong> developer need to work offline as a developer of several stacks on a Mac."

Bash scripts in this repo install, configure, then start programs running to prove that installation was successful. The "stacks" installed include:

   * MEAN (MongoDB, Express, Angular, NodeJs) with the MeanJs sample app
   * JAM (Jekyll, APIs, Markup) with a sample Github.io website
   * MAMP (Macintosh, Apache/Nginx, MySQL, PHP) for WordPress websites
   * Elastic (ELK) stack (Elasticsearch, Logstash, Kibana, etc.)
   * Serverless on Amazon Lambda, Azure Functions, Google Actions, Iron.io
   * DevSecOps "stack" of Git, Jenkins, Nexus, Vagrant, Docker, Terraform, etc.

By enabling you to switch quickly among sets of programs, scripts in this repo <strong>you can quickly evaluate</strong> the technical aspects of each stack and individual program not just conceptually, but really working together at the same time. The script in this repo is thousands of lines long so that you can mix and match what you install.

<a name="Homebrew"></a>

### Homebrew

Most of the apps installed make use of installation code defined in the Homebrew repository online. There is a file (of Ruby code) for each brew install formula at:<br />

   <a target="_blank" href="
   https://github.com/Homebrew/homebrew-core/blob/master/Formula/httpd.rb">
   https://github.com/Homebrew/homebrew-core/blob/master/Formula/httpd.rb</a>

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

Programa organzied by categories:

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
* CLOUDS icloud, aws, gcp, azure, cf, heroku, docker, vagrant, terraform, serverless

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

1. Obtain the Mac's Launch bar by positioning your mouse at the bottom edge of the screen until it appears.

2. If you don't see an icon for the Terminal program, click the magnifying glass icon always at the upper-right corner and type in Term until "Terminal app" is highlighted, then press Enter to accept it. 

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


<a name="JAVA_TOOLS"></a>

## Java tools via Maven, Ant

Apps added by specifying in JAVA_TOOLS are GUI apps.

Most other Java dependencies are specified by manually added in each custom app's <strong>pom.xml</strong> file
to specify what Maven downloads from the Maven Central online repository of installers at

   <a target="_blank" href="
   http://search.maven.org/#search%7Cga%7C1%7Cg%3A%22org.dbunit%22">
   http://search.maven.org/#search%7Cga%7C1%7Cg%3A%22org.dbunit%22</a>

Popular in the Maven Repository are:

   * <strong>yarn</strong> for code generation. JHipster uses it as an integrated tool in Java Spring development.
   * <strong>DbUnit</strong> extends the JUnit TestCase class to put databases into a known state between test runs. Written by Manuel Laflamme, DbUnit is added in the Maven pom.xml (or Ant) for download from Maven Central. See http://dbunit.wikidot.com/
   * <strong>mockito</strong> enables calls to be mocked as if they have been creted.
   Insert file java-mockito-maven.xml as a dependency to maven pom.xml
   See https://www.youtube.com/watch?v=GKUlQMrbtHE - May 28, 2016
   and https://zeroturnaround.com/rebellabs/rebel-labs-report-go-away-bugs-keeping-your-code-safe-with-junit-testng-and-mockito/9/

   * <strong>TestNG</strong> 
   See http://testng.org/doc/download.html
   and https://docs.mendix.com/howto/testing/create-automated-tests-with-testng
   
   When using Gradle, insert file java-testng-gradle as a dependency to gradle working within Eclipse plug-in
   Build from source git://github.com/cbeust/testng.git using ./build-with-gradle
   
TODO: The Python edition of this will insert specs such as this in pom.xml files.   

<a name="Logging"></a>

## Logging

The script outputs logs to a file.

This is so that during runs, what appears on the command console are only what is relevant to debugging the current issue.

At the end of the script, the log is shown in an editor to <strong>enable search</strong> through the whole log.


<a name="JenkinsStart"></a>

## Jenkins server

To start the Jenkins server to a specified port:

    <pre>jenkins --httpPort=$JENKINS_PORT  &</pre>

   The "&" puts the process in the background so that the script can continue running.

   The response is a bunch of lines ending with
   "INFO: Jenkins is fully up and running".

Several other methods (which don't work now) are presented on the internet:

   * <tt>sudo service jenkins start</tt>

   * <a target="_blank" href="https://three1415.wordpress.com/2014/12/29/changing-jenkins-port-on-mac-os-x/">
   This blog, on Dec 29, 2014</a> recommends

   <pre>sudo defaults write /Library/Preferences/org.jenkins-ci httpPort "$JENKINS_PORT"
   sudo launchctl unload /Library/LaunchDaemons/org.jenkins-ci.plist
   sudo launchctl load /Library/LaunchDaemons/org.jenkins-ci.plist
   </pre>


<a name="JenkinsJava"></a>

The command "jenkins" above is actually a bash script that invokes Java:

   <pre>#!/bin/bash
   JAVA_HOME="$(/usr/libexec/java_home --version 1.8)" \
   exec java  -jar /usr/local/Cellar/jenkins/2.113/libexec/jenkins.war "$@"
   </pre>

The code within "$(...)" is run to obtain the value. In this case, it's:

    <pre>/Library/Java/JavaVirtualMachines/jdk1.8.0_162.jdk/Contents/Home
    </pre>

   The link above is the folder where MacOS keeps the Java SDK.
   Java executables (java, javac, etc.) are in the bin folder below that location.

The path to jenkins.war and jenkins-cli.war executable files are physcally at:

   <pre>ls /usr/local/opt/jenkins/libexec</pre>


<a name="Jenkins"></a>

### Mac Plist file for Jenkins

Instead of specifying the port in the command, change the configuration file.

On MacOS, services are defined by <strong>plist</strong> files containing XML, 
such as this for Jenkins server:

   <pre>
&LT;?xml version="1.0" encoding="UTF-8"?>
&LT;!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
&LT;plist version="1.0">
  &LT;dict>
    &LT;key>Label&LT;/key>
    &LT;string>homebrew.mxcl.jenkins&LT;/string>
    &LT;key>ProgramArguments&LT;/key>
    &LT;array>
      &LT;string>/usr/libexec/java_home&LT;/string>
      &LT;string>-v&LT;/string>
      &LT;string>1.8&LT;/string>
      &LT;string>--exec&LT;/string>
      &LT;string>java&LT;/string>
      &LT;string>-Dmail.smtp.starttls.enable=true&LT;/string>
      &LT;string>-jar&LT;/string>
      &LT;string>/usr/local/opt/jenkins/libexec/jenkins.war&LT;/string>
      &LT;string>--httpListenAddress=127.0.0.1&LT;/string>
      &LT;string>--httpPort=8080&LT;/string>
    &LT;/array>
    &LT;key>RunAtLoad&LT;/key>
    &LT;true/>
  &LT;/dict>
&LT;/plist>
   </pre>

The "1.8" is the version of Java, <a href="#JenkinsJava"> described below</a>.

The "httpPort=8080" default is customized using this variable in secrets.sh:

      JENKINS_PORT="8082"  # default 8080

The above is file <tt>homebrew.mxcl.jenkins.plist</tt> within folder 
<tt>/usr/local/opt/jenkins</tt> installed by brew.
The folder is a symlink created by brew to the physical path where brew installed it:

      /usr/local/Cellar/Jenkins/2.113/homebrew.mxcl.jenkins.plist

The "2.113" means that several versions of Jenkins can be installed side-by-side.
This version number changes over time. So it is captured by command:

   <pre>JENKINS_VERSION=$(jenkins --version)  # 2.113</pre>

The folder is actually a symlnk which points to the physical folder defined by:
JENKINS_CONF="/usr/local/Cellar/Jenkins/$JENKINS_VERSION/homebrew.mxcl.jenkins.plist"

The path is defined in a variable so simplify the sed command to make the change:

         sed -i "s/httpPort=8080/httpPort=$JENKINS_PORT/g" $JENKINS_CONF
               # --httpPort=8080 is default.


<a name="JenkinsFirstTime"></a>

### Jenkins GUI in browser

The command to view the server in the default internet browser (such as Safari, Chrome, etc.) is:

   <pre>open "http://localhost:$JENKINS_PORT"</pre>

   It's "http" and not "https" because a certificate has not been established yet.

When executed the first time, Jenkins displays this screen:


However, we don't want to open it from the command line script, but from a GUI automation script.

<a name="JenkinsGUIAuto"></a>

### Jenkins GUI automation

The script invokes a GUI automation script that opens the file mentioned on the web page above:

   <pre>/Users/wilsonmar/.jenkins/secrets/initialAdminPassword</pre>

   "/Users/wilsonmar" is represented by the environment variable named $HOME or ~ symbol,
   which would be different for you, with your own MacOS account name.
   Thus, the generic coding is:

   <pre>JENKINS_SECRET=$(<$HOME/.jenkins/secrets/initialAdminPassword)</pre>

The file (and now $JENKINS_SECRET) contains a string in clear-text like "851ed535fd3249ab95a274d23242655c".

We then call a GUI automation script to get that string to paste it in the box labeled "Administrator Password"
based on the id "security-token" defined in this HTML:

   <pre>&LT;input id="security-token" class="form-control" type="password" name="j_password">
   </pre>

   This was determined by obtaining the outer HTML from Chrome Developer Tools.

The call is:

   <pre>python tests/jenkins_secret_chrome.py  chrome  $JENKINS_PORT  $JENKINS_SECRET
   </pre>

We use Selenium Python because it reads and writes system environment variables.

Use of Selenium and Python this way requires them to be installed before Jenkins and other web servers.


<a name="JenkinsShutdown"></a>

### Jenkins shutdown (kill)

To shut down Jenkins, 

   <pre>PID="ps -A | grep -m1 'jenkins' | awk '{print $1}'"
   fancy_echo "Shutting downn jenkins $PID ..."
   kill $PID</pre>

The above is the automated approach to the manual on recommended by many blogs on the internet:

   Some say in Finder look for Applications -> Utilities -> Activity Monitor
   
   Others say use command:

   <pre>ps -el | grep jenkins</pre>

   Two lines would appear. One is the bash command to do the ps command. 
   
   The PID desired is the one that lists the path used to invoke Jenkins, 
   <a href="#JenkinsJava">described above</a>:

   <pre>/usr/bin/java -jar /usr/local/Cellar/jenkins/2.113/libexec/jenkins.war</pre>

   <pre>kill <em>2134</em></pre>

   That is the equivalent of Windows command "taskkill /F /PID XXXX"

   There is also:

   <pre>sudo service jenkins stop</pre>

Either way, the response expected is:

   <pre>INFO: JVM is terminating. Shutting down Winstone</pre>


<a name="PythonGUI"></a>

## Python GUI Automation

If the title is not found an error message like this appears on the console:

   <pre>
  File "tests/jenkins_secret_chrome.py", line 30, in <module>
    assert "Jenkins [Jenkins]" in driver.title  # bail out if not found.
AssertionError
   </pre>


<a name="DelayToView"></a>

### Delay to view

Some put in a 5 second delay:

   <pre>time.sleep(5)</pre>

Use of this feature requires a library to be specified at the top of the file:

   <pre>import sys</pre>

<a name="ScreenShot"></a>

### Screen shot picture

Some also take a photo to "prove" that the result was achieved:

   <pre>driver.save_screenshot('jenkins_secret_chrome.py' +utc_offset_sec+ '.png')</pre>

We put the name of the script file in the picture name to trace back to its origin.
We put a time stamp in ISO 8601 format so that several png files sort by date.

utc_offset_sec = time.altzone if time.localtime().tm_isdst else time.timezone
datetime.datetime.now().replace(tzinfo=datetime.timezone(offset=utc_offset_sec)).isoformat()

The long explanation is https://docs.python.org/2/library/datetime.html


<a name="EndOfScript"></a>

### End of script

<a target="_blank" href="https://stackoverflow.com/questions/15067107/difference-between-webdriver-dispose-close-and-quit">
NOTE</a>:

   * webDriver.Close() - Close the browser window that currently has focus
   * webDriver.Quit() - Calls Dispose()
   * webDriver.Dispose() Closes all browser windows and safely ends the session

driver.quit() means that someone watching the script execute would only see the web app's screen for a split second. 

   We prefer to use id rather than name fields because the HTML standard states that id's are 
   supposed to be unique in each web page.

<hr />

<a name="Groovy"></a>

## Groovy

Other similar scripts (listed in "References" below) run

http://groovy-lang.org/install.html


<a name="CLOUD_TOOLS"></a>

## Cloud Sync

Dropbox, OneDrive, Google Drive, Amazon Drive


<a name="FONTS"></a>

## Scape for Fonts in GitHub
 
Some developers have not put their stuff from GitHub into Homebrew. So we need to read (scrape) the website and see what is listed, then grab the text and URL to download.

Such is the situation with font files at 
https://github.com/adobe-fonts/source-code-pro/releases/tag/variable-fonts
The two files desired downloaded using the curl command are:

* https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Italic.ttf
* https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Roman.ttf

The files are downloaded into <a target="_blank" href="https://support.apple.com/en-us/HT201722">where MacOS holds fonts available to all users</a>: <tt>/Library/Fonts/</tt>

<a target="_blank" href="http://sourabhbajaj.com/mac-setup/iTerm/README.html">ITerm2 can make use of these font files</a>.


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