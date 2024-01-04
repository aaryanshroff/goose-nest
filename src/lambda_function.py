import json
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

from utils.webdriver_manager import setup_webdriver, shutdown_webdriver
from logger import LOGGER


def lambda_handler(event, context):
    LOGGER.info("Setting up driver...")
    driver = setup_webdriver()
    LOGGER.info("Driver setup complete.")

    LOGGER.info("Waiting for page GET...")
    driver.get('https://example.com')

    LOGGER.info("Page GET complete. Waiting for dynamic DOM elements to load...")
    wait = WebDriverWait(driver, 10)
    collection_element = wait.until(EC.presence_of_element_located(
        (By.CSS_SELECTOR, '[aria-label="Collection of Marketplace items"]')))

    LOGGER.info("DOM elements finished loading.")

    link_elements = driver.find_elements(
        By.CSS_SELECTOR, '[aria-label="Collection of Marketplace items"] a')

    entries = []
    hrefs = []

    for element in link_elements:
        inner_text = element.text
        href = element.get_attribute('href')

        entries.append(inner_text)
        hrefs.append(href)

    LOGGER.info(entries)
    LOGGER.info(hrefs)

    # shutdown_webdriver(driver=driver)

    return json.dumps(entries)


if __name__ == '__main__':
    lambda_handler(None, None)
