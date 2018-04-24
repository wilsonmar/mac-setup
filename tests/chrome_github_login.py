#!/usr/bin/python
# chrome_pycon_search.py
# from http://selenium-python.readthedocs.io/getting-started.html#selenium-remote-webdriver
from selenium import webdriver
from selenium.webdriver.common.keys import Keys

#driver = webdriver.Chrome()
driver = webdriver.Firefox()

driver.get("https://github.com")
assert "The world" in driver.title
#elem = driver.find_element_by_name("q")
elem = driver.find_elements_by_css_selector('header div.HeaderMenu div.HeaderNavlink a')
print(elem)  # [<selenium.webdriver.firefox.webelement.FirefoxWebElement
# body > div.position-relative.js-header-wrapper > header > div > div.HeaderMenu.HeaderMenu--bright.d-lg-flex.flex-justify-between.flex-auto > div > span > div > a:nth-child(1)
# XPath: /html/body/div[1]/header/div/div[2]/div/span/div/a[1]
# <a class="text-bold text-white no-underline" href="/login" data-ga-click="(Logged out) Header, clicked Sign in, text:sign-in">Sign in</a>
elem[0].click()
#elem.send_keys("pycon")
#elem.send_keys(Keys.RETURN)
assert "No results found." not in driver.page_source
#driver.close()
