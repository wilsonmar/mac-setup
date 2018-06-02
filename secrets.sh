#!/usr/local/bin/bash
# secrets.sh in https://github.com/wilsonmar/mac-setup
# run by mac-setup-all.sh (in the same repo) to define variables
# after making a copy to your $HOME folder where you edit to customize.
# Do not edit the secrets.sh within the GitHub folder.
#
# CAUTION: No spaces around = sign.
RUNTYPE="fromscratch"  # fromscratch, upgrade, remove, keep, cleanup

# Change these to your own information:
GIT_NAME="Wilson Mar"
GIT_ID="WilsonMar@gmail.com"
GIT_EMAIL="WilsonMar+GitHub@gmail.com"
GIT_USERNAME="hotwilson"
GPG_PASSPHRASE="only you know this 2 well"

GITS_PATH="$HOME/gits"
GITHUB_ACCOUNT="hotwilson"
GITHUB_REPO="hotwilson.github.io"
GITHUB_PASSWORD="change this to your GitHub account password"

# Lists can be specified below. The last one in a list is the Git default:
MAC_TOOLS=""
         # coreutils, unhide, maxfiles, locale, iterm2, mas, 
         # ansible, 1password, powershell, alfred, vmware-fusion, 
         # bartender, charles, carthage, 
         # others( paragon-extfs, paragon-ntfs, paragon-vmdk-mounter, )
FONTS=""
     # mono (ubuntu), 
EDITORS=""
       # textedit, pico, nano, and vim are built into MacOS, but can be updated.
       # atom, brackets, code, eclipse, emacs, intellij, macvim, sts, sublime, textmate, webstorm
       # NOTE: Text Wrangler is a Mac app manually installed from the Apple Store.
GIT_CLIENTS=""
          # git, cola, github, gitkraken, smartgit, sourcetree, tower, magit, gitup, 
GIT_TOOLS=""
         # signing, hooks, 
         # keygen, tig, lfs, diff-so-fancy, grip, p4merge, git-flow, git-gerrit, hub, jekyll
BROWSERS=""
        # chrome, firefox, brave, phantomjs,    NOT: Safari
        # others (flash-player, adobe-acrobat-reader, adobe-air, silverlight)
DATA_TOOLS=""
          # mysql, neo4j, postgresql, mongodb, redis, rstudio, nexus, elastic, memcached?
          # vault, liquibase, others (dbunit?, mysql?, evernote?, influxdb?, Zeppelin, Nifi, Streamsets)
   MONGODB_DATA_PATH="/usr/local/var/mongodb" 
   MYSQL_PASSWORD="Pa$$w0rd"
LANG_TOOLS=""
          # python, python3, java, nodejs, go, dotnet
JAVA_TOOLS=""
          # maven, gradle, ant, TestNG, jmeter # REST-Assured, Spock
          # (Via maven, ant, or gradle: junit4, junit5, yarn, dbunit, mockito)
PYTHON_TOOLS=""
            # virtualenv, anaconda, jupyter, ipython, numpy, scipy, matplotlib, pytest, robot
            # robotframework, opencv, others
            # See http://www.southampton.ac.uk/~fangohr/blog/installation-of-python-spyder-numpy-sympy-scipy-pytest-matplotlib-via-anaconda.html
NODE_TOOLS=""
          # sfdx, aws-sdk, redis, graphicmagick, 
          # bower, gulp, gulp-cli, npm-check, jscs, less, jshint, eslint, webpack, 
          # mocha, chai, protractor, 
          # browserify, express, hapi, angular, react, redux
          # magicbook, others( , etc.)
RUBY_TOOLS=""
        # travis, rails, rust
CLOUD_TOOLS="terraform"
           # icloud, ironworker, docker, vagrant, rancher, 
           # awscli, gcp, azure, cf, heroku, terraform, serverless, (NOT: openstack)
           # others (google-drive-file-stream, dropbox, box, amazon-drive )

#   IRON_TOKEN="" # from https://hud-e.iron.io/signup (15 day trial)
#   IRON_PROJECT_ID="" # "helloworld1" from https://hud-e.iron.io/ settings page

#   SAUCE_USERNAME=""
#   SAUCE_ACCESS_KEY=""

COLAB_TOOLS=""
          # discord, google-hangouts, gotomeeting (32-bit), hipchat, joinme, keybase, microsoft-lync, 
          # signal, skype, slack, sococo, teamviewer, telegram, whatsapp, zoom
MEDIA_TOOLS=""
           # camtasia, kindle, tesseract, real-vnc, others (snagit?)
MON_TOOLS=""
         # wireshark, gcviewer, jprofiler, prometheus
VIZ_TOOLS=""
         # grafana, tableau, tableau-public, tableau-viewer
TRYOUT="all"  # smoke tests.
      # all, HelloJUnit5, TODO: `virtuaenv, phantomjs, docker, hooks, jmeter, minikube, cleanup, editor
TEST_TOOLS=""
        # selenium, sikulix, golum, opencv, sonar, soapui, gatling?, Tsung?, Locust?
        # Drivers for scripting language depend on what is defined in $GIT_LANG.
  # Listed alphabetically:
   CUCUMBER_PORT="9201"   # DATA_TOOLS from default ????
   ELASTIC_PORT="9200"    # DATA_TOOLS from default 9200
   GRAFANA_PORT="8089"    # VIZ_TOOLS from default 8080
   HYGIEIA_PORT="3000"    # LOCALHOSTS default 3000
   JEKYLL_PORT="4000"     # LOCAOHOSTS from default 4000
   JENKINS_PORT="8088"    # LOCALHOSTS from default 8080
   KIBANA_PORT="5601"     # DATA_TOOLS default 5601
   MB_PORT="2525"         # LOCALHOSTS from default 2525
   MYSQL_PORT="3060"      # DATA_TOOLS default 3060
   MEANJS_PORT="3000"     # NODE_TOOLS from default 3000
   MINIKUBE_PORT="8083"   # LOCAOHOSTS from default 8080
   MONGODB_PORT="27017"   # LOCALHOSTS default 27017
   NEO4J_PORT="7474"      # DATA_TOOL default 7474 HTTPS: 7473
   NGINX_PORT="8086"      # LOCALHOSTS from default 8080
   PACT_PORT="6666"       # TEST_TOOLS from default 6666
   POSTGRESQL_PORT="5432" # DATA_TOOLS default 5432
   PROMETHEUS_PORT="9090" # MON_TOOLS default 9090
   REDIS_PORT="6379"      # DATA_TOOLS default 6379
   SONAR_PORT="9000"      # DATA_TOOLS default 9000
   TOMCAT_PORT="8087"     # LOCALHOSTS from default 8080
     # FDM 4001
LOCALHOSTS=""
          # apache, hygieia, minikube, mountebank, nginx, tomcat, jenkins, grafana, prometheus, wikimedia?
DOCKERHOSTS=""  # prometheus
TRYOUT_KEEP="" # add to keep active after script.
           # grafana, ironworker, jekyll, jenkins, meanjs, mongodb, prometheus, sonar
# END
