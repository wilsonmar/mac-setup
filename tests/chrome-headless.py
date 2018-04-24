#!/usr/bin/python
# chrome_yun.py
# From https://github.com/pyzzled/selenium/tree/master/headless_browser explained at
# https://medium.com/@pyzzled/running-headless-chrome-with-selenium-in-python-3f42d1f5ff1d

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import os

# instantiate a chrome options object so you can set the size and headless preference
chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--window-size=1920x1080")

# download the chrome driver from https://sites.google.com/a/chromium.org/chromedriver/downloads and put it in the
# current directory
chrome_driver = os.getcwd() +"\\chromedriver.exe"

### Launch: 

# go to Google and click the I'm Feeling Lucky button
driver = webdriver.Chrome(chrome_options=chrome_options, executable_path=chrome_driver)
driver.get("https://www.google.com")
lucky_button = driver.find_element_by_css_selector("[name=btnI]")
lucky_button.click()

# capture the screen
driver.get_screenshot_as_file("capture.png")

# You should now have a screenshot of the I’m Feeling Lucky page in your project folder! 

