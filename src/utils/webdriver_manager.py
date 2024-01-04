from selenium import webdriver
from selenium.webdriver import ChromeService as Service
from selenium.webdriver import Chrome as Browser

from constants import APP
from logger import LOGGER

BROWSER_BINARY_LOCATION = "/opt/chrome/chrome"
DRIVER_EXEC_PATH = "/opt/chromedriver/chromedriver"


def setup_webdriver():
    options = webdriver.ChromeOptions()
    # TODO: Find way to DRY this location here and in Dockerfile
    options.binary_location = BROWSER_BINARY_LOCATION
    options.add_argument("--headless=new")
    # https://stackoverflow.com/questions/50642308/webdriverexception-unknown-error-devtoolsactiveport-file-doesnt-exist-while-t
    options.add_argument("--no-sandbox")
    # TODO: How many of these do we actually need?
    options.add_argument("--window-size=1280,1696")
    options.add_argument("--disable-gpu")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-dev-tools")
    options.add_argument("--single-process")
    options.add_argument("--no-zygote")
    options.add_argument("--remote-debugging-port=9222")

    # TODO: Find way to DRY this location here and in Dockerfile
    LOGGER.info("Initializing service...")
    service = Service(
        executable_path=DRIVER_EXEC_PATH)
    LOGGER.info("Service initialization complete.")

    LOGGER.info("Initializing browser...")
    browser = Browser(service=service, options=options)
    LOGGER.info("Browser initialization complete.")

    return browser


def shutdown_webdriver(driver: Browser):
    driver.stop_client()
    driver.close()
    driver.quit()
