#!/usr/bin/python
# jenkins_secret_setup.py in https://github.com/wilsonmar/mac-install/tree/master/tests/
# Call pattern:
# python tests/jenkins_secret_chrome.py  'chrome' $JENKINS_PORT  $JENKINS_SECRET  jenkins.png

#import argparse  # https://docs.python.org/2/howto/argparse.html
import sys
import pytz, time
from datetime import datetime, tzinfo, timedelta
from random import randint

from selenium import webdriver
from selenium.webdriver.common.keys import Keys

# From timestamps.py
def iso8601_local():
    class local_tz(tzinfo):
        def utcoffset(self, dt):
            ts = time.time()
            offset_in_seconds = (datetime.fromtimestamp(ts) - datetime.utcfromtimestamp(ts)).total_seconds()
            return timedelta(seconds=offset_in_seconds)
    return datetime.now().replace(microsecond=randint(0, 999999)).replace(tzinfo=local_tz()).isoformat()
    # print(iso8601_local()+" = ISO8601 time at local time zone offset, with random microseconds")

driver=sys.argv[1]
jenkins_port=sys.argv[2]
jenkins_secret=sys.argv[3]
#picture_path=sys.argv[3]
print('driver=', driver, ', port=', jenkins_port, ', secret=', jenkins_secret)

# TODO: #parser = argparse.ArgumentParser("simple_example")
#parser.add_argument("counter", help="An integer will be increased by 1 and printed.", type=int)
#args = parser.parse_args()
#print(args.counter + 1)

if driver == "chrome":
    print("chrome being used ...")
    driver = webdriver.Chrome()
elif driver == "firefox":
    print("chrome being used ...")
    driver = webdriver.Firefox()

driver.get("http://localhost:" + jenkins_port) # TODO: pass port in
assert "Jenkins [Jenkins]" in driver.title  # bail out if not found. Already processed.
#time.sleep(5) # to see it.

# <input id="security-token" class="form-control" type="password" name="j_password">         
secret = driver.find_element_by_id('security-token')
secret.send_keys(jenkins_secret)
secret.submit()
time.sleep(8) # to give it time to work.

# If the secret has already been processed:
# INFO: Session node0vq5f7379gwo49h7hz67yatn37 already being invalidated

# Take a picture (screen shot) of "Getting Started, Customize Jenkins"
driver.save_screenshot('jenkins_secret_chrome.py.' +iso8601_local()+ '.png')
assert "SetupWizard [Jenkins]" in driver.title 
#time.sleep(5) # to see it

driver.dispose()
