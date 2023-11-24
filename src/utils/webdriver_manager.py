from selenium import webdriver
from selenium.webdriver import ChromeService
from selenium.webdriver import Chrome

def setup_webdriver():
  chrome_options = webdriver.ChromeOptions()
  chrome_options.binary_location = "/opt/chrome-linux64/chrome"
  chrome_options.add_argument("--headless")
  # https://stackoverflow.com/questions/50642308/webdriverexception-unknown-error-devtoolsactiveport-file-doesnt-exist-while-t
  chrome_options.add_argument("--no-sandbox")
  chrome_options.add_argument("--disable-dev-shm-usage")

  service = ChromeService(executable_path="/opt/chromedriver-linux64/chromedriver")

  driver = Chrome(service=service, options=options)

  return driver