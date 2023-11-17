from selenium import webdriver

def lambda_handler(event, context):
  driver = webdriver.Firefox()

  return "Hello, Lambda"