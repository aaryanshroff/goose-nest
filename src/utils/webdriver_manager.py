from selenium import webdriver
from selenium.webdriver import ChromeService
from selenium.webdriver import Chrome

from constants import APP


def setup_webdriver():
    chrome_options = webdriver.ChromeOptions()
    if APP == "production":
        chrome_options.binary_location = "/opt/chrome-linux64/chrome"
    chrome_options.add_argument("--headless")
    # https://stackoverflow.com/questions/50642308/webdriverexception-unknown-error-devtoolsactiveport-file-doesnt-exist-while-t
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--remote-debugging-port=9230")

    service = None
    if APP == "production":
        service = ChromeService(
            executable_path="/opt/chromedriver-linux64/chromedriver")
    else:
        service = ChromeService()

    driver = Chrome(service=service, options=chrome_options)

    return driver


def shutdown_webdriver(driver: Chrome):
    driver.stop_client()
    driver.close()
    driver.quit()
