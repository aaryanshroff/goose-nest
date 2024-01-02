import json
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

from utils.webdriver_manager import setup_webdriver, shutdown_webdriver


def lambda_handler(event, context):
    driver = setup_webdriver()

    driver.get('https://facebook.com/marketplace/toronto/search?query=rentals')

    print("Waiting for page GET...")
    wait = WebDriverWait(driver, 10)

    print("Page GET complete. Waiting for dynamic DOM elements to load...")
    collection_element = wait.until(EC.presence_of_element_located(
        (By.CSS_SELECTOR, '[aria-label="Collection of Marketplace items"]')))
    print("DOM elements finished loading.")

    link_elements = driver.find_elements(
        By.CSS_SELECTOR, '[aria-label="Collection of Marketplace items"] a')

    entries = []
    hrefs = []

    for element in link_elements:
        inner_text = element.text
        href = element.get_attribute('href')

        entries.append(inner_text)
        hrefs.append(href)

    print(entries)
    print(hrefs)

    shutdown_webdriver(driver=driver)

    return json.dumps(entries)


if __name__ == '__main__':
    lambda_handler(None, None)
