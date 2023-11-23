from selenium import webdriver

def lambda_handler(event, context):
  options = webdriver.ChromeOptions()
  options.add_argument("--headless")

  browser = webdriver.Chrome(options=options)

  return "Hello, Selenium"