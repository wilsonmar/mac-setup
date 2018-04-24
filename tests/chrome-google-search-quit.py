#!/usr/bin/python
# chrome-google-search-quit.py
# from https://sites.google.com/a/chromium.org/chromedriver/getting-started
import time
from selenium import webdriver

driver = webdriver.Chrome()
driver.get('http://www.google.com/xhtml');
time.sleep(5) # Let the user actually see something!
search_box = driver.find_element_by_name('q')
search_box.send_keys('ChromeDriver')
search_box.submit()
time.sleep(5) # Let the user actually see something!
driver.quit()