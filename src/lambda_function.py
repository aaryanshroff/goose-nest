from selenium import webdriver

def lambda_handler(event, context):
  options = webdriver.ChromeOptions()
  options.binary_location = "/opt/chrome-linux64/chrome"
  options.add_argument("--headless")
  # https://stackoverflow.com/questions/50642308/webdriverexception-unknown-error-devtoolsactiveport-file-doesnt-exist-while-t
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")

  service = webdriver.ChromeService(executable_path="/opt/chromedriver-linux64/chromedriver")

  browser = webdriver.Chrome(service=service, options=options)

  return "Hello, Selenium"