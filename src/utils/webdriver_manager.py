from selenium import webdriver
from selenium.webdriver import FirefoxService
from selenium.webdriver import Firefox

from constants import APP


def setup_webdriver():
    options = webdriver.FirefoxOptions()
    # TODO: Find way to DRY this location here and in Dockerfile
    options.binary_location = "/opt/firefox/firefox"
    options.add_argument("-headless")
    # https://stackoverflow.com/questions/50642308/webdriverexception-unknown-error-devtoolsactiveport-file-doesnt-exist-while-t
    # chrome_options.add_argument("--no-sandbox")
    # chrome_options.add_argument("--disable-dev-shm-usage")
    # chrome_options.add_argument("--remote-debugging-port=9230")

    # TODO: Find way to DRY this location here and in Dockerfile
    service = FirefoxService(
        executable_path="/opt/geckodriver")

    driver = Firefox(service=service, options=options)

    return driver


def shutdown_webdriver(driver: Firefox):
    driver.stop_client()
    driver.close()
    driver.quit()
