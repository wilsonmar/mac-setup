#!/usr/bin/python
# firefox_github_ssh_add.py in https://github.com/wilsonmar/git-utilities
# Invokes python Firefox driver to open GitHub, SSH Keys, insert what waw pbcopy to clipboard.

import time, sys, argparse  # getopt

from selenium import webdriver
from selenium.webdriver.common.keys import Keys

# https://www.python-course.eu/python3_history_and_philosophy.php

#def main(argv):
#	parser = argparse.ArgumentParser()
#	parser.add_argument("square", help="display a square of a given number")
#	args = parser.parse_args()
#	print(args.square**2)

#	print ('Number of arguments:', len(sys.argv), 'arguments.')
#	print ('Argument List:', str(sys.argv))

#parser = argparse.ArgumentParser(description='Process selenium.')
#parser.add_argument('browser', help='browser type')
#args = parser.parse_args()
#parser.add_argument('integers', metavar='N', type=int, nargs='+',
#                    help='an integer for the accumulator')
#parser.add_argument('--sum', dest='accumulate', action='store_const',
#                    const=sum, default=max,
#                    help='sum the integers (default: find the max)')

#print args.accumulate(args.integers)
	
#    Create new browser session:
#    for opt, arg in opts:
#       if opt == 'firefox':
#          print  ("webdriver.Firefox")
driver = webdriver.Firefox()
#       elif opt == 'chrome':
#         # get the path of ChromeDriverServer;
#         dir = os.path.dirname(__file__)
#         chrome_driver_path = dir + "\chromedriver.exe"
#         print  ("webdriver.Chrome")
#         driver = webdriver.Chrome()
#       elif opt == 'ie':
#         # get the path of IEDriverServer
#         dir = os.path.dirname(__file__)
#         ie_driver_path = dir + "\IEDriverServer.exe"
#         print  ("webdriver.Chrome")
#         driver = webdriver.Chrome()


driver.implicitly_wait(1)  # seconds for network delays
#driver.maximize_window()   # so positions are consistent across sessions.

### Navigate to the application home/landing page:
driver.get("https://www.github.com/")
assert "The world's leading" in driver.title

#search_field = driver.find_element_by_id("lst-ib")
#search_field.clear()

### get the number of elements found:
#print ("Found " + str(len(lists)) + "searches:")

### Get to Sign-in page:
#	elem = driver.find_element_by_name("Sign in")
#	elem.send_keys(Keys.RETURN)
#   elem.clear()

	### Sign-in form:
#assert "Sign-in" in driver.title
#elem = driver.find_element_by_name("login")  # within Form
#elem.clear()
#elem.send_keys("UserID") # from ./secrets.sh

#elem = driver.find_element_by_name("password")
#elem.clear()
#elem.send_keys("password") # from ./secrets.sh via MacOS Clipboard.

#elem = driver.find_element_by_name("Sign In")  # Green button
#elem.send_keys(Keys.RETURN)

### New SSH Key:
#elem = driver.find_element_by_name("SSH Key")
#elem = driver.find_element_by_name("SSH key field")
#elem.clear()
#elem.send_keys("SSH Key") # from file (not Clipboard)
#elem.send_keys(Keys.RETURN)

	#assert "No results found." not in driver.page_source

#driver.quit()

#if __name__ == "__main__":
#   main(sys.argv[1:])