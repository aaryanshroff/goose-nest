from selenium import webdriver

def lambda_handler(event, context):
  service = webdriver.FirefoxService(executable_path="/opt/python/geckodriver")
  driver = webdriver.Firefox(service=service)

  return "Hello, Selenium"