from selenium import webdriver

from utils.webdriver_manager import setup_webdriver

def lambda_handler(event, context):
  driver = setup_webdriver()

  return "Hello, Selenium"