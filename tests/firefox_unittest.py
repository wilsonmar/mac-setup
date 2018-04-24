#!/usr/bin/python
# python_firefox_unittest.py
# from https://saucelabs.com/resources/articles/getting-started-with-webdriver-in-python-on-osx
import unittest
from selenium import webdriver
from selenium.webdriver.common.by import By

class WebDriverPythonBasics(unittest.TestCase):
    def setUp(self):
        self.browser = webdriver.Firefox()

    def test_saucelabs_homepage_header_displayed(self):
        self.browser.get('http://saucelabs.com')
        header = self.browser.find_element(By.ID, 'site-header')
        self.assertTrue(header.is_displayed())

    def tearDown(self):
        self.browser.close()

if name == 'main':