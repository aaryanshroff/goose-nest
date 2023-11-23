from selenium import webdriver

def lambda_handler(event, context):
  options = webdriver.ChromeOptions()
  options.binary_location = "/opt/bin/headless-chromium"
  options.add_argument("--headless")

  service = webdriver.ChromeService(executable_path="/opt/bin/chromedriver")

  browser = webdriver.Chrome(service=service, options=options)

  return "Hello, Selenium"