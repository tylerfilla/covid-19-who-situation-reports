#
# Sitrep Scraper - Scrapebot
#

import os

from cryptography.fernet import Fernet


def main():
    # Get the encryption key
    enckey = os.environ['INPUT_KEY']

    # Decrypt the app key
    with open('key.pem.fernet', 'rb') as file:
        appkey = Fernet(enckey.encode()).decrypt(file.read()).decode()

    print(appkey[:32])


if __name__ == '__main__':
    main()
