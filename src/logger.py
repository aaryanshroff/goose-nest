import logging

logging.basicConfig(level=logging.DEBUG)

LOGGER = logging.getLogger()

LOGGER.setLevel(logging.INFO)

SELENIUM_LOGGER = logging.getLogger('selenium')
SELENIUM_LOGGER.setLevel(logging.DEBUG)
